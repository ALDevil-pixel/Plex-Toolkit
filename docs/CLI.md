# CLI

Le point d'entrée du Toolkit est :

```bash
./plex-toolkit <commande> [options]
```

Commandes disponibles :

```text
audit
check
cleanup
doctor
duplicates
help
info
inventory
list
rename
self-check
version
```

Sans commande, `plex-toolkit` affiche l'aide.

Une commande inconnue retourne `2` et affiche une indication pour utiliser `help`.

Les commandes restent responsables de leurs propres options et de leur logique métier.
