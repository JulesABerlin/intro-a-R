# Introduction à R pour les sciences de la communication

Livre en ligne, en français, pour apprendre R pas à pas : bases du
langage, visualisations avec ggplot2, manipulation de données avec dplyr,
statistiques descriptives et inférentielles. Chaque chapitre combine des
explications, du code à exécuter dans RStudio et des exercices interactifs
corrigés.

**Site : <https://julesaberlin.github.io/intro-a-R/>**
(version PDF téléchargeable depuis le site, avec les corrigés en annexe)

Ce matériel a été développé pour le cours **Exercices Méthodes II** du
Bachelor en sciences de la communication de l'Université de Fribourg
(2023–2025). Il s'adresse à toute personne qui souhaite apprendre R à son
rythme.

## Licences

- **Textes, exercices, explications et figures** :
  [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr).
- **Code R** (extraits de code, `_common.R`, scripts de `data-raw/`) :
  licence MIT (voir [LICENSE](LICENSE)).
- **Éléments de tiers** (photos de Wikimedia Commons, logo de
  palmerpenguins, fichiers de webexercises, jeux de données intégrés à R,
  captures d'écran de RStudio) : ils restent sous leur propre licence ; voir
  la page [À propos](https://julesaberlin.github.io/intro-a-R/apropos.html).

## Données

Les jeux de données du cours se trouvent dans [`data/`](data/) et peuvent
être lus directement depuis le site :

```r
igposts <- read.csv("https://julesaberlin.github.io/intro-a-R/data/igposts.csv",
                    encoding = "UTF-8")
```

- `reponses_socio.csv` est **synthétique** : il est simulé à partir du
  questionnaire d'une classe et ne contient aucune personne réelle.
- `igposts.csv` contient les posts Instagram de l'échantillon de 2023
  encore accessibles en octobre 2026, avec des métriques réobservées le
  5 octobre 2026 (sans légendes ni texte de commentaires).
- `distribution_ps_1.csv` à `distribution_ps_4.csv` ne donnent que des
  distributions agrégées des résultats aux Problem Sets.

La provenance et les variables de chaque fichier sont décrites dans
[`data/README.md`](data/README.md).

## Citer ce livre

> Maitra, J. (2026). *Introduction à R pour les sciences de la
> communication*. https://julesaberlin.github.io/intro-a-R/

Les sources citées dans le livre (logiciels, paquets R, jeux de données,
lectures et vidéos) figurent dans la page
[Références](https://julesaberlin.github.io/intro-a-R/references.html)
(`references.bib`, style APA 7 en adaptation française : `apa-fr.csl`).

## Construire le livre

Le livre est écrit avec [Quarto](https://quarto.org) (projet de type
*book*). Il faut R avec les paquets `tidyverse`, `ggthemes`,
`palmerpenguins`, `webexercises`, `yaml` et `formatR`.

```sh
quarto render                              # site HTML et PDF dans _book/
quarto render --profile word --to docx     # copie Word dans _word/ (code non exécuté)
```

- R doit tourner dans une locale UTF-8 (p. ex. `LANG=fr_CH.UTF-8`), sinon la
  banque de questions et les caractères coréens ne sont pas lus correctement.
- Le PDF est produit avec LuaLaTeX ; il utilise les polices de macOS
  Apple SD Gothic Neo et Apple Color Emoji pour le coréen et les emoji.
- Les exercices viennent de `question-bank/questions.yml`. Dans le PDF, les
  réponses sont regroupées dans l'annexe « Corrigés »
  (`include/corriges.lua`).
- `freeze: auto` : les résultats du code sont gardés dans `_freeze/` ; un
  chapitre n'est réexécuté que si son fichier `.qmd` change.

Vous avez repéré une erreur ? Ouvrez une
[*issue*](https://github.com/julesaberlin/intro-a-R/issues).
