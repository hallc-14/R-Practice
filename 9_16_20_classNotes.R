# notes from 9.16.20 class

library(tidyverse)
library(nycflights13)

# nested grouping, using summarize() to "peel off"
daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))
(per_month <- summarize(per_day, flights = sum(flights)))
(per_month <- summarize(per_day, flights = sum(flights)))
(per_year <- summarize(per_month, flights = sum(flights)))

# ungroup
daily %>%
  ungroup() %>%
  summarize(flights = n())

flights_sml <- flights %>% select(year:day, ends_with("delay"),
                                   distance, air_time)
flights_sml %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

popular_dests <-
  flights %>% group_by(dest) %>%
  filter(n() > 365 )
popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)

# exploratory data analysis
# 1 Generate questions about the data
# 2 Search for answers by visualizing, transforming, modeling
# 3 Use what you learn to refine your questions and/or generate new questions

ggplot(data = diamonds) + 
  geom_bar(mapping = aes( x = cut ))

diamonds %>%
  count(cut)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

diamonds %>%
  count(cut_width(carat, 0.5))

smaller <- diamonds %>%
  filter(carat < 3)

ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

ggplot(faithful, aes(x = eruptions)) +
  geom_histogram(binwidth = .25)
# bimodal graph - 2 peaks. Likely that there are multiple distinctive subgroups within the dataset

ggplot(diamonds) + 
  geom_histogram(aes(x = y), binwidth = 0.5)

ggplot(diamonds) +
  geom_histogram(aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,50))

(unusual <- diamonds %>%
    filter(y < 3 | y > 20) %>%
    select(price, x, y, z) %>%
    arrange(y)
    )

# 1. figure out why there are outliers
# 2. analyze with/without to see how much they affect
# 3. typos, input errors, data entry errors, etc. Assign NA instead of excluding them

diamonds2 <-
  diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + geom_point(na.rm = TRUE)

# categ vs. cont variables
# hard to see the diff as overall counts between cut types differ a lot
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(diamonds, aes(cut, price)) +
  geom_boxplot()

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(aes(x = reorder(class, hwy, FUN = median), y = hwy))

ggplot(data = mpg) +
  geom_boxplot(aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

ggplot(data = diamonds) +
  geom_count(mapping = aes(cut, color))

diamonds %>%
  count(color, cut)

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill=n))

# conti vs conti variables
ggplot(diamonds) +
  geom_point(aes(carat, price), alpha = 1/100)

ggplot(smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

install.packages("hexbin")

library(hexbin)
ggplot(smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

# Simpson's paradox - occurs when comparing ratio, prop, fractions, percentages
#Year 1:
Tom <- 100/350; Tom; Jerry <- 14/50; Jerry
#Year 2:
Tom2 <- 3/9; Tom2; Jerry2 <- 123/400; Jerry2
#Career:
TomC <- 103/359; TomC; JerryC <- 137/450; JerryC

ggplot(faithful) +
  geom_point(aes(eruptions, waiting))

ggplot(diamonds) +
  geom_boxplot(mapping = aes(x = cut, y = price))

library(modelr)

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>%
  add_residuals(mod) %>%
  mutate(resid = exp(resid))

ggplot(diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(diamonds2) +
  geom_boxplot(mapping = aes(x = cut, y = resid))