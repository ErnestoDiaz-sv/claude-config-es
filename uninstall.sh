#!/usr/bin/env bash
set -euo pipefail

usage() { printf 'Usage: %s [--dry-run]\n' "$0"; }
dry_run=false
while (($#)); do
  case "$1" in
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
  shift
done

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
claude_home="${CLAUDE_HOME:-$HOME/.claude}"
while IFS= read -r relative_path; do
  source_path="$repo_dir/$relative_path"
  target_path="$claude_home/$relative_path"
  [[ -e "$target_path" || -L "$target_path" ]] || continue
  if cmp -s "$source_path" "$target_path"; then
    if [[ "$dry_run" == true ]]; then
      printf 'WOULD REMOVE: %s\n' "$target_path"
    else
      rm -- "$target_path"
      printf 'REMOVED: %s\n' "$target_path"
    fi
  else
    printf 'KEPT (modified): %s\n' "$target_path"
  fi
done < <("$repo_dir/scripts/list-files.sh")
