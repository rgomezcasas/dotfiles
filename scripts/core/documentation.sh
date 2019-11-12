#!/usr/bin/env bash

extract_help() {
  local -r file="$1"
  grep "^##?" "$file" | cut -c 5-
}

_compose_version() {
  local -r file="$1"
  local -r version_code=$(grep "^#??" "$file" | cut -c 5- || echo "unversioned")
  local -r git_info=$(cd "$(dirname "$file")" && git log -n 1 --pretty=format:'%h%n%ad%n%an%n%s' --date=format:'%Y-%m-%d %Hh%M' -- "$(basename "$file")")
  echo -e "${version_code}\n${git_info}"
}

docs::eval() {
  local -r file="$0"
  local -r help="$(extract_help "$file")"

  docopts="${DOTFILES_PATH}/scripts/core/utils/docopts"

  if [[ ${1:-} == "--version" ]]; then
    local -r version="$(_compose_version "$file")"
    eval "$($docopts -h "${help}" -V "${version}" : "${@:1}")"
  else
    eval "$($docopts -h "${help}" : "${@:1}")"
  fi
}

docs::eval_help() {
  local -r file="$0"

  case "${!#:-}" in
     -h|--help) extract_help "$file"; exit 0 ;;
     --version) _compose_version "$file"; exit 0 ;;
  esac
}

docs::eval_zsh() {
  local -r file=$1

  case "${2:-}" in
  -h | --help)
    extract_help "$file"
    exit 0
    ;;
  --version)
    _compose_version "$file"
    exit 0
    ;;
  esac
}

docs::eval_help_first_arg() {
  local -r file="$0"

  case "${1:-}" in
  -h | --help)
    extract_help "$file"
    exit 0
    ;;
  --version)
    _compose_version "$file"
    exit 0
    ;;
  esac
}
