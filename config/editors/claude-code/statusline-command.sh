#!/usr/bin/env bash

PATH="$HOME/.cache/npm/global/bin:$PATH"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

input=$(cat)

theme=$(jq -r '.theme // "dark"' ~/.claude.json 2>/dev/null || echo "dark")

model=$(echo "$input" | jq -r 'if .model | type == "object" then .model.id else .model end // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // "."')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
context_used=$(( context_pct * context_size / 100 ))
session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
effort_level=$(echo "$input" | jq -r '.effort.level // empty')
limit_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
limit_5h_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
limit_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
limit_7d_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

model_family=""
case "$model" in
  *opus*) model_family="Opus" ;;
  *sonnet*) model_family="Sonnet" ;;
  *haiku*) model_family="Haiku" ;;
  *fable*) model_family="Fable" ;;
esac

model_version=$(echo "$model" | grep -oE '[0-9]+[-.][0-9]+|[0-9]+' | head -1 | tr '-' '.')

if [[ -n "$model_family" && -n "$model_version" ]]; then
  model_name="$model_family $model_version"
elif [[ -n "$model_family" ]]; then
  model_name="$model_family"
else
  model_name="$model"
fi

git_branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree &>/dev/null; then
  git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

format_tokens() {
  local n=$1
  if (( n >= 1000 )); then
    printf '%dk' $(( n / 1000 ))
  else
    printf '%d' "$n"
  fi
}
context_used_str=$(format_tokens "$context_used")
context_size_str=$(format_tokens "$context_size")

pct_str="${context_pct}%"
if (( context_used > 0 )); then
  label="${pct_str} ∘ ${context_used_str}"
else
  label="${pct_str}"
fi
label_len=${#label}
bar_width=$(( label_len + 2 ))
filled=$(( context_pct * bar_width / 100 ))
pct_len=$label_len
pct_start=$(( (bar_width - pct_len + 1) / 2 ))

if [[ "$theme" == "light" ]]; then
  if (( context_pct > 69 )); then
    bar_fg="\033[38;2;239;68;68m"
    bar_filled_bg="\033[38;2;255;255;255;48;2;239;68;68m"
    bar_empty="\033[38;2;252;165;165m"
    bar_empty_bg="\033[38;2;100;116;139;48;2;252;165;165m"
  elif (( context_pct > 50 )); then
    bar_fg="\033[38;2;234;179;8m"
    bar_filled_bg="\033[38;2;255;255;255;48;2;234;179;8m"
    bar_empty="\033[38;2;253;224;71m"
    bar_empty_bg="\033[38;2;100;116;139;48;2;253;224;71m"
  else
    bar_fg="\033[38;2;22;163;74m"
    bar_filled_bg="\033[38;2;255;255;255;48;2;22;163;74m"
    bar_empty="\033[38;2;134;239;172m"
    bar_empty_bg="\033[38;2;55;65;81;48;2;134;239;172m"
  fi
else
  if (( context_pct > 69 )); then
    bar_fg="\033[31m"
    bar_filled_bg="\033[30;41m"
    bar_empty="\033[38;2;80;40;40m"
    bar_empty_bg="\033[37;48;2;80;40;40m"
  elif (( context_pct > 50 )); then
    bar_fg="\033[33m"
    bar_filled_bg="\033[30;43m"
    bar_empty="\033[38;2;80;80;40m"
    bar_empty_bg="\033[37;48;2;80;80;40m"
  else
    bar_fg="\033[32m"
    bar_filled_bg="\033[30;42m"
    bar_empty="\033[38;2;75;80;40m"
    bar_empty_bg="\033[37;48;2;75;80;40m"
  fi
fi

bar=""
for ((i=0; i<bar_width; i++)); do
  if (( i >= pct_start && i < pct_start + pct_len )); then
    char="${label:$(( i - pct_start )):1}"
    if (( i < filled )); then
      bar+="${bar_filled_bg}${char}"
    else
      bar+="${bar_empty_bg}${char}"
    fi
  else
    if (( i < filled )); then
      bar+="${bar_fg}█"
    else
      bar+="${bar_empty}█"
    fi
  fi
done
bar+="\033[0m"

limit_5h_str=""
[[ -n "$limit_5h" ]] && limit_5h_str=$(printf '%.0f%%' "$limit_5h")
limit_7d_str=""
[[ -n "$limit_7d" ]] && limit_7d_str=$(printf '%.0f%%' "$limit_7d")

session_cost_str=$(printf '$%.2f' "$session_cost")

# Daily cost from ccusage with 2-minute cache, online pricing refresh once per day
cache_dir="${TMPDIR:-/tmp}"
cache_file="$cache_dir/.claude-statusline-daily-cost"
pricing_stamp="$cache_dir/.claude-statusline-pricing-refresh"
now=$(date +%s)
cache_stale=1
if [[ -f "$cache_file" ]]; then
  cache_mtime=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
  (( now - cache_mtime < 120 )) && cache_stale=0
fi

if (( cache_stale )); then
  offline_flag="--offline"
  if [[ ! -f "$pricing_stamp" ]] || (( now - $(stat -f %m "$pricing_stamp" 2>/dev/null || echo 0) >= 86400 )); then
    offline_flag=""
    touch "$pricing_stamp"
  fi
  daily_cost=$(ccusage daily --since "$(date +%Y%m%d)" $offline_flag --json 2>/dev/null | jq -r '.totals.totalCost // 0')
  daily_cost=${daily_cost:-0}
  echo "$daily_cost" > "$cache_file"
else
  daily_cost=$(cat "$cache_file")
fi
if (( $(echo "$session_cost > $daily_cost" | bc -l) )); then
  daily_cost=$session_cost
fi
daily_cost_str=$(printf '$%.2f' "$daily_cost")


RESET='\033[0m'

if [[ "$theme" == "light" ]]; then
  GREEN='\033[38;2;22;163;74m'
  GRAY='\033[38;2;156;163;175m'
  ACCENT='\033[38;2;37;99;235m'
  TEXT='\033[38;2;55;65;81m'
else
  GREEN='\033[32m'
  GRAY='\033[90m'
  ACCENT='\033[32m'
  TEXT='\033[37m'
fi

case "$effort_level" in
  low)    effort_color="$TEXT" ;;
  medium) effort_color='\033[38;2;234;179;8m' ;;
  high)   effort_color="$GREEN" ;;
  xhigh)  effort_color='\033[38;2;249;115;22m' ;;
  max)    effort_color='\033[38;2;239;68;68m' ;;
  *)      effort_color="$TEXT" ;;
esac

# Rank a rate limit 0-4 by burn pace: project current usage to the end of the
# window based on how much of it has elapsed, with an absolute-usage safety net
# for windows that are nearly exhausted right now. Ranks map to gray (idle) →
# white (on pace) → yellow → orange → red (critical). Result is set in LIMIT_RANK.
limit_rank() {
  local used=$1 resets_at=$2 window=$3
  local used_int abs=0 pace=0
  used_int=$(printf '%.0f' "$used")

  if   (( used_int >= 90 )); then abs=4
  elif (( used_int >= 80 )); then abs=3
  fi

  if [[ -n "$resets_at" ]]; then
    local now remaining elapsed expected projected
    now=$(date +%s)
    remaining=$(( resets_at - now ))
    (( remaining < 0 )) && remaining=0
    elapsed=$(( window - remaining ))
    (( elapsed < 0 )) && elapsed=0
    expected=$(( elapsed * 100 / window ))
    (( expected < 1 )) && expected=1
    projected=$(( used_int * 100 / expected ))
    if   (( projected >= 250 )); then pace=4
    elif (( projected >= 175 )); then pace=3
    elif (( projected >= 110 )); then pace=2
    elif (( projected >=  75 )); then pace=1
    fi
  else
    if   (( used_int >= 90 )); then pace=4
    elif (( used_int >= 75 )); then pace=3
    elif (( used_int >= 50 )); then pace=2
    elif (( used_int >= 25 )); then pace=1
    fi
  fi

  LIMIT_RANK=$(( abs > pace ? abs : pace ))
}

rank_color() {
  case $1 in
    4) printf '%s' '\033[38;2;239;68;68m' ;;
    3) printf '%s' '\033[38;2;249;115;22m' ;;
    2) printf '%s' '\033[38;2;234;179;8m' ;;
    1) printf '%s' "$TEXT" ;;
    *) printf '%s' "$GRAY" ;;
  esac
}

format_reset() {
  local resets_at=$1
  [[ -z "$resets_at" ]] && return
  local now diff d h m
  now=$(date +%s)
  diff=$(( resets_at - now ))
  (( diff < 0 )) && diff=0
  d=$(( diff / 86400 ))
  h=$(( (diff % 86400) / 3600 ))
  m=$(( (diff % 3600) / 60 ))
  if   (( d > 0 )); then printf 'resets in %dd %dh' "$d" "$h"
  elif (( h > 0 )); then printf 'resets in %dh %dm' "$h" "$m"
  else                   printf 'resets in %dm' "$m"
  fi
}

SEP=" ${GRAY}⎮${RESET} "
MSEP=" ${GRAY}∘${RESET} "

_branding_unused="${TEXT}<${GREEN}${RESET}${TEXT}>${RESET}"
line="${GREEN}${model_name}${RESET}"
if [[ -n "$effort_level" ]]; then
  line+=" ${effort_color}${effort_level}${RESET}"
fi

if [[ -n "$git_branch" ]]; then
  line+=" ${GRAY}@${RESET} ${TEXT}${git_branch}${RESET}"
fi

line+="${SEP}${bar}"
line+="${SEP}${ACCENT}${session_cost_str}${RESET}${MSEP}${TEXT}${daily_cost_str} today${RESET}"

limits=""
if [[ -n "$limit_5h_str" ]]; then
  limit_rank "$limit_5h" "$limit_5h_reset" 18000
  seg="${GRAY}5h $(rank_color "$LIMIT_RANK")${limit_5h_str}${RESET}"
  (( LIMIT_RANK >= 2 )) && [[ -n "$limit_5h_reset" ]] && seg+=" ${TEXT}$(format_reset "$limit_5h_reset")${RESET}"
  limits="$seg"
fi
if [[ -n "$limit_7d_str" ]]; then
  limit_rank "$limit_7d" "$limit_7d_reset" 604800
  seg="${GRAY}7d $(rank_color "$LIMIT_RANK")${limit_7d_str}${RESET}"
  (( LIMIT_RANK >= 2 )) && [[ -n "$limit_7d_reset" ]] && seg+=" ${TEXT}$(format_reset "$limit_7d_reset")${RESET}"
  limits="${limits:+$limits${MSEP}}$seg"
fi
[[ -n "$limits" ]] && line+="${SEP}${limits}"

printf "%b" "$line"
