# Adding Mac App Store Apps

File: `nix/packages/app-store.nix` → `masApps` attribute

Add the app name (as it appears in `/Applications`) and its App Store ID:

```nix
masApps = {
    "Final Cut Pro" = 424389933;
};
```

Find the ID from the app URL (`https://apps.apple.com/app/idXXXXXXXXX`) or with `mas search <name>`.

Apps are only installed if missing from `/Applications` (no slow reinstalls on every update).

Run `rebuild` after changes.
