# Plugins

## Structure

Les plugins sont organisés par domaine :

```text
plugins/
├── anime/
├── movies/
└── plex/
```

Un plugin est un script shell exécutable.

Exemple :

```text
plugins/anime/audit.sh
```

## Contrat

Un plugin :

- est exécutable ;
- reçoit ses arguments dans le même ordre que l'appelant ;
- retourne un code de sortie ;
- ne doit pas appeler `exit` depuis une bibliothèque chargée par une commande ;
- doit utiliser les bibliothèques communes lorsqu'elles sont nécessaires.

## API

La découverte et l'exécution sont centralisées dans :

```text
lib/plugin.sh
```

Fonctions principales :

```text
ptk_plugin_root
ptk_plugin_path
ptk_plugin_exists
ptk_plugin_list
ptk_plugin_run
```

Les anciennes fonctions `plugin_exists` et `plugin_run` restent disponibles pour compatibilité.

## Liste

```bash
source lib/plugin.sh
ptk_plugin_list
```

## Exécution

```bash
source lib/plugin.sh
ptk_plugin_run anime audit
```

Les plugins actuellement présents sont des placeholders. Leur logique métier sera ajoutée dans les sprints fonctionnels dédiés.
