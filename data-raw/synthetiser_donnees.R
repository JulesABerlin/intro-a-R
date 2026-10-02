# Crée les versions publiques des données d'étudiant·es (PLAN_book.md, étape 4).
#
# Entrées : les fichiers originaux, gardés hors du dépôt dans raw_data/
#   (dossier exclu par .gitignore) :
#   - raw_data/reponses_socio.csv  réponses au questionnaire (74 étudiant·es)
#   - raw_data/points_PS_1.csv     points du Problem Set 1, avec le numéro d'étudiant·e
#
# Sorties :
#   - data/reponses_socio.csv  copie synthétique : mêmes variables, mêmes
#     distributions et relations, mais aucune ligne ne correspond à une vraie personne
#   - data/points_PS_1.csv     groupe et points seulement
#
# À lancer depuis la racine du projet : Rscript data-raw/synthetiser_donnees.R

library(synthpop)

# 1. Questionnaire -------------------------------------------------------------

reel <- read.csv("raw_data/reponses_socio.csv", encoding = "UTF-8",
                 stringsAsFactors = TRUE)
reel <- reel[, names(reel) != "X"]  # colonne des noms de lignes

# Synthèse séquentielle par arbres de décision (CART) : chaque variable est
# tirée conditionnellement aux variables déjà synthétisées, ce qui conserve les
# relations entre variables.
#
# Protection : les variables qui permettent de reconnaître quelqu'un (année de
# naissance, genre, origine, domicile, passeport) forment des combinaisons
# uniques pour la moitié de la classe. La synthèse CART en recrée une partie.
# On synthétise donc 500 lignes, on retire toutes celles qui reproduisent une
# combinaison unique d'une vraie personne, puis on tire 74 lignes.
# On essaie 40 graines. Parmi celles dont les corrélations restent à 0,15 au
# plus des originales (environ une erreur standard de r pour n = 74), on garde
# celle dont le pMSE standardisé est le plus faible (données les plus proches).
identifiants <- c("naissance", "genre", "origine", "domicile", "suisse")
numeriques <- c("naissance", "fraterie", "trajet", "note_ecole", "note_uni")
cle <- function(d, vars = names(d)) do.call(paste, c(lapply(d[vars], as.character), sep = "|"))
cles_reelles <- cle(reel, identifiants)
uniques_reels <- cles_reelles[!cles_reelles %in% cles_reelles[duplicated(cles_reelles)]]
cor_reelle <- cor(reel[numeriques], use = "pairwise.complete.obs")

evaluer <- function(graine) {
  s <- syn(reel, method = "cart", seed = graine, k = 500, print.flag = FALSE)
  candidats <- s$syn[!cle(s$syn, identifiants) %in% uniques_reels, ]
  set.seed(graine)
  d <- candidats[sample(nrow(candidats), nrow(reel)), ]
  rownames(d) <- NULL
  s$syn <- d
  s$k <- nrow(d)
  list(graine = graine, syn = d,
       ecart_cor = max(abs(cor(d[numeriques], use = "pairwise.complete.obs") - cor_reelle)),
       S_pMSE = utility.gen(s, reel, print.flag = FALSE)$S_pMSE)
}
essais <- lapply(1:40, evaluer)
proches <- Filter(function(e) e$ecart_cor <= 0.15, essais)
stopifnot(length(proches) > 0)
choix <- proches[[which.min(sapply(proches, `[[`, "S_pMSE"))]]
synth <- choix$syn

# Contrôles : aucune combinaison unique d'une vraie personne, aucune ligne réelle
# recopiée, et les mêmes modalités que dans les données réelles
stopifnot(!any(cle(synth, identifiants) %in% uniques_reels),
          !any(cle(synth) %in% cle(reel)),
          nrow(synth) == nrow(reel))

# Les notes suisses s'arrondissent au dixième, les années et les fratries sont
# des entiers ; la synthèse CART ne tire que des valeurs observées, on arrondit
# par sécurité.
synth$note_ecole <- round(synth$note_ecole, 1)
synth$note_uni <- round(synth$note_uni, 1)
synth$naissance <- as.integer(round(synth$naissance))
synth$fraterie <- as.integer(round(synth$fraterie))

write.csv(synth, "data/reponses_socio.csv", row.names = FALSE, fileEncoding = "UTF-8")

cat("Graine retenue :", choix$graine,
    "| écart maximal entre corrélations :", round(choix$ecart_cor, 2),
    "| S_pMSE :", round(choix$S_pMSE, 2), "\n")

# 2. Points du Problem Set 1 -----------------------------------------------------

points <- read.csv("raw_data/points_PS_1.csv", encoding = "UTF-8")
write.csv(points[, c("groupe", "points")], "data/points_PS_1.csv",
          row.names = FALSE, fileEncoding = "UTF-8")
