# Class notes 9/24/20

library(tidyverse)
charToRaw("Carolina University")
charToRaw("Charlie Hall")

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

day_of_week <- c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
parse_factor( c("Monday","Labor_Day"), levels = day_of_week)

parse_datetime("2020-09-21T18:30")
parse_datetime("20200921") #automatically sets to midnight

parse_date("2020-09-21"); library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

#formatting the date
parse_date("09/12/20", "%m/%d/%y")
parse_date("09/12/20", "%d/%m/%y")
parse_date("09/12/20", "%y/%m/%d")

parse_date("21 february 2022", "%d %B %Y")

date_names_langs()

challenge <- read_csv(readr_example("challenge.csv"))

problems(challenge)           

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols( x = col_double(), y = col_date())
)
tail(challenge)

challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
tail(challenge2)

(df <- tribble(
  ~x, ~y,
  "1","1.21",
  "2","2.32",
  "3","4.56"
))
type_convert(df)

challenge2 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character()))
tail(type_convert(challenge2))
tail(challenge2)

#rds format is R's custom binary data format

# Data Modeling 1 with tidyverse
library(tidyverse)

library(modelr)
options(na.action = na.warn)

ggplot(sim1, aes(x,y,)) +
  geom_point()
view(sim1)

# fitted model = predictive value
# residuals = actual values

# sq to remove negatives instead of abs value

# least squares regression line

ggplot(sim1, aes(x,y)) +
  geom_point() + 
  geom_smooth(method = "lm", color = "red", se = FALSE)

model_1 <- lm( y ~ x, data = sim1 )
summary(model_1) # residuals follow standard norm dist

ggplot(sim1, aes(x,y))+
  geom_point() +
  geom_abline( intercept = model_1$coefficients[1], slope = model_1$coefficients[2], color = 'red')

(sim1_1 <- sim1 %>% add_predictions(model_1))
(sim1_1 <- sim1_1 %>% add_residuals(model_1))

sim1_1 %>% ggplot(aes(resid)) +
  geom_freqpoly(binwidth = .5)
View(sim1)

sim1_1 %>% ggplot( aes(x = pred, y = resid)) +
  geom_point()

sim2 %>% ggplot(aes(x,y)) +
  geom_point(alpha = .2, color = "blue")