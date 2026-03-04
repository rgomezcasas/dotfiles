# Guidelines

- **Language:** English only for code, comments, docs, commits, configs, errors, tests
- **Style:** Self-documenting code, NO comments to explain code
- **Terms:** allowlist/blocklist, primary/replica (inclusive alternatives)
- **Implementations:** Real implementations only, NO mocks in non-test code

# Shell Tools

- **Files:** `fd`, **Text:** `rg`, **Structure:** `tree`
- **Code Analysis:** `ast-grep --lang ts/tsx/rust -p '<pattern>'`
- **Processing:** `fzf`, `jq`, `yq`

**Priority:** Use `ast-grep` over `rg`/`grep` unless plain-text search requested
