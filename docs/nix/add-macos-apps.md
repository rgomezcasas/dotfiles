# Adding Mac App Store Apps

File: `nix/_package-brew.nix` → `masApps` attribute

Add the app name and its App Store ID:

```nix
masApps = {
    "Final Cut Pro" = 424389933;
};
```

Find the ID from the app URL (`https://apps.apple.com/app/idXXXXXXXXX`) or with `mas search <name>`.

Run `rebuild` after changes.
