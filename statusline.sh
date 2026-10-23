#!/usr/bin/env bash
# Claude Code status line: model · context used (auto-compact threshold shown as 200k)
in=$(cat)
model=$(jq -r '.model.display_name // "?"' <<<"$in")
used=$(jq -r '.context_window.total_input_tokens // empty' <<<"$in")
if [[ -z "$used" ]]; then echo "$model"; exit 0; fi
k=$(( used / 1000 ))
if   (( k >= 150 )); then color='\033[31m'   # red: /clear or /compact soon
elif (( k >= 100 )); then color='\033[33m'   # yellow
else color='\033[32m'; fi
printf "%s · ${color}ctx %dk/200k\033[0m\n" "$model" "$k"
