Correction Release
Partie: 6

Status: COMPLETE

Partie 2:
- Priorité configuration → CLI corrigée.
- Normalisation des booléens communs ajoutée.
- Tests de précédence ajoutés.

Objectif:
- Restaurer les fichiers perdus lors de la consolidation.
- Corriger le dispatcher CLI.
- Ajouter la gestion commune de --config.
- Séparer validation booléenne et test de valeur booléenne.
- Restaurer l'exécutabilité Linux du lanceur.

Priorité:
- P0 : consolidation et socle CLI/configuration.

Fichiers restaurés depuis Git:
- version

Correction 3 validée : comparaison d'inventaires et tests associés OK.

Partie 4 validée : options spécifiques conservées par le parser commun et traitées par la commande.

Partie 5 validée : tests historiques rendus indépendants de SPRINT_STATE.md.

Partie 6 validée : permissions des entry points/plugins restaurées et testées.
