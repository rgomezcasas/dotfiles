# Adding Global npm Packages

File: `config/nix/packages/global-npm.nix`

For npm packages not available in `nixpkgs.nodePackages`, add the package name to the `packages` list in alphabetical order.

These packages are installed globally via `npm install -g` during `rebuild`.

Run `rebuild` after changes.
