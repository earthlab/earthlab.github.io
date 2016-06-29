---
author: Matt Oakley
category: blogposts
layout: single
title: Acquiring tutorials from GitHub
---

The Analytics Hub develops tutorials and deploys them via the [earthlab/tutorials](https://github.com/earthlab/tutorials) repository on GitHub.
Each tutorial appears in this web site as a blog post, but the tutorials begin as Jupyter Notebooks.
In this post, we will cover some options for acquiring and executing the notebooks.
Please note, the syntax of the code chunks in this document are written for bash, the syntax may be different and need adaptation if you are using a command-line different from bash.

## Downloading with git and Bash (experienced)

If you have experience with the command-line, you'll be able to download these notebooks directly with git commands.
Assuming that you have bash and git installed, you can [clone](https://help.github.com/articles/cloning-a-repository/) the repository to your local filesystem:

```sh
> git clone https://github.com/earthlab/tutorials.git notebooks
```

## Directly download a zip file from GitHub (Novice)

If you do not have experience with the command-line and git, you can download the repository as a .zip file directly from Github.

1. Head to the [Github repository](https://github.com/earthlab/tutorials) in your web browser
2. Click the green 'Clone or download' button
3. Click the 'Download ZIP' button
![alt text](http://i.imgur.com/fy2yKLb.png?1)
4. Open the downloaded ZIP file and extract the contents to a directory on your local filesystem.

### Executing the notebooks

Now that we have the notebooks downloaded onto our local machine, we can run and use them.

- Open up the command line and *cd* into the directory where the notebooks are stored

```sh
> cd notebooks
```

Then, assuming that you have [Jupyter Notebook installed](http://jupyter.readthedocs.io/en/latest/install.html), you can instantiate a notebook session in your web browser via:

```sh
> jupyter notebook
```

Note that the default installation only includes the Python kernel.
To run the R tutorials, you need to install the [IRkernel](https://irkernel.github.io/).

If you'd like to see a specific tutorial that does not yet exist, or if you find an issue with an existing tutorial, feel free to [file a new issue](https://github.com/earthlab/tutorials/issues) via GitHub.
