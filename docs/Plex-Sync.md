# Synchronisation Plex

## Sprint 1.14.0.1

La commande `plex-sync-plan` prépare les actions sans modifier Plex.

## Sprint 1.14.0.2

La commande `plex-sync-validate` vérifie les cibles avant action.

## Sprint 1.14.0.3

La commande `plex-sync-add` réalise la première action Plex réelle :

```bash
./plex-toolkit plex-sync-add   --config config/plex.conf   --fix   /media/Films/MonFilm.mkv   1
```

### Principe

Plex découvre les nouveaux médias lors d'un refresh de bibliothèque.

Le Toolkit ne déclenche jamais un refresh global lorsque l'ajout est ciblé.

Il :

1. vérifie le fichier ;
2. vérifie la bibliothèque ;
3. récupère les chemins `Location` de la bibliothèque Plex ;
4. vérifie que le fichier se trouve réellement sous une de ces locations ;
5. détermine le répertoire contenant le fichier ;
6. demande à Plex un refresh limité à ce répertoire.

Endpoint utilisé :

```text
/library/sections/<library-key>/refresh?path=<directory>
```

### Dry-run

Sans `--fix` :

```bash
./plex-toolkit plex-sync-add   --config config/plex.conf   /media/Films/MonFilm.mkv   1
```

aucune requête de modification n'est envoyée.

### Sécurité

Le `--fix` est obligatoire pour effectuer le refresh.

Le fichier doit appartenir à une location Plex de la bibliothèque cible.

Le Toolkit refuse :

- un fichier inexistant ;
- une extension non supportée ;
- un lien symbolique ;
- une bibliothèque inexistante ;
- une bibliothèque qui n'est pas de type `movie` ;
- un fichier situé hors des locations Plex ;
- un fichier situé hors des racines autorisées si `PLEX_SYNC_ALLOWED_ROOTS` est configuré.

Le Toolkit ne supprime, ne déplace et ne renomme aucun fichier.
