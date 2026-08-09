# Synchronisation Plex

## Sprint 1.14.0.1

`plex-sync-plan` prépare les actions sans modifier Plex.

## Sprint 1.14.0.2

`plex-sync-validate` vérifie les cibles avant action.

## Sprint 1.14.0.3

`plex-sync-add` demande un refresh ciblé du répertoire contenant le média.

## Sprint 1.14.0.4

Après le refresh, le Toolkit distingue :

```text
FOUND
PENDING
ERROR
```

## Sprint 1.14.0.5

La chaîne complète peut maintenant être testée :

```text
plex-sync-plan
       ↓
plex-sync-validate
       ↓
plex-sync-add
       ↓
Plex refresh
       ↓
plex-sync-verify
```

Le test d'intégration utilise une API Plex simulée.

Il vérifie :

- génération du plan ;
- validation de la cible ;
- dry-run ;
- action réelle avec `--fix` ;
- vérification `FOUND` ;
- absence de modification locale ;
- absence de fuite du token.

Un test d'échec vérifie également qu'un refresh Plex refusé provoque un code d'erreur et ne modifie pas le fichier local.

Les tests ne nécessitent pas de serveur Plex réel.
