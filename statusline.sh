#!/usr/bin/env bash
# Claude Code status line: model · context used / window size (fields documented in code.claude.com/docs/en/statusline)
in=$(cat)
model=$(jq -r '.model.display_name // "?"' <<<"$in")
used=$(jq -r '.context_window.total_input_tokens // empty' <<<"$in")
if [[ -z "$used" ]]; then echo "$model"; exit 0; fi
size=$(jq -r '.context_window.context_window_size // 200000' <<<"$in")
pct=$(jq -r --argjson u "$used" --argjson s "$size" '.context_window.used_percentage // ($u * 100 / $s) | floor' <<<"$in")
if   (( pct >= 75 )); then color='\033[31m'   # red: /clear or /compact soon
elif (( pct >= 50 )); then color='\033[33m'   # yellow
else color='\033[32m'; fi
printf "%s · ${color}ctx %dk/%dk\033[0m\n" "$model" $(( used / 1000 )) $(( size / 1000 ))
