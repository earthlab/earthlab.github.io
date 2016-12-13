## Key YAML

`order:` set the order to a numeric value. This is how the side bar populates
AND also how the bottom pagination populates before and after links.

**sidebar:** the sidebar list of lessons in the module populates based upon two things

1. The nav-title field needs to be set. this is the text that appears in the sidebar. It should be kept short.
2. The class-lesson NAME needs to be populated. Any posts that share a category =
course-materials and the same lesson name will be populated in the side bar,
ordered by the order value.


NOTE: if there are duplicate order values - ie two posts have order:2 then you'll get weird duplication of navigation at the bottom!


## Module elements

Note that the elements of a module landing page are below. THese elements trigger
jekyll to build a "welcome to the series" block at the top of the page.

```yaml
dateCreated: 2016-12-12
dateModified: 2016-12-12
module-title: 'Setup R, R Studio & Your Working Directory'
module-description: 'This module walks you through getting R and RStudio setup on your
computer. It also introduces file organization strategies.'
order: 1
```
