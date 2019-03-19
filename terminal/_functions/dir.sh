#!/usr/bin/env bash

function cdd {
  cd "$(ls -d -- */ | fzf)"
}

fcd() {
  local dir
  dir="$(
    find "${1:-.}" -path '*/\.*' -prune -o -type d -print 2> /dev/null \
      | fzf +m
  )" || return
  cd "$dir" || return
}
