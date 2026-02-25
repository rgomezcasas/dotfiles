# Adding Node Packages

Global Node packages are managed in `nix/_package-node.nix` through the Nix package set.

## File Structure

```nix
{ pkgs, ... }:

with pkgs.nodePackages; [
    typescript
    typescript-language-server
]
```

## Adding a Package

Add the package name in alphabetical order inside the list. Packages come from `pkgs.nodePackages`:

```nix
with pkgs.nodePackages; [
    my-new-package    # <-- add here alphabetically
    typescript
    typescript-language-server
]
```

## Apply Changes

After editing the file, run:

```sh
rebuild
```

## Notes

- Only add globally needed packages here (e.g., language servers, CLI tools)
- Project-specific dependencies should live in each project's `package.json`
- Use [search.nixos.org](https://search.nixos.org/packages) and search for `nodePackages.<name>` to verify availability
