# Creating New Scripts

Scripts live in `scripts/`, organized by category subdirectory (e.g., `docker/`, `github/`, `utils/`). No `.sh` extension. Use snake_case filenames.

## Template

```bash
#!/usr/bin/env bash

set -euo pipefail

source "$DOTLY_PATH/scripts/core/_main.sh"

##? Description of what the script does
#?? 1.0.0
##?
##? Usage:
##?   script_name [ARGS]
##?   script_name -h | --help

docs::parse "$@"

# script logic here
```

The `##?` docblock is parsed by `docs::parse` and shown automatically with `-h` or `--help`.

## CI Validation

CI automatically validates that every script in `scripts/` (excluding `core/` and `ci/`):

- Contains at least one `##?` docblock line
- Has executable permissions (`chmod +x`)
