
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
alias gw="git switch"
alias gwc="git switch main && git pull --rebase --autostash && git switch -c"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gl="dot git pretty-log"

# Nix
alias rebuild="sudo darwin-rebuild switch --flake $DOTFILES_PATH/nix#pro --impure"

alias copy='pbcopy'
alias dc='dot docker connect'
alias dcl='dot docker clear'

alias i.='(idea $PWD &>/dev/null &)'
alias c.='(cursor $PWD &>/dev/null &)'
alias o.='open .'

_cc_set_theme() {
  local theme="light"
  [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]] && theme="dark"
  jq --arg t "$theme" '.theme = $t' ~/.claude.json >| ~/.claude.json.tmp && mv ~/.claude.json.tmp ~/.claude.json
}

cc() {
  _cc_set_theme
  env -u BW_SESSION claude --append-system-prompt 'responde siempre en castellano'
}

ccyolo() {
  _cc_set_theme
  env -u BW_SESSION claude --dangerously-skip-permissions --append-system-prompt 'responde siempre en castellano'
}
alias ccupdate="brew update && brew upgrade claude-code"

# Zsh performance
alias zsh-rebuild-cache='rm -f ~/.zcompdump* && zcompile ~/.dotfiles/shell/zsh/.zshrc && exec zsh'
alias zsh-recompile='zcompile ~/.dotfiles/shell/zsh/.zshrc ~/.dotfiles/shell/{init,aliases,exports,functions}.sh'

# Export credentials
alias with_openai="dot system with_credential OPENAI_API_KEY OPENAI_API_KEY"
alias with_github="dot system with_credential GITHUB_TOKEN GITHUB_TOKEN"
alias with_test="dot system with_credential TEST_API_KEY SUPER_PRIVATE_TOKEN"
