#!/bin/user/env bash

DOTBOT_DIR="modules/dotbot"
DOTBOT_BIN="bin/dotbot"

self_update() {
  cd "$DOTFILES_PATH" || exit

  git fetch
  if [[ $(project_status) == "behind" ]]; then
    log::note "Needs to pull!"
    git pull && exit 0 || log::error "Failed"
  fi
}

update_submodules() {
  cd "$DOTFILES_PATH" || exit
  git pull
  git submodule init
  git submodule update
  git submodule status

  for submodule in "$DOTFILES_PATH/modules/"*; do git submodule update --init --recursive --remote --merge "$submodule"; done
}

apply_symlinks() {
  local -r CONFIG="$DOTFILES_PATH/symlinks/$1"
  shift

  echo
  "$DOTFILES_PATH/$DOTBOT_DIR/$DOTBOT_BIN" -d "$DOTFILES_PATH" -c "$CONFIG" "$@"
  echo
}

apply_common_symlinks() {
  apply_symlinks "conf.yaml"
}

apply_macos_symlinks() {
  apply_symlinks "conf.macos.yaml"

  sudo ln -sf "$DOTFILES_PATH/mac/plist/limit.maxfiles.plist" "/Library/LaunchDaemons/limit.maxfiles.plist"
  sudo ln -sf "$DOTFILES_PATH/mac/plist/limit.maxproc.plist" "/Library/LaunchDaemons/limit.maxproc.plist"
  sudo chmod 644 "/Library/LaunchDaemons/limit.maxfiles.plist"
  sudo chmod 644 "/Library/LaunchDaemons/limit.maxproc.plist"
  sudo chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
  sudo chown root:wheel /Library/LaunchDaemons/limit.maxproc.plist
  sudo launchctl load -w "/Library/LaunchDaemons/limit.maxfiles.plist"
  sudo launchctl load -w "/Library/LaunchDaemons/limit.maxproc.plist"
}

project_status() {
  cd "$DOTFILES_PATH" || exit

  local -r UPSTREAM="master"
  local -r LOCAL=$(git rev-parse @)
  local -r REMOTE=$(git rev-parse "$UPSTREAM")
  local -r BASE=$(git merge-base @ "$UPSTREAM")

  if [[ "$LOCAL" == "$REMOTE" ]]; then
    echo "synced"
  elif [[ "$LOCAL" == "$BASE" ]]; then
    echo "behind"
  elif [[ "$REMOTE" == "$BASE" ]]; then
    echo "ahead"
  else
    echo "diverged"
  fi
}
