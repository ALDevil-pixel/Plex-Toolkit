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

Le plan génère uniquement des propositions.

## Renommage

```bash
./plex-toolkit anime-rename <répertoire>
```

Par défaut, la commande fonctionne en **dry-run** :

```text
--dry-run
```

Aucun fichier n'est modifié.

Pour appliquer réellement les changements :

```bash
./plex-toolkit anime-rename --fix <répertoire>
```

`--fix` est donc obligatoire pour toute modification.

La commande :

- détecte les destinations déjà existantes ;
- ne remplace jamais un fichier existant ;
- conserve l'extension du média ;
- retourne une erreur si un renommage échoue ;
- peut être relancée sans renommer à nouveau les fichiers déjà normalisés.

Les opérations sont limitées au renommage des fichiers. Aucun déplacement ou suppression n'est effectué.
