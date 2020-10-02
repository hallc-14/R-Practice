# 9/30/20 class notes
# finish up modeling, 
# go over null hypothesis significance testing,
# p-value

library(tidyverse)
library(lubridate)
library(nycflights13)
library(modelr)

daily <- flights %>%
  mutate(date = make_date(year, month, day)) %>%
  group_by(date) %>%
  summarize(n = n())
daily

ggplot(daily, aes(date, n)) +
  geom_line()

(daily <- daily %>% mutate(wday = wday(date, label = TRUE)))

ggplot(daily, aes(wday, n)) +
  geom_boxplot()

mod <- lm(n ~ wday, data = daily)
(grid <- daily %>%
    data_grid(wday) %>%
    add_predictions(mod, "n"))

ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data = grid, color = "red", size = 4)

(daily <- daily %>%
    add_residuals(mod))

daily %>% ggplot(aes(date, resid)) +
  geom_ref_line(h = 0, colour = "red") +
  geom_line()

ggplot(daily, aes(date, resid, color = wday)) +
  geom_ref_line(h = 0) +
  geom_line()

daily %>% filter(resid < -100)

daily %>%
  ggplot(aes(date, resid)) +
  geom_ref_line(h = 0) +
  geom_line(color = "grey50") +
  geom_smooth(se = FALSE, span = .2)

daily %>% filter(wday == "Sat") %>%
  ggplot(aes(date, n)) + geom_point() + geom_line() +
  scale_x_date(NULL, date_breaks = '1 month', date_labels = '%b')

term <- function(date) {
  cut(date,
      breaks = ymd(20130101, 20130605, 20130825, 20140101),
      labels = c("spring","summer","fall"))
}

daily <- daily %>%
  mutate(term = term(date))
daily

daily %>%
  filter(wday == "Sat") %>%
  ggplot(aes(date,n,color = term)) +
  geom_point(alpha = 1/3) +
  geom_line() +
  scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")

daily %>%
  ggplot(aes(wday, n, color = term)) +
  geom_boxplot()

mod1 <- lm(n ~ wday, data = daily)
mod2 <- lm(n ~ wday * term, data = daily)

daily %>%
  gather_residuals(without_term = mod1, with_term = mod2) %>%
  ggplot(aes(date, resid, color = model)) +
  geom_line(alpha = .5)

( daily <- daily %>%
    gather_predictions(mod1,mod2) %>%
    gather_residuals(mod1,mod2))
daily %>%
  ggplot(aes(x = pred, y = resid, color =  model)) + 
  geom_point(alpha = .3) +
  facet_grid( ~ model)

AIC(mod1, mod2)
BIC(mod1, mod2)

( grid_points <- daily %>% filter(model == "mod2" ) %>%
    data_grid(wday, term) %>%
    add_predictions(mod2, "n"))

ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data = grid_points, color = "red") +
  facet_wrap(~term)

# many outliers in summer and fall
# incorporate public holiday information?

#NHST - the lady tasting tea
# Dr Muriel Bristol claimed that she could tell the diff.
# between tea where milk was poured first vs. tea poured first.
# Dr R A Fisher - trailblazer in statistical science - founding
# father of modern classical stats. 
# Fisher carries out scientific experiment. 

# NHST
# 1. Null hypothesis (H0): cannot tell the difference - nothing happens, no special effect, status quo, nothing changes, etc. (no-effect hypothesis)
# 2. Alternative hypotheiss (Ha): can tell the difference.
# 3. p-value: probability of having our outcome or more extreme ones assuming H0 is true.

# is this rare ? (1/70)
# bench mark, typically .05 (5 percent) in statistics
# as it's rare, we reject H0
# conclusion: Dr Bristol can tell the difference
summary(mod1)

#### SECTION TITLES FOR FINAL PRESENTATION ####
# 1. Abstract
# 2. Research Questions
# 3. Data
# 4. EDA
# 5. Modeling
# 6. Conclusions
# 7. Reference

install.packages("blogdown")
library ( blogdown )
