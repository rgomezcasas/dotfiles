# All bindings can be found https://www.zsh.org/mla/users/2014/msg00266.html
zle     -N   reverse-search
bindkey '^R' reverse-search

autoload -z edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line
