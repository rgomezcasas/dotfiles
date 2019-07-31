ulimit -n 65536
ulimit -u 1000

. "$HOME/bin/z.sh"

# Register all aliases
for aliasToSource in "$DOTFILES_PATH/terminal/_aliases/"*; do source $aliasToSource; done
# Register all exports
for exportToSource in "$DOTFILES_PATH/terminal/_exports/"*; do source $exportToSource; done
# Register all functions
for functionToSource in "$DOTFILES_PATH/terminal/_functions/"*; do source $functionToSource; done
