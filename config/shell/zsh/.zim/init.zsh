# FILE AUTOMATICALLY GENERATED FROM /Users/rafa.gomez/.zimrc
# EDIT THE SOURCE FILE AND THEN RUN zimfw build. DO NOT DIRECTLY EDIT THIS FILE!

if [[ -e ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]] zimfw() { source "${HOME}/.dotfiles/config/shell/zsh/.zim/zimfw.zsh" "${@}" }
fpath=("${HOME}/.dotfiles/config/shell/zsh/.zim/modules/git-info/functions" ${fpath})
autoload -Uz -- coalesce git-action git-info
source "${HOME}/.dotfiles/config/shell/zsh/.zim/modules/zsh-defer/zsh-defer.plugin.zsh"
source "${HOME}/.dotfiles/config/shell/zsh/.zim/modules/completion/init.zsh"
source "${HOME}/.dotfiles/config/shell/zsh/.zim/modules/environment/init.zsh"
source "${HOME}/.dotfiles/config/shell/zsh/.zim/modules/input/init.zsh"
source "${HOME}/.dotfiles/config/shell/zsh/.zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh"
