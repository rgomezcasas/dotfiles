# Adding Nix Packages

File: `nix/_package-nix.nix`

Add the package name in alphabetical order to the list. This is the preferred method over Homebrew for CLI tools.

Some packages use version suffixes (`nodejs_24`, `python313`) or sub-attribute sets (`python3Packages.pip`).

Run `rebuild` after changes.
