# Plex Toolkit

Plex Toolkit is a modular Bash toolkit for maintaining and auditing a Plex media server.

## Current release

Version: `0.2.1`

The repository currently contains the consolidated Sprint 1.x foundation and the correction releases applied after consolidation.

## Usage

```bash
./plex-toolkit help
./plex-toolkit version
```

Common options include:

```text
--config <file>
--dry-run
--fix
--verbose
--quiet
```

Command-specific options are handled by their respective commands.

## Development

```bash
make test
make lint
make validate
```

The historical sprint tests are regression tests: they validate retained functionality and do not require `SPRINT_STATE.md` to remain on an old sprint.
