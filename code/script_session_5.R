# Session 5
library(tidyverse)
library(ggthemes)

# 1. nuage de points

data(iris)

str(iris)

np1 <- ggplot(data = iris,
       mapping = aes(Sepal.Length, Sepal.Width)) +
  geom_point() +
  labs(title = "Longueur et largeur de sépales dans iris")

print(np1)

np1 + geom_smooth(method = lm)


np1 <- ggplot(data = iris,
              mapping = aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  labs(title = "Longueur et largeur de sépales dans iris")

print(np1)

# 2. diagrammes à barres

db1 <- ggplot(data = diamonds,
              mapping = aes(x = cut, fill = cut)) + 
  geom_bar() +
  labs(title = "Cut qualities in the diamonds dataset")
  
print(db1)

# 3. les histogrammes

# la fonction rnorm()

?rnorm()

rnorm(100, 20, 5)

# tailles des gens en Suisse
# femmes : moyenne = 164.7 cm, écart-type = 5.6 cm

taille_f <- rnorm(500, mean = 164.7, sd = 5.6)

head(taille_f)

taille_f <- as.data.frame(taille_f)

# histogramme de la taille des femmes en Suisse
library(ggthemes)


hist1 <- ggplot(data = taille_f,
                mapping = aes(x = taille_f)) + geom_histogram(binwidth = 1, color = "black",
                                                              fill = "white") +
  theme_bw() + labs(title = "Histogramme de tailles de femmes en Suisse",
                    subtitle = "Simulation de 500 tailles aléatoires",
                    x = "Taille en cm",
                    y = "Fréquence")
print(hist1)


# les boxplots

str(mtcars)

mtcars$cyl <- as.factor(mtcars$cyl)

box1 <- ggplot(data = mtcars,
               mapping = aes(x = cyl, y = mpg, fill = cyl)) + geom_boxplot(alpha = 0.6)

print(box1)

