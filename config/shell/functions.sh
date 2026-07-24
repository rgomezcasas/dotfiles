function mkcd() {
  mkdir -p "$1" && cd "$1"
}

function j() {
  if ! typeset -f _zlua > /dev/null 2>&1; then
    eval "$(z.lua --init zsh enhanced once)"
  fi
  _zlua "$1"
}
