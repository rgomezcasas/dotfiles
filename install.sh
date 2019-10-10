#!/bin/sh

CURRENT_FILE_PATH="$(pwd)/$(dirname $0)"
export DOTFILES_PATH=${CURRENT_FILE_PATH%"/."}

mkdir -p "$HOME/.config"


echo "🚀 Welcome to the rgomezcasas/dotfiles installer!"
echo "-------------------------------------------------"
echo ""
echo "👉 dotfiles path: '$DOTFILES_PATH'"

# SO Specific stuff
# -----------------------------------------------
if [ "$(uname -s)" = "Darwin" ]; then
  OPERATIVE_SYSTEM="MacOS "
  CUSTOM_INSTALLER="$DOTFILES_PATH/mac/install.sh"
else
  OPERATIVE_SYSTEM="Linux 🐧"
  CUSTOM_INSTALLER="$DOTFILES_PATH/linux/install.sh"
fi

echo "👉 OS: $OPERATIVE_SYSTEM"
echo ""
echo "👇 Installing $OPERATIVE_SYSTEM custom packages 👇"
echo ""

sh "$CUSTOM_INSTALLER"

# Common stuff
# -----------------------------------------------
echo "👇 Installing $OPERATIVE_SYSTEM common packages 👇"

### Console stuff ###
# Bash
ln -s -i "$DOTFILES_PATH/terminal/bash/.bashrc" "$HOME/.bashrc"
ln -s -i "$DOTFILES_PATH/terminal/bash/.bash_profile" "$HOME/.bash_profile"
ln -s -i "$DOTFILES_PATH/terminal/bash/.profile" "$HOME/.profile"

# Zsh
ln -s -i "$DOTFILES_PATH/terminal/zsh/.zshrc" "$HOME/.zshrc"
ln -s -i "$DOTFILES_PATH/terminal/zsh/.zimrc" "$HOME/.zimrc"
ln -s -i "$DOTFILES_PATH/terminal/zsh/.zlogin" "$HOME/.zlogin"

### Git stuff ###
# Git
ln -s -i "$DOTFILES_PATH/git/.gitconfig" "$HOME/.gitconfig"
ln -s -i "$DOTFILES_PATH/git/.gitignore_global" "$HOME/.gitignore_global"
ln -s -i "$DOTFILES_PATH/git/.gitattributes" "$HOME/.gitattributes"

### Editors stuff ###
# Vim
ln -s -i "$DOTFILES_PATH/editors/vim/.vimrc" "$HOME/.vimrc"

### Langs stuff ###
# PHP
mkdir -p "$HOME/.config/psysh"
ln -s -i "$DOTFILES_PATH/langs/php/psysh-config.php" "$HOME/.config/psysh/config.php"
mkdir -p "$HOME/.composer/"
ln -s -i "$DOTFILES_PATH/langs/php/composer.json" "$HOME/.composer/composer.json"

# Clojure
mkdir -p "$HOME/.config/clojure"
ln -s -i "$DOTFILES_PATH/langs/clojure/profiles.clj" "$HOME/.config/clojure/profiles.clj"

# Scala
mkdir -p "$HOME/.sbt/1.0/plugins"
ln -s -i "$DOTFILES_PATH/langs/scala/plugins.sbt" "$HOME/.sbt/1.0/plugins/plugins.sbt"

# Change default terminal to ZSH
chsh -s "$(command -v zsh)"
git clone --recursive https://github.com/zimfw/zimfw.git "${ZDOTDIR:-${HOME}}/.zim"

# Create the autojump historic file
touch "$HOME/.z"
