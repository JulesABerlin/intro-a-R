# R script session 7

library(tidyverse)

setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")

# lire le fichier CSV igposts.csv dans RStudio

igposts <- read.csv("~/Documents/GitHub/intro-a-R/code/igposts.csv", encoding="UTF-8", na.strings="#N/A")

str(igposts)

# Transformations du type de variable

igposts$Account <- as.factor(igposts$Account)

# Transformons les colonnes 'Account', 'User.Name' et
# 'Type' en facteurs :

igposts$User.Name <- as.factor(igposts$User.Name)

igposts$Type <- as.factor(igposts$Type)

# Vérifier, si ça a marché :

str(igposts)

# l'opérateur %>% (pipe)

log(sqrt(mean(c(1:100))))

c(1:100) %>% 
  mean() %>% 
  sqrt() %>% 
  log()

# dplyr

# select()

igposts %>% 
  select(Account, Type, Total.Interactions, Followers.at.Posting) %>% 
  head()

df1 <-igposts %>% 
  select(Account, Type, Total.Interactions, Followers.at.Posting) 


# mutate()

df1 <- df1 %>% mutate(TI_par_Follower = Total.Interactions/Followers.at.Posting)

# filter()

# filter() : fonction pour filtrer les lignes selon un ou
# plusieurs critères

df1 %>%
  filter(Account == "Cristiano Ronaldo")

df1 %>%
  filter(Account == "Cristiano Ronaldo", Type == "Photo")

df1 %>%
  filter(Total.Interactions >= 1e+07)

df1 %>%
  filter(Account == "Selena Gomez", Total.Interactions >= 1e+07)

# arrange()

# arrange() : fonction pour trier les lignes selon un ou
# plusieurs critères

df1 %>%
  arrange(Account) %>%
  head(10)

df1 %>%
  arrange(Total.Interactions) %>%
  head(10)

df1 %>%
  arrange(desc(TI_par_Follower)) %>%
  head(10)

# summarize()

# summarize() : fonction qui réduit une ou plusieurs
# colonnes en une seule ligne, notamment pour résumer des
# données

df1 %>%
  summarize(sum_TI = sum(Total.Interactions))

df1 %>%
  summarize(mean_TI = mean(Total.Interactions), mean_Followers = mean(Followers.at.Posting))

# count()

# count() : fonction qui compte le nombre d'observations
# d'une ou plusieurs catégories

df1 %>%
  count(Type)

df1 %>%
  count(Account)

df1 %>%
  count(Account) %>%
  arrange(-n) %>%
  head(10)

# group_by()

# group_by() : fonction qui regroupe des données selon une
# ou plusieurs catégories

df1 %>%
  group_by(Type) %>%
  summarize(mean_TI = mean(Total.Interactions))

df1 %>%
  group_by(Type) %>%
  summarize(n = n(), mean_TI = mean(Total.Interactions))

df1 %>%
  group_by(Account) %>%
  summarize(n = n(), mean_Followers = mean(Followers.at.Posting),
            mean_TI = mean(Total.Interactions)) %>%
  arrange(desc(n)) %>%
  head(10)
