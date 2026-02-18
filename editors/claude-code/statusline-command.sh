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
pct_str="${context_pct}%"
pct_len=${#pct_str}
pct_start=$(( (bar_width - pct_len + 1) / 2 ))
bar=""
for ((i=0; i<bar_width; i++)); do
  if (( i >= pct_start && i < pct_start + pct_len )); then
    char="${pct_str:$(( i - pct_start )):1}"
    if (( i < filled )); then
      bar+="\033[30;42m${char}"
    else
      bar+="\033[37;48;2;75;80;40m${char}"
    fi
  else
    if (( i < filled )); then
      bar+="\033[32m█"
    else
      bar+="\033[38;2;75;80;40m█"
    fi
  fi
done
bar+="\033[0m"

total_secs=$(( duration_ms / 1000 ))
hours=$(( total_secs / 3600 ))
minutes=$(( (total_secs % 3600) / 60 ))
seconds=$(( total_secs % 60 ))
if (( hours > 0 )); then
  duration_str="${hours}h ${minutes}m"
elif (( minutes > 0 )); then
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
if (( $(echo "$session_cost > $daily_cost" | bc -l) )); then
  daily_cost=$session_cost
fi
daily_cost_str=$(printf '$%.2f' "$daily_cost")


GREEN='\033[32m'
WHITE='\033[37m'
GRAY='\033[90m'
RESET='\033[0m'
SEP=" ${GRAY}⎮${RESET} "
MSEP=" ${GRAY}∘${RESET} "

branding="${WHITE}<${GREEN}${RESET}${WHITE}>${RESET}"
line="${GREEN}${model_name}${RESET}"

if [[ -n "$git_branch" ]]; then
  line+=" ${GRAY}@${RESET} ${WHITE}${git_branch}${RESET}"
fi

line+="${SEP}${bar}"
if (( context_used > 0 )); then
  line+=" ${WHITE}${context_used_str}${RESET}"
fi
line+="${SEP}${GREEN}${session_cost_str}${RESET}${MSEP}${WHITE}${daily_cost_str} today${RESET}"
line+="${SEP}${GRAY}\uf017  ${WHITE}${duration_str}${RESET}"

printf "%b" "$line"
