# $ nix-env -qaP | grep wget
{ pkgs, ... }:

with pkgs;
[
  ast-grep
  bat
  bitwarden-cli
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
  go
  goku
  gradle
  htop
  hyperfine
  jdk25
  lazygit
  libpq
  maven
  mitmproxy
  nixfmt
  nvd
  ollama
  pipx
  (python313.withPackages (ps: [ ps.pip ]))
  ripgrep
  shellcheck
  shfmt
  sl
  switchaudio-osx
  terminal-notifier
  tree
  unrar
  uv
  watch
  wget
  yt-dlp
  z-lua
  zsh

  # gui
  gum
  mas
  skhd
]
