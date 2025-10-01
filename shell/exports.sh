# ------------------------------------------------------------------------------
# Codely theme config
# ------------------------------------------------------------------------------
export CODELY_THEME_MODE="dark"
export CODELY_THEME_PWD_MODE="short"    # full, short, home_relative
export CODELY_THEME_STATUS_ICON_OK=""  #  󱁑        󰽰 󰯙
export CODELY_THEME_STATUS_ICON_KO="☢"  # ﮊ
export CODELY_THEME_PROMPT_IN_NEW_LINE=true

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
export JAVA_HOME='/Users/rafa.gomez/Library/Java/JavaVirtualMachines/openjdk-21.0.2/Contents/Home'
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

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_PREFIX="/opt/homebrew";

export BAT_THEME='gruvbox-dark'

GPG_TTY=$(tty)
export GPG_TTY

export LANG="en_US.UTF-8"


# ------------------------------------------------------------------------------
# Path - The higher it is, the more priority it has
# ------------------------------------------------------------------------------
# typeset -U path

export path=(
  "$HOME/bin"
  "$DOTLY_PATH/bin"
  "$DOTFILES_PATH/bin"
  "$HOME/.nix-profile/bin"
  "/etc/profiles/per-user/rafa.gomez/bin"
  "/run/current-system/sw/bin"
  "/nix/var/nix/profiles/default/bin"
  "/Applications/Ghostty.app/Contents/MacOS"
  "$JAVA_HOME/bin"
  "$GEM_HOME/bin"
  "$GOPATH/bin"
  "$HOME/.cargo/bin"
  "$HOME/.orbstack/bin"
  "$HOME/Library/pnpm"
  "$HOME/.claude/local"
  "/opt/homebrew/opt/ruby/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/Users/rafa.gomez/.cache/npm/global/bin"
  "/Users/rafa.gomez/.local/bin"
  "/usr/local/bin"
  "/bin"
  "/usr/bin"
  "/usr/sbin"
  "/sbin"
)
