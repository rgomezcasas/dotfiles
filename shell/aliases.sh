
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
alias gd="dot git pretty-diff"
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gl="dot git pretty-log"

# Nix
alias rebuild="sudo darwin-rebuild switch --flake /Users/rafa.gomez/.dotfiles/nix#pro --impure"

alias copy='pbcopy'
alias dc='dot docker connect'
alias docker-clear='dot docker clear'

alias i.='(idea $PWD &>/dev/null &)'
alias c.='(cursor $PWD &>/dev/null &)'
alias o.='open .'

alias cc="claude"
