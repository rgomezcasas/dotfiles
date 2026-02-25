# Adding Homebrew Brews

CLI tools not available in Nix are managed as brews in `nix/_package-brew.nix`.

## Adding a Brew

Add the package name in alphabetical order inside the `brews` list:

```nix
brews = [
    "bitwarden-cli"
    "my-new-tool"    # <-- add here alphabetically
    "switchaudio-osx"
];
```

For packages from custom taps, use the full tap path:

```nix
"denisidoro/tools/docpars"
"sst/tap/opencode"
```

## Apply Changes

After editing the file, run:

```sh
rebuild
```

## Notes

- Prefer Nix packages (`nix/_package-nix.nix`) for CLI tools when available
- Use `brew search <name>` to find the correct package name
- `onActivation.cleanup = "zap"` removes packages not listed in this file
