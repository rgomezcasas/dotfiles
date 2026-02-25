# Adding Mac App Store Apps

Mac App Store apps are managed in `nix/_package-brew.nix` under the `masApps` attribute.

## Adding an App

Add the app name and its App Store ID inside `masApps`:

```nix
masApps = {
    "Final Cut Pro" = 424389933;
    "My App" = 123456789;
};
```

## Finding the App Store ID

The ID is in the app's App Store URL: `https://apps.apple.com/app/idXXXXXXXXX`.

Or use `mas` from the terminal:

```sh
mas search <app-name>
```

## Apply Changes

After editing the file, run:

```sh
rebuild
```
