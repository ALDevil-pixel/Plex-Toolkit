# Configuration Anime

La configuration Anime est séparée de la configuration générale :

```text
config/anime.conf
```

Elle définit les éléments nécessaires aux prochains modules Anime :

- répertoire racine optionnel ;
- modèle de nom de série ;
- modèle de saison ;
- modèle d'épisode ;
- extensions vidéo autorisées ;
- obligation de détecter une saison ;
- obligation de détecter un épisode.

Le chargement et la validation sont centralisés dans :

```text
lib/anime_config.sh
```

Cette partie ne réalise encore aucun renommage et aucune modification de fichier.

Les fonctionnalités Anime utiliseront cette configuration dans les parties suivantes du Sprint 1.11.0.
