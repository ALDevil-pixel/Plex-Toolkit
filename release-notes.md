# Sprint 1.13.0 - Partie 2

## Client API Plex

- Ajout d'un client HTTP Plex centralisé.
- Utilisation du token via l'en-tête `X-Plex-Token`.
- Timeout configurable.
- Vérification TLS configurable.
- Retries configurables.
- Journalisation des échecs.
- Ajout de `plex-ping`.
- Ajout de tests de non-fuite du token.
- Aucune logique métier de bibliothèque dans le client API.
