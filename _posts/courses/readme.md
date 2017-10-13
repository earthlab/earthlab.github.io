## Key YAML

`order:` set the order to a numeric value. This is how the side bar populates
AND also how the bottom pagination populates before and after links.

**sidebar:** the sidebar list of lessons in the module populates based upon two things

1. The **nav-title** field needs to be set. this is the text that appears in the sidebar. It should be kept short.
2. The **class-lesson** NAME needs to be populated. Any posts that share a category =
courses and the same lesson name will be populated in the side bar,
ordered by the order value.


NOTE: if there are duplicate order values - ie two posts have order:2 then you'll get weird duplication of navigation at the bottom!


## Module elements

Note that the elements of a module landing page are below. The order==1
element triggers
jekyll to build a "welcome to the series" block at the top of the page.

```yaml
dateCreated: 2016-12-12
modified: 2016-12-12
module-title: 'Setup R, R Studio & Your Working Directory'
module-description: 'This module walks you through getting R and RStudio setup on your
computer. It also introduces file organization strategies.'
order: 1
```


### Styles

HERE is a learning objective box:
```
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
</div>
```

Here is a challenge
```
<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

</div>
```

*****

Here is additional resources box

```
<div class="notice--info" markdown="1">

## Additional Resources

</div>
```
****

#### Icons
Idea block - lightbulb: `<i class="fa fa-lightbulb-o" aria-hidden="true"></i>`
Challenge Activity - pencil writing: `<i class="fa fa-pencil-square-o" aria-hidden="true"></i>`
Regular pencil`<i class="fa fa-pencil" aria-hidden="true"></i>`

Learning Objective : graduate cap `<i class="fa fa-graduation-cap" aria-hidden="true"></i>`

To highlight code for pushing keyboard keys (example shows ctrl key) use:
<kbd>ctrl</kbd>

## Data tips

<div class="notice" markdown="1">
<i fa fa-star></i>**Data Tip:**
### Minimal mistakes

Styles:
https://mmistakes.github.io/minimal-mistakes/docs/utility-classes/


### Ignore a link that is not passing HTML proofer but we know works:
https://spock.rocks/tech/2016/03/21/basic-jekyll-site-tests.html

HTML url:
<a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.516&rep=rep1&type=pdf" target="_blank" data-proofer-ignore=''>

Markdown url:
[get pdf](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.516&rep=rep1&type=pdf){:data-proofer-ignore=''}
