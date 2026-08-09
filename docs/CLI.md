# CLI

Le point d'entrée du Toolkit est :

```bash
./plex-toolkit <commande> [options]
```

## Commandes

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

## Options communes

Les commandes qui les supportent utilisent :

```text
--dry-run
--fix
--verbose
--quiet
--
```

Une option commençant par `-` et inconnue est maintenant rejetée avec le code `2`.

Les valeurs d'options obligatoires doivent être vérifiées par les commandes ou bibliothèques concernées.

## Codes

```text
0 = succès
1 = erreur
2 = erreur d'utilisation
```

Une commande inconnue retourne `2`.

Sans commande, `plex-toolkit` affiche l'aide.
