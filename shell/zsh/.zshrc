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

## Autocd
setopt +o nomatch
# setopt autopushd

## Navigation
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

## Performance feedback
REPORTTIME=5

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Start zim
source "$ZIM_HOME/init.zsh"

# Defer syntax highlighting for faster startup
zsh-defer source "$ZIM_HOME/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Compile ZIM init if needed
if [[ ! -f "$ZIM_HOME/init.zsh.zwc" || "$ZIM_HOME/init.zsh" -nt "$ZIM_HOME/init.zsh.zwc" ]]; then
  zcompile "$ZIM_HOME/init.zsh"
fi

# Lazy load fzf-tab on first TAB press (more efficient)
_lazy_load_fzf_tab() {
  source "$ZIM_HOME/modules/fzf-tab/fzf-tab.zsh" 2>/dev/null
  [[ ${+functions[enable-fzf-tab]} ]] && enable-fzf-tab

  # Configure fzf-tab after loading
  if [[ -z $TMUX ]]; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath' 2>/dev/null || true
  else
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  fi

  # Restore original TAB binding after loading
  bindkey '^I' expand-or-complete
  # Execute the completion
  zle expand-or-complete
}

# Register as ZLE widget and bind to TAB
zle -N _lazy_load_fzf_tab
bindkey '^I' _lazy_load_fzf_tab

# Async mode for autocompletion
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_MAXLENGTH=100

source "$DOTFILES_PATH/shell/init.sh"

# Compile shell helper files if needed
() {
  local f
  for f in "$DOTFILES_PATH/shell"/{aliases,exports,functions}.sh; do
    [[ -f $f && $f -nt $f.zwc ]] && zcompile $f 2>/dev/null
  done
}

fpath=("$DOTLY_PATH/shell/zsh/themes" "$DOTLY_PATH/shell/zsh/completions" $fpath)

autoload -Uz promptinit && promptinit
prompt ${DOTLY_THEME:-codely}

source "$DOTLY_PATH/shell/zsh/bindings/reverse_search.zsh"

# Shift + Enter = newline
bindkey -s '^[[27;2;13~' '^[^M'

# zprof
