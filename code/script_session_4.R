# R script session 4
# 13 mars 2024

# répértoire de travail
setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")

# 1. paquets R

# install.packages("tidyverse")
# install.packages("ggthemes")

library(tidyverse)
library(ggthemes)

# 2. jeu de données intégrés

data(iris)

?iris

str(iris)


data(mtcars)

?mtcars

min(diamonds$price)

str(diamonds)

dim(diamonds)

glimpse(diamonds)

?diamonds


# 3. ggplot2

library(ggthemes)

ggplot(data = diamonds,
       mapping = aes(x = carat, 
                     y = price,
                     color = clarity)) +
  geom_point() +
  labs(title = "Relation entre carat et prix des diamants",
       subtitle = "n = 53940 diamants",
       x = "Carat",
       y = "Prix",
       colour = "Pureté") +
  theme_economist()
