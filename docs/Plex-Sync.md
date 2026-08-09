# Synchronisation Plex

## Sprint 1.14.0.1

`plex-sync-plan` prépare les actions sans modifier Plex.

## Sprint 1.14.0.2

`plex-sync-validate` vérifie les cibles avant action.

## Sprint 1.14.0.3

`plex-sync-add` demande un refresh ciblé du répertoire contenant le média :

```bash
./plex-toolkit plex-sync-add   --config config/plex.conf   --fix   /media/Films/MonFilm.mkv   1
```

Le Toolkit ne copie, ne déplace, ne renomme et ne supprime aucun fichier.

## Sprint 1.14.0.4

Après le refresh, Plex traite la demande de manière asynchrone.

Le Toolkit distingue donc :

```text
Plex add request: OK
```

de :

```text
Plex media verification: FOUND
Plex media verification: PENDING
```

`FOUND` signifie que le média est déjà visible dans la bibliothèque.

`PENDING` signifie que Plex a accepté la demande mais que le média n'est pas encore visible au moment de la vérification.

Une erreur réelle du contrôle retourne un échec.

Cette distinction évite de considérer un refresh asynchrone comme un échec simplement parce que l'indexation n'est pas instantanée.

La vérification utilise le titre et l'année extraits du nom de fichier.

Aucune suppression ou modification locale n'est effectuée.
