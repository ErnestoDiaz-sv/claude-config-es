#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s [--dry-run] [--only skills|agents|hooks|all]\n' "$0"
}

dry_run=false
only=all
while (($#)); do
  case "$1" in
    --dry-run) dry_run=true ;;
    --only)
      shift
      (($#)) || { usage >&2; exit 2; }
      only=$1
      ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
  shift
done

case "$only" in
  skills|agents|hooks|all) ;;
  *) usage >&2; exit 2 ;;
esac

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
claude_home="${CLAUDE_HOME:-$HOME/.claude}"
mapfile -t files < <("$repo_dir/scripts/list-files.sh" "$only")
did_action=false

for relative_path in "${files[@]}"; do
  source_path="$repo_dir/$relative_path"
  target_path="$claude_home/$relative_path"
  if [[ -e "$target_path" || -L "$target_path" ]]; then
    printf 'SKIP (exists): %s\n' "$target_path"
  elif [[ "$dry_run" == true ]]; then
    printf 'WOULD COPY: %s -> %s\n' "$source_path" "$target_path"
    did_action=true
  else
    mkdir -p "$(dirname -- "$target_path")"
    cp -- "$source_path" "$target_path"
    case "$relative_path" in
      *.sh) chmod +x "$target_path" ;;
    esac
    printf 'COPY: %s -> %s\n' "$source_path" "$target_path"
    did_action=true
  fi
done

if [[ "$did_action" == true ]]; then
  printf 'Merge settings.example.json into %s/settings.json by hand if desired.\n' "$claude_home"
fi
