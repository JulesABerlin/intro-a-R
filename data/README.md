# Données du cours

Les fichiers de ce dossier sont publiés avec le site et peuvent être lus
directement dans R, p. ex. :

```r
igposts <- read.csv("https://julesaberlin.github.io/intro-a-R/data/igposts.csv",
                    encoding = "UTF-8", na.strings = "#N/A")
```

| Fichier | Contenu |
|---|---|
| `reponses_socio.csv` | **Données synthétiques** : 74 réponses simulées à partir du questionnaire d’une classe (sessions 10 et 13). Aucune personne réelle. |
| `igposts.csv` | 100 posts Instagram publics de célébrités (export CrowdTangle, sessions 7 et 8). |
| `points_PS_1.csv`, `points_ps_2.csv`, `points_ps_3.csv`, `points_ps_4.csv` | Points obtenus aux Problem Sets (groupe et points seulement, sans identifiant). |
| `ice_age_df.csv` | Le petit tableau des animaux de *L’Âge de glace* (session 10). |

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
