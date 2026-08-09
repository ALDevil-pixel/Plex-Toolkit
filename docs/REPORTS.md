# Reports

Les rapports utilisent les configurations présentes dans `config/`.

## Fiabilité des écritures

Les rapports sont écrits dans un fichier temporaire puis remplacés avec `mv`.
Cela évite de laisser un rapport partiellement écrit en cas d'échec pendant la génération.

## CSV

Les champs CSV sont systématiquement entourés de guillemets et les guillemets internes sont doublés conformément au format CSV.

## JSON

Les caractères spéciaux utilisés dans les noms et chemins sont échappés avant génération du JSON.

La taille des entrées Inventory doit être un entier positif ou nul.

## Logs Inventory

Les erreurs d'écriture du log sont maintenant retournées au caller.
