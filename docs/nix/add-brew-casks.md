# Adding Homebrew Casks

macOS GUI applications are managed as casks in `nix/_package-brew.nix`.

## Adding a Cask

Add the cask name in alphabetical order inside the `casks` list:

```nix
casks = [
    "figma"
    "my-new-app"    # <-- add here alphabetically
    "notion"
];
```

Some casks support version channels:

```nix
"ghostty@tip"
"google-chrome@canary"
```

## Apply Changes

After editing the file, run:

```sh
rebuild
```

## Notes

- Use `brew search --casks <name>` to find the correct cask name
- `onActivation.cleanup = "zap"` removes casks not listed in this file
