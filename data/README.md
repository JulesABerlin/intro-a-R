# Données du cours

Les fichiers de ce dossier sont publiés avec le site et peuvent être lus
directement dans R, p. ex. :

```r
igposts <- read.csv("https://julesaberlin.github.io/intro-a-R/data/igposts.csv",
                    encoding = "UTF-8")
```

| Fichier | Contenu |
|---|---|
| `reponses_socio.csv` | **Données synthétiques** : 74 réponses simulées à partir du questionnaire d’une classe (sessions 10 et 13). Aucune personne réelle. |
| `igposts.csv` | 84 observations compte–post (82 posts Instagram distincts de 33 comptes de célébrités, publiés entre le 7 février et le 5 mars 2023), métriques relevées le 5 octobre 2026 (sessions 7 à 9). Métriques et URL uniquement. |
| `distribution_ps_1.csv` à `distribution_ps_4.csv` | Distributions agrégées des résultats réels (nombre d’étudiant·es par nombre de points) aux Problem Sets 1 à 4 de l’édition 2025, colonnes `points` et `n` (sessions 3, 6, 9 et 13). Pour le PS 4, seuls les résultats supérieurs à 0 sont comptés. Les résultats individuels ne sont pas publiés. |
| `ice_age_df.csv` | Le petit tableau des animaux de *L’Âge de glace* (session 10). |

## À propos de `igposts.csv`

`igposts.csv` contient les observations encore accessibles de l’échantillon
initial de posts Instagram publiés en février–mars 2023. L’échantillon initial
avait été constitué en 2023 à partir de CrowdTangle. Pour la version publique
actuelle, les métriques des posts encore disponibles ont été réobservées le
5 octobre 2026 directement à partir de pages Instagram publiques avec
[Zeeschuimer](https://github.com/digitalmethodsinitiative/zeeschuimer) ; les
nombres de followers ont été relevés sur les profils publics le même jour. Le
fichier contient 84 observations compte–post correspondant à 82 posts distincts
de 33 comptes : deux posts co-publiés apparaissent une fois pour chacun des deux
comptes. Seize URL originales n’étaient plus disponibles et ont été exclues sans
remplacement. Le fichier public ne contient ni légendes, ni texte de
commentaires, ni données brutes Zeeschuimer.

Les nombres de followers sont arrondis selon l’affichage public d’Instagram ;
les ratios par follower utilisent donc un instantané approximatif du nombre de
followers au 5 octobre 2026 et ne constituent pas des taux d’engagement
historiques au moment de la publication des posts.

| Variable | Contenu |
|---|---|
| `Account`, `User.Name` | Nom et identifiant du compte tels qu’ils figuraient dans l’échantillon de 2023 (p. ex. `justinbieber`, aujourd’hui `lilbieber`) |
| `Followers.at.Observation` | Nombre de followers affiché sur le profil le 5 octobre 2026 (arrondi) |
| `Post.Created.Date`, `Post.Created.Time` | Date et heure de publication, en **UTC** (l’ancien fichier les donnait avec 5 heures de retard) |
| `Type` | `Photo` ou `Album` |
| `Likes`, `Comments` | Nombre de likes et de commentaires relevé le 5 octobre 2026 |
| `Reposts` | Nombre de reposts relevé le 5 octobre 2026 (fonction introduite par Instagram en 2025) |
| `Total.Interactions` | `Likes` + `Comments` |
| `URL` | Lien vers le post |

Les photos et textes des posts restent la propriété de leurs auteur·es ; ils ne
sont pas reproduits ici.

## À propos de `reponses_socio.csv`

Ce fichier est **synthétique**. Ses données ont été simulées à partir des
réponses d’une classe au questionnaire du cours ; il ne contient **aucun·e
répondant·e réel·le**. Il a les mêmes variables (`naissance`, `genre`, `permis`,
`suisse`, `origine`, `fraterie`, `domicile`, `trajet`, `note_ecole`, `note_uni`),
avec des distributions et des relations semblables.

Pour protéger les participant·es :

- chaque valeur du fichier est partagée par au moins 3 personnes du
  questionnaire d’origine : les valeurs rares ont été regroupées avec leurs
  voisines (p. ex. les années de naissance extrêmes) ou sous une étiquette
  commune (« Autre canton », « Autre continent »). Seule exception : la
  modalité « Autre » de la variable `genre`, conservée pour ne pas effacer
  les personnes non binaires ;
- les temps de trajet sont arrondis à 5 minutes ;
- aucune ligne ne reproduit une vraie réponse, ni une combinaison unique
  d’année de naissance, genre, domicile, passeport et origine.

Le fichier est créé par `data-raw/synthetiser_donnees.R`. Les réponses
d’origine ne sont pas publiées.
