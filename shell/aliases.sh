
# Enable aliases to be sudo’ed
alias sudo='sudo '

alias ..="cd .."
alias ...="cd ../.."
alias ll="eza -l --icons"
alias la="eza -la --icons"

# Jumps
alias ~="cd ~"
alias tmp="cd ~/Desktop/tmp"
alias c="cd ~/Code/codely"

# Git
alias gaa="git add -A"
alias gc="dot git commit"
alias gca="git add --all && git commit --amend --no-edit"
alias gsw="git switch"
alias gd="dot git pretty-diff"
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gl="dot git pretty-log"

# Nix
alias rebuild="darwin-rebuild switch --flake /Users/rafa.gomez/.dotfiles/nix#pro --impure"

alias copy='pbcopy'
alias dc='dot docker connect'
alias vcode='/usr/local/bin/code'
alias htop='btm'

alias i.='(idea $PWD &>/dev/null &)'
alias c.='(code $PWD &>/dev/null &)'
alias o.='open .'

alias mp3="dot youtube download-mp3"
alias mp4="dot youtube download-mp4"
