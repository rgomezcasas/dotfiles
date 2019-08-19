#!/usr/bin/env bash

function cdd {
  cd "$(ls -d -- */ | fzf)"
}

function j {
  fname=$(declare -f -F _z)

  [ -n "$fname" ] || . "$HOME/bin/z.sh"

  _z "$1"
}
