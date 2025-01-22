#!/bin/bash -l

# @raycast.schemaVersion 1
# @raycast.title Paste 2 levels Markdown
# @raycast.packageName Utils
# @raycast.mode silent
# @raycast.icon 🤏
# @raycast.description Paste 2 levels Markdown

extract_lists() {
  local text="$1"
  echo "$text" | \
    grep -v "     " | \
    sed -E $'s/[✅☑️🎥🖼️]//g' | \
    sed 's/YouTube //g' | \
    sed 's/\xC2\xA0/ /g'
}

extract_lists "$(pbpaste)" | pbcopy

"$HOME/.dotfiles/bin/sdot" mac paste_text -n
