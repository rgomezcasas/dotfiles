#
# Editor and input char assignment
#

[[ ${TERM} != dumb ]] && () {

  # Use human-friendly identifiers.
  zmodload -F zsh/terminfo +b:echoti +p:terminfo
  typeset -gA key_info
  key_info=(
    Control      '\C-'
    ControlLeft  '\e[1;5D \e[5D \e\e[D \eOd \eOD'
    ControlRight '\e[1;5C \e[5C \e\e[C \eOc \eOC'
    Escape       '\e'
    Meta         '\M-'
    Backspace    '^?'
    Delete       '^[[3~'
    BackTab      "${terminfo[kcbt]}"
    Left         "${terminfo[kcub1]}"
    Down         "${terminfo[kcud1]}"
    Right        "${terminfo[kcuf1]}"
    Up           "${terminfo[kcuu1]}"
    End          "${terminfo[kend]}"
    F1           "${terminfo[kf1]}"
    F2           "${terminfo[kf2]}"
    F3           "${terminfo[kf3]}"
    F4           "${terminfo[kf4]}"
    F5           "${terminfo[kf5]}"
    F6           "${terminfo[kf6]}"
    F7           "${terminfo[kf7]}"
    F8           "${terminfo[kf8]}"
    F9           "${terminfo[kf9]}"
    F10          "${terminfo[kf10]}"
    F11          "${terminfo[kf11]}"
    F12          "${terminfo[kf12]}"
    Home         "${terminfo[khome]}"
    Insert       "${terminfo[kich1]}"
    PageDown     "${terminfo[knp]}"
    PageUp       "${terminfo[kpp]}"
  )

  # Bind the keys

  local key
  for key (${(s: :)key_info[ControlLeft]}) bindkey ${key} backward-word
  for key (${(s: :)key_info[ControlRight]}) bindkey ${key} forward-word

  bindkey ${key_info[Delete]} delete-char

  if [[ -n ${key_info[Home]} ]] bindkey ${key_info[Home]} beginning-of-line
  if [[ -n ${key_info[End]} ]] bindkey ${key_info[End]} end-of-line

  if [[ -n ${key_info[PageUp]} ]] bindkey ${key_info[PageUp]} up-line-or-history
  if [[ -n ${key_info[PageDown]} ]] bindkey ${key_info[PageDown]} down-line-or-history

  if [[ -n ${key_info[Insert]} ]] bindkey ${key_info[Insert]} overwrite-mode

  if [[ -n ${key_info[Left]} ]] bindkey ${key_info[Left]} backward-char
  if [[ -n ${key_info[Right]} ]] bindkey ${key_info[Right]} forward-char

  # Expandpace.
  bindkey ' ' magic-space

  # Bind insert-last-word even in viins mode
  bindkey "${key_info[Escape]}." insert-last-word
  bindkey "${key_info[Escape]}_" insert-last-word

  # <Ctrl-x><Ctrl-e> to edit command-line in EDITOR
  autoload -Uz edit-command-line && zle -N edit-command-line && \
      bindkey "${key_info[Control]}x${key_info[Control]}e" edit-command-line

  # Bind <Shift-Tab> to go to the previous menu item.
  if [[ -n ${key_info[BackTab]} ]] bindkey ${key_info[BackTab]} reverse-menu-complete

  # Use smart URL pasting and escaping.
  autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
  autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

  if zstyle -t ':zim:input' double-dot-expand; then
    double-dot-expand() {
      # Expand .. at the beginning, after space, or after any of ! " & ' / ; < > |
      if [[ ${LBUFFER} == (|*[[:space:]!\"\&\'/\;\<\>|]).. && -z ${RBUFFER} ]]; then
        LBUFFER+=/..
      else
        LBUFFER+=.
      fi
    }
    zle -N double-dot-expand
    bindkey . double-dot-expand
    bindkey -M isearch . self-insert

    double-dot-contract() {
      if [[ ${LBUFFER} == *../.. && -z ${RBUFFER} ]] LBUFFER=${LBUFFER:0:-2}
      zle backward-delete-char
    }
    zle -N double-dot-contract
    bindkey ${key_info[Backspace]} double-dot-contract
    bindkey -M isearch ${key_info[Backspace]} backward-delete-char
  else
    bindkey ${key_info[Backspace]} backward-delete-char
  fi

  autoload -Uz is-at-least && if ! is-at-least 5.3; then
    # Redisplay after completing, and avoid blank prompt after <Tab><Tab><Ctrl-C>
    expand-or-complete-with-redisplay() {
      print -n ...
      zle expand-or-complete
      zle redisplay
    }
    zle -N expand-or-complete-with-redisplay
    bindkey "${key_info[Control]}I" expand-or-complete-with-redisplay
  fi

  if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} && \
      ! ${+functions[_start_application_mode]} && ! ${+functions[_stop_application_mode]} )); then
    # Enable application mode when zle is active
    functions[_start_application_mode]=${widgets[zle-line-init]#user:}'
echoti smkx'
    functions[_stop_application_mode]=${widgets[zle-line-finish]#user:}'
echoti rmkx'
    zle -N zle-line-init _start_application_mode
    zle -N zle-line-finish _stop_application_mode
  fi

  _input_deferred_init_precmd() {
    if (( ${+functions[history-substring-search-up]} && ${+functions[history-substring-search-down]} )); then
      local key
      for key ('^[[A' ${key_info[Up]} '^P') bindkey ${key} history-substring-search-up
      for key ('^[[B' ${key_info[Down]} '^N') bindkey ${key} history-substring-search-down
    fi
    precmd_functions=(${precmd_functions:#_input_deferred_init_precmd})
    unfunction _input_deferred_init_precmd
  }
  autoload -Uz add-zsh-hook && add-zsh-hook precmd _input_deferred_init_precmd
}
