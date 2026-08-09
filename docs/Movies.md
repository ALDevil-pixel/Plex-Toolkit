# Fonctionnalités Films

## Configuration

La configuration Films est définie dans :

```text
config/movies.conf
```

Paramètres :

```text
MOVIES_ROOT
MOVIES_VIDEO_EXTENSIONS
MOVIES_MIN_SIZE
MOVIES_INCLUDE_HIDDEN
MOVIES_PREFERRED_EXTENSIONS
```

## Analyse

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
2. vérification exacte SHA-256.

La commande est en lecture seule par défaut.

### Sélection

Le fichier conservé est choisi selon :

1. préférence d'extension ;
2. chemin le plus court ;
3. ordre lexical.

La préférence par défaut est :

```text
MKV > MP4 > TS
```

### Suppression

Pour appliquer les suppressions :

```bash
./plex-toolkit movie-duplicates --fix <répertoire>
```

Avant chaque suppression, le fichier candidat est revérifié par SHA-256.

Si un candidat a disparu ou changé depuis l'analyse, la suppression est refusée.

Aucun fichier différent n'est supprimé.

Le comportement est idempotent : une seconde exécution ne supprime rien de plus une fois les doublons traités.
