# Uncomment for debuf with `zprof`
# zmodload zsh/zprof

export DOTFILES_PATH=$HOME/.dotfiles
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.dotfiles/modules/zimfw

# ZSH Ops
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FCNTL_LOCK
# setopt autopushd

# Start zim
source ${ZIM_HOME}/init.zsh

# Removing the waiting dots from completion (...). Original: ~/.zim/modules/input/init.zsh
# expand-or-complete-with-redisplay() {
#   zle expand-or-complete
#   zle redisplay
# }

# Async mode for autocompletion
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_MAXLENGTH=300

source $DOTFILES_PATH/terminal/init.sh

fpath=("$DOTFILES_PATH/terminal/zsh/themes" "$DOTFILES_PATH/terminal/zsh/completions" $fpath)

autoload -Uz promptinit && promptinit
prompt rafa

# iTerm tab name
# precmd() {
#   echo -ne "\e]1;$(dot filesystem short_pwd)\a"
# }

source $DOTFILES_PATH/terminal/zsh/key-bindings.zsh
