# ------------------------------------------------------------------------------
# Codely theme config
# ------------------------------------------------------------------------------
if [[ $(defaults read -g AppleInterfaceStyle 2>/dev/null) == "Dark" ]]; then
  export CODELY_THEME_MODE="dark"
else
  export CODELY_THEME_MODE="light"
fi
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
if [ "$CODELY_THEME_MODE" = "dark" ]; then
  fzf_colors="pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934"
else
  fzf_colors="pointer:#db0f35,bg+:#d6d6d6,fg:#808080,fg+:#363636,hl:#8ec07c,info:#928374,header:#fffee3"
fi

export FZF_DEFAULT_OPTS="--color=$fzf_colors --reverse"

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_PREFIX="/opt/homebrew";

if [ "$CODELY_THEME_MODE" = "dark" ]; then
  export BAT_THEME='gruvbox-dark'
else
  export BAT_THEME='gruvbox-light'
fi

export EZA_COLORS="di=34:ln=36:ex=32:fi=0:uu=33:gu=33:sn=0:sb=0:da=36:hd=4:bu=4;33:ur=33:uw=31:ux=32:ue=32:gr=33:gw=31:gx=32:tr=33:tw=31:tx=32:xx=90"

# GPG_TTY set lazily on first gpg use (see functions.sh)

export LANG="en_US.UTF-8"

export EDITOR="idea -e --wait"
# ------------------------------------------------------------------------------
# Path - The higher it is, the more priority it has
# ------------------------------------------------------------------------------
typeset -U path

_path_candidates=(
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
  "$HOME/.lmstudio/bin"
  "/opt/homebrew/opt/ruby/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "$HOME/.cache/npm/global/bin"
  "$HOME/.local/bin"
  "/usr/local/bin"
  "/bin"
  "/usr/bin"
  "/usr/sbin"
  "/sbin"
)

path=()
for p in "${_path_candidates[@]}"; do
  [[ -d "$p" ]] && path+=("$p")
done
unset _path_candidates p
