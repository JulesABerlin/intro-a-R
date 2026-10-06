# Code commun, exécuté (sans être affiché) au début de chaque chapitre.

knitr::opts_chunk$set(tidy.opts = list(width.cutoff = 60), tidy = TRUE)

# Version PDF : les sorties de la console ne doivent pas dépasser la largeur
# de la page (les tibbles et data frames larges passent à la ligne).
pdf <- knitr::is_latex_output()
if (pdf) {
  options(width = 72, cli.width = 72, str = utils::strOptions(strict.width = "wrap"))
  # Graphiques en codage ISO Latin-9 : le codage par défaut de pdf() n'a pas « œ »
  knitr::opts_chunk$set(dev.args = list(encoding = "ISOLatin9.enc"))
}

# Les chapitres lisent les données depuis le site publié, p. ex.
# read.csv("https://julesaberlin.github.io/intro-a-R/data/igposts.csv").
# Lors du rendu, on lit plutôt la copie locale dans data/, pour que le livre
# se construise hors ligne et avant la publication des fichiers.
site_data_url <- "https://julesaberlin.github.io/intro-a-R/data/"
read.csv <- function(file, ...) {
  utils::read.csv(sub(site_data_url, "data/", file, fixed = TRUE), ...)
}

# Dans le PDF, les réponses ne figurent pas sous les questions : elles sont
# placées dans un bloc ::: {.corrige}, que le filtre corriges.lua déplace dans
# l'annexe « Corrigés ». fitb(), hide() et unhide() (questions avancées
# de la session 3) suivent la même règle.
if (pdf) {
  reponse_en_attente <- NULL
  fitb <- function(answer, ...) {
    reponse_en_attente <<- answer[1]
    "\\_\\_\\_\\_\\_\\_\\_\\_"
  }
  hide <- function(button = "Solution") {
    reponse <- if (!is.null(reponse_en_attente))
      paste0("**Réponse :** ", reponse_en_attente, "\n\n")
    reponse_en_attente <<- NULL
    paste0("\n\n::: {.corrige}\n\n", reponse)
  }
  unhide <- function() "\n\n:::\n\n"
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
# Chaque question est numérotée « Question <chapitre>.<rang> » ; son ancre stable
# (#q<ID>) reprend le numéro de la banque (non affiché), pour des liens qui ne
# changent pas.
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
  # Numéro du chapitre : la session, ou le chapitre de révision du Problem Set
  chapitre <- if (!is.null(problem_set)) c(3, 6, 9, 13)[problem_set] else session
  for (i in seq_along(ordre)) {
    afficher_question(qs[[ordre[i]]], paste0(chapitre, ".", i))
  }
  invisible(NULL)
}

afficher_question <- function(q, numero) {
  if (pdf) return(afficher_question_pdf(q, numero))
  cat("\n### Question ", numero, " {#q", q$id, " .unnumbered}\n\n", sep = "")
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

# Version PDF d'une question : l'énoncé et les options, sans réponse ; la
# réponse et l'explication vont dans un bloc .corrige (voir plus haut).
afficher_question_pdf <- function(q, numero) {
  # Une même question peut figurer dans une session et dans un chapitre de
  # révision : dans le PDF (un seul document), l'ancre inclut le chapitre.
  ancre <- paste0("q", q$id, "-", sub("\\..*", "", numero))
  cat("\n### Question ", numero, " {#", ancre, " .unnumbered}\n\n", sep = "")
  cat(q$stem, "\n\n", sep = "")
  if (!is.null(q$code)) cat("```r\n", q$code, "```\n\n", sep = "")
  if (!is.null(q$figure)) {
    graphique <- eval(parse(text = q$figure), envir = new.env())
    print(graphique)
    cat("\n\n")
  }

  options <- setdiff(names(q$options), q$drop)
  # « a\) » : une ligne par option, sans que Pandoc en fasse une liste
  ligne <- function(l, texte) cat(l, "\\) ", texte, "\n\n", sep = "")
  switch(q$type,
    vf = cat("*Vrai ou faux ?*\n\n"),
    mcq = {
      for (l in options) ligne(l, q$options[[l]])
      cat("*Une seule réponse est correcte.*\n\n")
    },
    multi = {
      for (l in options) ligne(l, q$options[[l]])
      cat("*Pour chaque proposition : vrai ou faux ?*\n\n")
    },
    numeric = ,
    text = cat("Réponse : \\_\\_\\_\\_\\_\\_\\_\\_\n\n")
  )

  reponse <- switch(q$type,
    vf = if (isTRUE(q$key)) "Vrai" else "Faux",
    mcq = paste0(q$key, "\\) ", q$options[[q$key]]),
    multi = paste0(options, "\\) ", ifelse(options %in% q$key, "Vrai", "Faux"),
                   collapse = " ; "),
    numeric = if (is.null(q$tol) || q$tol == 0) format(q$key)
              else paste0(q$key, " (à ", q$tol, " près)"),
    text = q$key[1]
  )
  explication <- gsub("(?m)^([a-e])\\)", "\n\\1\\\\)", q$explanation, perl = TRUE)
  cat("::: {.corrige}\n\n**Réponse :** ", reponse, "\n\n", explication,
      "\n\n:::\n\n", sep = "")
}
