# Enable aliases to be sudo’ed
alias sudo='sudo '

# Others
alias aux='ps uax'
alias brwe='brew'
alias edithosts='sudo vim /etc/hosts'
alias c='pbcopy'
alias copy='pbcopy'
alias copy_ssh_key='xclip -sel clip < ~/.ssh/id_rsa.pub'
alias count_files_recursive='find . -type f -print | wc -l'
alias count_files_recursive_per_directory='ls -d */ | xargs -I _ sh -c "find \"_\" -type f | wc -l | xargs echo _"'
alias emptytrash='sudo empty_trash'
alias find_broken_symlinks='find -L . -type l'
alias fuck!='sudo $history[1]'
alias flat_this_dir="sudo find . -mindepth 2 -type f -exec mv -i '{}' . ';'"
alias k='kill -9'
alias map="xargs -n1"
alias r='realpath'
alias reveal='open .'
alias size_of_the_current_directory='du -ch | grep total'
alias size_of_directories='ls | xargs -I _ du -sch "_" | grep -v total | sort -h'
alias stt='subl .'
alias watch_number_of_files='watch -n1 "find . -type f -print | wc -l"'
alias t='time'
alias pubkey='cat ~/.ssh/id_rsa.pub | pbcopy'
alias fuck_sbt="ps aux | grep sbt | awk '{print $2}' | xargs kill -9"

alias catimg='imgcat'
alias editdotfiles='subl ~/.dotfiles'

alias optimize_zsh='source ${ZDOTDIR:-${HOME}}/.zlogin'

# Start
alias start-supervisor='supervisord -c /usr/local/etc/supervisord.ini'
alias start-dynamo='dynamodb-local &'

# Stop
alias stop-all-brew-services="brew services stop --all"

# Kill
alias kill-supervisor="kill_named 'usr/local/bin/supervisord'"
alias kill-dynamo="kill_named 'DynamoDB'"

# Log
alias log-supervisor='tail -f /usr/local/var/log/supervisord.log'

# Mac
alias wall='change_wallpaper'
alias out='outdated_apps'
alias up='update_apps'
alias export_brew="brew bundle dump --file=${DOTFILES_PATH}/mac/brew/Brewfile --force"

# Functions
function idea. {
  idea $PWD &>/dev/null
}
