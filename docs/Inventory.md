# Inventaire

## Sprint 1.15.0

Le Sprint 1.15.0 ajoute une chaîne d'inventaire et de rapprochement local/Plex :

```text
inventory
   ↓
identité
   ↓
inventory-compare
   ↓
inventory-plex-compare
   ↓
inventory-plex-report
```

### Inventaire

Configuration :

```text
INVENTORY_FOLLOW_SYMLINKS=false
INVENTORY_INCLUDE_HIDDEN=true
INVENTORY_HASH_ENABLED=false
INVENTORY_HASH_ALGORITHM="sha256"
```

Le hash est désactivé par défaut.

Le format interne est :

```text
name|extension|size|mtime|hash|path
```

### Comparaison locale

```bash
./plex-toolkit inventory-compare   --config config/inventory.conf   old.txt new.txt
```

États :

```text
UNCHANGED
CHANGED
ADDED
REMOVED
```

### Rapprochement Plex

```bash
./plex-toolkit inventory-plex-compare   --config config/plex.conf   inventory.txt   <library-key>
```

États :

```text
MATCH
LOCAL_ONLY
```

### Rapport

```bash
./plex-toolkit inventory-plex-report   --config config/plex.conf   inventory.txt   <library-key>   reports/plex-compare.txt
```

Le rapport est écrit via un fichier temporaire puis déplacé vers sa destination.

### Sécurité

Les commandes d'inventaire et de comparaison sont en lecture seule.

`--fix` est refusé par les commandes de comparaison.

Par défaut :

- les liens symboliques ne sont pas suivis ;
- aucun média n'est modifié ;
- aucun fichier source n'est supprimé ou déplacé ;
- le token Plex n'est pas écrit dans les rapports.

Le Sprint 1.15.0 est prêt pour consolidation.
