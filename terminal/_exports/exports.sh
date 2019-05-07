export MY_SSH_USERNAME='rafa.gomez'

export JAVA_HOME='/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home'
export PHP_PATH='/usr/local/opt/php@7.1'
export PYTHON_PATH='/usr/local/opt/python'
export GOPATH="$HOME/.go"
export GEM_HOME="$HOME/.gem"

export SBT_OPTS='-Xms512M -Xmx1024M -Xss2M -XX:MaxMetaspaceSize=512m -XX:ReservedCodeCacheSize=256M -Dfile.encoding=UTF8'
export SBT_CREDENTIALS=$HOME/.sbt/.credentials
export FZF_DEFAULT_OPTS='--color=bg+:24 --reverse'

export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_NO_ANALYTICS=true
export HOMEBREW_INSTALL_BADGE="(ʘ‿ʘ)"
export HOMEBREW_BUNDLE_FILE_PATH=${DOTFILES_PATH}/mac/brew/Brewfile

export LANG=en_GB

# @todo Migrate this to an array of paths (I don't like this inline because it's hard to read)
PATH=/usr/local/sbin:$PATH
PATH=/usr/local/bin:$PATH
PATH=/usr/local/opt/fzf/bin:$PATH
PATH=/usr/local/opt/make/libexec/gnubin:$PATH
PATH=~/.composer/vendor/bin:$PATH
PATH=${PHP_PATH}/sbin:$PATH
PATH=${PHP_PATH}/bin:$PATH
PATH=${PYTHON_PATH}/libexec/bin:$PATH
PATH=${GEM_HOME}/bin:$PATH
PATH=${GOPATH}/bin:$PATH
PATH=${JAVA_HOME}/bin:$PATH
PATH=~/bin:$PATH
PATH=${DOTFILES_PATH}/git/bin:$PATH
PATH=${DOTFILES_PATH}/bin:$PATH

export PATH=$PATH
