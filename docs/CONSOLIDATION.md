# Consolidation v0.2.1

La base commune CLI fournit désormais aussi deux helpers :

- `ptk_is_dry_run`
- `ptk_is_fix_enabled`

Les commandes peuvent donc tester le mode d'exécution sans dupliquer la logique sur `PTK_DRY_RUN`.

Le comportement reste inchangé :
- mode lecture seule par défaut ;
- `--dry-run` force la lecture seule ;
- `--fix` active les modifications uniquement pour les commandes qui le supportent.
