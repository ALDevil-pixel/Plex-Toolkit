# Configuration

Les valeurs communes sont centralisées dans :

```text
config/defaults.conf
```

Les fichiers spécialisés peuvent surcharger ces valeurs.

Exemples :

```text
config/library.conf
config/check.conf
config/report.conf
config/inventory.conf
```

## Validation

Le chargement passe par :

```text
lib/config.sh
```

Après chargement, les paramètres communs sont validés.

Les booléens acceptent :

```text
true / false
yes / no
1 / 0
on / off
```

Les chemins configurés ne doivent pas contenir de retour à la ligne.

Une configuration invalide fait échouer le chargement avec un code différent de `0`.
