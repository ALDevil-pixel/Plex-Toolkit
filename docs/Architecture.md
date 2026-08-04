# Architecture

```text
User
  │
  ▼
plex-toolkit
  │
  ▼
Plugin (commands/)
  │
  ▼
Library (lib/)
  │
  ▼
Configuration (config/)
  │
  ▼
Filesystem / Plex
```

Rules:

- One plugin = one responsibility.
- Shared code goes into `lib/`.
- No hardcoded paths.
- Plugins never call each other.
