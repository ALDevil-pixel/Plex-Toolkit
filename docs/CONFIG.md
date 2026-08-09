# Configuration

Les valeurs communes sont centralisées dans :

```text
config/defaults.conf
```

Les fichiers de configuration spécialisés peuvent surcharger ces valeurs.

Exemples :

```text
config/library.conf
config/check.conf
config/report.conf
config/inventory.conf
```

Le chargement commun est assuré par :

```text
lib/config.sh
```

Ordre de chargement :

```text
defaults.conf
      ↓
configuration spécialisée
      ↓
valeurs spécialisées
```

Une configuration spécialisée peut donc modifier une valeur commune sans dupliquer toute la configuration par défaut.
