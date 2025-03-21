function cdd() {
  cd "$(ls -d -- */ | fzf)" || echo "Invalid directory"
}

function j() {
  fname=$(declare -f -F _z)

  [ -n "$fname" ] || source "$DOTLY_PATH/modules/z/z.sh"

  _z "$1"
}

function recent_dirs() {
  # This script depends on pushd. It works better with autopush enabled in ZSH
  escaped_home=$(echo $HOME | sed 's/\//\\\//g')
  selected=$(dirs -p | sort -u | fzf)

  cd "$(echo "$selected" | sed "s/\~/$escaped_home/")" || echo "Invalid directory"
}

function up() {
	nix flake update --flake /Users/rafa.gomez/.dotfiles/nix
	nvd diff $(ls -dt /nix/var/nix/profiles/system-*-link | head -n2)
	darwin-rebuild switch --flake /Users/rafa.gomez/.dotfiles/nix#pro --impure
}
