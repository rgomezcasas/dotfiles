# This is a useful file to have the same aliases/functions in bash and zsh
if [ $__CFBundleIdentifier == "com.jetbrains.intellij" ] || [ $__CFBundleIdentifier == "com.microsoft.VSCodeInsiders" ]; then
    export CODELY_THEME_MINIMAL=true
fi

source "$DOTFILES_PATH/shell/aliases.sh"
source "$DOTFILES_PATH/shell/exports.sh"
source "$DOTFILES_PATH/shell/private-exports.sh"
source "$DOTFILES_PATH/shell/functions.sh"
