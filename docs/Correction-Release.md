# Release de correction

## Partie 1

- Restauration des fichiers perdus lors de la consolidation.
- Correction du dispatcher CLI.
- Ajout du routage de `--config`.
- Correction de la validation booléenne.
- Restauration de l'exécutabilité du lanceur.

## Partie 2

### Priorité de configuration

La priorité est désormais :

```text
valeurs par défaut
      ↓
fichiers de configuration
      ↓
options CLI explicites
```

Les options explicites :

```text
--fix
--dry-run
--verbose
--quiet
```

restent prioritaires sur les valeurs chargées depuis les fichiers de configuration.

### Booléens

Les valeurs de configuration sont normalisées avant leur utilisation par les commandes.

```text
true  → 1
false → 0
```

pour les indicateurs CLI internes.

La validation d'une valeur booléenne reste distincte du test logique de cette valeur.
