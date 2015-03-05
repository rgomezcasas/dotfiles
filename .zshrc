# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerline"

# Gnome Terminal Colors
source $HOME/.dotfiles/zsh/gnome-terminal.sh

# "Import" aliases
source $HOME/.dotfiles/zsh/aliases.sh

# Exports
source $HOME/.dotfiles/zsh/exports.sh

DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

POWERLINE_DETECT_SSH="true"
#POWERLINE_FULL_CURRENT_PATH="true"

# Oh My ZSH
plugins=(command-not-found laravel4 vagrant colorize colored-man autojump)
source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='subl'
else
  export EDITOR='vim'
fi

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
