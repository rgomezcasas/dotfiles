export JAVA_HOME='/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home'
export PHP_PATH='/usr/local/opt/php@7.2'
export PYTHON_PATH='/usr/local/opt/python'
export GOPATH="$HOME/.go"
export GEM_HOME="$HOME/.gem"

export SBT_OPTS='-Xms512M -Xmx1024M -Xss2M -XX:MaxMetaspaceSize=512m -XX:ReservedCodeCacheSize=256M -Dfile.encoding=UTF8'
export SBT_CREDENTIALS="$HOME/.sbt/.credentials"

export FZF_DEFAULT_OPTS='--color=bg+:24 --reverse'

export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_NO_ANALYTICS=true
export HOMEBREW_INSTALL_BADGE="(ʘ‿ʘ)"
export HOMEBREW_BUNDLE_FILE_PATH=${DOTFILES_PATH}/mac/brew/Brewfile

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export _JAVA_AWT_WM_NONREPARENTING=1

paths=(
  "$PHP_PATH/bin"
  "$PHP_PATH/sbin"
  "/usr/local/bin"
  "/bin"
  "/usr/local/opt/make/libexec/gnubin"
  "/usr/bin"
  "/usr/local/sbin"
  "/usr/sbin"
  "/sbin"
  "/snap/bin"
  "$HOME/bin"
  "$DOTFILES_PATH/bin"
  "$DOTFILES_PATH/git/bin"
  "$JAVA_HOME/bin"
  "$GOPATH/bin"
  "$GEM_HOME/bin"
  "$PYTHON_PATH/libexec/bin"
  "$HOME/.composer/vendor/bin"
)

PATH=$(IFS=":"; echo "${paths[*]}";)

export PATH
