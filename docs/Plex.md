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

Les erreurs réseau, timeout, TLS et retries sont gérés par cette couche.

## Bibliothèques

```bash
./plex-toolkit plex-libraries --config config/plex.conf
```

## Médias

```bash
./plex-toolkit plex-media --config config/plex.conf <library-key>
```

## Comparaison

```bash
./plex-toolkit plex-compare --config config/plex.conf <répertoire-local> <library-key>
```

La comparaison est en lecture seule et retourne :

```text
MATCH
LOCAL_ONLY
PLEX_ONLY
```

Avant la comparaison, le Toolkit vérifie :

- que le répertoire local existe ;
- que la clé Plex est valide ;
- que la bibliothèque existe ;
- que son type correspond au type attendu par l'action.

## Actions futures

Les protections communes sont centralisées dans :

```text
lib/plex_safety.sh
```

Toute future action destructive Plex devra utiliser `--fix`.

Une commande sans `--fix` ne doit jamais effectuer d'action destructive.

Le token Plex ne doit jamais apparaître dans les sorties ou les logs.

La validation des cibles doit être effectuée avant toute future modification.
