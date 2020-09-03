library(tidyverse); library(ggplot2)

# slide 24
ggplot( data = mpg ) +
  geom_point( mapping = aes( x = displ, y = hwy ))

# slide 25
ggplot( data = mpg ) +
  geom_point( mapping = aes( x = displ, y = hwy, color = class ))

# slide 26
ggplot( data = mpg ) +
  geom_point( mapping = aes( x = displ, y = hwy, size = class ))

# slide 27
ggplot( data = mpg) +
  geom_point( mapping = aes(x = displ, y=hwy, alpha = class))

#slide 28
ggplot(data = mpg) +
  geom_point( mapping = aes( x = displ, y = hwy, shape = class))