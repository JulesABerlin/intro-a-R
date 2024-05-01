# Session 7

library(tidyverse)

setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")

igposts <- read.csv("~/Documents/GitHub/intro-a-R/code/igposts.csv", encoding="UTF-8", na.strings="#N/A")

str(igposts)


# Transformons les colonnes 'Account', 'User.Name' et
# 'Type' en facteurs :

igposts$Account <- as.factor(igposts$Account)

igposts$User.Name <- as.factor(igposts$User.Name)

igposts$Type <- as.factor(igposts$Type)

# Vérifier, si ça a marché :

str(igposts)


# l'opérateur %>% 

sqrt(mean(c(1:100)))

c(1:100) %>% 
  mean() %>% 
  sqrt()

# dplyr

# select() : fonction pour extraire une ou plusieurs
# colonnes d'un data frame

# Par exemple, nous pouvons extraire le quatres colonnes
# suivantes d'igposts (voir comment le pipe est utilisé)

igposts %>%
  select(Account, Type, Followers.at.Posting, Total.Interactions)

# Avec les deux points dans la fonction select(), vous
# pouvez sélectionner plusieurs colonnes successives. Notez
# que cette fois-ci, nous affichons que les six premières
# lignes avec la fonction head() :

igposts %>%
  select(Account:Views) %>%
  head()

# Vous pouvez également créer un nouvel objet, df1, qui est
# essentiellement un data frame plus petit que igposts avec
# un sous-ensemble de variables (un tel data frame plus
# petit peut être plus utile à analyser et à afficher) :

df1 <- igposts %>%
  select(Account, Type, Followers.at.Posting, Total.Interactions,
         URL)


###############################################################################


# mutate() : fonction pour créer une ou plusieurs nouvelles
# colonnes dans un data frame

# Par exemple, nous pouvons créer une nouvelle colonne qui
# compte le nombre d'interactions par follower

df1 %>%
  mutate(TI_par_Follower = Total.Interactions/Followers.at.Posting)

# Attention, sans opérateur <-, nous ne changeons pas
# l'objet df1 Pour ce faire et sauvegarder notre nouvelle
# colonne, nous pouvons l'écraser :

df1 <- df1 %>%
  mutate(TI_par_Follower = Total.Interactions/Followers.at.Posting)

str(df1)







