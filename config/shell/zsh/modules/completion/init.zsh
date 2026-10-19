#
# Completion enhancements
#

if [[ ${TERM} == dumb ]]; then
  return 1
fi

if (( ${+_comps} )); then
  print -u2 'warning: completion was already initialized before completion module. Will call compinit again. See https://github.com/zimfw/zimfw/wiki/Troubleshooting#completion-is-not-working'
fi

() {
  builtin emulate -L zsh -o EXTENDED_GLOB

  # Check if dumpfile is up-to-date by comparing the full path and
  # last modification time of all the completion functions in fpath.
  local zdumpfile zold_dat LC_ALL=C
  local -a zmtimes
  local -i zdump_dat=1
  zstyle -s ':zim:completion' dumpfile 'zdumpfile' || zdumpfile=${ZDOTDIR:-${HOME}}/.zcompdump
  local -r zcomps=(${^fpath}/^([^_]*|*~|*.zwc)(N))
  if (( ${#zcomps} )); then
    zmodload -F zsh/stat b:zstat && zstat -A zmtimes +mtime ${zcomps} || return 1
  fi
  local -r znew_dat=${ZSH_VERSION}$'\0'${(pj:\0:)zcomps}$'\0'${(pj:\0:)zmtimes}
  if [[ -e ${zdumpfile}.dat ]]; then
    zmodload -F zsh/system b:sysread && sysread -s ${#znew_dat} zold_dat <${zdumpfile}.dat || return 1
    if [[ ${zold_dat} == ${znew_dat} ]] zdump_dat=0
  fi
  if (( zdump_dat )); then
    command rm -f ${zdumpfile}(|.dat|.zwc(|.old))(N) || return 1
  fi

  # Load and initialize the completion system
  autoload -Uz compinit && compinit -C -d ${zdumpfile} && [[ -e ${zdumpfile} ]] || return 1

  if [[ ! ${zdumpfile}.dat -nt ${zdumpfile} ]]; then
    >! ${zdumpfile}.dat <<<${znew_dat}
  fi
  # Compile the completion dumpfile; significant speedup
  if [[ ! ${zdumpfile}.zwc -nt ${zdumpfile} ]] zcompile ${zdumpfile}
}

functions[compinit]=$'print -u2 \'warning: compinit being called again after completion module at \'${funcfiletrace[1]}
'${functions[compinit]}

#
#
# Zsh options
#
local glob_case_sensitivity completion_case_sensitivity
zstyle -s ':zim:glob' case-sensitivity glob_case_sensitivity || glob_case_sensitivity=insensitive
zstyle -s ':zim:completion' case-sensitivity completion_case_sensitivity || completion_case_sensitivity=insensitive

# Move cursor to end of word if a full completion is inserted.
setopt ALWAYS_TO_END

# Completion is done from both ends of the cursor.
setopt COMPLETE_IN_WORD

if [[ ${glob_case_sensitivity} == sensitive ]]; then
  setopt CASE_GLOB
else
  setopt NO_CASE_GLOB
fi

# Don't beep on ambiguous completions.
setopt NO_LIST_BEEP

#
# Completion module options
#

# Enable caching
zstyle ':completion::complete:*' use-cache on

# Group matches and describe.
zstyle ':completion:*' menu select
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
if [[ ${completion_case_sensitivity} == sensitive ]]; then
  zstyle ':completion:*' matcher-list '' '+r:|[._-]=* r:|=*' '+l:|=*'
else
  # This is actually "smart" case sensitivity. Case insensitive is 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
  # which is broken in Zsh 5.9. See https://www.zsh.org/mla/workers/2022/msg01229.html
  zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' '+r:|[._-]=* r:|=*' '+l:|=*'
fi

# Insert a TAB character instead of performing completion when left buffer is empty.
zstyle ':completion:*' insert-tab false

# Ignore useless commands and functions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'
# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order 'indexes' 'parameters'

# Directories
if (( ${+LS_COLORS} )); then
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
else
  # Use same LS_COLORS definition from utility module, in case it was not set
  zstyle ':completion:*:default' list-colors ${(s.:.):-di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43}
fi
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts{,2} 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts 2>/dev/null; (( ${+commands[ypcat]} )) && ypcat hosts 2>/dev/null)"}%%(\#)*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config{,.d/*(N)} 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
  '_*' adm amanda apache avahi beaglidx bin cacti canna clamav daemon dbus \
  distcache dovecot fax ftp games gdm gkrellmd gopher hacluster haldaemon \
  halt hsqldb ident junkbust ldap lp mail mailman mailnull mldonkey mysql \
  nagios named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser \
  rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle ':completion:*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

unset glob_case_sensitivity completion_case_sensitivity
