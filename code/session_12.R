# Session 12
setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")

library(tidyverse)

# install.packages("palmerpenguins")

library(palmerpenguins)

# install.packages("stats")

library(stats)

?palmerpenguins

# test t

scores_qi <- rnorm(500, mean = 105, sd = 15)

scores_qi

resultat_test_t <- t.test(scores_qi, mu = 100)

print(resultat_test_t)


scores_qi <- rnorm(50, mean = 105, sd = 15)

scores_qi

resultat_test_t <- t.test(scores_qi, mu = 100)

print(resultat_test_t)

# Données exemplaires :
tailles_f <- rnorm(5, mean = 177.4, sd = 5.6)
tailles_h <- rnorm(5, mean = 164.7, sd = 6.1)

# Two-sample t-test
t_test_two_sample <- t.test(tailles_f, tailles_h)
print(t_test_two_sample)

# ANOVA

library(palmerpenguins)
# Visualisez les distributions de flipper length avec des
# boxplots
ggplot(penguins, aes(x = species, y = flipper_length_mm)) + geom_boxplot()

# Calculs des variances de flipper length avec dplyr par
# espèce de pingouin, pour vérifier si l'hypothèse des
# variances similaire entre groupes est satisfaite :
penguins %>%
  group_by(species) %>%
  summarize(var_fl = var(flipper_length_mm, na.rm = TRUE))

# ANOVA avec aov()
anova_1 <- aov(flipper_length_mm ~ species, data = penguins)
summary(anova_1)

# à noter, avec TukeyHSD() nous pouvons vérifier d'avantage
# les différence entre chaque paire de variables des trois
# groupe :
TukeyHSD(anova_1)

# régression linéaire

# Charger le jeu de données mtcars
data(mtcars)

# Ajuster un modèle de régression linéaire avec mpg comme
# variable dépendante et wt comme variable indépendante
modele_1 <- lm(mpg ~ wt, data = mtcars)

# Afficher le résumé du modèle que nous pouvons interpréter
summary(modele_1)
