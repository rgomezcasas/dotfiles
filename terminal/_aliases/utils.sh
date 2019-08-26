#!/usr/bin/env bash

# Mac
alias out="outdated_apps"
alias up="update_apps"

# Brew
alias brwe="brew"
alias bs="brew services"
alias bsl="brew services list"
alias bss="brew services start"
alias bssp="brew services stop"
alias bsr="brew services restart"
alias bsspa="brew services stop --all"
alias bi="brew_install"
alias bu="brew_uninstall"
alias bci="brew_cask_install"
alias bcu="brew_cask_uninstall"

# Others
alias available_commands='bash -c "compgen -c"'
alias available_jdks='ls /Library/Java/JavaVirtualMachines'
alias aux='ps uax'
alias c='pbcopy'
alias count_files_recursive='find . -type f -print | wc -l'
alias count_files_recursive_per_directory='ls -d */ | xargs -I _ sh -c "find \"_\" -type f | wc -l | xargs echo _"'
alias dc='docker_connect'
alias flat_this_dir="sudo find . -mindepth 2 -type f -exec mv -i '{}' . ';'"
alias ping='prettyping --nolegend'
alias size_of_directory="ncdu --color dark -rr -x"

alias k='kill -9'
alias t="fzf --preview 'bat --color \"always\" {}'"
alias i.='(idea $PWD &>/dev/null &)'
alias o.='open .'

alias privateip="ipconfig getifaddr en0"
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"

alias optimize_zsh='source ${ZDOTDIR:-${HOME}}/.zlogin'
