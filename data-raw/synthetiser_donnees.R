# Crée les versions publiques des données d'étudiant·es (PLAN_book.md, étape 4).
#
# Entrées : les fichiers originaux, gardés hors du dépôt dans raw_data/
#   (dossier exclu par .gitignore) :
#   - raw_data/reponses_socio.csv  réponses au questionnaire (74 étudiant·es)
#   - raw_data/points_PS_1.csv     points du Problem Set 1, avec le numéro d'étudiant·e
#
# Sorties :
#   - data/reponses_socio.csv  copie synthétique : mêmes variables, distributions
#     et relations semblables, mais aucune ligne ne correspond à une vraie personne
#   - data/points_PS_1.csv     groupe et points seulement
#
# Ce script ne contient aucune valeur réelle : toutes les règles sont calculées
# à partir des fichiers de raw_data/.
#
# À lancer depuis la racine du projet : Rscript data-raw/synthetiser_donnees.R

library(synthpop)

k_min <- 3  # chaque valeur publiée doit être partagée par au moins 3 personnes

# 1. Questionnaire -------------------------------------------------------------

reel <- read.csv("raw_data/reponses_socio.csv", encoding = "UTF-8",
                 stringsAsFactors = FALSE)
reel <- reel[, names(reel) != "X"]  # colonne des noms de lignes

# 1a. Recodage avant la synthèse ------------------------------------------------
# La synthèse CART ne produit que des valeurs observées : une valeur rare (la
# seule personne née une certaine année, le seul trajet de 3 heures…) peut donc
# réapparaître telle quelle. On recode d'abord les données pour que chaque
# valeur soit partagée par au moins k_min personnes.

# Variables numériques : tant qu'une valeur est portée par moins de k_min
# personnes, on la fusionne avec la valeur voisine la plus fréquente (vers le
# centre en cas d'égalité). Pour les extrêmes, cela revient à un codage
# plafond/plancher (top/bottom coding).
regrouper_rares <- function(x, k = k_min) {
  repeat {
    n <- table(x)
    if (min(n) >= k) return(x)
    v <- as.numeric(names(n))
    rares <- which(n == min(n))
    i <- rares[which.max(abs(v[rares] - median(x, na.rm = TRUE)))]  # le plus extrême
    voisins <- c(i - 1, i + 1)
    voisins <- voisins[voisins >= 1 & voisins <= length(v)]
    cible <- voisins[order(-n[voisins], abs(v[voisins] - median(x, na.rm = TRUE)))[1]]
    x[!is.na(x) & x == v[i]] <- v[cible]
  }
}

# Variables catégorielles : les modalités portées par moins de k_min personnes
# sont regroupées sous une étiquette commune ; si ce groupe reste trop petit,
# on y ajoute la plus petite des autres modalités.
regrouper_modalites <- function(x, etiquette, k = k_min) {
  n <- sort(table(x))
  groupe <- names(n)[n < k]
  if (length(groupe) == 0) return(x)
  while (sum(n[groupe]) < k) groupe <- c(groupe, names(n)[length(groupe) + 1])
  x[x %in% groupe] <- etiquette
  x
}

base <- reel
base$trajet <- pmax(5, round(base$trajet / 5) * 5)  # minutes arrondies à 5
for (v in c("naissance", "fraterie", "trajet", "note_ecole", "note_uni")) {
  base[[v]] <- regrouper_rares(base[[v]])
}
base$domicile <- regrouper_modalites(base$domicile, "Autre canton")
base$origine <- regrouper_modalites(base$origine, "Autre continent")
base$permis[base$permis == "N/A"] <- NA  # non-réponse : valeur manquante
# Exception volontaire : la modalité « Autre » de genre (moins de k_min
# personnes) est conservée, pour ne pas effacer les personnes non binaires.
base[] <- lapply(base, function(x) if (is.character(x)) factor(x) else x)

# 1b. Synthèse ------------------------------------------------------------------
# Synthèse séquentielle par arbres de décision (CART) : chaque variable est
# tirée conditionnellement aux variables déjà synthétisées, ce qui conserve les
# relations entre variables.
#
# Protection : les variables qui permettent de reconnaître quelqu'un (année de
# naissance, genre, origine, domicile, passeport) forment des combinaisons
# uniques pour une partie de la classe. La synthèse CART en recrée certaines.
# On synthétise donc 500 lignes, on retire toutes celles qui reproduisent une
# combinaison unique d'une vraie personne ou une ligne réelle entière, puis on
# tire 74 lignes.
# On essaie 150 graines. Parmi celles dont les corrélations restent à 0,15 au
# plus de celles des données recodées (environ une erreur standard de r pour
# n = 74), on garde celle dont le pMSE standardisé est le plus faible. Le recodage
# déplace lui-même un peu les corrélations, car quelques valeurs extrêmes pèsent
# lourd dans un échantillon de 74 personnes.
identifiants <- c("naissance", "genre", "origine", "domicile", "suisse")
numeriques <- c("naissance", "fraterie", "trajet", "note_ecole", "note_uni")
cle <- function(d, vars = names(d)) do.call(paste, c(lapply(d[vars], as.character), sep = "|"))
cles_base <- cle(base, identifiants)
uniques_reels <- cles_base[!cles_base %in% cles_base[duplicated(cles_base)]]
correlations <- function(d) cor(d[numeriques], use = "pairwise.complete.obs")
cor_reelle <- correlations(reel)
cor_base <- correlations(base)

evaluer <- function(graine) {
  s <- syn(base, method = "cart", seed = graine, k = 500, print.flag = FALSE)
  candidats <- s$syn[!cle(s$syn, identifiants) %in% uniques_reels &
                       !cle(s$syn) %in% cle(base), ]
  set.seed(graine)
  d <- candidats[sample(nrow(candidats), nrow(base)), ]
  rownames(d) <- NULL
  s$syn <- d
  s$k <- nrow(d)
  list(graine = graine, syn = d,
       ecart_cor = max(abs(correlations(d) - cor_base)),
       S_pMSE = utility.gen(s, base, print.flag = FALSE)$S_pMSE)
}
essais <- lapply(1:150, evaluer)
proches <- Filter(function(e) e$ecart_cor <= 0.15, essais)
stopifnot(length(proches) > 0)
choix <- proches[[which.min(sapply(proches, `[[`, "S_pMSE"))]]
synth <- choix$syn

# 1c. Contrôles -----------------------------------------------------------------
# - aucune combinaison unique d'identifiants d'une vraie personne ;
# - aucune ligne réelle recopiée (ni dans les données recodées, ni dans les originales) ;
# - chaque valeur publiée est portée par au moins k_min personnes réelles
#   (sauf l'exception volontaire de genre).
stopifnot(!any(cle(synth, identifiants) %in% uniques_reels),
          !any(cle(synth) %in% cle(base)),
          !any(cle(synth) %in% cle(reel)),
          nrow(synth) == nrow(base))
for (v in setdiff(names(base), "genre")) {
  n <- table(base[[v]])
  stopifnot(all(as.character(na.omit(unique(synth[[v]]))) %in% names(n)[n >= k_min]))
}

write.csv(synth, "data/reponses_socio.csv", row.names = FALSE, fileEncoding = "UTF-8")

cat("Graine retenue :", choix$graine, "| S_pMSE :", round(choix$S_pMSE, 2), "\n",
    "Écart maximal entre corrélations : synthétiques/recodées", round(choix$ecart_cor, 2),
    "| recodées/originales", round(max(abs(cor_base - cor_reelle)), 2),
    "| synthétiques/originales", round(max(abs(correlations(synth) - cor_reelle)), 2), "\n")

# 2. Points du Problem Set 1 -----------------------------------------------------

points <- read.csv("raw_data/points_PS_1.csv", encoding = "UTF-8")
write.csv(points[, c("groupe", "points")], "data/points_PS_1.csv",
          row.names = FALSE, fileEncoding = "UTF-8")
