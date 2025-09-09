- **Language:** Use only English for code, including comments, documentation, examples, commits, configurations, errors, and tests.
- **Style**: Prefer self-documenting code over comments.
- **Comments**: DON'T use comments to explain code.
- **Inclusive Terms:** Use allowlist/blocklist instead of whitelist/blacklist, primary/replica instead of master/slave, and so on.
- **Tools**: Use `rg` instead of `grep`, `fd` instead of `find`, and if needed, use `tree` to understand directory structure.
- **Implementations**: On non-test code, using mocks are FORBIDDEN. Create the real implementation like PostgresUserRepository.
# When you need to call tools from the shell, **use this rubric**:

- Find Files: `fd`
- Find Text: `rg` (ripgrep)
- Find Code Structure (TS/TSX): `ast-grep`
	- **Default to TypeScript:**
		- `.ts` → `ast-grep --lang ts -p '<pattern>'`
		- `.tsx` (React) → `ast-grep --lang tsx -p '<pattern>'`
	- For other languages, set `--lang` appropriately (e.g., `--lang rust`).
- Select among matches: pipe to `fzf`
- JSON: `jq`
- YAML/XML: `yq`

If ast-grep is available avoid tools `rg` or `grep` unless a plain‑text search is explicitly requested.
