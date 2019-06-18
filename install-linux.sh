#!/bin/sh

DOTFILES_PATH=$HOME/.dotfiles

### Linux stuff ###
# Fonts
# mkdir -p .local/share/fonts
# fc-cache

### Console stuff ###
# Bash
ln -s -i ${DOTFILES_PATH}/terminal/bash/.bashrc $HOME/.bashrc
ln -s -i ${DOTFILES_PATH}/terminal/bash/.bash_profile $HOME/.bash_profile
ln -s -i ${DOTFILES_PATH}/terminal/bash/.profile $HOME/.profile

# Zsh
ln -s -i ${DOTFILES_PATH}/terminal/zsh/.zshrc $HOME/.zshrc
ln -s -i ${DOTFILES_PATH}/terminal/zsh/.zimrc $HOME/.zimrc
ln -s -i ${DOTFILES_PATH}/terminal/zsh/.zlogin $HOME/.zlogin

# Dash
ln -sf $(which dash) /usr/local/bin/sh

### Git stuff ###
# Git
ln -s -i ${DOTFILES_PATH}/git/.gitconfig $HOME/.gitconfig
ln -s -i ${DOTFILES_PATH}/git/.gitignore_global $HOME/.gitignore_global
ln -s -i ${DOTFILES_PATH}/git/.gitattributes $HOME/.gitattributes

### Editors stuff ###
# Vim
ln -s -i ${DOTFILES_PATH}/editors/vim/.vimrc $HOME/.vimrc

# Sublime Text
ln -s -i ${DOTFILES_PATH}/editors/sublime-text-3 $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

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
