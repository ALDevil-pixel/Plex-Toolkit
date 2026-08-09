# Release Sprint 1.10.0

## Vérification finale

Lancer la suite complète :

```bash
bash tests/run.sh
```

Puis le contrôle spécifique au sprint :

```bash
bash tests/test-sprint-1.10.sh
```

Enfin :

```bash
bash tests/test-release-ready.sh
```

Si ShellCheck est installé :

```bash
make lint
```

## Après validation

Créer un nouveau ZIP consolidé du dépôt.

Ce ZIP consolidé devient la seule base de référence pour le sprint suivant.

Ne pas repartir d'un lot intermédiaire.
