function mkcd() {
  mkdir -p "$1" && cd "$1"
}

function j() {
  if ! typeset -f _zlua > /dev/null 2>&1; then
    eval "$(z.lua --init zsh enhanced once)"
  fi
  _zlua "$1"
}

eza_tree() {
  eza --tree --level=4 --color=always --icons=always --git-ignore --group-directories-first "$@" | awk '
    BEGIN {
      eza_folder = "\356\227\277"
      closed = "\357\201\273"
      open = "\357\201\274"
    }
    function strip(line) { gsub(/\033\[[0-9;]*m/, "", line); return line }
    function depth(line) { return index(strip(line), eza_folder) }
    function emit(line, next_line,   d, nd) {
      d = depth(line)
      if (d == 0) { print line; return }
      nd = depth(next_line)
      if (nd == 0) nd = match(strip(next_line), /[^│├└─ ]/)
      if (next_line != "" && nd > d) sub(eza_folder, open, line)
      else sub(eza_folder, closed, line)
      print line
    }
    NR > 1 { emit(prev, $0) }
    { prev = $0 }
    END { emit(prev, "") }'
}
