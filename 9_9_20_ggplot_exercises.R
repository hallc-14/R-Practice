# ggplot2 exercises in R --- September 9th, 2020
library(tidyverse)

# slide 6
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

# slide 7
ggplot( data = mpg ) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

# slide 8
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# slide 9
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# slide 10
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# slide 12
ggplot(data = mpg) +
  geom_smooth(mapping = aes( x = displ, y = hwy, group = drv ))

# slide 13
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

# slide 14
ggplot( data = mpg ) + 
  geom_point(mapping = aes( x = displ , y = hwy )) +
  geom_smooth(mapping = aes(x = displ, y = hwy ))

# slide 15
ggplot( data = mpg, mapping = aes(x = displ, y = hwy )) +
  geom_point() +
  geom_smooth()

# slide 16
ggplot(data = mpg, mapping = aes( x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth()

# slide 17
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# slide 18 
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# slide 19
ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

# slide 20
ggplot( data = diamonds ) +
  geom_bar(mapping = aes( x = cut, color = cut ))

# slide 21
ggplot( data = diamonds ) +
  geom_bar(mapping = aes( x = cut, fill = cut ))

# slide 22
ggplot( data = diamonds ) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

# slide 23
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(alpha = 1/5, position = "identity")

# slide 24
ggplot( data = diamonds, mapping = aes(x = cut, color = clarity )) +
  geom_bar ( fill = NA, position = "identity")

# slide 25
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

# slide 26
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# slide 27
ggplot( data = mpg ) +
  geom_point( mapping = aes( x = displ, y = hwy ), position = "jitter")

ggplot( data = mpg ) +
  geom_point( mapping = aes( x = displ, y = hwy ))

# slide 28
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

# slide 29
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

# slide 30
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

# slide 31
graph_1 <- ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

# slide 32
graph_1 + coord_flip()

# slide 33
graph_1 + coord_polar()