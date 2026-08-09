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

La découverte des bibliothèques est centralisée dans :

```text
lib/plex_libraries.sh
```

```bash
./plex-toolkit plex-libraries --config config/plex.conf
```

## Médias

La lecture des médias d'une bibliothèque est centralisée dans :

```text
lib/plex_media.sh
```

Commande :

```bash
./plex-toolkit plex-media --config config/plex.conf <library-key>
```

Elle interroge :

```text
/library/sections/<library-key>/all
```

et affiche notamment :

```text
ratingKey
type
title
year
librarySectionID
librarySectionTitle
updatedAt
```

Cette commande est strictement en lecture seule.

Elle ne modifie aucun élément Plex.

La clé de bibliothèque est vérifiée avant l'interrogation des médias.

Les prochaines parties pourront utiliser ces données pour comparer l'état Plex avec l'inventaire local.
