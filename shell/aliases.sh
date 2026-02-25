# Enable aliases to be sudo’ed
alias sudo='sudo '

alias ..="cd .."
alias ...="cd ../.."
alias ll="eza -l --icons"
alias la="eza -la --icons"

# Jumps
alias ~="cd ~"
alias tmp="cd ~/Desktop/tmp"

# Git
alias gaa="git add -A"
alias gc="dot git commit"
alias gca="git add --all && git commit --amend --no-edit"
alias gd="dot git pretty-diff"
alias gs="git status -sb"
alias gw="git switch"
alias gwc="git switch main && git pull --rebase --autostash && git switch -c"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gl="dot git pretty-log"

# Nix
alias rebuild="dot system rebuild"
alias up="dot system update"

alias copy='pbcopy'
alias dc='dot docker connect'

alias i.='(idea $PWD &>/dev/null &)'
alias c.='(cursor $PWD &>/dev/null &)'
alias o.='open .'

# Claude code
alias cc="dot claude cc"
alias ccyolo="cc --dangerously-skip-permissions --settings '{\"sandbox\":{\"enabled\":true}}'"
alias ccupdate="claude update"

alias t="dot claude t"
alias tldr="dot claude tldr"
alias f="dot claude f"

# Export credentials
alias with_openai="dot system with_credential OPENAI_API_KEY OPENAI_API_KEY"
alias with_github="dot system with_credential GITHUB_TOKEN GITHUB_TOKEN"
alias with_test="dot system with_credential TEST_API_KEY SUPER_PRIVATE_TOKEN"
