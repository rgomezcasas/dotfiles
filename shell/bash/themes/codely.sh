PROMPT_COMMAND="rafa_theme"

MIDDLE_CHARACTER="$"
GREEN_COLOR="32"
RED_COLOR="31"

rafa_theme() {
  LAST_CODE="$?"
  current_dir=$(dot filesystem short_pwd)
  STATUS_COLOR=$GREEN_COLOR

  if [ $LAST_CODE -ne 0 ]; then
    STATUS_COLOR=$RED_COLOR
  fi

  export PS1="\[\e[${STATUS_COLOR}m\]{\[\e[m\]${MIDDLE_CHARACTER}\[\e[${STATUS_COLOR}m\]}\[\e[m\] \[\e[33m\]${current_dir}\[\e[m\] "
}
