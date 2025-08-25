
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
alias dcl='dot docker clear'

alias i.='(idea $PWD &>/dev/null &)'
alias c.='(cursor $PWD &>/dev/null &)'
alias o.='open .'

alias cc="env -u BW_SESSION claude --append-system-prompt 'responde siempre en castellano'"
alias ccyolo="env -u BW_SESSION claude --dangerously-skip-permissions"

# Zsh performance
alias zsh-rebuild-cache='rm -f ~/.zcompdump* && zcompile ~/.dotfiles/shell/zsh/.zshrc && exec zsh'
alias zsh-recompile='zcompile ~/.dotfiles/shell/zsh/.zshrc ~/.dotfiles/shell/{init,aliases,exports,functions}.sh'

# Export credentials
alias with_openai="dot system with_credential OPENAI_API_KEY OPENAI_API_KEY"
alias with_github="dot system with_credential GITHUB_TOKEN GITHUB_TOKEN"
alias with_test="dot system with_credential TEST_API_KEY TEST_API_KEY"
