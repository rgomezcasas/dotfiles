# ZSH Utils
function preexec() {
   (( $#_elapsed > 1000 )) && set -A _elapsed $_elapsed[-1000,-1]
   typeset -ig _start=SECONDS
}
function precmd() { set -A _elapsed $_elapsed $(( SECONDS-_start )) }

# Alias de Alias
alias editaliases="vim ~/.dotfiles/zsh/aliases.sh"
alias cataliases="cat ~/.dotfiles/zsh/aliases.sh"
alias reloadaliases="source ~/.dotfiles/zsh/aliases.sh"

# Git
function gitall() { git add -A && git commit -m "$1" && git push origin $2 }
alias gc='git commit'
alias gd='git diff --color'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset %C(yellow)%d%Creset %an: %s - %Creset %Cgreen(%cr)%Creset" --abbrev-commit --date=relative'
alias gs="git status -sb"

# Apache
alias edithosts='sudo vim /etc/hosts'
alias disable_apache_autostart='sudo update-rc.d -f  apache2 remove'
alias apachestart='sudo /etc/init.d/apache2 start'
alias apachestop='sudo /etc/init.d/apache2 stop'
alias apacherestart='sudo /etc/init.d/apache2 restart'

# PHP
function phpserve() { sudo php -S 0.0.0.0:$1 }
alias phpspec='./vendor/bin/phpspec'
alias phpspecrun='./vendor/bin/phpspec run -fpretty -v'
alias phpunit='./vendor/bin/phpunit --testdox --colors'
alias behat='./vendor/bin/behat'
alias dump='composer dump-autoload'
alias artserve='php artisan serve --host 0.0.0.0'
alias composerupdate='sudo composer self-update'
alias cu='composer update'
alias ci='composer install'
alias cdump='composer dump-autoload'

# JS
function gadd() { sudo npm install gulp-$1 --save-dev }
alias lr='livereloadx --exclude ".idea" --include "*.twig"'

# Ip's
function privateip() { ip addr | awk '/inet / {sub(/\/.*/, "", $2); print $2}' }
alias publicip="curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
function port_owner() { sudo netstat -tulpn | grep --color :$1 }

# Screen
function brillo() { xrandr --output LVDS1 --brightness 0.$1 }
function brillo_a_tope() { xrandr --output LVDS1 --brightness 1 }

# Term
function execute_in_new_windows() { gnome-terminal -e $1 }
function execute_in_new_tab() {
    xdotool key ctrl+shift+t
    xdotool type "$*"
    xdotool key Return
}

# Utils
alias c='reset'
alias reveal='nautilus .'
alias remove='rm -Rf'
alias count_files_recursive='find . -type f -print | wc -l'
alias watch_number_of_files='watch -n1 "find . -type f -print | wc -l"'
alias watch_ftp_connections='watch -n1 "ftpwho -c /opt/lampp/sbin/proftpd -f /opt/lampp/var/proftpd.scoreboard"'
alias size_of_the_current_directory='du -ch | grep total'
alias YOLO='sudo find . -exec chmod 777 {} \;'
alias get_last_executed_command='echo $(fc -ln -1)'
function get_last_command_execution_time() {
    text='Ejecutado en aprox: '
    timeUnity='s'

    echo $text$_elapsed[-1]$timeUnity
}
alias fuck='sudo $(fc -ln -1)'
alias stt='subl .'
function diff_between() {
    comm -23 <(sort $2) <(sort $1)
}
alias normalize_perms='chmod 775'
alias get_current_gnome_terminal_conf='gconftool-2 -a "/apps/gnome-terminal/profiles/Default"'
alias copy_ssh_key='xclip -sel clip < ~/.ssh/id_rsa.pub'

# Common Ubuntu Errors
alias ubuntu_solve_system_error_messages_on_startup='sudo rm /var/crash/*'

