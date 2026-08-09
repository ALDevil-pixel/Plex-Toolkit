# Intégration Plex

## Configuration

La configuration Plex est définie dans :

```text
config/plex.conf
```

## Client API

Les appels HTTP sont centralisés dans :

```text
lib/plex_api.sh
```

## Bibliothèques

```bash
./plex-toolkit plex-libraries --config config/plex.conf
```

## Médias

```bash
./plex-toolkit plex-media --config config/plex.conf <library-key>
```

## Comparaison local ↔ Plex

La comparaison est centralisée dans :

```text
lib/plex_compare.sh
```

Commande :

```bash
./plex-toolkit plex-compare --config config/plex.conf <répertoire-local> <library-key>
```

Exemple :

```bash
./plex-toolkit plex-compare --config config/plex.conf /media/Films 1
```

Le résultat utilise trois états :

```text
MATCH
LOCAL_ONLY
PLEX_ONLY
```

La correspondance initiale est volontairement prudente et basée sur le titre normalisé et, lorsqu'il est disponible, l'année.

Cette commande ne modifie ni les fichiers locaux ni Plex.

Elle sert de couche de diagnostic avant toute future action de synchronisation.
