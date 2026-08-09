# Release de correction

## Partie 1

- Restauration des fichiers perdus lors de la consolidation.
- Correction du dispatcher CLI.
- Ajout du routage de `--config`.
- Correction de la validation booléenne.
- Restauration de l'exécutabilité du lanceur.

## Partie 2

### Priorité de configuration

```text
valeurs par défaut
      ↓
configuration
      ↓
options CLI explicites
```

### Booléens

Validation et interprétation des booléens sont séparées.

## Partie 3

### Comparaison d'inventaires

Chaque ancien enregistrement est classé une seule fois :

1. même chemin :
   - `UNCHANGED` si les métadonnées sont identiques ;
   - `CHANGED` sinon ;
2. chemin différent mais identité identique :
   - `CHANGED` ;
3. aucune correspondance :
   - `REMOVED`.

Les nouveaux enregistrements non rapprochés deviennent `ADDED`.

## Partie 4

### Options communes / spécifiques

Le parser commun traite uniquement les options globales.

Les options propres à une commande sont transmises intactes dans `PTK_POSITIONAL` afin que la commande puisse les interpréter elle-même.

Le flux est :

```text
CLI
 ↓
options communes
 ↓
options/options arguments spécifiques conservés
 ↓
parser de la commande
```

Le dispatcher continue de convertir automatiquement les noms de commandes :

```text
plex-sync-add
      ↓
cmd_plex_sync_add
```

Cette architecture évite de faire grossir le parser global à chaque nouveau plugin.
