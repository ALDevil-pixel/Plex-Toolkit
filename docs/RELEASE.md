# Release 0.2.1

## État

La consolidation `0.2.1` et le Sprint `1.8.0` sont prêts pour une vérification finale.

## Vérification

Depuis la racine :

```bash
bash tests/run.sh
```

Puis :

```bash
make lint
```

La cohérence structurelle peut être vérifiée avec :

```bash
bash tests/test-release-coherence.sh
```

## Règle de consolidation

Les fichiers modifiés lors des lots sont toujours fournis dans leur intégralité.

Le prochain dépôt consolidé doit être utilisé comme base avant tout nouveau sprint.

## Version

La version actuelle du dépôt est celle indiquée dans `VERSION`.
