# Tests

## Suite complète

```bash
bash tests/run.sh
```

## Intégration

```bash
bash tests/test-integration.sh
```

Le test d'intégration vérifie le fonctionnement combiné du CLI, de la configuration, des plugins et du reporting.

## Non-régression

```bash
bash tests/test-regression.sh
```

Le test de non-régression vérifie les commandes de base et les wrappers legacy conservés pour compatibilité.

Les tests restent indépendants et ne nécessitent aucun framework externe.
