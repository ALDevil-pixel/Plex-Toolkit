# Synchronisation Plex

## Sprint 1.14.0

Le sprint introduit une chaîne de synchronisation locale vers Plex progressive :

```text
plex-sync-plan
       ↓
plex-sync-validate
       ↓
plex-sync-add
       ↓
refresh Plex ciblé
       ↓
vérification
```

### Sécurité

Toutes les actions sont en lecture seule par défaut.

Une action réelle nécessite explicitement :

```text
--fix
```

Les protections suivantes sont appliquées :

- extension média autorisée ;
- fichier existant et lisible ;
- refus des liens symboliques ;
- racines locales autorisées ;
- bibliothèque Plex existante ;
- type `movie` ;
- fichier situé dans une `Location` Plex de la bibliothèque ;
- refresh limité au répertoire contenant le média ;
- aucune copie, suppression, déplacement ou renommage local.

### Vérification asynchrone

Après le refresh :

```text
FOUND
```

signifie que Plex voit déjà le média.

```text
PENDING
```

signifie que Plex a accepté la demande mais que l'indexation n'est pas encore visible.

### Tests

Les tests spécifiques peuvent être exécutés avec :

```bash
bash tests/test-sprint-1.14.sh
bash tests/test-plex-sync-safety.sh
bash tests/test-plex-sync-integration.sh
bash tests/test-plex-sync-failure.sh
```

Les tests utilisent une API Plex simulée.

Aucun serveur Plex réel n'est requis.

Le Sprint 1.14.0 est prêt pour consolidation.
