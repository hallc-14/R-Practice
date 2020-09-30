# 9/28/20 class notes
library(tidyverse)
library(modelr); options(na.action = na.warn)

sim2 %>% ggplot(aes(x,y)) +
  geom_point(alpha = .2, color = "blue")

model_2 <- lm(y~x, data = sim2)
summary(model_2)
# it uses (n.levels - 1) dummy variables
# NHST - null hypothesis significance testing *** 
# p-value

(sim2_1 <- sim2 %>% add_predictions(model_2) %>% add_residuals(model_2))
sim2_1 %>% ggplot(aes(x)) +
  geom_point( aes(y = y), color = "blue", alpha = .2 ) +
  geom_point( aes(y = pred), color = "red", size = 4)

sim2_1 %>% ggplot( aes(resid) ) +
  geom_freqpoly(binwidth = .5)

sim2_1 %>% ggplot( aes(resid) ) +
  geom_histogram(bins = 13)

sim3
ggplot(sim3, aes(x1, y)) +
  geom_point(aes(colour = x2), alpha = .6)

# plus sign + indicates no interaction, mult sign * indicates interaction (use to evaluate dependency)
model_3 <- lm( y ~ x1 + x2, data = sim3 )
model_4 <- lm( y ~ x1 * x2, data = sim3 )

# model formula: + for independent predictors, * for interaction terms
# y ~ x + x2 = y = a(int) + a1x(predvar1) + a2x(predvar2)
# y ~ x * x2 = y = a(int) + a1x(predvar1) + a2x(predvar2) + a1x(predvar1)x2
# 3 dummy variables separate, then another three for interaction
summary(model_4)

# model formula: + for independent predictors, * for interaction terms
# assume both predictors are continuous. y ~ sqrt(x1) + x2 means y = a0 + a1x1^1/2 + a2x2
# y ~ x + I(x^2)
# y ~ x + x^2 = y ~ x + x*x

summary(model_3)
summary(model_4)
# r-squared will always increase if you add more terms
(grid_points <- sim3 %>% 
    data_grid(x1,x2) %>%
    gather_predictions(model_3,model_4))

(sim3_1 <- sim3 %>%
    gather_predictions(model_3, model_4) %>%
    gather_residuals(model_3, model_4))

sim3_1 %>%
  ggplot( aes (x1, y, color = x2) ) +
  geom_point() +
  geom_line(data = grid_points, aes( y = pred) ) +
  facet_wrap ( ~ model )

sim3_1 %>%
  ggplot( aes( x = pred, y = resid, color = model)) +
  geom_point() +
  facet_grid( ~ model) # this representation is always possible

sim3_1 %>%
  ggplot(aes(x1, resid, color = x2)) +
  geom_point() +
  facet_grid(model ~ x2)

# means of comparison
AIC(model_3, model_4)
BIC(model_3, model_4)

sim4[40:45, ]

model_5 <- lm(y ~ x1 + x2, data = sim4)
model_6 <- lm(y ~ x1 * x2, data = sim4)

summary(model_6)

sim4_1 <- sim4 %>%
  gather_predictions(model_5, model_6) %>%
  gather_residuals(model_5, model_6)
sim4_1

ggplot(diamonds, aes(cut, price)) + geom_boxplot()
# typical value = median
# average value = mean
# typical can be more useful in cases such as price

ggplot(diamonds, aes(color, price)) + geom_boxplot()
ggplot(diamonds, aes(clarity, price)) + geom_boxplot()
ggplot(diamonds, aes(carat, price)) +
  geom_hex(bins = 50)
ggplot(diamonds, aes(carat)) +
  geom_histogram(bins = 50)

diamonds %>% summarize(prop_lt_25 = mean(carat <= 2.5, na.rm = TRUE)) # find outliers
diamonds2 <- diamonds %>%
  filter(carat <= 2.5) %>%
  mutate(lprice = log2(price), lcarat = log2(carat))
diamonds2

ggplot(diamonds2, aes(lcarat, lprice)) + 
  geom_hex(bins = 50)
# log transform is necessary because both variables grow exponentially

mod_diamond1 <- lm(lprice ~ lcarat, data = diamonds2)
mod_diamond2 <- lm(lprice ~ lcarat + color + cut + clarity, data =diamonds2)

summary(mod_diamond1)
summary(mod_diamond2)

AIC(mod_diamond1, mod_diamond2)
BIC(mod_diamond1, mod_diamond2)

grid <- diamonds2 %>%
  data_grid(cut, .model = mod_diamond2) %>%
  add_predictions(mod_diamond2)
ggplot(grid, aes(cut, pred)) + geom_point()

( diamonds2 <- diamonds2 %>%
    gather_predictions(mod_diamond1, mod_diamond2) %>%
    gather_residuals(mod_diamond1, mod_diamond2))

diamonds2 %>% ggplot(aes(pred, resid, color = model)) +
  geom_point(alpha = .3) +
  facet_grid( ~model)

diamonds2 %>%
  filter(model == "mod_diamond2", abs(resid) > 1) %>%
  mutate(pred = round(2^pred)) %>%
  select(price, pred, carat:table, x:z) %>%
  arrange(price)

library(lubridate)
library(nycflights13)
(daily <- flights %>%
    mutate(date = make_date(year, month, day)) %>%
    group_by(date) %>%
    summarize(n=n()))
