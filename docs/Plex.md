# Intégration Plex

## Configuration

```text
config/plex.conf
```

Paramètres :

```text
PLEX_URL
PLEX_TOKEN
PLEX_TIMEOUT
PLEX_VERIFY_TLS
PLEX_RETRIES
```

Le token ne doit jamais être versionné ni affiché.

## Commandes

### Vérifier la configuration

```bash
./plex-toolkit plex-config --config config/plex.conf
```

### Tester la connexion

```bash
./plex-toolkit plex-ping --config config/plex.conf
```

### Lister les bibliothèques

```bash
./plex-toolkit plex-libraries --config config/plex.conf
```

### Lister les médias

```bash
./plex-toolkit plex-media --config config/plex.conf <library-key>
```

### Comparer local et Plex

```bash
./plex-toolkit plex-compare --config config/plex.conf <répertoire-local> <library-key>
```

La comparaison retourne :

```text
MATCH
LOCAL_ONLY
PLEX_ONLY
```

## Architecture

```text
commandes
   ↓
modules métier
   ↓
plex_api.sh
   ↓
Plex HTTP API
```

Les protections communes sont centralisées dans :

```text
lib/plex_safety.sh
```

## Sécurité actuelle

Toutes les commandes livrées dans le Sprint 1.13.0 sont en lecture seule vis-à-vis des bibliothèques et médias Plex.

Aucune synchronisation destructive n'est activée dans ce sprint.

Toute future action destructive devra :

- exiger explicitement `--fix` ;
- valider sa cible ;
- valider le type de bibliothèque ;
- être journalisée ;
- retourner un code d'erreur cohérent ;
- disposer d'un test dédié.

## Validation

Les tests spécifiques du sprint :

```bash
bash tests/test-sprint-1.13.sh
bash tests/test-plex-release.sh
```

La suite générale du projet doit également être exécutée avant consolidation.

Après validation, le dépôt peut être consolidé pour préparer le sprint suivant.
