# Sprint 1.16.0 - Partie 1

## Socle CLI

Cette partie corrige deux incohérences importantes révélées par la consolidation :

- les commandes avec un tiret dans leur nom n'étaient pas correctement appelées par le dispatcher ;
- `--config` n'était pas géré par le parser CLI commun des nouvelles commandes.

### Corrections

- Conversion automatique `-` → `_` dans le dispatcher.
- Ajout de `--config <fichier>` à `cli_options.sh`.
- Routage des configurations connues vers leurs variables dédiées.
- Conservation de la compatibilité `PLEXTK_CONFIG`.
- Ajout de tests unitaires et d'intégration.
- Documentation CLI mise à jour.

Aucune nouvelle action destructive n'est introduite.
