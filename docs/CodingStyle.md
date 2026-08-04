# Coding Style

Mandatory rules

- `set -euo pipefail`
- Quote all variables.
- ShellCheck clean.
- Exit codes:
  - 0 success
  - 1 runtime error
  - 2 configuration error
  - 3 invalid arguments
- Every command logs its actions.
- Support `--dry-run` whenever changes are made.
- No duplicated code.
