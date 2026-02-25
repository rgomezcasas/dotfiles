function j() {
  if ! typeset -f _zlua > /dev/null 2>&1; then
    eval "$(z.lua --init zsh enhanced once)"
  fi
  _zlua "$1"
}

gpg() {
  export GPG_TTY=${GPG_TTY:-$(tty)}
  command gpg "$@"
}

function up() {
	nix flake update --flake "$DOTFILES_PATH/nix"
	nvd diff $(ls -dt /nix/var/nix/profiles/system-*-link | head -n2)
	sudo darwin-rebuild switch --flake "$DOTFILES_PATH/nix#pro" --impure
	zimfw upgrade
}

