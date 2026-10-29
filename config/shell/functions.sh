function mkcd() {
  mkdir -p "$1" && cd "$1"
}

function j() {
  if ! typeset -f _zlua > /dev/null 2>&1; then
    eval "$(z.lua --init zsh enhanced once)"
  fi
  _zlua "$1"
}

eza_tree() {
  eza --tree --level=4 --color=always --icons=always --git-ignore --group-directories-first "$@" | awk '
    BEGIN {
      eza_folder = "\356\227\277"
      closed = "\357\201\273"
      open = "\357\201\274"
    }
    function strip(line) { gsub(/\033\[[0-9;]*m/, "", line); return line }
    function depth(line) { return index(strip(line), eza_folder) }
    function emit(line, next_line,   d, nd) {
      d = depth(line)
      if (d == 0) { print line; return }
      nd = depth(next_line)
      if (nd == 0) nd = match(strip(next_line), /[^│├└─ ]/)
      if (next_line != "" && nd > d) sub(eza_folder, open, line)
      else sub(eza_folder, closed, line)
      print line
    }
    NR > 1 { emit(prev, $0) }
    { prev = $0 }
    END { emit(prev, "") }'
}

function ccusa() {
  local color=0 period="LAST 30 DAYS"
  local -a range
  if [[ "$1" == "--all" ]]; then
    shift
    period="ALL TIME"
  else
    range=(--since "$(date -d "30 days ago" +%Y%m%d 2>/dev/null || date -v-30d +%Y%m%d)")
  fi
  [[ -t 1 && -z "$NO_COLOR" ]] && color=1
  local report prices codex
  report=$(NPM_CONFIG_LOGLEVEL=error npx ccusage@latest daily "${range[@]}" --json "$@") || return
  codex=$(NPM_CONFIG_LOGLEVEL=error npx ccusage@latest codex daily "${range[@]}" --json 2>/dev/null)
  jq -e .daily >/dev/null 2>&1 <<< "$codex" || codex='{"daily": []}'
  prices=$(find "${XDG_CACHE_HOME:-$HOME/.cache}/ccusage/http-cache" -name '*model_prices*' 2>/dev/null | head -1)
  jq -r --slurpfile prices_file <(sed -n '/^{/,$p' "$prices" 2>/dev/null) '
    ($prices_file[0] // {}) as $prices |
    ($codex.daily | map({key: .date, value: .models}) | from_entries) as $codex_models |
    def tokens: tostring | [while(length > 0; .[:-3]) | .[-3:]] | reverse | join(",");
    def model_parts: sub("^claude-"; "") | sub("-[0-9]{8}$"; "") |
      if test("^[a-z]+(-[0-9]+)+$") then capture("^(?<family>[a-z]+)-(?<variant>.+)$") | .variant |= gsub("-"; ".")
      elif test("^gpt-[0-9.]+-") then capture("^(?<family>gpt-[0-9.]+)-(?<variant>.+)$")
      else {family: ., variant: null} end;
    def models: map(model_parts) | group_by(.family) | map(.[0].family + ([.[].variant // empty] | if length > 0 then " " + join("/") else "" end)) | join("; ");
    def percent($part; $whole): if $whole > 0 then ($part * 1000 / $whole | round) as $tenths | "\($tenths / 10 | floor).\($tenths % 10)%" else "-" end;
    def write_cost: [.modelBreakdowns[] | ($prices[.modelName] // $prices["claude-" + .modelName]) as $price | select($price.input_cost_per_token != null) | [.cost - .inputTokens * $price.input_cost_per_token - .outputTokens * ($price.output_cost_per_token // 0) - .cacheReadTokens * ($price.cache_read_input_token_cost // 0), 0] | max] | add // 0;
    def without_auto_review:
      .period as $day |
      ($codex_models[$day] // {} | to_entries) as $codex_day |
      [$codex_day[] | select(.value.isFallback) | .key] as $fallbacks |
      [.modelBreakdowns[] | select(.modelName | IN($fallbacks[]))] as $removed |
      .modelBreakdowns -= $removed |
      .modelsUsed -= $fallbacks |
      reduce $removed[] as $model (.;
        .inputTokens -= $model.inputTokens |
        .outputTokens -= $model.outputTokens |
        .cacheCreationTokens -= $model.cacheCreationTokens |
        .cacheReadTokens -= $model.cacheReadTokens |
        .totalTokens -= ($model.inputTokens + $model.outputTokens + $model.cacheCreationTokens + $model.cacheReadTokens) |
        .totalCost -= $model.cost) |
      if $fallbacks != [] and ([$codex_day[] | select(.value.isFallback | not)] == []) then .metadata.agents -= ["codex"] else . end;
    def usage($write): [(.totalTokens - .cacheReadTokens | tokens), (.cacheReadTokens | tokens), percent(.cacheReadTokens; .totalTokens), (if $prices == {} then "-" else percent($write; .totalCost) end), (.totalTokens | tokens), .totalCost];
    [.daily[] | without_auto_review | select(.modelsUsed != [])] as $days |
    ($days | {
      totalTokens: (map(.totalTokens) | add // 0),
      cacheReadTokens: (map(.cacheReadTokens) | add // 0),
      totalCost: (map(.totalCost) | add // 0)
    }) as $totals |
    ($days[] | [.period, (.period | strptime("%Y-%m-%d") | mktime | strftime("%a")), (.metadata.agents | join(", ")), (.modelsUsed | models)] + usage(write_cost) | @tsv),
    (["Total", "", "", ""] + ($totals | usage([$days[] | write_cost] | add // 0)) | @tsv)
  ' --argjson codex "$codex" <<< "$report" | awk -F'\t' -v color="$color" -v period="$period" '
    BEGIN {
      bar_width = 24
      columns_count = split("Date|Day|Agents|Models|Usage|Uncached|Cached|Cached %|Write %|Total Tokens|Cost (USD)", header, "|")
      fields_count = split("1 2 3 4 6 7 8 9 10 11", target, " ")
      split("▏ ▎ ▍ ▌ ▋ ▊ ▉", partial, " ")
      split("72 61 139|94 96 206|157 78 221|247 37 133|255 158 0", stops, "|")
      for (i = 1; i <= 5; i++) { split(stops[i], rgb, " "); R[i] = rgb[1]; G[i] = rgb[2]; B[i] = rgb[3] }
      agent_rgb["claude"] = "217;119;87"
      agent_rgb["codex"] = "16;163;127"
      agent_rgb["opencode"] = "86;182;194"
      for (i = 1; i <= columns_count; i++) width[i] = length(header[i])
      width[5] = bar_width
    }
    {
      rows++
      $10 = sprintf("$%.2f", cost[rows] = $10)
      for (i = 1; i <= fields_count; i++) {
        cell[rows, target[i]] = $i
        if (length($i) > width[target[i]]) width[target[i]] = length($i)
      }
      if ($1 != "Total" && cost[rows] > max) max = cost[rows]
    }
    function paint(code, text) { return color ? "\033[" code "m" text "\033[0m" : text }
    function heat(t,   segment, i, f) {
      if (t < 0) t = 0
      if (t > 1) t = 1
      segment = t * 4
      i = int(segment) + 1
      if (i > 4) i = 4
      f = segment - (i - 1)
      return sprintf("38;2;%d;%d;%d", R[i] + (R[i + 1] - R[i]) * f, G[i] + (G[i + 1] - G[i]) * f, B[i] + (B[i + 1] - B[i]) * f)
    }
    function pad(text, size, right) { return sprintf(right ? "%" size "s" : "%-" size "s", text) }
    function border(text) { return paint("38;2;88;91;112", text) }
    function rule(left, middle, right,   i, line) {
      line = left
      for (i = 1; i <= columns_count; i++) {
        line = line sprintf("%" width[i] + 2 "s", "")
        line = line (i < columns_count ? middle : right)
      }
      gsub(/ /, "─", line)
      return border(line)
    }
    function bar(t,   cells, full, rest, j, out) {
      cells = t * bar_width
      full = int(cells)
      rest = int((cells - full) * 8)
      for (j = 1; j <= full; j++) out = out paint(heat(j / bar_width), "█")
      if (full < bar_width) {
        out = out (rest > 0 ? paint(heat((full + 1) / bar_width), partial[rest]) : " ")
        for (j = full + 2; j <= bar_width; j++) out = out " "
      }
      return out
    }
    function agents(text,   name, padded) {
      padded = pad(text, width[3])
      for (name in agent_rgb) gsub(name, paint("38;2;" agent_rgb[name], name), padded)
      return padded
    }
    function line(columns,   i, out) {
      out = border("│")
      for (i = 1; i <= columns_count; i++) out = out " " columns[i] " " border("│")
      print out
    }
    function title(text,   i, out, n) {
      n = length(text)
      for (i = 1; i <= n; i++) out = out paint("1;" heat((i - 1) / (n - 1)), substr(text, i, 1))
      return out
    }
    END {
      print ""
      print "  " title("AI CODING USAGE  -  " period)
      print rule("┌", "┬", "┐")
      for (i = 1; i <= columns_count; i++) columns[i] = paint("1", pad(header[i], width[i], i > 5))
      line(columns)
      print rule("├", "┼", "┤")
      for (r = 1; r < rows; r++) {
        t = max > 0 ? cost[r] / max : 0
        tone = heat(t)
        weekend = cell[r, 2] == "Sat" || cell[r, 2] == "Sun"
        columns[1] = paint(weekend ? "2;3" : "0", pad(cell[r, 1], width[1]))
        columns[2] = paint(weekend ? "2;3" : "0", pad(cell[r, 2], width[2]))
        columns[3] = agents(cell[r, 3])
        columns[4] = paint("38;2;166;173;200", pad(cell[r, 4], width[4]))
        columns[5] = bar(t)
        columns[6] = paint("38;2;205;214;244", pad(cell[r, 6], width[6], 1))
        columns[7] = paint("38;2;137;180;250", pad(cell[r, 7], width[7], 1))
        columns[8] = paint("2", pad(cell[r, 8], width[8], 1))
        columns[9] = paint("38;2;250;179;135", pad(cell[r, 9], width[9], 1))
        columns[10] = paint(tone, pad(cell[r, 10], width[10], 1))
        columns[11] = paint((cost[r] == max ? "1;" : "") tone, pad(cell[r, 11], width[11], 1))
        line(columns)
      }
      print rule("├", "┼", "┤")
      for (i = 1; i <= columns_count; i++) columns[i] = pad("", width[i])
      columns[1] = paint("1", pad(cell[rows, 1], width[1]))
      for (i = 6; i <= 10; i++) columns[i] = paint("1", pad(cell[rows, i], width[i], 1))
      columns[11] = paint("1;" heat(1), pad(cell[rows, 11], width[11], 1))
      line(columns)
      print rule("└", "┴", "┘")
      print ""
    }'
}
