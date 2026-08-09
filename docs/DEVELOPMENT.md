# Développement

## Tests

```bash
make test
```

ou directement :

```bash
bash tests/run.sh
```

## Lint

Le lint utilise ShellCheck :

```bash
make lint
```

Si ShellCheck n'est pas installé, la commande retourne `2`.

## Validation complète

```bash
make validate
```

Cette cible exécute les tests puis le lint.

## Installation des permissions

```bash
make install
```

Les scripts du Toolkit sont rendus exécutables, y compris ceux des répertoires `commands`, `lib`, `plugins` et `tests`.
