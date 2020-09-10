# dplyr exercises in R --- September 9th, 2020
install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

# slide 36
flights

# slide 37
head(flights)
tail(flights)

# slide 39
filter( flights, month == 5, day == 28)

# slide 40
flights %>% filter( month ==5, day == 28)

# slide 41
jan1 <- filter(flights, month == 1, day == 1)

# slide 42
(jul4 <- filter(flights, month == 7, day == 4))

# slide 43
flights %>% filter(month = 7, day = 4) # this produces an error

# slide 44
sqrt(2)^2 == 2; near(sqrt(2)^2, 2)
1/49*49 == 1; near(1/49*49, 1)

# slide 46
flights %>% filter( month ==1 | month ==2)

# slide 47
flights %>% filter( month %in% c(1,2))
