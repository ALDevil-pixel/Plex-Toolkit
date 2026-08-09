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

La correction évite notamment qu'une modification de contenu au même chemin soit rapportée comme `REMOVED + ADDED`.

Elle reconnaît aussi un déplacement lorsque le hash reste identique.
