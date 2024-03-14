# Session 4

# Les paquets R

# install.packages("tidyverse")

library(tidyverse)

# install.packages("ggthemes")

library(ggthemes)


# répértoire de travail

setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")

# jeux de données intégrés

data(iris)

dim(iris)

str(iris)


data(mtcars)

?mtcars

str(mtcars)

mean(mtcars$mpg)


glimpse(mtcars)


data(diamonds)

?diamonds

dim(diamonds)

names(diamonds)

# ggplot avec l'exemple diamonds

library(ggthemes)

ggplot(data = diamonds,
       mapping = aes(x = carat, 
                     y = price,
                     color = clarity)) +
  geom_point() +
  labs(title = "Relation entre carat et prix des diamants",
       subtitle = "n = 53 940 diamants",
       y = "Prix",
       x = "Carat") +
  theme_economist()






