# Consolidation v0.2.1

## Lot 7

Journalisation commune des commandes principales.

Les commandes :
- `rename`
- `cleanup`
- `check`
- `inventory`

utilisent maintenant `lib/logger.sh` pour enregistrer :
- le démarrage ;
- la fin ;
- le code de retour ;
- les erreurs d'exécution.

Fichier par défaut :

```text
logs/plex-toolkit.log
```

Le fichier peut être redéfini avec `PTK_LOG_FILE`.
