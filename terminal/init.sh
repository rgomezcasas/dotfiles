ulimit -n 65536
ulimit -u 1000

. /usr/local/etc/profile.d/z.sh

# Register all aliases
for aliasToSource in $DOTFILES_PATH/terminal/_aliases/*; do source $aliasToSource; done
# Register all exports
for exportToSource in $DOTFILES_PATH/terminal/_exports/*; do source $exportToSource; done
# Functions
function cdd {
  cd "$(ls -d -- */ | fzf)"
}
