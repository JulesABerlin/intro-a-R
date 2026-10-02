# Code commun, exécuté (sans être affiché) au début de chaque chapitre.

knitr::opts_chunk$set(tidy.opts = list(width.cutoff = 60), tidy = TRUE)

# Les chapitres lisent les données depuis le site publié, p. ex.
# read.csv("https://julesaberlin.github.io/intro-a-R/data/igposts.csv").
# Lors du rendu, on lit plutôt la copie locale dans data/, pour que le livre
# se construise hors ligne et avant la publication des fichiers.
site_data_url <- "https://julesaberlin.github.io/intro-a-R/data/"
read.csv <- function(file, ...) {
  utils::read.csv(sub(site_data_url, "data/", file, fixed = TRUE), ...)
}

# Liste déroulante Vrai / Faux pour webexercises (torf() n'offre que TRUE / FALSE)
vf <- function(x) {
  if (x) webexercises::mcq(c(answer = "Vrai", "Faux"))
  else webexercises::mcq(c("Vrai", answer = "Faux"))
}

# Exercices tirés de la banque de questions (question-bank/questions.yml).
# À appeler dans un chunk avec `echo: false` et `results: asis` :
#   exercices(session = 2)       questions de la session 2 (sans les variantes)
#   exercices(problem_set = 1)   les questions du Problem Set 1
# Les questions qui dépendent d'une image manquante (needs_image) sont omises.
exercices <- function(session = NULL, problem_set = NULL, variantes = FALSE,
                      fichier = "question-bank/questions.yml") {
  qs <- yaml::read_yaml(fichier)
  garder <- function(q) {
    if (isTRUE(q$needs_image)) return(FALSE)
    if (!is.null(problem_set)) return(problem_set %in% q$problem_sets)
    q$session %in% session && (variantes || is.null(q$variant_of))
  }
  qs <- Filter(garder, qs)
  ordre <- order(sapply(qs, `[[`, "session"), sapply(qs, `[[`, "id"))
  for (i in seq_along(ordre)) afficher_question(qs[[ordre[i]]], i)
  invisible(NULL)
}

afficher_question <- function(q, numero) {
  cat("\n### Question ", numero, " [n° ", q$id, "]{.small .text-muted}\n\n", sep = "")
  cat(q$stem, "\n\n", sep = "")
  if (!is.null(q$code)) cat("```r\n", q$code, "```\n\n", sep = "")
  if (!is.null(q$figure)) {
    graphique <- eval(parse(text = q$figure), envir = new.env())
    print(graphique)
    cat("\n\n")
  }

  if (identical(q$key, "TBD")) {
    if (q$type == "multi") {
      for (l in setdiff(names(q$options), q$drop)) cat(l, ") ", q$options[[l]], "\n\n", sep = "")
    }
    cat("*Corrigé en cours de révision : il sera recalculé avec le nouveau jeu de données.*\n\n")
  } else {
    switch(q$type,
      vf = cat(vf(q$key), "\n\n"),
      mcq = {
        choix <- unlist(q$options)
        names(choix) <- ifelse(names(q$options) == q$key, "answer", "")
        cat(webexercises::longmcq(choix), "\n\n")
      },
      multi = {
        for (l in setdiff(names(q$options), q$drop)) {
          cat(l, ") ", q$options[[l]], " ", vf(l %in% q$key), "\n\n", sep = "")
        }
      },
      numeric = cat("Réponse : ", webexercises::fitb(q$key, num = TRUE, tol = q$tol,
                                                     width = max(4, nchar(q$key))), "\n\n"),
      text = cat("Réponse : ", webexercises::fitb(q$key, ignore_case = TRUE), "\n\n")
    )
  }

  # Une ligne « a) … » par paragraphe, sans que Pandoc en fasse une liste
  # (il renumérote les listes : « a) b) d) » deviendrait « a) b) c) »)
  explication <- gsub("(?m)^([a-e])\\)", "\n\\1\\\\)", q$explanation, perl = TRUE)
  cat(webexercises::hide("Explication"), explication, webexercises::unhide(), sep = "")
}
