# self-check

## Usage

```bash
plex-toolkit self-check
```

Options communes :

```text
--dry-run
--verbose / -v
--quiet / -q
```

`self-check` vérifie uniquement les dépendances minimales nécessaires au Toolkit.
Il ne modifie aucun fichier et refuse donc `--fix`.

Le code de retour est :

- `0` : environnement minimal disponible ;
- `1` : une dépendance obligatoire manque ;
- `2` : mauvais paramètre.
