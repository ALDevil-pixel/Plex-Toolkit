# Developer Guide

Create a new command:

1. Create `commands/my-command`
2. Implement logic in `lib/mycommand.sh`
3. Add tests in `tests/`
4. Document options if needed.

Plugins should stay very small and delegate all work to `lib/`.
