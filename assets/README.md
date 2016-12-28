## about

The site is currently using SASS css.  This allows us to organize styles, pass
variables for consistency and more. To modify the styles

1. be sure to edit the _scss file where the style belongs
2. then rebuild the styles to create a new main.css file

NOTE: the main.scss is the file that maps all of the SASS files (in order) to build
the final css file. 

## To build css in shell
from the assets dir run:
`sass _scss/main.scss css/main.css`
