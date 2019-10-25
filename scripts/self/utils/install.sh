#!/bin/user/env bash

install_macos_custom() {
  # All apps (This line is 2 times because there are dependencies between brew cask and brew)
  brew bundle --file="$DOTFILES_PATH/mac/brew/Brewfile"
  brew bundle --file="$DOTFILES_PATH/mac/brew/Brewfile"

  # ulimit
  sudo chown root:wheel "/Library/LaunchDaemons/limit.maxfiles.plist"
  sudo launchctl load -w "/Library/LaunchDaemons/limit.maxfiles.plist"
  sudo chown root:wheel "/Library/LaunchDaemons/limit.maxproc.plist"
  sudo launchctl load -w "/Library/LaunchDaemons/limit.maxproc.plist"

  # Correct paths (so, we handle all with $PATH)
  sudo truncate -s 0 /etc/paths
}

install_linux_custom() {
  echo
}
