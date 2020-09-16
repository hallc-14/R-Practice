# notes from class 9.14.20

library(nycflights13)
library(tidyverse)
head(flights)
tail(flights)

# filtering with dplyr
filter(flights, month == 5, day == 28)

flights %>% filter( month == 5, day == 28)

jan1 <- filter(flights, month == 1, day == 1)

(jul4 <- filter(flights, month == 7, day == 4))

# error
flights %>% filter(month =7, day = 4)

# using near instead of ==
sqrt(2)^2 == 2; near ( sqrt(2^2), 2)
1/49*49 == 1; near( 1/49 * 49, 1)

# logical operators: & and, | or, ! not
flights %>% filter(month ==1 | month ==2)
flights %>% filter(month %in% c(1,2))

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter( flights, arr_delay <= 120, dep_delay <= 120)

NA > 5
5 == NA
NA + 10
NA / 2
NA == NA

x <- NA
is.na(x)

# creating a tibble
df <- tibble( x = c(1, NA, 3))
df

df %>% filter( x > 1 )

# using arrange()
arrange(flights, year, month, day)
flights %>% arrange( desc(month))

arrange(df, x)
arrange(df, desc(x))

flights %>% select(year, month, day)
flights %>% select(year:day)
flights %>% select(-(year:day))

#other functions
rename(flights, tail_num = tailnum)
flights %>% select(tail_num = tailnum)

flights %>% select(time_hour, air_time, everything())

flights_sml <- flights %>% select( year:day, ends_with("delay"), distance, air_time)
flights_sml %>% mutate( gain = dep_delay - arr_delay, speed = distance / air_time * 60)
flights_sml %>% mutate( gain = dep_delay - arr_delay,
                        hours = air_time / 60,
                        gain_per_hour = gain / hours)

flights %>% transmute( gain = dep_delay - arr_delay, hours = air_time / 60, gain_per_hour = gain/hours)
flights %>% transmute ( dep_time,
                        hour = dep_time %/% 100,
                        minute = dep_time %% 100)

# example of vectorized operation
(x <- 1:10)
lag(x)
lead(x)

x; cumsum(x); cumprod(x)
cummean(x)

flights %>% summarize(delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

flights %>% group_by(year, month, day) %>%
  summarize(delay = mean(dep_delay, na.rm = TRUE))

delays <- flights %>%
  group_by(dest) %>%
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")

view(delays)

delays %>% ggplot(mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

flights %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay, na.rm = TRUE))

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay)
  )
head(delays)

delays %>% ggplot(mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

delays %>% ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

delays %>% filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) + geom_point(alpha = 1/10)

not_cancelled %>%
  group_by(year,month,day) %>%
  summarize(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

not_cancelled %>%
  group_by(year,month,day) %>%
  summarize(
    first = min(dep_time),
    last = max(dep_time)
  )

not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

not_cancelled %>%
  count(dest)

not_cancelled %>%
  count(tailnum, wt = distance)

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_prop = mean(arr_delay > 60))

daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))
