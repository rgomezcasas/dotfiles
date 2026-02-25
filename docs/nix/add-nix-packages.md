# Adding Nix Packages

Nix packages are managed in `nix/_package-nix.nix`. This is the preferred method for installing CLI tools and libraries.

## File Structure

```nix
{ pkgs, ... }:

with pkgs; [
    ast-grep
    bat
    fd
    # ...
]
```

## Adding a Package

1. Search for the package name:

```sh
nix-env -qaP | grep <name>
```

2. Add the package in alphabetical order to the list:

```nix
with pkgs; [
    fd
    my-new-package    # <-- add here alphabetically
    fzf
]
```

### Packages with Version Suffixes

Some packages require a version suffix:

```nix
jdk21
nodejs_24
python313
```

### Packages from Sub-Attribute Sets

Some packages live under a namespace:

```nix
python3Packages.pip
```

## Apply Changes

After editing the file, run:

```sh
rebuild
```

## Notes

- Prefer Nix over Homebrew brews for CLI tools whenever possible
- Use [search.nixos.org](https://search.nixos.org/packages) to find package names
