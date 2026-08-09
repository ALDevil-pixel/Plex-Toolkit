# Consolidation v0.2.1

## Lot 2

Ajout de `lib/library_runner.sh` pour centraliser le parcours des bibliothèques.

Les commandes concernées conservent leur comportement existant :
- une cible passée en argument traite uniquement cette cible ;
- sans cible, les bibliothèques de `config/library.conf` sont parcourues.

Le runner reçoit un callback et transmet le nom et le chemin de chaque bibliothèque.
