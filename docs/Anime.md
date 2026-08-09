# Fonctionnalités Anime

## Configuration

La configuration Anime est définie dans :

```text
config/anime.conf
```

Elle est chargée et validée par :

```text
lib/anime_config.sh
```

## Scan

```bash
./plex-toolkit anime-scan <répertoire>
```

Le scan est strictement en lecture seule.

## Plan de renommage

```bash
./plex-toolkit anime-rename-plan <répertoire>
```

Le plan de renommage analyse les fichiers vidéo détectés et propose un nom normalisé à partir de :

```text
ANIME_EPISODE_PATTERN
```

Les formats d'épisode actuellement reconnus sont :

```text
S01E02
s01e02
1x02
```

Le plan distingue :

```text
[ OK ]      fichier déjà normalisé
[RENAME]    renommage proposé
[WARN]      conflit de destination
[SKIP]      informations insuffisantes
```

Cette commande est **strictement en lecture seule**.

Elle ne renomme, ne déplace et ne supprime aucun fichier.

L'application effective des renommages sera traitée dans une partie ultérieure du sprint.
