# ------------------------------------------------------------------------------
# Codely theme config
# ------------------------------------------------------------------------------
export CODELY_THEME_PROMPT_IN_NEW_LINE=false
export CODELY_THEME_MODE="dark"
export CODELY_THEME_PROMPT_IN_NEW_LINE=true
export CODELY_THEME_PWD_MODE="home_relative" # full, short, home_relative
export CODELY_THEME_STATUS_ICON_KO="▸"

# ------------------------------------------------------------------------------
# Languages
# ------------------------------------------------------------------------------
export JAVA_HOME='/Library/Java/JavaVirtualMachines/amazon-corretto-16.jdk/Contents/Home'
export GEM_HOME="$HOME/.gem"
export GOPATH="$HOME/.go"

# ------------------------------------------------------------------------------
# Apps
# ------------------------------------------------------------------------------
if [ "$CODELY_THEME_MODE" == "dark" ]; then
  fzf_colors="pointer:#db0f35,bg+:#d6d6d6,fg:#808080,fg+:#363636,hl:#8ec07c,info:#928374,header:#fffee3"
else
  fzf_colors="pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934"
fi

export FZF_DEFAULT_OPTS="--color=$fzf_colors --reverse"

export HOMEBREW_AUTO_UPDATE_SECS=604800 # 1 week
export HOMEBREW_NO_ANALYTICS=true

export BAT_THEME='gruvbox-dark'

GPG_TTY=$(tty)
export GPG_TTY

# ------------------------------------------------------------------------------
# Path - The higher it is, the more priority it has
# ------------------------------------------------------------------------------
export path=(
  "$HOME/bin"
  "$DOTLY_PATH/bin"
  "$DOTFILES_PATH/bin"
  "$JAVA_HOME/bin"
  "$GEM_HOME/bin"
  "$GOPATH/bin"
  "$HOME/.cargo/bin"
  "/opt/homebrew/opt/ruby/bin"
  "/opt/homebrew/opt/python@3.9/libexec/bin"
  "/opt/homebrew/bin"
  "/usr/local/bin"
  "/bin"
  "/usr/bin"
  "/usr/sbin"
  "/sbin"
)
