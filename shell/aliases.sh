# Enable aliases to be sudo’ed
alias sudo='sudo '

alias ..="cd .."
alias ...="cd ../.."
alias ll="exa -l"
alias la="exa -la"

# Jumps
alias ~="cd ~"
alias tmp="cd ~/Desktop/tmp"
alias code='cd ~/Code'
alias mines="cd ~/Code/mines"
alias codely="cd ~/Code/codely"

# Git
alias gaa="git add -A"
alias gc="dot git commit"
alias gca="git add --all && git commit --amend --no-edit"
alias gco="git checkout"
alias gd="dot git pretty-diff"
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gl="dot git pretty-log"

alias up="dot package update_all"
alias copy='pbcopy'
alias dc='dot docker connect'
alias vcode='/usr/local/bin/code'
alias vt='vim $(mktemp $TMPDIR/$(uuidgen).txt)'
alias htop='btm'

alias i.='(idea $PWD &>/dev/null &)'
alias c.='(code $PWD &>/dev/null &)'
alias o.='open .'