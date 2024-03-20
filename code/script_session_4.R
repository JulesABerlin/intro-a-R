# Session 4

# Les paquets R

# install.packages("tidyverse")

library(tidyverse)

# install.packages("ggthemes")

library(ggthemes)

# répértoire de travail

setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")


# jeu de données intégrés

data(iris)

?iris

dim(iris)

str(iris)

glimpse(iris)


# mtcars

data(mtcars)

?mtcars

mean(mtcars$mpg)

max(mtcars$mpg)


# diamonds

data(diamonds)

# ggplot2

library(ggthemes)

ggplot(data = diamonds,
       mapping = aes(x = carat, y = price, color = clarity)) +
  geom_point() +
  labs(title = "Relation entre carat et prix des diamants",
       subtitle = "n = 53 940 diamants",
       x = "Carat",
       y = "Prix") +
  theme_economist()


# Boxplot de la relation entre nombre de cylindres et mpg dans mtcars

data(mtcars)

class(mtcars$cyl)

mtcars$cyl <- as.factor(mtcars$cyl)

str(mtcars)
ggplot(data = mtcars,
       mapping = aes(x = cyl, y = mpg)) +
  geom_boxplot()

ggplot(data = mtcars,
       mapping = aes(x = cyl, y = mpg, fill = cyl)) +
  geom_boxplot()


# Simulation de tailles d'hommes et de femmes en Suisse

# D'abord,il faut comprendre la fonction rnorm()


hommes <- as.data.frame(rnorm(500, 178, 6.1))
femmes <- rnorm(500, 166, 5.6)

ggplot(data = hommes,
       mapping = aes(hommes[0,1])) +
  geom_histogram()


tailles_ch <- tibble(
  sexe = rep(c("homme", "femme"), each = 500),
  taille = c(rnorm(500, 178, 6.1), rnorm(500, 166, 5.6))
  )

head(tailles_ch)  

str(tailles_ch)

table(tailles_ch$sexe)

tailles_ch$sexe <- as.factor(tailles_ch$sexe)

ggplot(data = tailles_ch,
       mapping = aes(x = taille, fill = sexe)) +
  geom_density(alpha = 0.6) +
  labs(title = "Tailles des hommes et femmes en Suisse",
       subtitle = "Simulation avec 1000 observations aléatoires",
       x = "Taille en cm",
       y = "Densité")
  
# Histogramme des prix des diamants

ggplot(data = diamonds,
       mapping = aes(x = price)) +
  geom_histogram()

ggplot(data = diamonds,
       mapping = aes(x = price)) +
  geom_histogram(fill = "lightblue", color = "black")

ggplot(data = diamonds,
       mapping = aes(x = price)) +
  geom_histogram(fill = "lightblue", color = "black") +
  labs(title = "Histogramme des prix de diamants dans le jeu de données diamonds",
       subtitle = "n = 53 940 diamants",
       x = "Prix en USD",
       y = "Fréquence") +
  theme_minimal()

# diagrammes à barres avec diamonds

p1 <- ggplot(data = diamonds, 
             mapping = aes(x = cut, fill = cut)) + 
  geom_bar() +
  labs(title = "Frequency of cut quality types in the diamonds dataset",
       subtitle = "n = 53,940 diamonds",
       x = "Cut Quality", y = "Count") +
  theme_minimal()

print(p1)



p2 <- ggplot(data = diamonds, 
             mapping = aes(x = color, fill = color)) + 
  geom_bar() +
  labs(title = "Frequency of color quality types in the diamonds dataset",
       subtitle = "n = 53,940 diamonds",
       x = "Color Quality", y = "Count") +
  theme_minimal()

print(p2)


# nuage de points avec iris  

str(iris)

# nuage de points basique pour comparer la longueur et l'épaisseur des sépales
np_1 <- ggplot(data = iris, 
               mapping = aes(x=Sepal.Length, y=Sepal.Width)) +
  geom_point() 

print(np_1)

# nous pouvons ajouter des couches à l'objet np1 sans l'écraser.
# p. ex. une ligne de régréssion linéaire avec la géometrie geom_smooth()

np_1 + geom_smooth(method = lm)

np_1 <- ggplot(iris, 
               aes(x=Sepal.Length, y=Sepal.Width, color = Species)) +
  geom_point() 

print(np_1)

np_1 + geom_smooth(method = lm)





np_2 <- ggplot(data = iris, 
               mapping = aes(x=Petal.Length, y=Petal.Width)) +
  geom_point() 

print(np_2)


?rnorm()

# Créez 500 valeurs aléatoires de taille de femmes
# (moyenne = 164.7 et écart-type = 5.6) avec la fonction rnorm().


taille_f <- rnorm(500, mean = 164.7, sd = 5.6)

head(taille_f)

# stocker taille_f comme objet de type "data.frame"
taille_f <- as.data.frame(taille_f)

# visualiser taille_f avec un histogramme
ggplot(data = taille_f, 
       mapping = aes(x=taille_f)) +
  geom_histogram()

# jouer avec le paramètre "binwidth" de l'histogramme 
# qui définit l'intervalle de la base de ses barres
ggplot(data = taille_f, 
       mapping = aes(x=taille_f)) +
  geom_histogram(binwidth = 1)

ggplot(data = taille_f, 
       mapping = aes(x=taille_f)) +
  geom_histogram(binwidth = 0.1)

ggplot(data = taille_f, 
       mapping = aes(x=taille_f)) +
  geom_histogram(binwidth = 10)

# Modifier la couleur des barres 
ggplot(data = taille_f, 
       mapping = aes(x=taille_f)) +
  geom_histogram(binwidth = 1, color = "black", fill = "white")

# stocker l'histogramme comme objet, nommé hist_1

hist_1 <- ggplot(data = taille_f, 
                 mapping = aes(x=taille_f)) +
  geom_histogram(binwidth = 1, color = "black", fill = "white")

print(hist_1)

# Ajouter des couches supplémentaires pour améliorer la visualisation

# des titres
hist_1 <- hist_1 + labs(title = "Histogramme des tailles de femmes en Suisse",
                        subtitle = "Simulation basée sur 500 observations",
                        x = "Taille en cm",
                        y = "Fréquence") 

print(hist_1)

  
library(ggplot2)

library(ggplot2)
library(dplyr)

# Sample data creation
# Replace this with your actual dataframe and column name for the numerical values
df <- data.frame(value = rnorm(300, mean = 5, sd = 2))

# Calculating summary statistics for annotations
summaries <- df %>% 
  summarise(
    Min = min(value),
    Q1 = quantile(value, 0.25),
    Median = median(value),
    Q3 = quantile(value, 0.75),
    Max = max(value)
  )

# Creating the boxplot with annotations
p <- ggplot(df, aes(x = factor(1), y = value)) +
  geom_boxplot() +
  geom_text(data = summaries, aes(x = 1.40, y = Q1, label = paste("Q1:", round(Q1, 2))), hjust = -0.1) +
  geom_text(data = summaries, aes(x = 1.40, y = Median, label = paste("Median:", round(Median, 2))), hjust = -0.1) +
  geom_text(data = summaries, aes(x = 1.40, y = Q3, label = paste("Q3:", round(Q3, 2))), hjust = -0.1) +
  geom_text(data = summaries, aes(x = 1.2, y = Min, label = paste("Min: point extrême", round(Min, 2))), hjust = -0.1) +
  geom_text(data = summaries, aes(x = 1.2, y = Max, label = paste("Max:point extrême", round(Max, 2))), hjust = -0.1) +
  scale_x_discrete(labels = NULL) + # Hide x-axis labels
  theme_minimal() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

# Display the plot
print(p)

library(ggplot2)
library(dplyr)

# Sample data creation
# Replace this with your actual dataframe and column name for the numerical values
df <- data.frame(value = rnorm(300, mean = 5, sd = 2))

# Calculating summary statistics for annotations
summaries <- df %>% 
  summarise(
    Min = min(value),
    Q1 = quantile(value, 0.25),
    Median = median(value),
    Q3 = quantile(value, 0.75),
    Max = max(value),
    IQR = IQR(value)
  ) %>% 
  mutate(
    LowerWhisker = pmax(Q1 - 1.5 * IQR, Min),
    UpperWhisker = pmin(Q3 + 1.5 * IQR, Max)
  )

# Creating the boxplot with annotations
p <- ggplot(df, aes(x = factor(1), y = value)) +
  geom_boxplot() +
  geom_text(data = summaries, aes(x = 1.4, y = Q1, label = paste("Q1:", round(Q1, 2))), hjust = -0.1) +
  geom_text(data = summaries, aes(x = 1.4, y = Median, label = paste("Médianne:", round(Median, 2))), hjust = -0.1) +
  geom_text(data = summaries, aes(x = 1.4, y = Q3, label = paste("Q3:", round(Q3, 2))), hjust = -0.1) +
  geom_text(data = summaries, aes(x = 1.2, y = LowerWhisker, label = paste("Minimum (début de la moustache):", round(LowerWhisker, 2))), hjust = -0.1) +
  geom_text(data = summaries, aes(x = 1.2, y = UpperWhisker, label = paste("Maximum (valeur extême):", round(UpperWhisker, 2))), hjust = -0.1) +
  scale_x_discrete(labels = NULL) + # Hide x-axis labels
  theme_minimal() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  labs(title = "Boîte à moustache avec des valeurs aléatoires")


# Display the plot
print(p)

