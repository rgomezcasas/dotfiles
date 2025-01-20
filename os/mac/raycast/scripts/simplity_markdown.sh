#!/bin/bash -l

# @raycast.schemaVersion 1
# @raycast.title Simplify Markdown
# @raycast.packageName Utils
# @raycast.mode silent
# @raycast.icon 🤏
# @raycast.description Simplify Markdown

"$HOME/.dotfiles/bin/sdot" markdown reduce_to_two_levels | pbcopy
"$HOME/.dotfiles/bin/sdot" mac paste_text -n
