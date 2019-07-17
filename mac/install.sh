#!/bin/sh

# All apps (This line is 2 times because there are dependencies between brew cask and brew)
brew bundle --file="$DOTFILES_PATH/mac/brew/Brewfile"
brew bundle --file="$DOTFILES_PATH/mac/brew/Brewfile"

# Remove bash last login
touch "$HOME/.hushlogin"

# Alfred
mkdir -p "$HOME/Library/Application Support/Alfred"
ln -s -i "$DOTFILES_PATH/mac/alfred" "$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences"

# Karabiner Elements
ln -s -i "$DOTFILES_PATH/mac/karabiner-elements" "$HOME/.config/karabiner"

# Spectacle
mkdir -p "$HOME/Library/Application Support/Spectacle"
ln -s -i "$DOTFILES_PATH/mac/spectacle/Shortcuts.json" "$HOME/Library/Application Support/Spectacle/Shortcuts.json"

# Rocket
ln -s "$DOTFILES_PATH/mac/Rocket" "$HOME/Library/Application Support"

# Docker for Mac
ln -s "$DOTFILES_PATH/mac/docker/settings.json" "$HOME/Library/Group Containers/group.com.docker/settings.json"

# ulimit
sudo ln -s -i "$DOTFILES_PATH/mac/plist/limit.maxfiles.plist" "/Library/LaunchDaemons/limit.maxfiles.plist"
sudo chown root:wheel "/Library/LaunchDaemons/limit.maxfiles.plist"
sudo launchctl load -w "/Library/LaunchDaemons/limit.maxfiles.plist"
sudo ln -s -i "$DOTFILES_PATH/mac/plist/limit.maxproc.plist" "/Library/LaunchDaemons/limit.maxproc.plist"
sudo chown root:wheel "/Library/LaunchDaemons/limit.maxproc.plist"
sudo launchctl load -w "/Library/LaunchDaemons/limit.maxproc.plist"

# Correct paths (so, we handle all with $PATH)
sudo truncate -s 0 /etc/paths

# Sublime Text
ln -s -i "$DOTFILES_PATH/editors/sublime-text-3" "$HOME/Library/Application Support/Sublime Text 3/Packages/User"

# VS Code
ln -s "$DOTFILES_PATH/editors/vs-code/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
ln -s "$DOTFILES_PATH/editors/vs-code/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
