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

?iris

dim(iris)

str(iris)

# mtcars

data(mtcars)

?mtcars

mean(mtcars$mpg)

min(mtcars$mpg)

str(mtcars)

# diamonds

data("diamonds")

head(diamonds)


# ggplot2

library(ggthemes)

ggplot(data = diamonds,
       mapping = aes(x = carat, y = price, color = clarity)) +
  geom_point() +
  labs(title = "Relation entre carat et prix des diamants",
       subtitle = "n = 53 940 diamants",
       x = "Carat",
       y = "Prix") +
  theme_wsj()


