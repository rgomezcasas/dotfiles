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

t() {
  claude \
    --model "haiku" \
    --append-system-prompt "Responde sólo con el comando. No lo metas dentro de backticks ni nada de markdown." \
    -p "Dame un comando de terminal para $*"
}

tldr() {
  claude \
    --model "haiku" \
    --append-system-prompt 'Responde siempre en castellano.
El output se mostrará directamente en una terminal, así que:
- Responde con texto sin formatear.
- MUY IMPORTANTE: No uses formato markdown NI backticks.
- Usa ejemplos y títulos claros.' \
    -p "Dame 3 ejemplos de uso para el comando $*."
}

f() {
  claude --continue -p "$*"
}

cc() {
  local theme="light"
  [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]] && theme="dark"
  jq --arg t "$theme" '.theme = $t' ~/.claude.json >| ~/.claude.json.tmp && mv ~/.claude.json.tmp ~/.claude.json

  env -u BW_SESSION claude --append-system-prompt 'responde siempre en castellano' "$@"
}

