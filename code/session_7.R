# R script session 7

library(tidyverse)

setwd("/Users/domus_julian/Documents/GitHub/intro-a-R/code")

# lire le fichier CSV igposts.csv dans RStudio

igposts <- read.csv("~/Documents/GitHub/intro-a-R/code/igposts.csv", encoding="UTF-8", na.strings="#N/A")

str(igposts)

