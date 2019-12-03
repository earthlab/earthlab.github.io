# Upgrade To Susy3


The upgrade from Susy `2.x` to Susy `3.x`
can be quite simple or difficult,
depending how your project is set up.
We recommend reading the [philosophy](./PHILOSOPHY.md)
before preceding,
to get a better sense of how we're thinking about Susy
in a changing browser landscape.
The [Changelog](./CHANGELOG.md) document
also contains detailed feature/deprecation lists.


## Configuration

Since Susy3 no longer provides direct CSS output,
only length/width values,
most of the output-related configuration options
have been removed.
We've trimmed the Susy map down to math-related settings:
`columns`, `gutters`, `spread`, and `container-spread`.

Read the [configuration docs][config] to learn how these have changed.

The spread settings are new,
and act as a flexible replacement
for the Susy2 `gutter-position` property.
We [wrote an article][spread] to explain them in more detail.

[config]: config.html
[spread]: http://oddbird.net/2017/06/13/susy-spread/


## No Mixins

In Sass:
`functions` return a single value to be manipulated,
while `mixins` output code directly to CSS.
Susy is no longer providing output directly,
and so the entire API is now mixin-free,
providing functions instead.
With all the mixins removed,
there are two primary upgrade paths you can take:

1. **Create your own mixins**:
  Best if you need to build a consistent system
  or find yourself repeting exactly the same code
  in multiple places.
  This will often be true of `float`-based layouts.
2. **Switch to using functions directly**:
  Best if you use Susy for on-the-fly calculations,
  and grids-on-demand --
  or need to support multiple layout techniques.

The following guides should help
find mixin-replacements for either approach:


### Replacing the `Container()` Mixin

The container mixin was used to establish an outer max-width,
add a float-[clearfix](https://css-tricks.com/snippets/css/clear-fix/),
and center the page.

```scss
.container {
  @include container();
}
```

If you are using fluid grids,
or setting the container-width explicitly,
you can now do that on the `width` property.
Centering was handled with `auto` left-and-right margins:

```scss
.container {
  width: 80%; // any length value.
  margin-left: auto;
  margin-right: auto;
}
```

To calculate a fixed outer-width based on column settings
you can use the `span()` function.
In order to get the proper value for a container
rather than a nested element,
pass in the `container-spread` value

```scss
.container {
  $spread: susy-get('container-spread');
  width: span(all $spread);
}
```
