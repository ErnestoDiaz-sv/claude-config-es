#!/usr/bin/env bash
set -euo pipefail

unset CLAUDE_PROJECT_DIR CLAUDE_SKIP_VERIFY
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }
new_repo() {
  local dir="$tmp/$1"
  mkdir -p "$dir/scripts"
  git -C "$dir" init -q
  git -C "$dir" config user.name Test
  git -C "$dir" config user.email test-identity
  printf 'base\n' >"$dir/file.txt"
  git -C "$dir" add file.txt
  git -C "$dir" commit -qm base
  printf '#!/usr/bin/env bash\n%s\n' "$2" >"$dir/scripts/check.sh"
  chmod +x "$dir/scripts/check.sh"
  git -C "$dir" add scripts/check.sh
  git -C "$dir" commit -qm check
}
run_hook() { printf '{"cwd":"%s","stop_hook_active":%s}\n' "$1" "${2:-false}" | "$root/hooks/verify-on-stop.sh" >"$3/out" 2>"$3/err"; }
case_dir="$tmp/case"
mkdir -p "$case_dir"
new_repo absent 'exit 1'
rm "$tmp/absent/scripts/check.sh"
run_hook "$tmp/absent" false "$case_dir" || fail 'repo without check'
new_repo clean 'echo run >>"$COUNTER"; exit 1'
COUNTER="$tmp/count"; export COUNTER
run_hook "$tmp/clean" false "$case_dir" || fail 'clean tree'
printf 'doc\n' >"$tmp/clean/change.md"
run_hook "$tmp/clean" false "$case_dir" || fail 'markdown-only change'
new_repo pass 'echo run >>"$COUNTER"; exit 0'
printf 'change\n' >>"$tmp/pass/file.txt"
run_hook "$tmp/pass" false "$case_dir" || fail 'passing check'
stamp="$(git -C "$tmp/pass" rev-parse --absolute-git-dir)/claude-check-ok"
[[ -f "$stamp" ]] || fail 'stamp missing'
count_before="$(wc -l <"$COUNTER")"
run_hook "$tmp/pass" false "$case_dir" || fail 'cached passing check'
[[ "$(wc -l <"$COUNTER")" == "$count_before" ]] || fail 'check reran'
new_repo failure 'echo run >>"$COUNTER"; exit 1'
printf 'change\n' >>"$tmp/failure/file.txt"
if run_hook "$tmp/failure" false "$case_dir"; then fail 'failing check exit code'; else code=$?; [[ $code == 2 ]] || fail 'failing check exit code'; fi
[[ "$(<"$case_dir/err")" == *'scripts/check.sh failed'* ]] || fail 'failure message'
if run_hook "$tmp/failure" true "$case_dir"; then :; else fail 'retry handling'; fi
jq -e '.systemMessage' "$case_dir/out" >/dev/null || fail 'retry JSON'
CLAUDE_SKIP_VERIFY=1; export CLAUDE_SKIP_VERIFY
printf 'change\n' >>"$tmp/failure/file.txt"
run_hook "$tmp/failure" false "$case_dir" || fail 'skip verify'
printf 'PASS: stop hook behaviour\n'
