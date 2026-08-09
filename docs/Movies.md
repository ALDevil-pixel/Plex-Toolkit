# Fonctionnalités Films

## Configuration

La configuration Films est définie dans :

```text
config/movies.conf
```

Elle est chargée et validée par :

```text
lib/movie_config.sh
```

Paramètres actuels :

```text
MOVIES_ROOT
MOVIES_VIDEO_EXTENSIONS
MOVIES_MIN_SIZE
MOVIES_INCLUDE_HIDDEN
```

## Scan

```bash
./plex-toolkit movie-scan <répertoire>
```

Le scan est strictement en lecture seule.

Il permet de :

- identifier les fichiers vidéo supportés ;
- signaler les extensions non supportées ;
- signaler les fichiers sous la taille minimale ;
- afficher la taille des fichiers vidéo ;
- ignorer les fichiers cachés par défaut.

La détection des doublons est volontairement séparée et reste traitée par la commande `duplicates`.

Aucun fichier n'est renommé, déplacé, supprimé ou modifié.
