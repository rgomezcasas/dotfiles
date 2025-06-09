function j() {
  fname=$(declare -f -F _z)

  [ -n "$fname" ] || source "$DOTLY_PATH/modules/z/z.sh"

  _z "$1"
}

function up() {
	nix flake update --flake /Users/rafa.gomez/.dotfiles/nix
	nvd diff $(ls -dt /nix/var/nix/profiles/system-*-link | head -n2)
	darwin-rebuild switch --flake /Users/rafa.gomez/.dotfiles/nix#pro --impure
}
