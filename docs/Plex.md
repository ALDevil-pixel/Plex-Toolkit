# Intégration Plex

## Configuration

La configuration Plex est séparée de la configuration générale :

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

Exemple :

```text
PLEX_URL="https://plex.example.test:32400"
PLEX_TOKEN="..."
PLEX_TIMEOUT=10
PLEX_VERIFY_TLS=true
PLEX_RETRIES=2
```

Le token ne doit jamais être placé dans le dépôt Git.

## Validation

```bash
./plex-toolkit plex-config --config config/plex.conf
```

La commande vérifie uniquement la cohérence de la configuration. Elle ne contacte pas encore le serveur Plex.

Le token est volontairement masqué dans la sortie.

## URL

Le module commun :

```text
lib/plex_config.sh
```

fournit également `ptk_plex_url` pour construire les URL Plex sans dupliquer la logique dans les prochaines commandes.

Les appels HTTP et l'API Plex seront ajoutés dans les parties suivantes.
