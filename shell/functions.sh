function j() {
  fname=$(declare -f -F _z)

  [ -n "$fname" ] || source "$DOTLY_PATH/modules/z/z.sh"

  _z "$1"
}

function up() {
	nix flake update --flake /Users/rafa.gomez/.dotfiles/nix
	nvd diff $(ls -dt /nix/var/nix/profiles/system-*-link | head -n2)
	sudo darwin-rebuild switch --flake /Users/rafa.gomez/.dotfiles/nix#pro --impure
}

t() {
  env -u BW_SESSION claude \
    --append-system-prompt "Responde sólo con el comando. No lo metas dentro de backticks ni nada de markdown." \
    -p "Dame un comando de terminal para $*"
}

tldr() {
  env -u BW_SESSION claude \
    --append-system-prompt 'Responde siempre en castellano.
El output se mostrará directamente en una terminal, así que:
- Responde con texto sin formatear.
- MUY IMPORTANTE: No uses formato markdown NI backticks.
- Usa ejemplos y títulos claros.' \
    -p "Dame 3 ejemplos de uso para el comando $*."
}

f() {
  env -u BW_SESSION claude --continue -p "$*"
}
