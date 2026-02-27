<h3 align="center">
    rgomezcasas/dotfiles
    <a href="mac"><img height="12" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/apple.svg" /></a>
</h3>
<p align="center">
  <img src="https://user-images.githubusercontent.com/1331435/70709921-530e8780-1cde-11ea-814c-7b63566670d4.gif" alt="rgomezcasas/dotfiles" width="80%">
  <br>
  <sub>macOS dotfiles powered by Nix flakes, home-manager, and 80+ shell scripts</sub>
</p>
<p align="center">
  <a href="#-installation">Install</a>&nbsp;&nbsp;•&nbsp;
  <a href="#-daily-workflow">Workflow</a>&nbsp;&nbsp;•&nbsp;
  <a href="#-structure">Structure</a>&nbsp;&nbsp;•&nbsp;
  <a href="#-documentation">Docs</a>
</p>


## Stack

| Layer         | Tool                                                                                                                |
|---------------|---------------------------------------------------------------------------------------------------------------------|
| System config | [nix-darwin](https://github.com/LnL7/nix-darwin) flake                                                              |
| User config   | [home-manager](https://github.com/nix-community/home-manager) (symlinks, session)                                   |
| GUI packages  | [Homebrew](https://brew.sh) via [nix-homebrew](https://github.com/zhaofengli-wip/nix-homebrew)                      |
| Shell         | Zsh + [Zim](https://zimfw.sh) (<10ms startup)                                                                       |
| Terminal      | [Ghostty](https://ghostty.org)                                                                                      |
| Keyboard      | [Karabiner-Elements](https://karabiner-elements.pqrs.org) via [Goku](https://github.com/yqrashawn/GokuRakuJoketsu)  |
| Scripts       | 80+ bash scripts via [dotly](https://github.com/codelytv/dotly) framework                                           |


## Prerequisites

- macOS on Apple Silicon (aarch64-darwin)
- [Nix](https://nixos.org/download/) with flakes enabled
- SSH key with access to [dotfiles-private](https://github.com/rgomezcasas/dotfiles-private) submodule


## Installation

```bash
# 1. Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Clone with submodules
git clone --recurse-submodules git@github.com:rgomezcasas/dotfiles.git ~/.dotfiles

# 3. Build and apply the system configuration
cd ~/.dotfiles/nix
sudo darwin-rebuild switch --flake .#pro --impure
```

This single command installs all Nix packages, Homebrew formulas/casks, Mac App Store apps, applies macOS defaults, and creates all symlinks via home-manager.


## Daily workflow

| Command              | Alias     | What it does                                                        |
|----------------------|-----------|---------------------------------------------------------------------|
| `dot system rebuild` | `rebuild` | Rebuild system with current Nix flake                               |
| `dot system update`  | `up`      | Update flake inputs, diff changes, rebuild, and upgrade Zim plugins |
| `dot`                | —         | Browse all available scripts interactively                          |

### Adding packages

See the [nix docs](docs/nix/) for step-by-step guides:

- [Nix packages](docs/nix/add-nix-packages.md) — CLI tools managed by Nix
- [Homebrew packages](docs/nix/add-brew-packages.md) — brews not available in nixpkgs
- [Homebrew casks](docs/nix/add-brew-casks.md) — GUI applications
- [Node packages](docs/nix/add-node-packages.md) — global Node.js tools
- [Mac App Store apps](docs/nix/add-macos-apps.md) — apps via `mas`

### Editing keyboard shortcuts

Edit `os/mac/karabiner-goku/karabiner.edn` and run `goku`. **Never** edit `karabiner.json` directly. See the [Karabiner guide](docs/karabiner/custom-shortcuts.md).


## Structure

```
~/.dotfiles
├── ai/                  # Claude/AI agent instructions and commands
├── docs/                # Guides (packages, scripts, keyboard, editors)
├── editors/             # VSCode, Cursor, IntelliJ, Vim, Claude Code configs
├── git/                 # .gitconfig, .gitattributes, .gitignore_global
├── modules/
│   ├── dotly/           # Shell script framework (submodule)
│   ├── private/         # Credentials, GPG, private configs (submodule)
│   └── ghostty-cursor-shaders/
├── nix/
│   ├── flake.nix        # Main flake: nix-darwin + home-manager + nix-homebrew
│   ├── home.nix         # Home-manager entry point
│   ├── _symlinks.nix    # All dotfile symlinks (~/.zshrc, ~/.gitconfig, etc.)
│   ├── _package-nix.nix # Nix packages (50+ CLI tools)
│   ├── _package-brew.nix# Homebrew brews, casks, and Mac App Store apps
│   ├── _package-node.nix# Global Node.js packages
│   └── _macos-defaults.nix # macOS system preferences
├── os/mac/              # Karabiner, Ghostty, skhd, Raycast, LaunchAgents
├── scripts/             # 80+ scripts organized by category
│   ├── system/          #   rebuild, update, volume, cron...
│   ├── github/          #   git/GitHub utilities
│   ├── claude/          #   Claude CLI wrappers
│   └── ...              #   ai, docker, image, network, utils, video...
└── shell/               # Zsh/Bash configs, aliases, exports, functions
```


## Documentation

| Guide              | Path                                                 |
|--------------------|------------------------------------------------------|
| Adding packages    | [`docs/nix/`](docs/nix/)                             |
| Creating scripts   | [`docs/scripts/`](docs/scripts/)                               |
| Keyboard shortcuts | [`docs/karabiner/`](docs/karabiner/)                             |
| Raycast scripts    | [`docs/raycast/`](docs/raycast/)                               |
| Editor settings    | [`docs/vscode-and-cursor/`](docs/vscode-and-cursor/)                     |


## Performance

Shell startup consistently under 10ms thanks to Zim + `zsh-defer` lazy loading:

```
λ ~ dot shell zsh test_performance
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.00s
```


## License

The MIT License (MIT). See [LICENSE](LICENSE) for more information.
