# Fonctionnalités Films

## Configuration

La configuration Films est définie dans :

```text
config/movies.conf
```

## Scan

```bash
./plex-toolkit movie-scan <répertoire>
```

Lecture seule.

## Doublons

```bash
./plex-toolkit movie-duplicates <répertoire>
```

La détection utilise :

1. regroupement par taille ;
2. SHA-256 exact.

La commande est en lecture seule par défaut.

Pour supprimer les copies identiques :

```bash
./plex-toolkit movie-duplicates --fix <répertoire>
```

### Sécurité du mode `--fix`

Avant toute suppression :

1. le groupe est identifié par SHA-256 ;
2. le fichier à conserver est sélectionné selon la politique configurée ;
3. chaque fichier candidat à la suppression est revérifié ;
4. si un fichier a disparu ou changé depuis l'analyse, la suppression du groupe est interrompue ;
5. les suppressions ne commencent qu'après cette vérification.

Le Toolkit ne supprime jamais un fichier dont le contenu ne correspond plus au hash analysé.

La sélection du fichier conservé utilise :

```text
MOVIES_PREFERRED_EXTENSIONS
```

puis le chemin le plus court et l'ordre lexical pour départager les égalités.

Aucun écrasement, renommage ou déplacement n'est effectué.
