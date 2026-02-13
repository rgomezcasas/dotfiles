#!/usr/bin/env bash

input=$(cat)

model=$(echo "$input" | jq -r 'if .model | type == "object" then .model.id else .model end // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // "."')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
context_used=$(( context_pct * context_size / 100 ))
session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

case "$model" in
  *opus*4-6*|*opus*4.6*) model_name="Opus 4.6" ;;
  *opus*4-5*|*opus*4.5*) model_name="Opus 4.5" ;;
  *opus*) model_name="Opus" ;;
  *sonnet*4-5*|*sonnet*4.5*) model_name="Sonnet 4.5" ;;
  *sonnet*) model_name="Sonnet" ;;
  *haiku*4-5*|*haiku*4.5*) model_name="Haiku 4.5" ;;
  *haiku*) model_name="Haiku" ;;
  *) model_name="$model" ;;
esac

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

bar_width=10
filled=$(( context_pct * bar_width / 100 ))
empty=$(( bar_width - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

total_secs=$(( duration_ms / 1000 ))
minutes=$(( total_secs / 60 ))
seconds=$(( total_secs % 60 ))
if (( minutes > 0 )); then
  duration_str="${minutes}m ${seconds}s"
else
  duration_str="${seconds}s"
fi

session_cost_str=$(printf '$%.2f' "$session_cost")

# Daily cost from ccusage with 2-minute cache
cache_file="/tmp/.claude-statusline-daily-cost"
now=$(date +%s)
cache_stale=1
if [[ -f "$cache_file" ]]; then
  cache_mtime=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
  (( now - cache_mtime < 120 )) && cache_stale=0
fi

if (( cache_stale )); then
  daily_cost=$(npx ccusage@latest daily --since "$(date +%Y%m%d)" --json 2>/dev/null | jq -r '.totals.totalCost // 0')
  daily_cost=${daily_cost:-0}
  echo "$daily_cost" > "$cache_file"
else
  daily_cost=$(cat "$cache_file")
fi
daily_cost_str=$(printf '$%.2f' "$daily_cost")

if (( duration_ms > 60000 )); then
  cost_per_hour=$(echo "scale=2; $session_cost * 3600000 / $duration_ms" | bc 2>/dev/null || echo "0")
  cost_per_hour_str=$(printf '$%.2f/h' "$cost_per_hour")
else
  cost_per_hour_str="-"
fi

GREEN='\033[32m'
WHITE='\033[37m'
GRAY='\033[90m'
RESET='\033[0m'

line="${GREEN}${model_name}${RESET}"

if [[ -n "$git_branch" ]]; then
  line+=" ${GRAY}@${RESET} ${WHITE}${git_branch}${RESET}"
fi

line+="  ${GRAY}|${RESET}  ${GREEN}${bar}${RESET} ${WHITE}${context_pct}% (${context_used_str}/${context_size_str})${RESET}"
line+="  ${GRAY}|${RESET}  ${GREEN}${session_cost_str}${RESET} ${GRAY}·${RESET} ${WHITE}${daily_cost_str} today${RESET} ${GRAY}·${RESET} ${WHITE}${cost_per_hour_str}${RESET}"
line+="  ${GRAY}|${RESET}  🕐 ${WHITE}${duration_str}${RESET}"

printf "%b" "$line"
