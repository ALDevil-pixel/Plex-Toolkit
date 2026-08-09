# Fonctionnalités Films

## Configuration

La configuration Films est définie dans :

```text
config/movies.conf
```

Paramètres :

```text
MOVIES_ROOT
MOVIES_VIDEO_EXTENSIONS
MOVIES_MIN_SIZE
MOVIES_INCLUDE_HIDDEN
MOVIES_PREFERRED_EXTENSIONS
```

`MOVIES_PREFERRED_EXTENSIONS` définit l'ordre de préférence lorsqu'un même contenu existe sous plusieurs extensions.

Par défaut :

```text
mkv mp4 ts
```

## Scan

```bash
./plex-toolkit movie-scan <répertoire>
```

Le scan est strictement en lecture seule.

## Doublons

```bash
./plex-toolkit movie-duplicates <répertoire>
```

La détection utilise :

1. regroupement par taille ;
2. vérification SHA-256.

Un doublon supprimable doit donc avoir exactement le même contenu.

### Sélection du fichier conservé

Lorsqu'un groupe contient plusieurs copies identiques, le Toolkit ne conserve plus arbitrairement le premier fichier rencontré.

Il applique la politique :

1. préférence d'extension configurée ;
2. chemin le plus court ;
3. ordre lexical pour départager les égalités.

Par défaut, l'ordre est :

```text
MKV > MP4 > TS
```

La décision est donc déterministe.

Par défaut, la commande reste en lecture seule.

Pour appliquer la suppression :

```bash
./plex-toolkit movie-duplicates --fix <répertoire>
```

Seuls les fichiers dont le contenu est vérifié identique sont supprimés.
