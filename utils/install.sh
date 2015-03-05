#!/bin/sh

# Metemos el config general
ln -s -i $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Metemos el theme
ln -s -i $HOME/.dotfiles/zsh/themes/powerline.zsh-theme $ZSH/themes/powerline.zsh-theme

# Git
ln -s -i $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
ln -s -i $HOME/.dotfiles/.gitignore_global $HOME/.gitignore_global

# Vim
ln -s -i $HOME/.dotfiles/.vimrc $HOME/.vimrc

# CLOSE YOUR EYES :)
ln -s -i $HOME/Dropbox/Private/filezilla.xml $HOME/.filezilla/sitemanager.xml

# Fonts
rm -rf $HOME/.fonts
ln -s $HOME/.dotfiles/.fonts $HOME

# Sublime
rm -rf $HOME/.config/sublime-text-3/Packages/User
ln -s $HOME/.dotfiles/sublime-text-3/Packages/User $HOME/.config/sublime-text-3/Packages

# Intellij
rm -rf $HOME/.IntelliJIdea14/config
ln -s $HOME/.dotfiles/.IntelliJIdea14/config $HOME/.IntelliJIdea14/

# iMacros
rm -rf $HOME/iMacros/Macros
ln -s $HOME/.dotfiles/iMacros/Macros $HOME/iMacros

