# Intégration Plex

## Configuration

La configuration Plex est définie dans :

```text
config/plex.conf
```

Paramètres :

```text
PLEX_URL
PLEX_TOKEN
PLEX_TIMEOUT
PLEX_VERIFY_TLS
PLEX_RETRIES
```

Le token ne doit jamais être versionné.

## Client API

Les appels HTTP sont centralisés dans :

```text
lib/plex_api.sh
```

Le module fournit notamment :

```text
ptk_plex_request
ptk_plex_ping
ptk_plex_url
```

Les paramètres réseau sont pris exclusivement depuis `config/plex.conf`.

Le client :

- utilise le token Plex dans l'en-tête HTTP ;
- applique le timeout configuré ;
- respecte la vérification TLS ;
- effectue le nombre de tentatives configuré ;
- journalise les échecs ;
- ne contient aucune logique métier.

## Vérification de connexion

```bash
./plex-toolkit plex-ping --config config/plex.conf
```

Cette commande contacte :

```text
/identity
```

et retourne un code de succès ou d'erreur.

Le token n'est jamais affiché dans la sortie.

Les commandes de bibliothèque seront ajoutées dans les prochaines parties.
