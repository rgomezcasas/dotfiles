# Uncomment for debug with `zprof`
# zmodload zsh/zprof

if [[ -n "$INTELLIJ_ENVIRONMENT_READER" ]]; then
  return 0
fi

_short_pwd() {
  [[ $PWD == $HOME ]] && { print -n '~'; return }
  local current=${PWD/#$HOME/\~}
  local parts=(${(s:/:)current})
  local len=${#parts[@]}
  (( len <= 3 )) && { print -n $current; return }
  local result=${parts[1]}
  for (( i=2; i<len-1; i++ )); do
    result+="/${parts[i][1]}"
  done
  result+="/${parts[-2][1,2]}/${parts[-1]}"
  print -n $result
}

# ZSH Ops
## History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY
setopt HIST_FCNTL_LOCK
setopt HIST_NO_STORE

## Redirection
setopt APPEND_CREATE

## Autocd
setopt +o nomatch
# setopt autopushd

## Navigation
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

## Performance feedback
REPORTTIME=5

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

fpath=("$DOTLY_PATH/shell/zsh/completions" "$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

zsh_plugins="/run/current-system/sw/share"
zsh_modules="$DOTFILES_PATH/config/shell/zsh/modules"

fpath=("$zsh_modules/git-info/functions" $fpath)
autoload -Uz -- coalesce git-action git-info
source "$zsh_plugins/zsh-defer/zsh-defer.plugin.zsh"
zsh-defer source "$zsh_modules/completion/init.zsh"
source "$zsh_modules/environment/init.zsh"
setopt CLOBBER
zsh-defer source "$zsh_modules/input/init.zsh"
zsh-defer source "$zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

zsh-defer source "$zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
zsh-defer -c "ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'"

# Lazy load fzf-tab on first TAB press (more efficient)
_lazy_load_fzf_tab() {
  unset POSTDISPLAY
  source "$zsh_plugins/fzf-tab/fzf-tab.zsh" 2>/dev/null
  [[ ${+functions[enable-fzf-tab]} ]] && enable-fzf-tab

  # Configure fzf-tab after loading
  if [[ -z $TMUX ]]; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' 2>/dev/null || true
  else
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  fi

  # Restore original TAB binding and rebind autosuggestions
  bindkey '^I' expand-or-complete
  _zsh_autosuggest_bind_widgets 2>/dev/null
  zle expand-or-complete
}

# Register as ZLE widget and bind to TAB
zle -N _lazy_load_fzf_tab
bindkey '^I' _lazy_load_fzf_tab

# Async mode for autocompletion
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(expand-or-complete expand-or-complete-prefix)
ZSH_HIGHLIGHT_MAXLENGTH=100

source "$DOTFILES_PATH/modules/private/shell/exports.sh"
source "$DOTFILES_PATH/config/shell/exports.sh"
if [[ -o interactive ]]; then
  zsh-defer source "$DOTFILES_PATH/config/shell/aliases.sh"
  zsh-defer source "$DOTFILES_PATH/config/shell/functions.sh"
else
  source "$DOTFILES_PATH/config/shell/aliases.sh"
  source "$DOTFILES_PATH/config/shell/functions.sh"
fi

setopt PROMPT_CR PROMPT_PERCENT PROMPT_SP PROMPT_SUBST
source "$DOTLY_PATH/shell/zsh/themes/prompt_${DOTLY_THEME:-codely}_setup"

zsh-defer source "$DOTLY_PATH/shell/zsh/bindings/reverse_search.zsh"

# Shift + Enter = newline
bindkey -s '^[[27;2;13~' '^[^M'

# zprof

# source "$DOTFILES_PATH/modules/private/shell/idx.sh"

# Added by aidevtracker
# source "/Users/rafa.gomez/.config/inditex/aidevtracker/scripts/init.sh"
