# Session 10

library(tidyverse)
library(ggthemes)

setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")

reponses_socio <- read.csv("~/Documents/GitHub/intro-a-R/code/reponses_socio.csv", encoding="UTF-8", stringsAsFactors=TRUE)

# Statistiques déscriptives

str(reponses_socio)

summary(reponses_socio)

# Histogramme du trajet à l'uni

ggplot(data = reponses_socio,
       mapping = aes(x=trajet)) +
  geom_histogram(fill = "steelblue", color = "black", binwidth = 10) +
  theme_minimal() +
  labs(title = "Trajet pour arriver à l'université en minutes",
       subtitle = "n = 74 participants à un questionnaire",
       x = "Trajet en minutes",
       y = "Fréquence")

# Répartition des genres

ggplot(data = reponses_socio,
       mapping = aes(x=genre, fill=genre)) +
  geom_bar()



# graphique plus sophistiquée

# changer d'abord l'ordre des catégories (commençant avec
# la plus fréquente)

ordre = c("Femme", "Homme", "Autre")

# Puis combiner dplyr avec ggplot2 !
reponses_socio %>%
  select(genre) %>%
  mutate(genre = factor(genre, levels = ordre)) %>%
  arrange(genre) %>%
  ggplot(aes(x = genre, fill = genre)) + geom_bar(show.legend = FALSE) +
  labs(title = "Répartition des genres", subtitle = "n = 74 répondants à un questionnaire",
       x = "Genre", y = "Fréquence", legend = "") + theme_minimal()

# Moyennes des notes

mean(reponses_socio$note_ecole, na.rm = TRUE)

mean(reponses_socio$note_uni, na.rm = TRUE)

cor(reponses_socio$note_ecole, 
    reponses_socio$note_uni, 
    use='complete.obs')

cor(x, y, use='complete.obs')

reponses_socio %>% select(genre,note_ecole,note_uni) %>% 
  group_by(genre) %>% 
  summarize(note_ecole_moyenne = mean(note_ecole, na.rm = TRUE),
            note_uni_moyene = mean(note_uni, na.rm = TRUE))

