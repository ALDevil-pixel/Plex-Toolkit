Sprint: 1.16.0
Partie: 1

Status: COMPLETE

Objectif:
- Réparer et uniformiser le socle CLI avant d'ajouter de nouvelles fonctionnalités.

Modified:
- plex-toolkit
- lib/cli_options.sh
- docs/CLI.md

New:
- tests/test-cli-dispatch-config.sh
- tests/test-cli-dispatch-integration.sh

Important:
- Le dispatcher convertit désormais automatiquement les tirets des commandes en underscores pour appeler les fonctions shell.
- --config est pris en charge par le parser CLI commun et routé vers la variable de configuration appropriée.
