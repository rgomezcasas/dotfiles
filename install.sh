#!/bin/sh

DOTFILES_PATH=$HOME/.dotfiles

### MacOs stuff ###
# All apps (This line is 2 times because there are dependencies between brew cask and brew)
brew bundle --file=${DOTFILES_PATH}/mac/brew/Brewfile
brew bundle --file=${DOTFILES_PATH}/mac/brew/Brewfile
# Remove bash last login
touch $HOME/.hushlogin
# Alfred
mkdir -p $HOME/Library/Application\ Support/Alfred\ 3/
ln -s -i ${DOTFILES_PATH}/mac/alfred $HOME/Library/Application\ Support/Alfred\ 3/Alfred.alfredpreferences
# Karabiner Elements
mkdir $HOME/.config
ln -s -i ${DOTFILES_PATH}/mac/karabiner-elements $HOME/.config/karabiner
# Spectacle
mkdir -p $HOME/Library/Application\ Support/Spectacle
ln -s -i ${DOTFILES_PATH}/mac/spectacle/Shortcuts.json $HOME/Library/Application\ Support/Spectacle/Shortcuts.json
# Rocket
ln -s ${DOTFILES_PATH}/mac/Rocket $HOME/Library/Application\ Support/Rocket
# Docker for Mac
ln -s ${DOTFILES_PATH}/mac/docker/settings.json $HOME/Library/Group\ Containers/group.com.docker/settings.json

# ulimit
sudo ln -s -i ${DOTFILES_PATH}/mac/plist/limit.maxfiles.plist /Library/LaunchDaemons/limit.maxfiles.plist
sudo chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
sudo ln -s -i ${DOTFILES_PATH}/mac/plist/limit.maxproc.plist /Library/LaunchDaemons/limit.maxproc.plist
sudo chown root:wheel /Library/LaunchDaemons/limit.maxproc.plist
sudo launchctl load -w /Library/LaunchDaemons/limit.maxproc.plist


### Console stuff ###
# Bash
ln -s -i ${DOTFILES_PATH}/terminal/bash/.bashrc $HOME/.bashrc
ln -s -i ${DOTFILES_PATH}/terminal/bash/.bash_profile $HOME/.bash_profile
ln -s -i ${DOTFILES_PATH}/terminal/bash/.profile $HOME/.profile

# Zsh
ln -s -i ${DOTFILES_PATH}/terminal/zsh/.zshrc $HOME/.zshrc
ln -s -i ${DOTFILES_PATH}/terminal/zsh/.zimrc $HOME/.zimrc
ln -s -i ${DOTFILES_PATH}/terminal/zsh/.zlogin $HOME/.zlogin

### Git stuff ###
# Git
ln -s -i ${DOTFILES_PATH}/git/.gitconfig $HOME/.gitconfig
ln -s -i ${DOTFILES_PATH}/git/.gitignore_global $HOME/.gitignore_global
ln -s -i ${DOTFILES_PATH}/git/.gitattributes $HOME/.gitattributes

### Editors stuff ###
# Vim
ln -s -i ${DOTFILES_PATH}/editors/vim/.vimrc $HOME/.vimrc

# VS Code
ln -s ${DOTFILES_PATH}/editors/vs-code/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
ln -s ${DOTFILES_PATH}/editors/vs-code/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json

### Langs stuff ###
# PHP
mkdir $HOME/.config/psysh
ln -s -i ${DOTFILES_PATH}/langs/php/psysh-config.php $HOME/.config/psysh/config.php
mkdir $HOME/.composer/composer.json
ln -s -i ${DOTFILES_PATH}/langs/php/composer.json $HOME/.composer/composer.json

# Clojure
mkdir $HOME/.config/clojure
ln -s -i ${DOTFILES_PATH}/langs/clojure/profiles.clj $HOME/.config/clojure/profiles.clj

# Scala
mkdir -p $HOME/.sbt/1.0/plugins
ln -s -i ${DOTFILES_PATH}/langs/scala/plugins.sbt $HOME/.sbt/1.0/plugins/plugins.sbt

# Change default terminal to ZSH
chsh -s $(which zsh)
git clone --recursive https://github.com/zimfw/zimfw.git ${ZDOTDIR:-${HOME}}/.zim
touch $HOME/.z
