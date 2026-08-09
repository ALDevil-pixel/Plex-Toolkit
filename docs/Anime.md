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

Les modèles acceptent uniquement les variables connues :

```text
{title}
{season}
{season:02d}
{episode}
{episode:02d}
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

Le plan génère uniquement des propositions.

## Renommage

```bash
./plex-toolkit anime-rename <répertoire>
```

Par défaut, la commande fonctionne en dry-run.

Pour appliquer les changements :

```bash
./plex-toolkit anime-rename --fix <répertoire>
```

### Protections

Le renommage :

- ne remplace jamais un fichier existant ;
- détecte les destinations identiques produites par plusieurs sources ;
- valide les numéros de saison et d'épisode ;
- conserve l'extension du fichier ;
- refuse les placeholders de configuration inconnus ;
- n'effectue ni déplacement ni suppression ;
- est idempotent.

Les cas ambigus sont signalés et ne sont pas modifiés automatiquement.
