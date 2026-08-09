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

Le scanner est :

```text
lib/anime_scanner.sh
```

Il est accessible via :

```bash
./plex-toolkit anime-scan <répertoire>
```

Le scan est **strictement en lecture seule**.

Il recherche les formats vidéo configurés et tente de détecter :

```text
S01E02
s01e02
1x02
```

Pour chaque fichier vidéo, il indique la saison et l'épisode détectés lorsqu'ils sont disponibles.

Les fichiers dont l'extension n'est pas autorisée sont signalés.

Aucun fichier n'est renommé, déplacé ou supprimé.

## Suite du développement

Le scanner constitue la base des prochaines étapes de détection et de proposition de renommage.
