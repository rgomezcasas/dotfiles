## Documentation

Refer to the `docs/` folder for detailed guides:

- `docs/karabiner/` — Karabiner keyboard shortcuts
- `docs/nix/` — Adding packages (nix, brew, casks, node, Mac App Store)
- `docs/raycast/` — Creating Raycast scripts
- `docs/scripts/` — Creating new scripts (docblock format, structure)
- `docs/shell/` — Shell command portability and aliases
- `docs/vscode-and-cursor/` — Custom shortcuts and settings

## Nix symlinks — when to rebuild

Almost every file under `config/` (shell, editors, macos, git, agents) is symlinked into place by home-manager with `mkOutOfStoreSymlink` (see `config/nix/system/symlinks.nix`). Editing those files takes effect immediately — never suggest running `rebuild` after editing them.

`rebuild` is only needed when `config/nix/` itself changes:

- `packages/*.nix` — packages added or removed
- `system/symlinks.nix` — symlink entries added, removed, or repointed
- `system/macos-defaults.nix`, `flake.nix`

Special cases:

- `karabiner.edn` → run `goku` (never edit `karabiner.json`)
- Shell config (aliases, functions, zshrc) → only affects new shell sessions

## Git

- If you think it makes sense to split something into separate commits, go ahead and do it.
- **Do not** autocommit
