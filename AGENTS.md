## Keyboard shortcuts

When modifying keyboard shortcuts, always edit `os/mac/karabiner-goku/karabiner.edn`.

After any change, run `goku` to validate the configuration compiles correctly.

## Packages

When asked to install a package, add it to the appropriate file in alphabetical order:

- **Nix packages** (CLI tools, libraries): `nix/_packages.nix`
- **Homebrew brews** (CLI tools not available in Nix): `nix/_homebrew.nix` under `brews`
- **Homebrew casks** (GUI apps): `nix/_homebrew.nix` under `casks`
- **Mac App Store apps**: `nix/_homebrew.nix` under `masApps`

After adding the package, tell the user to run `rebuild` to apply changes.

## Git

When committing, include all files except submodules.
