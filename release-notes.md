# Sprint 1.8.0 - Partie 13

## Point d'entrée CLI

- Le script `plex-toolkit` distribue maintenant vers toutes les commandes consolidées.
- Les fonctions `cmd_*` sont appelées directement.
- Les options restent gérées par chaque commande.
- Une commande inconnue retourne `2`.
- Sans argument, l'aide est affichée.
- Ajout d'un test du dispatcher.
