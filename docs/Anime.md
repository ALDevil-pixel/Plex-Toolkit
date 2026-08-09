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

Les modèles acceptent uniquement :

```text
{title}
{season}
{season:02d}
{episode}
{episode:02d}
```

## Analyse

```bash
./plex-toolkit anime-scan <répertoire>
```

Lecture seule.

## Plan

```bash
./plex-toolkit anime-rename-plan <répertoire>
```

Lecture seule : aucune modification n'est effectuée.

## Renommage

```bash
./plex-toolkit anime-rename <répertoire>
```

Le comportement par défaut est le dry-run.

Pour appliquer :

```bash
./plex-toolkit anime-rename --fix <répertoire>
```

### Garanties actuelles

- aucun écrasement de fichier existant ;
- détection des destinations concurrentes ;
- validation des numéros saison/épisode ;
- validation des placeholders ;
- conservation des extensions ;
- pas de déplacement ;
- pas de suppression ;
- dry-run par défaut ;
- `--fix` obligatoire pour modifier ;
- opération idempotente.

## Validation du sprint

Les tests spécifiques sont :

```bash
bash tests/test-sprint-1.11.sh
bash tests/test-anime-release.sh
```

La suite générale reste :

```bash
bash tests/run.sh
```

Après validation, le dépôt doit être consolidé dans un nouveau ZIP avant de commencer le sprint suivant.
