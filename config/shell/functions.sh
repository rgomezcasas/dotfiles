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
