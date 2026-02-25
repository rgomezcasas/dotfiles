# Creating New Scripts

Scripts in this project live in the `scripts/` directory, organized by category (e.g., `docker/`, `utils/`, `github/`). Each script includes a docblock that documents its purpose and usage.

## Script Structure

Start every script with the shebang and safety flags:

```bash
#!/usr/bin/env bash

set -euo pipefail
```

Then source the main utilities:

```bash
source "$DOTLY_PATH/scripts/core/_main.sh"
```

## Docblock Format

Use `##?` to document the script. The docblock is parsed automatically and shown when running with `-h` or `--help`:

```bash
##? Clear all Docker containers and volumes
##?
##? Usage:
##?   clear
##?   clear -h | --help
```

After the docblock, call `docs::parse` to handle help:

```bash
docs::parse "$@"
```

## Docblock Sections

### Description

First line after the shebang describes what the script does:

```bash
##? Clear all Docker containers and volumes
```

### Version (Optional)

Add a version with `#??`:

```bash
#?? 1.0.0
```

### Usage

Show how to run the script:

```bash
##? Usage:
##?   clear
##?   clear -h | --help
##?   deploy --environment prod
```

## Complete Example

```bash
#!/usr/bin/env bash

set -euo pipefail

source "$DOTLY_PATH/scripts/core/_main.sh"

##? Deploy application to a target environment
#?? 1.2.0
##?
##? Usage:
##?   deploy [ENVIRONMENT]
##?   deploy -h | --help
##?
##? Arguments:
##?   ENVIRONMENT  Target environment (dev, staging, prod)

docs::parse "$@"

environment="${1:-dev}"
echo "🚀 Deploying to $environment..."
# Script logic here
```

## Directory Organization

Place scripts in the appropriate category subdirectory:

```
scripts/
├── docker/      # Docker-related scripts
├── utils/       # General utilities
├── github/      # GitHub operations
├── ui/          # User interface scripts
└── [category]/  # Add new categories as needed
```

## Testing Help Output

Test your docblock by running the script with `-h`:

```bash
./scripts/docker/clear -h
```

## Notes

- No `.sh` extension needed (scripts are executable)
- Use lowercase directory names and snake_case filenames
- Keep scripts focused on a single task
- The `docs::parse` function automatically handles `-h` and `--help` flags
