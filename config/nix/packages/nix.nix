# $ nix-env -qaP | grep wget
{ pkgs, ... }:

with pkgs;
[
  bat
  cargo
  cmatrix
  coreutils
  delta
  eza
  fd
  ffmpeg
  findutils
  fzf
  gh
  git
  git-lfs
  gnupg
  go
  goku
  gradle
  htop
  hyperfine
  jdk21
  lazygit
  nixfmt
  nodejs_24
  nvd
  pipx
  python313
  python3Packages.pip
  ripgrep
  shellcheck
  shfmt
  sl
  terminal-notifier
  tree
  unrar
  uv
  watch
  wget
  yarn
  z-lua
  zsh
  ast-grep
  bitwarden-cli
  libpq
  mitmproxy
  ollama
  switchaudio-osx
  yt-dlp

  # gui
  gum
  mas
  pinentry_mac
  skhd
]
