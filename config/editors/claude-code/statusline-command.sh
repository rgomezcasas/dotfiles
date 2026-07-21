#!/usr/bin/env bash

PATH="$HOME/.cache/npm/global/bin:$PATH"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

input=$(cat)

theme=$(jq -r '.theme // "dark"' ~/.claude.json 2>/dev/null || echo "dark")

model=$(echo "$input" | jq -r 'if .model | type == "object" then .model.id else .model end // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // "."')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
session_id=$(echo "$input" | jq -r '.session_id // empty')
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
  if (( n >= 1000000 )); then
    printf '%dM' $(( n / 1000000 ))
  elif (( n >= 1000 )); then
    printf '%dk' $(( n / 1000 ))
  else
    printf '%d' "$n"
  fi
}
context_size_str=$(format_tokens "$context_size")
cache_read_str=$(format_tokens "$cache_read")
cache_write_str=$(format_tokens "$cache_write")

cache_total=$(( cache_read + cache_write ))
if (( cache_total > 0 )); then
  cache_read_pct=$(( cache_read * 100 / cache_total ))
else
  cache_read_pct=0
fi
cache_ratio_str="${cache_read_pct}%"

pct_str="${context_pct}%"
label="${pct_str} / ${context_size_str}"
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

# Warn when the next request will miss the prompt cache. State is per-session
# (parallel Claude Code sessions each keep their own file, keyed by session_id).
# The session cost only grows when a request completes, so a cost increase means
# the current model just got cached — commit it and reset the TTL clock. If the
# model differs from the committed value, no request has run since the change, so
# the next one breaks the cache — but only once a real request has completed
# (prev_cost > 0), since switching model before sending any message has no cache
# to break. Changing effort does not break the cache, so it is not tracked here.
# Otherwise count down the 5m TTL.
cache_ttl=300
cache_warn_threshold=90
cache_warning=""
if [[ -n "$session_id" ]]; then
  state_file="$cache_dir/.claude-statusline-cache-${session_id//[^A-Za-z0-9_-]/_}"
  prev_model="" prev_cost="" commit_time=""
  [[ -f "$state_file" ]] && IFS=$'\t' read -r prev_model prev_cost commit_time < "$state_file"
  if [[ -z "$prev_cost" ]] || (( $(echo "$session_cost > $prev_cost" | bc -l) )); then
    prev_model="$model" prev_cost="$session_cost" commit_time="$now"
    printf '%s\t%s\t%s\n' "$model" "$session_cost" "$now" > "$state_file" 2>/dev/null
  fi
  if [[ "$model" != "$prev_model" ]] && (( $(echo "$prev_cost > 0" | bc -l) )); then
    cache_warning="You've changed model so cache is gonna break"
  elif [[ -n "$commit_time" ]]; then
    remaining=$(( cache_ttl - (now - commit_time) ))
    (( remaining > 0 && remaining < cache_warn_threshold )) && \
      cache_warning=$(printf '%d:%02d remaining to use cache' $(( remaining / 60 )) $(( remaining % 60 )))
  fi
fi


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

RED='\033[38;2;239;68;68m'

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

# Sweep a bright glint across the text, then rest, on a loop. The frame is keyed
# to wall-clock seconds so it advances via statusLine refreshInterval (capped at
# 1s); each tick moves the glint center by `speed` chars, blending base->highlight
# per char by triangular distance. Emits literal \033 escapes for printf "%b".
shimmer_text() {
  local text=$1 br=$2 bg=$3 bb=$4 hr=$5 hg=$6 hb=$7 sec=$8
  local n=${#text} spread=2 rest=2 speed=2 scale=100
  local period=$(( (n + 2 * spread) / speed + rest ))
  local center=$(( -spread + (sec % period) * speed ))
  local out="" i dist inten r g b
  for (( i = 0; i < n; i++ )); do
    dist=$(( i - center )); (( dist < 0 )) && dist=$(( -dist ))
    inten=$(( scale - dist * scale / spread ))
    (( inten < 0 )) && inten=0
    r=$(( br + (hr - br) * inten / scale ))
    g=$(( bg + (hg - bg) * inten / scale ))
    b=$(( bb + (hb - bb) * inten / scale ))
    out+="\033[38;2;${r};${g};${b}m${text:i:1}"
  done
  printf '%s' "$out"
}

# Scrolling rainbow, matching /effort's "max": each char takes palette[(i-offset)
# % 7] and the offset advances over time so the band slides left-to-right. Bold
# like the menu. Offset is keyed to seconds (statusLine caps refresh at 1s); it is
# normalized into [0,6] so bash never indexes the array with a negative value.
rainbow_text() {
  local text=$1 offset=$2
  local pr=(235 245 250 145 130 155 200)
  local pg=(95 139 195 200 170 130 130)
  local pb=(87 87 95 130 220 200 180)
  local n=${#text} out="" i k
  for (( i = 0; i < n; i++ )); do
    k=$(( (i - offset % 7 + 7) % 7 ))
    out+="\033[1;38;2;${pr[k]};${pg[k]};${pb[k]}m${text:i:1}"
  done
  printf '%s' "$out"
}

SEP=" ${GRAY}⎮${RESET} "
MSEP=" ${GRAY}∘${RESET} "

_branding_unused="${TEXT}<${GREEN}${RESET}${TEXT}>${RESET}"
line="${GREEN}${model_name}${RESET}"
if [[ -n "$effort_level" ]]; then
  if [[ "$effort_level" == "xhigh" ]]; then
    if [[ "$theme" == "light" ]]; then
      effort_render=$(shimmer_text "$effort_level" 249 115 22 194 65 12 "$now")
    else
      effort_render=$(shimmer_text "$effort_level" 249 115 22 255 244 224 "$now")
    fi
  elif [[ "$effort_level" == "max" ]]; then
    effort_render=$(rainbow_text "$effort_level" "$now")
  else
    effort_render="${effort_color}${effort_level}"
  fi
  line+=" ${effort_render}${RESET}"
fi

if [[ -n "$git_branch" ]]; then
  line+=" ${GRAY}@${RESET} ${TEXT}${git_branch}${RESET}"
fi

line+="${SEP}${bar}"
cache_seg="${GREEN}↓${RESET} ${TEXT}${cache_read_str}${RESET}${MSEP}${ACCENT}↑${RESET} ${TEXT}${cache_write_str}${RESET}"
if (( cache_read > 0 && cache_read_pct < 80 )); then
  cache_seg+="${MSEP}${RED}${cache_ratio_str}${RESET}"
fi
line+="${SEP}${cache_seg}"
line+="${SEP}${ACCENT}${session_cost_str}${RESET}${MSEP}${TEXT}${daily_cost_str} today${RESET}"
[[ -n "$cache_warning" ]] && line+="${SEP}${RED}${cache_warning}${RESET}"

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

# Display width of a rendered segment: strip the literal \033[…m color codes,
# then count the East-Asian-ambiguous glyphs this line emits (█ ∘ ⎮ ↑ ↓) as 2
# columns, since this terminal renders them wide and they would otherwise overflow.
visible_len() {
  local stripped narrow
  stripped=$(printf '%s' "$1" | sed -E 's/\\033\[[0-9;]*m//g')
  narrow=${stripped//[█∘⎮↑↓]/}
  printf '%s' "$(( 2 * ${#stripped} - ${#narrow} ))"
}

# Terminal columns, since the status line JSON does not expose the width. Prefer
# COLUMNS, then the controlling tty; empty when neither is available.
detect_cols() {
  if [[ "$COLUMNS" =~ ^[0-9]+$ ]] && (( COLUMNS > 0 )); then
    printf '%s' "$COLUMNS"
    return
  fi
  local size
  size=$(stty size </dev/tty 2>/dev/null)
  [[ "$size" =~ [0-9]+$ ]] && printf '%s' "${size##* }"
}

# Push the rate limits to the far right when the width is known, otherwise drop
# them onto their own line so they never collide with the inline content.
if [[ -n "$limits" ]]; then
  term_cols=$(detect_cols)
  right_margin=-7
  gap=-1
  if [[ "$term_cols" =~ ^[0-9]+$ ]]; then
    gap=$(( term_cols - $(visible_len "$line") - $(visible_len "$limits") - right_margin ))
  fi
  if (( gap >= 1 )); then
    printf -v pad '%*s' "$gap" ''
    line+="${pad}${limits}"
  else
    line+=$'\n'"${limits}"
  fi
fi

printf "%b" "$line"
