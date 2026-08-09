# Inventaire

## Sprint 1.15.0.1

L'inventaire peut être configuré avec :

```text
INVENTORY_FOLLOW_SYMLINKS
INVENTORY_INCLUDE_HIDDEN
INVENTORY_HASH_ENABLED
INVENTORY_HASH_ALGORITHM
```

Le format reste :

```text
name|extension|size|mtime|hash|path
```

## Sprint 1.15.0.2

Une identité stable est maintenant disponible pour les futures comparaisons.

Si un hash est disponible :

```text
hash:<sha256>
```

est utilisé comme identité.

Sans hash, le fallback est :

```text
name-size:<name>|<size>
```

Cette distinction est importante :

- le nom seul n'est pas considéré comme une identité fiable ;
- le hash permet de reconnaître un fichier même si son chemin change ;
- sans hash, la comparaison reste volontairement prudente.

Le module est :

```text
lib/inventory_identity.sh
```

Aucune modification des fichiers locaux n'est effectuée.
