#!/bin/user/env bash

coll::is_empty() {
  local var=${1}
  [[ -z ${var} ]]
}

coll::contains_element() {
  elements="${@:2}"
  element="${1}"

  for e in ${elements[@]}; do
    if [[ "$e" == "${element}" ]]; then
      return 1
    fi
  done
  return 0
}

coll::new() {
  for x in "$@"; do
    echo "$x"
  done
}

coll::map() {
  local -r fn="$1"

  for x in $(cat); do
    "$fn" "$x"
  done
}

coll::map2() {
  local -r fn="$1"
  local -r arg1="$2"

  for x in $(cat); do
    "$fn" "$arg1" "$x"
  done
}
