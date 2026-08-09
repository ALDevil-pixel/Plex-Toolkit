# Tests

La suite de tests peut être lancée depuis la racine du dépôt :

```bash
bash tests/run.sh
```

Elle recherche automatiquement tous les fichiers :

```text
tests/test-*.sh
```

Chaque test est exécuté séparément.

À la fin, le nombre de tests réussis et échoués est affiché.

Le script retourne :
- `0` si tous les tests passent ;
- `1` si au moins un test échoue.
