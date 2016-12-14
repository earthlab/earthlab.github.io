## ---- echo=FALSE, purl=TRUE----------------------------------------------
### Vectors and data types

## ---- echo=FALSE, eval=FALSE, purl=TRUE----------------------------------
## ## We’ve seen that atomic vectors can be of type character, numeric, integer, and
## ## logical. But what happens if we try to mix these types in a single
## ## vector?
## 
## ## What will happen in each of these examples? (hint: use `class()` to
## ## check the data type of your object)
## num_char <- c(1, 2, 3, 'a')
## 
## num_logical <- c(1, 2, 3, TRUE)
## 
## char_logical <- c('a', 'b', 'c', TRUE)
## 
## tricky <- c(1, 2, 3, '4')
## 
## ## Why do you think it happens?
## 
## ## Can you draw a diagram that represents the hierarchy of the data
## ## types?

## ---- echo=FALSE, purl=TRUE----------------------------------------------
# * Can you figure out why `"four" > "five"` returns `TRUE`?

