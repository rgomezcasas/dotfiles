# ------------------------------------------------------------------------------
# Private exports
# ------------------------------------------------------------------------------
. "$DOTFILES_PATH/modules/private/shell/exports.sh"

# ------------------------------------------------------------------------------
# Codely theme config
# ------------------------------------------------------------------------------
export CODELY_THEME_MODE="dark"
export CODELY_THEME_PWD_MODE="short" # full, short, home_relative
export CODELY_THEME_STATUS_ICON_OK="" # 
export CODELY_THEME_STATUS_ICON_KO=""
export CODELY_THEME_PROMPT_IN_NEW_LINE=false

if [[ $__CFBundleIdentifier == "com.jetbrains."* ]]; then
  export CODELY_THEME_MINIMAL=true
fi

if [[ $__CFBundleIdentifier == "com.microsoft."* ]]; then
  export CODELY_THEME_MINIMAL=true
  export CODELY_THEME_MODE=light
fi

# ------------------------------------------------------------------------------
# Languages
# ------------------------------------------------------------------------------
export JAVA_HOME='/Library/Java/JavaVirtualMachines/jbrsdk_jcef-17.0.4.1-osx-aarch64-b597.1/Contents/Home'
export GEM_HOME="$HOME/.gem"
export GOPATH="$HOME/.go"
export PYTORCH_ENABLE_MPS_FALLBACK=1
# ------------------------------------------------------------------------------
# Apps
# ------------------------------------------------------------------------------
if [ "$CODELY_THEME_MODE" == "dark" ]; then
  fzf_colors="pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934"
else
  fzf_colors="pointer:#db0f35,bg+:#d6d6d6,fg:#808080,fg+:#363636,hl:#8ec07c,info:#928374,header:#fffee3"
fi

export FZF_DEFAULT_OPTS="--color=$fzf_colors --reverse"

export HOMEBREW_AUTO_UPDATE_SECS=604800 # 1 week
export HOMEBREW_NO_ANALYTICS=true
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";

export BAT_THEME='gruvbox-dark'

GPG_TTY=$(tty)
export GPG_TTY

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH="/opt/homebrew/bin/chromium"

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
  "/opt/homebrew/opt/node@14/bin"
  "/opt/homebrew/opt/python@3.9/libexec/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/bin"
  "/usr/bin"
  "/usr/sbin"
  "/sbin"
)
