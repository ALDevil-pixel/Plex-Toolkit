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

La commande :

```bash
./plex-toolkit plex-libraries --config config/plex.conf
```

interroge :

```text
/library/sections
```

et affiche :

```text
key    type    title    agent    scanner
```

Exemple :

```text
1       movie   Films
2       show    Séries
3       artist Musique
```

La commande est strictement en lecture seule.

Elle ne modifie aucune bibliothèque et ne lance aucune analyse Plex.

Le token Plex est transmis au client API mais n'est jamais affiché.

La logique de découverte est séparée du transport HTTP afin que les prochaines commandes puissent réutiliser le même client.
