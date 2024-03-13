# script pour faire un histogramme des points obtenus dans le Problem Set 1
# cours : Exercices Méthodes II
# date : 6/7 mars 2024
# auteur : Julian Maitra

library(tidyverse)
library(ggthemes)
library(scales) # il faut d'abord installer ce paquet, si vous ne l'avez pas encore

# Adaptez le code suivant pour votre répertoire de travail :

setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")

# Enregistrez le fichier CSV points_ps_2 dans votre répertoire de travail, 
# puis importez les données dans R (modifiez le code suivant selon votre ordinateur) :

points_ps_1 <- read.csv("~/Documents/GitHub/intro-a-R/code/points_PS_1.csv", encoding="UTF-8")

#points_ps_1 # il y a 81 observations de trois variables : etudiant.e, groupe et points

hist_ps_1 <-ggplot(points_ps_1, 
                   aes(x=points)) + 
  geom_histogram(binwidth = 1, color="black", fill="white") +
  labs(title = "Histogramme des points obtenus dans le PS 1", # labs() permet de définir plusieurs labels en même temps (titre, axes, etc.)
       subtitle = "n = 81 résultats de test", 
       caption = "Source des données : Moodle") +       
  xlab("Points obtenus") +                             
  ylab("Fréquence") + 
  scale_x_continuous(breaks=seq(1, 20, 1)) + # cette couche définit les unité de l'axe x
  scale_y_continuous(breaks=seq(0, 20, 2)) + # cette couche définit les unité de l'axe x
  theme_minimal() 
hist_ps_1

mean(points_ps_1$points)


points_ps_3 <- read.csv("C:/Users/julim/switchdrive/001_Exercices_Methodes_2_SP_22/sessions/10_lecon_test/hist_test_3.csv", encoding="UTF-8", na.strings="")

points_ps_3

str(points_ps_3)

hist_ps_3 <-ggplot(points_ps_3, 
                   aes(x=points_ps_3)) + 
  geom_histogram(binwidth = 2, color="black", fill="white") +
  labs(title = "Histogramme des points obtenus dans le 3e test", # labs() permet de définir plusieurs labels en même temps (titre, axes, etc.)
       subtitle = "n = 78 résultats de test", 
       caption = "Source des données : Moodle") +       
  xlab("Points obtenus") +                             
  ylab("Fréquence") + 
  scale_x_continuous(breaks=seq(20, 60, 2)) + # cette couche définit les unité de l'axe x
  theme_minimal() 
hist_ps_3




# FIN
