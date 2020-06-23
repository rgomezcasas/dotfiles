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
  eval "$(docpars -h "$(grep "^##?" "$0" | cut -c 5-)" : "$@")"
}

docs::eval_help() {
  local -r file="$0"

  case "${!#:-}" in
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
