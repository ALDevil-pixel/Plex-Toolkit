# Consolidation v0.2.1

## Lot 4

Les commandes principales utilisent maintenant le parseur commun :

- `rename`
- `cleanup`
- `check`
- `inventory`

Options communes :
- `--dry-run`
- `--fix`
- `--verbose` / `-v`
- `--quiet` / `-q`

Les arguments positionnels sont conservés pour cibler une bibliothèque.
La logique métier reste dans `lib/`.
