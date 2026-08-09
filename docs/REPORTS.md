# Reports

Les rapports sont configurés dans les fichiers `config/`.

## Audit

```text
config/report.conf
```

Paramètres :

```text
REPORT_DIR
AUDIT_TEXT_REPORT
AUDIT_JSON_REPORT
```

## Inventory

```text
config/inventory.conf
```

Paramètres :

```text
REPORT_DIR
INVENTORY_CSV_REPORT
INVENTORY_JSON_REPORT
INVENTORY_LOG
```

Aucun chemin de rapport ne doit être codé en dur dans les modules.
