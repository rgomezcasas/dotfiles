#PHP_PATH='/usr/local/opt/php@7.4'
#GLOBAL_COMPOSER_PATH="$HOME/.composer"
PYTHON_PATH='/usr/local/opt/python'
RUBY_PATH='/usr/local/opt/ruby'

export JAVA_HOME='/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home'
export GEM_HOME="$HOME/.gem"
export GOPATH="$HOME/.go"

export FZF_DEFAULT_OPTS='
  --color=pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934
  --reverse
'

export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_NO_ANALYTICS=true
export HOMEBREW_BUNDLE_FILE_PATH="${DOTFILES_PATH}/mac/brew/Brewfile"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export path=(
  "$HOME/bin"
  "$DOTFILES_PATH/bin"
#  "$PHP_PATH/bin"
#  "$PHP_PATH/sbin"
  "$RUBY_PATH/bin"
  "$JAVA_HOME/bin"
  "$GOPATH/bin"
  "$GEM_HOME/bin"
#  "$GEM_HOME/ruby/2.7.0/bin/bin"
  "$PYTHON_PATH/libexec/bin"
#  "$GLOBAL_COMPOSER_PATH/vendor/bin"
  "/bin"
  "/usr/local/bin" # This contains all Brew binaries (bash...)
  "/usr/local/opt/gnu-sed/libexec/gnubin" # Use gnu-sed (mac version is from BSD 2005)
  "/usr/local/opt/make/libexec/gnubin" # Use gnu-make
  "/usr/bin"
#  "/usr/local/sbin"
#  "/usr/sbin"
  "/sbin"
)
