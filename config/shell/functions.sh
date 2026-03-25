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

mooc() {
  cd /Users/rafa.gomez/Code/codely/codely || return
  osascript -e '
    tell application "Ghostty"
      set currentTerm to focused terminal of selected tab of front window
      set newTerm to split currentTerm direction down
      input text "cd /Users/rafa.gomez/Code/codely/codely && yarn dev --filter=@codely/mooc\n" to newTerm
    end tell
  '
  docker compose up mooc-postgres
}
