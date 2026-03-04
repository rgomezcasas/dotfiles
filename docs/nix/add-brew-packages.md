# Adding Homebrew Brews

File: `config/nix/packages/brew.nix` → `brews` list

Add the package name in alphabetical order. For custom taps, use the full path (e.g., `"denisidoro/tools/docpars"`).

Prefer Nix packages (`config/nix/packages/nix.nix`) when available.

Run `rebuild` after changes.
