#!/usr/bin/env sh

preferences_dir="$HOME/Library/Preferences"
intellij_version=$(ls "$preferences_dir" | grep 'IntelliJIdea' | sort -r | head -n 1)
intellij_code_templates_folder="$preferences_dir/$intellij_version/fileTemplates"

rm -rf "$intellij_code_templates_folder"
ln -s -i "$DOTFILES_PATH/editors/intellij/Code Templates/" "$intellij_code_templates_folder"

echo "Done for $intellij_version!"
