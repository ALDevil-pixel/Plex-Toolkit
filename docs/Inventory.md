# Inventaire

## Sprint 1.15.0.1

La commande `inventory` reste la commande d'inventaire principale.

Configuration :

```text
config/inventory.conf
```

Nouveaux paramètres :

```text
INVENTORY_FOLLOW_SYMLINKS=false
INVENTORY_INCLUDE_HIDDEN=true
INVENTORY_HASH_ENABLED=false
INVENTORY_HASH_ALGORITHM="sha256"
```

### Hash

Le hash est désactivé par défaut afin d'éviter une lecture complète des fichiers.

Pour l'activer :

```text
INVENTORY_HASH_ENABLED=true
```

L'algorithme actuellement recommandé est :

```text
sha256
```

### Liens symboliques

Par défaut, les liens symboliques ne sont pas suivis.

Cela évite de sortir involontairement de l'arborescence inventoriée.

### Fichiers cachés

Par défaut, les fichiers cachés sont inclus.

Pour les exclure :

```text
INVENTORY_INCLUDE_HIDDEN=false
```

### Compatibilité

Le format de base des lignes d'inventaire reste compatible :

```text
name|extension|size|mtime|hash|path
```

Le champ `hash` est vide lorsque le calcul est désactivé.

L'inventaire reste une opération de lecture seule.
