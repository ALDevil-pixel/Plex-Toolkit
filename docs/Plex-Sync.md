# Synchronisation Plex

## Sprint 1.14.0.1

Cette première partie prépare la synchronisation sans effectuer de modification.

## Sprint 1.14.0.2

Cette partie ajoute la validation d'une cible avant toute future action `ADD_TO_PLEX`.

Configuration :

```text
PLEX_SYNC_ALLOWED_ROOTS
```

Lorsqu'elle est renseignée, un fichier doit se trouver sous l'un des répertoires autorisés.

La commande :

```bash
./plex-toolkit plex-sync-validate --config config/plex.conf <fichier-local> <library-key>
```

vérifie :

- existence du fichier ;
- lecture du fichier ;
- extension autorisée ;
- absence de lien symbolique ;
- appartenance éventuelle aux racines autorisées ;
- existence de la bibliothèque Plex ;
- type `movie` de la bibliothèque.

La commande est strictement en lecture seule.

Elle affiche explicitement :

```text
Action         : ADD_TO_PLEX (prepared only)
Modification   : NONE
```

`--fix` est refusé.

Aucune requête de modification Plex n'est encore effectuée.
