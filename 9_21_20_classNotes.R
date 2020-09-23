# week 6 class notes 9/21/20
# EDA with tidyverse
library(tidyverse)
ggplot(faithful, aes(eruptions)) +
  geom_freqpoly(binwidth = .25)

# data pipes %>% and graphical layers +
diamonds %>%
  count(cut, clarity) %>%
  ggplot(aes(clarity, cut, fill = n)) +
  geom_tile()

# install GGally
install.packages("GGally")
library(GGally)
?ggpairs

ggpairs(iris) # get a snapshot of association

# R markdown
install.packages("rmarkdown")
library(rmarkdown)

# 3 distinctive areas in RMarkdown
# Header: surrounded by --- ---
# Code Chunk: ``` ```
# Markdown Script
# eval = FALSE (prevents code from being evaluated)
# include = FALSE (runs the code but doesn't show the code or results in final doc)
# echo - FALSE (doesn't show code but results are displayed)
# message = FALSE, warning = FALSE
# results = 'hide': hides printed output
# fig.show = 'hide': hides plots

#Data Wrangling with Tidyverse
class(iris)
as_tibble(iris)

tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

(tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
))

tribble(          #transposed tibble: row-wise instead of column-wise
  ~x, ~y, ~z,
  "a", 2, 3.6,
  "b", 1, 8.5
)

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df$x       #subset by name
df[["x"]]  #subset by name
df[[1]]    #subset by position
df %>% .$x #subset with pipes
df %>% .[["x"]]   

df$y
df$[["y"]]
df[[2]]
df %>% .$y
df %>% .[["y"]]

class( as.data.frame( df ))

# use read_csv instead of read.csv in order to create tibble instead of dataframe

read_csv("a,b,c
         1,2,3
         4,5,6")

read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3", skip = 2)

read_csv("# a comment I want to skip
         x,y,z
         1,2,3", comment = "#")

read_csv("1,2,3\n4,5,6", col_names = FALSE)

read_csv("1,2,3\n4,5,6", col_names = c("x","y","z"))

read_csv("a,b,c\n1,2,.", na = ".")

str(parse_logical(c("TRUE","FALSE","NA")))

str(parse_integer(c("1","2","3")))

str(parse_date(c("2010-01-01","1979-10-14")))

parse_integer(c("1","231",".","456"), na = ".")

(x <- parse_integer(c("123","345","abc","123.45")))

problems(x)

parse_double("1.23")

parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100")

parse_number("20%")

parse_number("It cost $123.45")

parse_number("$123,456,789")

parse_number("123.456.789", locale = locale(grouping_mark = "."))

# swiss convention
parse_number("123'456'789", locale = locale(grouping_mark = "'"))
