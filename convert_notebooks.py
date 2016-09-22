# converting ipynb files to markdown posts
import sys
import os
import re
import subprocess
from glob import glob
from io import StringIO
import frontmatter

def generate_md_prefix(input_file, destination, lang):
    """
    Generates a markdown filename prefix for a ipynb input file.
    """
    input_filename_components = input_file.split(".")
    input_prefix = input_filename_components[0]
    input_prefix = re.sub("tutorials", "", input_prefix)
    date = gen_date_string(input_prefix)
    md_prefix = gen_output_filename(destination, input_prefix, date, lang)
    return md_prefix



def gen_output_filename(destination, input_prefix, date_string, lang):
    """
    Generates output file name
    """
    tutorial_name = input_prefix.split("/")[-1]
    filename = destination + "/" + date_string + tutorial_name + "-" + lang
    return filename



def gen_date_string(input_prefix):
    """
    Uses file commit history to figure out when the last change was made.

    returns: a date string, e.g., 2015-03-23-
    """
    os.chdir("tutorials")
    s_format = "--pretty='format:%h %s%n\t%<(12,trunc)%ci%x08%x08, %an <%ae>'"
    input_file = input_prefix.strip("/") + ".ipynb"
    cmd = "git log -1 --format=%cd {0} {1}".format(s_format, input_file)
    last_commit_info = subprocess.check_output(cmd, shell=True).decode('utf-8')
    try:
        date = re.search("\d{4}-\d{2}-\d{2}", last_commit_info).group(0)
    except AttributeError:
        date = "" # date not found in commit info
        print("Date not found in commit info" + last_commit_info)
    os.chdir("..")
    date = date + "-"
    return date



def convert_notebook(input_file, destination, lang):
    """
    Converts one notebook file to a markdown post
    """
    md_prefix = generate_md_prefix(input_file, destination, lang)
    wd = os.getcwd()
    md_prefix = md_prefix.replace("_", "-")
    md_prefix = md_prefix.replace("-posts/", "_posts/")
    md_out = wd + "/" + md_prefix
    ipynb_in = wd + "/" + input_file
    cmd = "jupyter nbconvert --to markdown --output {0} {1}".format(md_out, ipynb_in)
    os.system(cmd)
    add_yaml(md_out, lang)
    move_images(md_prefix)
    fix_img_paths(md_out, wd)


def fix_img_paths(md_out, wd):
    filename = md_out + '.md'
    to_replace = wd + "/_posts"
    with open(filename) as f:
        out_fname = filename + ".tmp"
        out = open(out_fname, "w")
        for line in f:
            out.write(re.sub(to_replace, '/images', line))
        out.close()
        os.rename(out_fname, filename)


def move_images(markdown_file):
    """ Moves any images into the img/ directory and fixes paths in md post """
    files_to_move = glob(markdown_file + "*.png")
    dest = []
    for i, file in enumerate(files_to_move):
        dest.append(re.sub("_posts", "images", file))
        os.rename(file, dest[i])
    dest

def add_yaml(markdown_file, lang):
    """
    Adds yaml front-matter to markdown files produced by nbconvert
    """
    md_filename = markdown_file + ".md"
    fm = frontmatter.load(md_filename)
    fm['layout'] = 'single'
    fm['title'], first_header = get_title(md_filename)
    fm['category'] = lang
    fm['author'], authline = get_author(md_filename)
    fm['tags'] = get_tags(md_filename, lang)
    f = StringIO()
    frontmatter.dump(fm, f)
    new_post_contents = f.getvalue()
    new_post = trim(new_post_contents, [first_header, authline])
    new_md_file = open(md_filename, 'w')
    new_md_file.write(new_post)
    new_md_file.close()



def trim(post, to_trim):
    """
    Trims lines from posts
    """
    for lines in to_trim:
        post = re.sub(lines, "", post)
    return post



def get_title(markdown_filename):
    """
    Fetches the title and title line from a markdown file
    """
    contents = open(markdown_filename, 'r')
    text = contents.readlines()
    headers = [s for s in text if "#" in s]
    first_header = headers[0]
    contents.close()
    title = parse_header(first_header)
    return title, first_header



def parse_header(header):
    """
    Strips trailing newlines and leading comments/spaces from titles
    """
    no_newline_at_end = header.rstrip()
    first_lett_or_num = re.search("[a-zA-Z]+", no_newline_at_end).start()
    title = no_newline_at_end[first_lett_or_num:]
    return title



def get_author(markdown_filename):
    """
    Fetches the author and author line from a markdown file
    """
    contents = open(markdown_filename, 'r')
    text = contents.readlines()
    authlines = [s for s in text if "Author:" in s]
    authline = authlines[0]
    contents.close()
    author = parse_authline(authline)
    return author, authline



def parse_authline(authline):
    """
    Strips trailing newlines and leading "Author: " string from author lines
    """
    no_newline_at_end = authline.rstrip()
    author = re.sub("Author: ", "", no_newline_at_end)
    return author



def get_tags(markdown_filename, lang):
    """ Finds post tags based on loaded packages/modules"""
    contents = open(markdown_filename, 'r')
    text = contents.readlines()
    keyword = get_keyword(lang)
    pkg_lines = [s for s in text if keyword in s and '.' not in s[-2:]]
    tags = find_package(pkg_lines, lang)
    unique_tags = list(set(tags))
    unique_tags.sort()
    tags_to_exclude = ['__future__', 'sys']
    return [tag for tag in unique_tags if tag not in tags_to_exclude]



def find_package(commands, lang):
    """Finds packages loaded in an R or Python script"""
    if lang == "r":
        packages = find_r_packages(commands)
    elif lang == "python":
        packages = find_python_packages(commands)
    return packages



def find_r_packages(commands):
    """Finds R packages in a list of commands"""
    packages = []
    for i, cmd in enumerate(commands):
        lib_loc = re.search("library\(", cmd).end()
        no_prefix = cmd[lib_loc:]
        in_paren = no_prefix.split(")")[0]
        in_paren = re.sub("\'", "", in_paren)
        in_paren = re.sub("\"", "", in_paren)
        packages.append(in_paren)
    return packages



def find_python_packages(commands):
    """Finds Python modules loaded in a list of commands"""
    packages = []
    for i, cmd in enumerate(commands):
        if "from " in cmd:
            import_start = re.search("import", cmd).start()
            cmd = cmd[:(import_start - 1)]
            cmd = cmd.replace("from ", "")
        else:
            cmd = cmd.replace("import ", "")
        if " as " in cmd:
            cmd = re.split('\s', cmd)[0]
        cmd = cmd.rstrip()
        packages.append(cmd)
    return packages



def get_keyword(lang):
    """ Returns package loading keyword for a language """
    if lang == "python":
        keyword = "import "
    elif lang == "r":
        keyword = "library("
    else:
        raise NameError('Unknown language (not R or python)')
    return keyword


def identify_notebooks(input_dir, lang):
    """
    Returns a list of available notebooks in a directory/language combination.
    """
    if lang == 'r':
        lang = lang.upper()
    notebook_directory = '{0}/{1}/'.format(input_dir, lang)
    notebooks = glob(notebook_directory + "*.ipynb")
    return notebooks

exclude = ['tutorials/python/introduction_to_bokeh.ipynb'] # these don't render properly

def main():
    """Main function identifies notebooks and converts each one to md post
parameters: input_dir, output_dir

usage: python convert_notebooks.py input_dir output_dir
    """
    assert len(sys.argv) is 3, 'Usage: convert_notebooks.py input_dir output_dir'
    input_dir, output_dir = sys.argv[1:]
    assert os.path.isdir(input_dir), 'Please specify an existing input directory'
    assert os.path.isdir(output_dir), 'Please specify an existing output directory'

    languages = ["python", "r"]

    for lang in languages:
        notebooks = identify_notebooks(input_dir, lang)
        for nb in notebooks:
            if nb not in exclude:
                convert_notebook(input_file = nb, destination = output_dir, lang = lang)

if __name__ == "__main__":
    main()
