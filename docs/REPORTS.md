# Reports

Les chemins et noms des rapports sont définis dans :

```text
config/report.conf
```

Paramètres :

```text
REPORT_DIR
AUDIT_TEXT_REPORT
AUDIT_JSON_REPORT
```

Le code ne doit pas contenir de chemin de rapport en dur.

La fonction commune `ptk_report_summary` crée le répertoire configuré si nécessaire et écrit le rapport demandé.
