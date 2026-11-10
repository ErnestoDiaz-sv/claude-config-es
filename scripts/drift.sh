#!/usr/bin/env bash
set -euo pipefail

usage() { printf 'Usage: %s [--diff|-h|--help]\n' "$0"; }
show_diff=0
case "${1:-}" in
  '') ;;
  --diff) show_diff=1 ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac
[[ $# -le 1 ]] || { usage >&2; exit 2; }

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
destination="${CLAUDE_HOME:-$HOME/.claude}"
missing=0
different=0
identical=0
while IFS= read -r relative; do
  if [[ ! -f "$destination/$relative" ]]; then
    printf 'MISSING: %s\n' "$relative"
    ((missing+=1))
  elif cmp -s "$root/$relative" "$destination/$relative"; then
    ((identical+=1))
  else
    printf 'DIFFERENT: %s\n' "$relative"
    ((different+=1))
    if ((show_diff)); then diff -u "$destination/$relative" "$root/$relative" || true; fi
  fi
done < <("$root/scripts/list-files.sh")
printf 'drift: %d different, %d missing, %d identical\n' "$different" "$missing" "$identical"
((different == 0 && missing == 0))
