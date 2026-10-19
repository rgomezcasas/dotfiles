# $ nix-env -qaP | grep wget
{ pkgs, ... }:

with pkgs;
[
  ast-grep
  bat
  bitwarden-cli
  cargo
  choose-gui
  cmatrix
  coreutils
  delta
  docker-credential-helpers
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
  jsongrep
  lazygit
  libpq
  maven
  mitmproxy
  nixfmt
  nvd
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
  zsh-autosuggestions
  zsh-defer
  zsh-fzf-tab
  zsh-syntax-highlighting

  # gui
  gum
  mas
  skhd
]
