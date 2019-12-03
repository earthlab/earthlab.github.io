## About

The site uses SASS for css. A recent jekyll update rebuild the css automatically,
so the instructions below do not apply! yay!


To modify the styles:

1. Find the .scss sheet that contains the elements that you wish to fix in the _sass folder
2. Fix Them
3. Jekyll will automagically rebuild the css and create a clean new main.css file.
4. The file in assets/css main.scss is the jekyll template that triggers the css build.

Below, find the old instructions to manually run a css build. I will leave
this for the time being as a reminder.

NOTE: the main.scss is the file that maps all of the SASS files (in order) to build
the final css file.

## To build css in shell
from the assets dir run:
`sass _scss/main.scss css/main.css`
