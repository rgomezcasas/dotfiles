#!/bin/sh

ln -s -i "$DOTFILES_PATH/linux/.Xmodmap" "$HOME/.Xmodmap"
ln -s -i "$DOTFILES_PATH/linux/.Xresources" "$HOME/.Xresources"
ln -s -i "$DOTFILES_PATH/linux/autostart" "$HOME/.config/"

sudo ln -s -i "$DOTFILES_PATH/linux/configs/keyboard" "/etc/default/keyboard"
sudo ln -s -i "$DOTFILES_PATH/linux/xorg.conf.d/00-keyboard.conf" "/usr/share/X11/xorg.conf.d/00-keyboard.conf"

mkdir -p "$HOME/.fonts"
for font in ${DOTFILES_PATH}/fonts/*; do ln -s -i "$font" "$HOME/.fonts/"; done
,
