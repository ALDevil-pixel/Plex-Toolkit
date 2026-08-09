# Release de correction - Partie 4

## Options CLI spécifiques

- Le parser commun ne consomme plus les options propres aux commandes.
- `--deep` et `--summary` sont transmis tels quels.
- `--min-size <valeur>` et `--extensions <valeur>` conservent leur valeur.
- `duplicates` traite ses options métier dans son propre parser.
- Le dispatcher convertit les noms `commande-avec-tirets` en `cmd_commande_avec_tirets`.
- Ajout de tests de non-régression du parsing et de `duplicates`.
