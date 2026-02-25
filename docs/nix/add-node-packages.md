# Adding Node Packages

File: `nix/_package-node.nix`

Add the package name in alphabetical order. Packages come from `pkgs.nodePackages`.

Only globally needed packages belong here (e.g., language servers). Project-specific dependencies go in each project's `package.json`.

Run `rebuild` after changes.
