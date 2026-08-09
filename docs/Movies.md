# Fonctionnalités Films

## Configuration

La configuration Films est définie dans :

```text
config/movies.conf
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

La détection Films utilise deux niveaux :

1. regroupement par taille ;
2. vérification exacte par SHA-256.

Un fichier n'est donc considéré comme doublon supprimable qu'après vérification du contenu.

Par défaut, la commande est en lecture seule.

Pour supprimer les doublons vérifiés :

```bash
./plex-toolkit movie-duplicates --fix <répertoire>
```

En mode `--fix`, le premier fichier du groupe est conservé et les autres fichiers dont le SHA-256 est identique sont supprimés.

Les fichiers de taille différente ne sont jamais considérés comme des doublons exacts.

La logique générale de détection est centralisée dans :

```text
lib/duplicates.sh
```

La commande Films ne crée pas une deuxième implémentation de l'algorithme.
