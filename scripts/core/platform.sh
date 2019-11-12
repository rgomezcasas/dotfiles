#!/usr/bin/env bash

platform::command_exists() {
  type "$1" &>/dev/null
}

platform::is_macos() {
  [[ $(uname -s) == "Darwin" ]]
}

platform::is_linux() {
  [[ $(uname -s) == "Linux" ]]
}
