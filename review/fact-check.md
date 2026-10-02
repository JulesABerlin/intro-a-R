# Fact-check and correctness review: *Exercices Méthodes II* (Quarto book)

**Version reviewed:** branch `book` as pushed to GitHub (`JulesABerlin/intro-a-R`), fetched 2 Oct 2026. That covers `index.qmd`, `sessions/session-01.qmd` … `session-14.qmd`, `question-bank/questions.yml` (125 questions) and `data/`. Commits made locally after the last push (e.g. the rights-audit fixes) are not included. The chapter text itself has not changed since the split from `index.qmd`.

**How it was checked**

- **Code and numbers.** Every numerical claim in the text and every answer key that R can compute was recomputed in R 4.x (ggplot2 3.4, dplyr, palmerpenguins), with the same seeds. That covers the t-tests, ANOVA, regressions, stepwise selection, `mtcars`/`diamonds`/`iris`/`penguins` facts, `igposts.csv`, the synthetic `reponses_socio.csv` and the Problem Set scores.
- **Methodology.** Statistical statements were checked against standard references (listed at the end): the ASA statement on p-values, R documentation, *R for Data Science*, OpenIntro Statistics, Harrell's *Regression Modeling Strategies*.
- **External facts.** Swiss internet use, Swiss heights, bibliographic details and historical claims were checked against primary sources where available.
- **Not done here.** External links could not be checked from this sandbox, whose network blocks most sites; run a link checker locally (see §4).

**Severity**

| Level | Meaning |
|---|---|
| **A** | Wrong, or teaches a misconception. Fix before publishing. |
| **B** | Imprecise or misleading. Should be fixed. |
| **C** | Minor: wording, language, outdated course logistics. |

Proposed replacements are in French, ready to paste.

---

## 1. Summary

| | A | B | C |
|---|---|---|---|
| Sessions 1–9, 13–14 | 4 | 23 | ~20 |
| Sessions 10–12 (statistics) | 17 | 14 | ~8 |
| Question bank | 2 | 5 | 3 |

**What is solid:** every numerical result in the text and every answer key that can be computed matches R. That is 60+ checks across t-tests, ANOVA, regressions, Problem Set statistics, the dataset facts and all session 8 model answers. The synthetic-data keys (40, 70–73, 76, 83, 116) match the published `reponses_socio.csv`.

**What needs work is the interpretation, not the arithmetic.** Most A-level problems are in sessions 11–12:

1. **p-values and hypotheses are misstated** in several places: "probability that the result is due to chance", "H0 = the difference is not significant", "95 % confidence intervals" used for the significance level. These are the misreadings that the corrected key of question 43 now tells students to avoid, so the book currently contradicts its own exercises.
2. **Causal claims from regression on observational data.** The text presents regression as a way to "quantify the causal relationship" between education and salary.
3. **Stepwise selection is presented as producing "the optimal model".**
4. **Wrong function names or code:** `test.t()` instead of `t.test()`, and `install.packages("stats")`.

Three recurring wording errors run through the whole book:

- **`mpg` is not fuel consumption.** It measures fuel *efficiency* (distance per gallon). "Consommation … diminue de 5,345 miles" and "consomment plus de `mpg`" therefore say the opposite of what is meant. About 8 places.
- **Penguins.** The Palmer Penguins are *manchots*; in French a *pingouin* is an auk (northern hemisphere). 5 places in session 12, 7 in the question bank.
- **Course logistics.** Moodle links, Problem Set dates and the 2024/2025 dates are inconsistent and meaningless for a public book (see §4).

---

## 2. Chapter by chapter

### Session 1: Introduction

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 1.1 | **A** | 87 | « le nombre entre crochets indique la ligne du résultat » | `[1]` is the **index of the first element** shown on that line, not a line number. This becomes visible with long vectors, e.g. `1:30` shows `[1]` and then `[26]`. | « Le nombre entre crochets indique la **position du premier élément** affiché sur cette ligne. Ici, il n'y a qu'un élément, donc `[1]`. Essayez `1:30` pour voir la différence. » |
| 1.2 | **A** | 351 | « on ne peut généralement pas mélanger les valeurs numériques, textuelles et logiques dans le même vecteur » | You *can* write `c(1, "a", TRUE)`, and R gives no error: it silently **converts** everything to the most general type, here `"1" "a" "TRUE"`. Students need to understand this coercion, because it causes many bugs later. | « Un vecteur ne contient qu'**un seul type** de données. Si l'on mélange des types, R les convertit sans prévenir vers le type le plus général (logique → numérique → texte) : `c(1, "a", TRUE)` donne `"1" "a" "TRUE"`. » |
| 1.3 | B | 146–150 | « C'est pourquoi R est également appelé langage de programmation orienté objet » | The reasoning doesn't hold: talking about objects doesn't make a language object-oriented. R is multi-paradigm, mostly functional, with several object systems (S3, S4, R6). | « En R, tout ce que l'on manipule (une valeur, un vecteur, un tableau, une fonction) est un **objet** qui porte un nom. » Then drop the "orienté objet" claim. |
| 1.4 | B | 318–319 | « insérés entre les crochets » | Function arguments go between **parentheses** `()`. *Crochets* `[]` are used for indexing (session 2). | « entre les **parenthèses** » |
| 1.5 | C | 246 | `c <- "chien"` | It works, because R still finds the function `c()`, but naming an object `c` is bad practice in a lesson that introduces `c()` right afterwards. | Use `animal1 <- "chien"`, `animal2 <- "chat"`. |
| 1.6 | C | 264 | binary categories « homme/femme » | Not wrong as an example of coding, but the book's own data contain a third category, "Autre". A neutral example avoids the tension. | e.g. « a un permis / n'a pas de permis », « mineur/majeur », « a répondu / n'a pas répondu ». |
| 1.7 | C | 10–13 | « Bienvenue … Bachelor … Fribourg », « Sur cette page Github » | Course-specific (see §4). | Rephrase for the public book. |

### Session 2: Commandes de base II

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 2.1 | **A** | 212–213 | « Extraire la moitié supérieure de la matrice : `m4[c(6:10),]` » | Rows 6–10 are the **lower** half. | « Extraire la moitié **inférieure** (lignes 6 à 10) : `m4[6:10, ]` », and optionally add the upper half: `m4[1:5, ]`. |
| 2.2 | B | 428 | `factor(tailles, order = TRUE, …)` | The argument is called `ordered`. `order =` only works through R's partial matching, which is discouraged and fragile. | `factor(tailles, ordered = TRUE, levels = c("Small", "Medium", "Large"))` |
| 2.3 | B | 436–451 | « Transformons maintenant la colonne `species` … » | The transformation code is commented out, so nothing happens and the second `str()` is never run. | Un-comment both lines. |
| 2.4 | B | 456–490 | `setwd()` as the recommended way to work | Defensible for beginners, but current best practice is an **RStudio Project** (`.Rproj`) with relative paths, or `here::here()`. `setwd()` breaks as soon as code moves to another computer, as the text itself admits. | Add a tip: « Bonne pratique : créez un **projet RStudio** (*File → New Project*). Le répertoire de travail est alors défini automatiquement et vos chemins restent valables sur tout ordinateur. » Source: Bryan (2017); R4DS 2e, ch. « Workflow: scripts and projects ». |
| 2.5 | C | 190 | « parenthèses carrées `[]` » | The French term is « crochets ». | « **crochets** `[]` » |
| 2.6 | C | 39 | « avec un colon » | Anglicism. | « avec le deux-points `:` » |
| 2.7 | C | 222 | « (français : *cadre de données*) » | Rarely used in French; the usual terms are « tableau de données » or simply « data frame ». | « (en français : *tableau de données*) » |
| 2.8 | C | 484–485 | the teacher's personal path `C:/Users/julim/switchdrive/…` | Personal path; dates (SP 22). | Replace with a generic example. |
| 2.9 | C | 492–525 | Problem Set 1 instructions (Moodle, groups A–D, my.unifr) | Course logistics (§4). | Remove or move to an "À propos du cours" box. |

### Session 3: Problem Set 1 (review)

All figures were checked against `points_PS_1.csv`: n = 62, mean 14.19, 59 passed (95.2 %). ✔︎

| # | Lvl | Line | Problem | Proposed fix |
|---|---|---|---|---|
| 3.1 | C | 9–20 | Moodle and course-result framing (§4). | « Lors de l'édition SP 2025 du cours, n = 62 étudiant·es ont passé ce test… » or remove. |
| 3.2 | C | — | The grade conversion (« note = 4.75 ») depends on the UniFR grading scale and means nothing to outside readers. | Remove, or explain the 1–6 scale. |

The model solutions to the advanced questions A1–A10 were rechecked in R: all correct.

### Session 4: Paquets, jeux de données, ggplot2

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 4.1 | B | 166–170 | « Les données d'iris … récoltées par Edgar Anderson en 1935 sur la péninsule de Gaspésie » | Anderson **published** in 1935. According to Anderson and the standard accounts, only **two** of the three species (setosa, versicolor) were collected in Gaspé, all from the same pasture. | « Les mesures ont été publiées par le botaniste Edgar Anderson (1935) ; deux des trois espèces proviennent de la péninsule de Gaspé (Québec). Ronald Fisher les a rendues célèbres dans un article de 1936. » |
| 4.2 | B | 166–168 | Fisher (1936) article | Correct. Many current teaching materials note that the 1936 paper appeared in the *Annals of Eugenics* and that Fisher was a prominent eugenicist; some now prefer `penguins` to `iris` for this reason. That's a choice for you; a one-line note would be honest. | Optional: « L'article est paru dans les *Annals of Eugenics* ; Fisher était aussi un défenseur de l'eugénisme, ce qui explique que certains enseignant·es préfèrent aujourd'hui d'autres jeux de données. » |
| 4.3 | B | 142–151 | « quatre jeux de données classiques … intégrés » including `palmerpenguins` | Only `iris` and `mtcars` come with base R. `diamonds` comes with **ggplot2**, `penguins` with the **palmerpenguins** package (installed separately in session 12). `palmerpenguins` is also never shown in this session. | « …des jeux de données fournis avec R (`iris`, `mtcars`) ou avec des paquets (`diamonds` dans ggplot2, `penguins` dans palmerpenguins, que nous verrons en session 12). » |
| 4.4 | B | 309–311 | « *ggplot2* est donc un acronyme formé à partir des mots *grammar of graphics plots* » | The "gg" stands for *grammar of graphics* (Wilkinson 2005, implemented by Wickham 2010). The "plots" expansion isn't documented. The "2" marks the successor to Wickham's earlier `ggplot` package. | « Le « gg » de *ggplot2* signifie *grammar of graphics* (Wilkinson, 2005), une théorie que Hadley Wickham a implémentée dans R ; le « 2 » distingue le paquet de sa première version, `ggplot`. » |
| 4.5 | C | 180 | « l'estimation du maximum likelihood » | French term. | « l'estimation par **maximum de vraisemblance** » |
| 4.6 | C | 233, 292 | `?iris()`, `?diamonds()` | Works (checked), but unusual for datasets. | `?iris`, `?diamonds` |
| 4.7 | C | 154–155 | `data()` « affiche les jeux de données accessibles sur votre ordinateur » | It lists the datasets in the **currently loaded** packages. | « …les jeux de données des paquets actuellement chargés » |
| 4.8 | C | 37 | `http://cran.r-project.org` | http → https. | `https://cran.r-project.org` |

Verified ✔︎: iris 150 × 5 with 50 per species; diamonds 53,940 rows; the 4C (GIA); Fisher's dates (1890–1962); `ggplot()` with data only gives an empty grey panel.

### Session 5: Visualisations II

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 5.1 | B | 214 | « si elles présentent un plateau (kurtosis) » | Kurtosis measures the weight of the **tails**, not flatness or "peakedness" (Westfall 2014). | « …si elles sont asymétriques (*skewness*) ou si elles ont des queues plus ou moins épaisses que la loi normale (*kurtosis*). » |
| 5.2 | B | 223–226 | « ggplot2 calcule automatiquement la taille des intervalles » | ggplot2 uses a fixed **default of 30 bins** and prints a message asking you to choose a better value. It doesn't optimise anything. | « Par défaut, `geom_histogram()` découpe les données en 30 intervalles (*bins*) et affiche un message invitant à choisir une meilleure valeur avec `binwidth` ou `bins`. » |
| 5.3 | B | 349–355 + figure | Boxplot: « minimum (début de la moustache) … maximum (fin de la moustache) » | In ggplot2 (Tukey's convention), the whiskers end at the **most extreme data points within 1.5 × IQR** of the box; points beyond are drawn individually as outliers. The whiskers equal the min and max only when there are no outliers. The annotated figure also labels the fence (Q1 − 1.5 × IQR) as « Minimum (valeur extrême) », which isn't a data value. | « Les moustaches s'étendent jusqu'aux valeurs les plus extrêmes situées à moins de 1,5 × l'écart interquartile de la boîte ; les valeurs au-delà sont dessinées comme des points (valeurs extrêmes potentielles). » Fix the figure labels accordingly. |
| 5.4 | B | 76–79 | « la zone grise … indique une marge d'erreur » | It's the **95 % confidence interval** of the fitted line (the default `se = TRUE`, `level = 0.95`). | « …la zone grise est l'intervalle de confiance à 95 % de la droite de régression. » |
| 5.5 | B | 108–110 | The three regression lines become positive | Correct (r = 0.74, 0.53, 0.46 within species; −0.12 overall). This is the classic **Simpson's paradox**, and naming it makes the point memorable. | Add: « Ce renversement s'appelle le **paradoxe de Simpson** : une tendance globale peut s'inverser lorsqu'on tient compte d'une variable de groupe. » |
| 5.6 | B | 264–269 | Heights: 24 heures article, 164.7 / 177.4 cm, sd 5.6 / 6.1 | The means are close to the authoritative figures, but the source is a newspaper calculator and the **SDs are too small**. Swiss Health Survey 2017 (Staub et al. 2022): women 164.6 cm (sd 6.5), men 177.0 cm (sd 7.1). | Cite Staub et al. (2022). Either keep 164.7/177.4 as "d'après l'Enquête suisse sur la santé 2017, environ…" or update the values. Changing them also changes the simulated outputs and the keys of questions 34 and 104, so it's simpler to keep the means and only fix the source. |
| 5.7 | **A** | 412–443 + line 436 | « consommation de carburant (`mpg`) » | `mpg` is **efficiency** (miles per gallon): higher means *less* consumption. The conclusion at l. 454–460 is phrased correctly; the labels are not. | « l'efficacité énergétique (`mpg`, miles par gallon) ». Title: « Miles par gallon (mpg) selon le nombre de cylindres ». |
| 5.8 | C | 462–501 | Problem Set 2 instructions and the LimeSurvey announcement (deadline 31 March 2025, bonus points) | Course logistics (§4). | Remove. |

### Session 6: Problem Set 2 (review)

n = 65, mean 12.75, 56 passed (86.2 %). ✔︎ Only the logistics framing applies (§4).

### Session 7: Manipuler les données I

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 7.1 | B | 247–248 | « `|>` comme opérateur pipe alternatif (équivalent à `%>%`) » | Similar, not equivalent. `|>` is built into R (≥ 4.1) and needs no package; it always requires parentheses (`x |> f()`) and uses the placeholder `_` instead of `.`. | « …le pipe natif de R `|>` (depuis R 4.1), qui fonctionne sans paquet et s'utilise de la même façon dans les cas simples. » |
| 7.2 | B | 155–170 | « Vous ne devez pas ouvrir les fichiers CSV avec Excel … cela modifie automatiquement le format » | Opening a file doesn't change it; *saving* it from Excel can (dates, leading zeros, separators, encoding). | « N'enregistrez pas un fichier CSV après l'avoir ouvert dans Excel : Excel peut modifier les dates, les zéros initiaux, le séparateur ou l'encodage. » |
| 7.3 | B | 128, everywhere | `read.csv(…, encoding = "UTF-8")` | The CSV files start with a **byte-order mark (BOM)**. In R on older Windows versions, or any non-UTF-8 locale, the first column is then read as `ï..Account` or `X.U.FEFF.Account`, and `igposts$Account` no longer exists. Reproduced here. `encoding=` doesn't remove the BOM; `fileEncoding = "UTF-8-BOM"` does. | Simplest fix: **remove the BOM from all CSVs in `data/`** once, e.g. `readr::write_csv()` or re-save without BOM. Then `encoding = "UTF-8"` is enough on every system. |
| 7.4 | C | 79–81 | Link to the UniFR Moodle course | Not accessible to the public (§4). | « Téléchargez le fichier depuis [data/igposts.csv](…) ou lisez-le directement depuis le site. » |
| 7.5 | C | 25 | « Lire des données **auf** format CSV » | Typo (German). | « au format CSV » |
| 7.6 | C | 426 | « (Photo et Album, dans ce cas) » | Correct: 73 Album, 27 Photo, no Video. ✔︎ | — |

Verified ✔︎: 100 obs × 12 variables; `Total.Interactions = Likes + Comments` in all 100 rows; 38 accounts.

### Session 8: Manipuler les données II

Every model answer was recomputed and is correct: 6 cars with mpg ≥ 25; Lotus Europa; 32 diamonds above 3 carats; SI2 at 5,063 USD; virginica; Premium > Very Good > Ideal; Messi, Selena Gomez, Kendall, Anastasia Karanikolaou, KIARA and KAROL G for the URL questions. ✔︎

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 8.1 | B | 186, 258 | « la catégorie de pureté SI2 est la plus chère » ; « les diamants … Ideal ne sont pas les plus chers » | Arithmetically correct, but students will read it as "lower clarity makes diamonds more expensive". The real reason is **confounding by carat**: lower-clarity and lower-cut diamonds are on average larger. This is a perfect, cheap teaching moment. | Add: « Attention : cela ne veut pas dire qu'une pureté plus faible rend un diamant plus cher. Les diamants SI2 sont en moyenne plus **lourds** (carat), et le poids influence fortement le prix. Comparez `diamonds %>% group_by(clarity) %>% summarize(mean(carat))`. C'est un exemple de **variable confondante**. » |
| 8.2 | C | 382, 408, 432 | Descriptions of what the posts show (« flirter avec la caméra », « grimaces ») | Subjective descriptions of real people's photos. They're harmless, but they will age, and posts may be deleted. | Keep them neutral and short, or drop the "De quoi s'agit-il ?" part. |
| 8.3 | C | 264–268 | « téléchargez-le encore une fois depuis Moodle » | §4. | — |

### Session 9: Problem Set 3 (review)

n = 64, mean 13.12, 58 passed (90.6 %). ✔︎ Logistics only (§4).

### Session 10: Statistiques descriptives

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 10.1 | **A** | 17–18 | « Il ne s'agit pas d'analyser des relations de cause à effet (c'est le rôle de la statistique inférentielle) » | Inferential statistics generalise from a **sample to a population**; it does not, by itself, establish causation. Causal conclusions require a **design**: randomisation, or explicit causal assumptions. The same misconception appears in 11.1 and 12.4. | « La statistique descriptive **résume** les données de l'échantillon. La statistique **inférentielle** permet ensuite de généraliser de l'échantillon à la population (avec une marge d'incertitude). Établir une **relation de cause à effet** demande en plus un dispositif adapté, par exemple une expérience randomisée. » |
| 10.2 | B | 29–30 | « mesures de dispersion (étendue, variance, écart-type, kurtosis, etc.) » | Kurtosis (and skewness) are measures of **shape**, not dispersion. The interquartile range is missing. | « Les mesures de dispersion (étendue, écart interquartile, variance, écart-type) ; les mesures de forme (asymétrie, *kurtosis*) » |
| 10.3 | B | 204–219 | `filter(note_ecole > 3.99, note_uni > 0.99)` without explanation | Originally this removed implausible real values. With the synthetic data it does nothing (min 4.2 and 4.0), except silently dropping the **4 rows with `NA`**. Unexplained filtering is bad modelling practice for students. | Remove the filter and use `na.rm = TRUE`, **or** explain it: « On exclut les valeurs manquantes (`!is.na(note_ecole)`) ; dans les données réelles, il fallait aussi exclure des valeurs impossibles. » |
| 10.4 | B | 217 | Scatter `aes(x = note_uni, y = note_ecole)` + `geom_smooth(method = "lm")` | The school grade comes **before** the university grade, so if anything it predicts it. Put the predictor on the x axis. | `aes(x = note_ecole, y = note_uni)` |
| 10.5 | B | 231 | `filter(permis != "N/A")` | The synthetic data use real `NA` (1 case), not the string `"N/A"`. The filter still drops it, because `filter()` discards `NA` comparisons, but for the wrong reason. | `filter(!is.na(permis))` |
| 10.6 | C | 189 | `labs(legend = "")` | `legend` isn't a `labs()` aesthetic, so it does nothing. The legend is already hidden by `show.legend = FALSE`. | Delete. |
| 10.7 | C | 90–92 | « téléchargez … depuis la page Moodle » | §4. | Link to `data/`. |

Verified ✔︎: n = 74; the order Femme > Homme > Autre (51/17/6) still holds; the synthetic-data callout is accurate.

### Session 11: Statistiques inférentielles I

Numbers verified ✔︎ (seed 123):

| Example | n | p-value |
|---|---|---|
| IQ | 25 | 0.126 |
| IQ | 50 | 0.0071 |
| Internet use exercise | 30 | 1.0 × 10⁻⁶ |
| Heights | 5 | **0.020** |
| WNBA | 24 | 0.00032 |

The Internet figures are correct: WIP-CH 2023 reports 5.6 h overall and 7.9 h for 20–29-year-olds (Latzer et al. 2023).

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 11.1 | **A** | 32–36 | « les statistiques inférentielles sont souvent utilisées pour **démontrer** des corrélations et des relations de cause à effet » | Same issue as 10.1. Tests quantify evidence against H0 under assumptions; they don't *demonstrate* anything, and they don't establish causality. | « …pour évaluer si une différence ou une association observée dans l'échantillon est susceptible d'exister aussi dans la population. Une relation **causale** ne peut être conclue que si le dispositif le permet (p. ex. une expérience). » |
| 11.2 | B | 41 | « confirmer ou infirmer nos hypothèses » | A test can **reject** or **fail to reject** H0. It can't confirm H1. | « …rejeter ou non l'hypothèse nulle » |
| 11.3 | **A** | 98 | « Dans R, le test t est effectué avec la fonction `test.t()` » | The function is `t.test()`. `test.t()` doesn't exist. | `t.test()` |
| 11.4 | **A** | 109–112 | « test t à deux échantillons indépendants (… aussi appelé *Welch two sample t-test*) » | Welch's test is the variant that does **not** assume equal variances. It is R's default (`var.equal = FALSE`). Listing homoscedasticity as a required assumption (l. 82–86) while R runs Welch by default is contradictory. | « …Par défaut, R effectue la variante de **Welch**, qui n'exige pas que les variances soient égales (`var.equal = FALSE`). Le test t « classique » de Student (`var.equal = TRUE`) suppose des variances égales. » Then move homoscedasticity to "only for Student's version". |
| 11.5 | B | 118 | « échantillons appariés (angl. *pairwise t-test*) » | The English term is *paired t-test*. "Pairwise" refers to multiple pairwise comparisons, e.g. `pairwise.t.test()`, which is something else. | *paired t-test* |
| 11.6 | B | 92–95 | Alternatives: Wilcoxon–Mann–Whitney and **Kruskal–Wallis** | Kruskal–Wallis is the non-parametric alternative to **ANOVA** (3+ groups), not to the t-test. Both links point to `#0` (broken). | « …le test de Wilcoxon-Mann-Whitney (`wilcox.test()`) pour deux groupes indépendants, ou le test des rangs signés de Wilcoxon pour un échantillon ou des données appariées. (Pour plus de deux groupes, l'équivalent non paramétrique de l'ANOVA est le test de Kruskal-Wallis, `kruskal.test()`.) » Fix the links. |
| 11.7 | B | 75–81 | Normality: « la variable … doit suivre une loi normale », checked with Shapiro–Wilk | What matters is approximate normality of the **sampling distribution of the mean**. With moderate n this holds thanks to the central limit theorem, as l. 88–90 says. Shapiro–Wilk is widely discouraged as a gatekeeper: it's under-powered for small n and flags trivial deviations for large n. | « …surtout important pour les **petits** échantillons ; vérifiez-le plutôt visuellement (histogramme, graphique Q-Q) que par un test. » |
| 11.8 | **A** | 140–147 | H1: « il y a une **différence significative** » ; H0: « la différence n'est **pas significative** » | Hypotheses are statements about the **population**, not about test results. "Significant" is a property of the test outcome. The text also states a **one-sided** H1 ("plus élevé") but runs a **two-sided** test. | « **H0** : la moyenne de QI des étudiant·es dans la population est égale à 100 (μ = 100). **H1** : elle est différente de 100 (μ ≠ 100). » If you want the one-sided version, add `alternative = "greater"` and say so. |
| 11.9 | **A** | 191 | « En pratique, c'est surtout la valeur p qui compte ! » | Directly contradicts the ASA statement: "Scientific conclusions … should not be based only on whether a p-value passes a specific threshold." Report the **estimate and confidence interval** too, which `t.test()` prints. | « La valeur p indique si l'écart observé est compatible avec H0. Mais regardez aussi la **moyenne estimée** et l'**intervalle de confiance à 95 %** affichés par `t.test()` : ils indiquent l'ampleur de la différence et sa précision. » |
| 11.10 | **A** | 192–201 | « (si nous utilisons des intervalles de confiance de 95 %) » ; « nous ne pouvons PAS abandonner H0, car il y a une forte probabilité que la différence soit le résultat d'un pur hasard » | Two errors. (1) The decision uses the **significance level α = 0.05**; "95 % confidence intervals" is a different, if related, concept. (2) The p-value is **not** the probability that the result is due to chance. That's exactly the misreading question 43 now marks as wrong. | « La valeur p (0,13) est supérieure au seuil α = 0,05 : nous **ne rejetons pas** H0. Les données sont compatibles avec une moyenne de 100 ; cela ne prouve pas que la moyenne *est* 100. L'intervalle de confiance à 95 % (qui contient 100) le montre aussi. Avec seulement 25 observations, le test manque peut-être simplement de puissance. » |
| 11.11 | **A** | 213–222 | « la probabilité que les valeurs observées soient le résultat d'un pur hasard sont très faible (moins de 1 %) » | Same misreading. Also, "significativement plus élevé" after a two-sided test. | « Si la vraie moyenne était 100, obtenir un écart aussi grand ou plus grand serait très improbable (p = 0,007). Nous rejetons H0 au seuil de 5 %. La moyenne estimée (105,5) est supérieure à 100. » Then add the key lesson: « Même vraie différence, **n plus grand** → plus de puissance. » |
| 11.12 | **A** | 258–266 | « il est extrêmement improbable que l'utilisation … ne diffère PAS » ; « avec une très grande certitude » | Same misreading, a probability statement about the hypothesis. | « La valeur p est très faible : des données comme celles-ci seraient très improbables si la moyenne des 20–29 ans était de 5,6 h. Nous rejetons H0. » Also note: « (Les données étant simulées avec une moyenne de 7,9, ce résultat était attendu.) » |
| 11.13 | **A** | 297–302 | « Comme nos échantillons de n = 5 sont très petits, il se peut que la différence … ne soit pas significative » | With the seed shown, the result **is** significant (p = 0.020). The output contradicts the text right beneath it. | « Avec `set.seed(123)`, la différence est significative (p ≈ 0,02) même avec n = 5, car l'écart entre hommes et femmes (≈ 12 cm) est grand par rapport à la variabilité. Essayez d'autres graines : avec des échantillons si petits, le résultat varie beaucoup d'une simulation à l'autre. » |
| 11.14 | **A** | 313–315 | Exercise 2: « Quelle est la probabilité que 24 hommes suisses … mesurent également cette taille en moyenne ? » | A t-test doesn't answer that question. The solution (l. 333–338) repeats the probability-of-hypothesis misreading. | Rephrase: « Testez si la taille moyenne de 24 joueuses de la WNBA diffère significativement de celle de 24 hommes suisses tirés au hasard. » Solution: « p < 0,001 : on rejette H0 ; dans ces données, les joueuses sont en moyenne plus grandes (≈ 184 contre ≈ 177 cm). » |
| 11.15 | B | 310 | WNBA heights from *jokermag.com* | Not an authoritative source. | Cite the WNBA rosters, or label the value as approximate: « environ 1,83–1,85 m ». |
| 11.16 | C | 54, 42 (s12) | « Wikipédia, 2024 » as the source for definitions | Acceptable for history; for definitions, a textbook reads better (OpenIntro, ch. 5–7). | Optional. |
| 11.17 | C | 196 | « abondonner », « intérvalles », « pa significative »… | Typos. | Spell-check pass. |

### Session 12: Statistiques inférentielles II

Numbers verified ✔︎:

- ANOVA: F = 594.8, p < 2e-16. Group variances 42.8 / 50.9 / 42.1; Levene p = 0.72.
- `mpg ~ wt`: b = −5.345, R² = 0.7528, RSE = 3.046, F = 91.38, p = 1.29 × 10⁻¹⁰.
- `mpg ~ wt + hp`: R² = 0.8268, adjusted R² = 0.8148, F = 69.21, `hp` p = 0.0015.
- Stepwise selection ends at `mpg ~ wt + qsec + am`.
- Fisher's dates and n = 344 are correct.

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 12.1 | **A** | 83 and 4 other lines; 7 questions | « pingouins » | Antarctic penguins are **manchots** in French: *manchot Adélie*, *manchot à jugulaire* (Chinstrap), *manchot papou* (Gentoo). *Pingouin* = auk. | Replace everywhere with « manchots ». Variable values stay as they are (`Adelie`, `Gentoo`…). |
| 12.2 | B | 49–53 | ANOVA assumptions: « les observations … doivent être … identiquement distribuées (approximativement une distribution normale) » | It's the **residuals** (equivalently, the observations within each group) that should be approximately normal with equal variance, plus independence. | « …indépendance des observations ; dans chaque groupe, une distribution à peu près normale (vérifiable sur les résidus) ; des variances semblables entre groupes (homoscédasticité). » |
| 12.3 | C | 145 | « différence entre chaque paire de **variables** des trois groupes » | Tukey compares each pair of **groups**. | « …entre chaque paire d'**espèces** » |
| 12.4 | **A** | 155–197, 222–232 | « nous pouvons raisonnablement supposer qu'… une relation de cause à effet entre le niveau d'éducation et le salaire existe » ; « Une solution possible pour **quantifier néanmoins la relation de causalité** … est d'effectuer une analyse de régression linéaire ! » | Regression on observational data estimates **associations**. The text itself lists the omitted variables (ability, social class…) that make the education coefficient biased as a causal effect. Causal estimates require a design (experiments, natural experiments, instruments…) or strong, explicit assumptions. | « La régression linéaire permet de **quantifier l'association** entre x et y, éventuellement en tenant compte d'autres variables mesurées (« toutes choses égales par ailleurs »). Elle ne prouve pas à elle seule une relation causale : si des facteurs importants ne sont pas mesurés (p. ex. les capacités ou l'origine sociale), le coefficient de l'éducation peut être biaisé. » Same for the height/weight example (l. 226–232): « association ». |
| 12.5 | **A** | 353–357 | « pour chaque tranche de 1 000 livres … la valeur de sa **consommation** de carburant diminue de 5,345 **miles** » | `mpg` is miles **per gallon** (efficiency). The coefficient means efficiency *drops* by 5.3 mpg, i.e. consumption *rises*. | « …une voiture plus lourde de 1 000 livres (≈ 454 kg) parcourt en moyenne **5,3 miles de moins par gallon** (elle consomme donc davantage). » |
| 12.6 | B | 375–384 | « Pour un modèle ne comportant qu'une seule variable, il s'agit d'une valeur exceptionnellement élevée » ; « les variations de la consommation … s'expliquent dans une très large mesure par les différences de poids ! » | "Exceptional" depends on the field: physical data like these often have high R². "Expliquer" is meant statistically. Also `mpg` again. | « …le poids rend compte d'environ 75 % de la variance de `mpg` dans ces données (« expliquer » au sens statistique, pas causal). » |
| 12.7 | B | 386–396 | Adjusted R²: « Un modèle avec un R² ajusté plus élevé est considéré comme un meilleur modèle » | Too strong. Adjusted R² penalises extra predictors and is one criterion among several (AIC, out-of-sample prediction, theory). | « …est un critère utile pour comparer des modèles ayant un nombre différent de variables, parmi d'autres (AIC, théorie, validation). » |
| 12.8 | B | 412–418 | Diagnostic plots check « si les **variables** suivent approximativement une loi normale » | The assumption is about the **residuals**, not the variables. The text gets this right later (l. 444–448). | « …p. ex. si les **résidus** suivent approximativement une loi normale » |
| 12.9 | B | 484–486 | « les graphiques de diagnostic sont tout à fait acceptables » for `mpg ~ wt` | Residuals vs Fitted shows a clear **U-shaped curvature**: a quadratic term in `wt` is significant (p = 0.003). The three largest residuals belong to Fiat 128, Toyota Corolla and Chrysler Imperial. Calling these plots "fully acceptable" teaches students to overlook exactly what the plots are for. | « Le graphique *Residuals vs Fitted* montre une légère courbure : la relation n'est pas tout à fait linéaire (on pourrait essayer `mpg ~ wt + I(wt^2)` ou `log(mpg)`). Quelques voitures (Fiat 128, Toyota Corolla, Chrysler Imperial) s'écartent nettement du modèle. Pour un modèle simple d'illustration, cela reste acceptable. » |
| 12.10 | **A** | 503–505 | « les voitures avec plus de chevaux … **consomment plus de `mpg`** » | Inverted: more powerful cars achieve **fewer** mpg. Also "relation causale" again. | « …on peut supposer que les voitures plus puissantes parcourent **moins de miles par gallon**. » |
| 12.11 | **A** | 527–530 | « parce qu'il utilise plus de variables, modele_2 est plus complexe. Cela se traduit par une statistique F plus faible » | The overall F statistic tests "all slopes = 0" for **each model separately**; it's not a complexity penalty and can't be compared across models this way. The correct comparison of nested models is `anova(modele_1, modele_2)`: F = 12.38, p = 0.0015, so adding `hp` improves the fit significantly. | « Pour comparer deux modèles emboîtés, on utilise `anova(modele_1, modele_2)` : ici, l'ajout de `hp` améliore significativement l'ajustement (F = 12,4 ; p = 0,0015). Le R² ajusté et l'AIC sont d'autres critères. La statistique F de `summary()` teste seulement si le modèle explique quelque chose ; elle ne sert pas à comparer des modèles. » |
| 12.12 | **A** | 535–606 | Stepwise selection: « élimine les variables qui ne contribuent pas de manière significative » ; « pouvoir explicatif suffisant (montré par sa valeur R-carré) » ; « **R produira le modèle optimal pour nous !** » | `step()` uses **AIC**, not significance or R². More importantly, stepwise selection is widely criticised: biased coefficients, p-values and R² that are too optimistic after selection, unstable results, especially with n = 32 and 10 candidate predictors (Harrell 2015; Whittingham et al. 2006; Smith 2018). It doesn't produce "the optimal model". | Keep it as a demonstration **with a caveat box**: « ⚠️ La sélection automatique pas à pas est pratique pour explorer, mais elle est **critiquée** : elle tend à surestimer la qualité du modèle (valeurs p et R² trop optimistes), et le modèle choisi peut changer avec d'autres données. En recherche, on choisit plutôt les variables à partir de la théorie et de la question de recherche. » Rephrase « R produira le modèle optimal » to « R propose le modèle ayant l'AIC le plus faible parmi ceux explorés ». Fix the AIC/R² description. |
| 12.13 | **A** | 567–569 | `# install.packages("stats")` / `library(stats)` | `stats` is part of base R and loaded by default. `install.packages("stats")` produces a warning or error and confuses students. | Delete both lines. |
| 12.14 | C | 398–402 | F-statistic « teste l'hypothèse nulle que le coefficient de régression est égal à zéro » | True for simple regression; in general, H0 is that **all** slope coefficients are zero. | « …que tous les coefficients (sauf l'ordonnée à l'origine) sont nuls ; en régression simple, cela revient au test de `wt`. » |
| 12.15 | C | 359–360, 400 | « (< 0,000000000129) » | Hard to read. | « p ≈ 1,3 × 10⁻¹⁰ » |
| 12.16 | C | 630–640 | Problem Set 4 dates (22/23 May) vs session 13 (22/28 May 2025) vs session 14 (29/30 May **2024**) | Inconsistent; course logistics (§4). | Remove. |
| 12.17 | C | 408 | YouTube embed | Privacy (rights audit): use `youtube-nocookie.com`. | — |

### Session 13: Problem Set 4 (review)

n = 56, mean 11.04, 39 passed (69.6 %). ✔︎ « 11. (note = 4.25) » has a stray full stop; dates conflict with session 12 (see 12.16).

### Session 14: Auto-apprentissage

| # | Lvl | Line | Current | Problem | Proposed fix |
|---|---|---|---|---|---|
| 14.1 | B | 113 | *R for Data Science* « par Wickham & Grolemund (2023, 2e éd.) » | The 2nd edition is by **Wickham, Çetinkaya-Rundel & Grolemund (2023)**. | Fix the authors. |
| 14.2 | B | 121 | *R Graphics Cookbook* « (2022, 2e éd.) » | The 2nd edition was published in **2018** (O'Reilly, ISBN 978-1-491-97860-3). | 2018 |
| 14.3 | B | 88–95 | AI: « fournir du code prêt à l'emploi, que vous pouvez copier et coller directement » | Encourages pasting unchecked code. Given your own disclosure plans, recommend verification and citing your institution's rules. | « …Vérifiez toujours le code proposé (exécutez-le, comprenez chaque ligne) : les assistants d'IA se trompent souvent avec assurance. Respectez les règles de votre université sur l'usage de l'IA. » Consider naming tools generically rather than listing brands. |
| 14.4 | B | MOOC list | Several courses (Udacity ud651, edX Stanford "R Programming Fundamentals") are likely retired or moved. | Link rot. | Run the link check (§4) and prune the list. |
| 14.5 | C | 132 | Goulet, 5e éd. 2016 | Newer French resources exist, notably Larmarange's *guide-R* (2023–, open access) and Barnier's *Introduction à R et au tidyverse*; both are maintained. | Add them as the first French references. |
| 14.6 | C | 152 | « Fribourg, 30 mai 2024 » | Date and place of the course edition. | Update or remove. |

### Welcome page (`index.qmd`)

| # | Lvl | Problem | Proposed fix |
|---|---|---|---|
| 0.1 | C | Presents the site as UniFR course material only. | Add one sentence for outside readers: « Ce matériel, conçu pour un cours de Bachelor en sciences de la communication, est librement accessible à toute personne qui souhaite apprendre R. » |
| 0.2 | C | The example `read.csv(…, encoding = "UTF-8")` is affected by the BOM issue (7.3). | Fix the CSVs. |

---

## 3. Question bank (`questions.yml`)

**Recomputed in R:** all numeric and text keys and all data-based Vrai/Faux and multi keys. They are correct, including:

- the synthetic-data keys 40, 70, 71, 72, 73, 76, 83 and 116;
- the `igposts` keys 36, 65, 66, 67, 81, 82, 107 and 109;
- the dataset keys 4, 6 (d, e), 15, 23, 24 (e), 26, 29, 30, 32, 33, 35, 47–64, 69, 74, 75 and 77–80.

The key changes already applied (34, 35, 43, 66, 74) are confirmed.

| ID | Lvl | Problem | Proposed fix |
|---|---|---|---|
| **108** | **A** | The explanation says « Les autres posts ont `NA` ». In `igposts.csv` they have **0**, not `NA`: 88 posts with 0 views, none missing. The key (Faux) is fine. | « `Views` compte les vues de **vidéos** : les 88 posts sans vidéo ont la valeur 0. Cela ne veut pas dire que personne ne les a vus : le nombre total d'affichages n'est pas dans les données. » Then remove `check`. Confirming the definition against CrowdTangle's docs would be nice, but the 0/>0 split is consistent with it. |
| **42** | **A** | Option c) « L'hypothèse nulle … est qu'il n'y a pas de différence **significative** » is keyed **true**, but it's the same misstatement as 11.8. The question also depends on a missing screenshot. | Rewrite c): « …l'hypothèse nulle est que les moyennes des deux populations sont égales. » Regenerate the output with a seeded simulation (e.g. WNBA mean 184.5, sd 6.5 vs Dutch men mean 183.8, sd 7.1, n = 100 each). Recompute the key from that output. |
| 6 | B | a) « deux variables catégorielles »: `nom` is also a character variable (`check: true`). | Reword: « Ce data frame contient **deux facteurs**. » The key (a true) is then unambiguous. |
| 10 | B | d) « collectées par Edgar Anderson en 1935 en Gaspésie » keyed true. Only two species come from Gaspé; 1935 is the publication year (see 4.1). | « Les mesures ont été publiées par Edgar Anderson (1935). » (true) |
| 24 | B | d) « La pureté a un impact considérable sur le prix » (`check: true`): a causal reading of a scatterplot. | « À carat égal, les diamants plus purs semblent plus chers dans ce graphique. » (true) |
| 29 | B | « consommation de carburant (`mpg`) » (see 5.7). | « efficacité énergétique (`mpg`) » |
| 23, 74, 75 + 4 others | B | « pingouins » (see 12.1). | « manchots » |
| 114 | C | "Consomment plus de carburant… relation de cause à effet": key true is defensible thanks to the physical mechanism, and the explanation already hedges. | Keep. Optionally « …on peut raisonnablement **supposer** un effet causal (que des données observationnelles seules ne prouvent pas). » |
| 115 | C | « pourcentage de la variabilité … expliquée » | R² is a proportion, often given as a %. Fine; add « (au sens statistique) ». |
| 118, 1 | C | Missing images (already known). Question 118 can use your new RStudio screenshot (rights audit). | — |

**Explanations to align with the book after the fixes:** 3, 38, 41, 43 and 112 already use correct p-value language. Once sessions 11 and 12 are fixed, book and questions will say the same thing.

---

## 4. Cross-cutting issues

1. **Course logistics in a public book.** Sessions 2, 3, 5, 6, 7, 8, 9, 10, 12, 13 and 14 contain Moodle links, Problem Set dates and rules, group letters, bonus points, the LimeSurvey deadline and inconsistent years (2024/2025). Suggestion: replace with neutral wording, and keep a single, clearly dated "À propos de l'édition SP 2025 du cours" box if you want to preserve the history.
2. **`mpg` ≠ consommation.** About 8 occurrences (5.7, 12.5, 12.6, 12.10, question 29). Note that « efficaces en termes de consommation » (session 5, l. 456–459) and question 114 are correct as written. One global search for « consomm » finds them.
3. **pingouin → manchot.** 12 occurrences.
4. **BOM in the CSV files** (7.3). This silently breaks `igposts$Account` on non-UTF-8 systems.
5. **Link check.** Couldn't be run here. Locally: `lychee sessions/*.qmd index.qmd` (or the Claude Code prompt below). The Moodle links, retired MOOCs and `#0` anchors in session 11 are known problems.
6. **Spelling.** Many typos (« éxécutez », « répértoire », « intéractions », « abondonner », « auf », « techniquesqui »…). One proofreading pass with a French spell checker (e.g. LanguageTool) is worth it before PPUR.
7. **Same content twice.** The PS1 questions now appear in session 3 (advanced A1–A10, written by me) and the bank renders the standard ones. Check that nothing appears twice.

---

## 5. Suggested order of work

1. **A-level items** in sessions 10–12 (17 items), then 1.1, 1.2, 2.1, 5.7, 7.3, and questions 42 and 108. These change what students learn.
2. Global search-and-replace: `mpg` wording and pingouin → manchot.
3. B-level items.
4. Course logistics and C-level items, together with the rights-audit fixes.
5. Link check and spell check.
6. Re-render, compare every changed output, update `_freeze/`.

Prompt for Claude Code:

> Read review/fact-check.md. Apply all **A-level** fixes in sessions 10, 11 and 12 using the proposed French text (adapt wording where needed to fit the surrounding text). One commit per session. Re-render each session and check that every number quoted in the text matches the output. Show me the diff before committing. Don't touch other sessions yet.

---

## 6. Sources

- Wasserstein, R. L., & Lazar, N. A. (2016). The ASA statement on p-values: Context, process, and purpose. *The American Statistician*, 70(2), 129–133. https://doi.org/10.1080/00031305.2016.1154108
- Greenland, S., et al. (2016). Statistical tests, P values, confidence intervals, and power: A guide to misinterpretations. *European Journal of Epidemiology*, 31, 337–350. https://doi.org/10.1007/s10654-016-0149-3
- Diez, D., Çetinkaya-Rundel, M., & Barr, C. (2019). *OpenIntro Statistics* (4th ed.). https://www.openintro.org/book/os/
- Harrell, F. E. (2015). *Regression Modeling Strategies* (2nd ed.), §4.3 "Variable selection". Springer.
- Smith, G. (2018). Step away from stepwise. *Journal of Big Data*, 5, 32. https://doi.org/10.1186/s40537-018-0143-6
- Whittingham, M. J., et al. (2006). Why do we still use stepwise modelling in ecology and behaviour? *Journal of Animal Ecology*, 75(5), 1182–1189.
- Westfall, P. H. (2014). Kurtosis as peakedness, 1905–2014. R.I.P. *The American Statistician*, 68(3), 191–195.
- Wickham, H. (2010). A layered grammar of graphics. *Journal of Computational and Graphical Statistics*, 19(1), 3–28.
- Wickham, H., Çetinkaya-Rundel, M., & Grolemund, G. (2023). *R for Data Science* (2nd ed.). https://r4ds.hadley.nz
- R Core Team. Documentation for `t.test`, `aov`, `lm`, `step`, `factor`, `read.table` (R 4.x).
- ggplot2 documentation: `geom_boxplot`, `geom_histogram`, `geom_smooth`. https://ggplot2.tidyverse.org
- Latzer, M., Festic, N., Kappeler, K., & Odermatt, C. (2023). *Internetanwendungen und deren Nutzung in der Schweiz 2023*. WIP-CH, Universität Zürich. https://mediachange.ch/media//pdf/publications/Anwendungen_Nutzung_2023_.pdf
- Staub, K., et al. (2022). Body height among adult male and female Swiss Health Survey participants in 2017. *SSM – Population Health*. https://pmc.ncbi.nlm.nih.gov/articles/PMC9502675/
- Anderson, E. (1935). The irises of the Gaspé Peninsula. *Bulletin of the American Iris Society*, 59, 2–5. Fisher, R. A. (1936). The use of multiple measurements in taxonomic problems. *Annals of Eugenics*, 7(2), 179–188.
- Horst, A. M., Hill, A. P., & Gorman, K. B. (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. R package. https://allisonhorst.github.io/palmerpenguins/
- Bryan, J. (2017). Project-oriented workflow. https://www.tidyverse.org/blog/2017/12/workflow-vs-script/
- Larmarange, J. *guide-R : Guide pour l'analyse de données d'enquêtes avec R*. https://larmarange.github.io/guide-R/
