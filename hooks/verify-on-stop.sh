#!/usr/bin/env bash
# Global Claude Code Stop hook: before Claude is allowed to stop, run the
# project's scripts/check.sh -- but only if the repo has one (opt-in), there
# are uncommitted non-Markdown changes, and those exact changes haven't
# already passed. Exit 2 + stderr sends the failure back to Claude.
# Skip for one run with CLAUDE_SKIP_VERIFY=1.
set -uo pipefail

input="$(cat)"
[[ "${CLAUDE_SKIP_VERIFY:-}" == "1" ]] && exit 0

dir="${CLAUDE_PROJECT_DIR:-$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)}"
[[ -n "$dir" ]] && cd "$dir" 2>/dev/null || exit 0
root="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
cd "$root" || exit 0
[[ -x scripts/check.sh ]] || exit 0
git rev-parse --verify -q HEAD >/dev/null || exit 0

already_retried="$(jq -r '.stop_hook_active // false' <<<"$input" 2>/dev/null || echo false)"

# Fingerprint of every uncommitted change except docs (tracked diff + untracked files).
fingerprint="$(
  {
    git diff HEAD -- . ':!*.md'
    git ls-files --others --exclude-standard -z -- . ':!*.md' | xargs -0 -r cat
  } | sha256sum | cut -d' ' -f1
)"
empty="$(printf '' | sha256sum | cut -d' ' -f1)"
[[ "$fingerprint" == "$empty" ]] && exit 0

stamp="$(git rev-parse --git-dir)/claude-check-ok"
[[ -f "$stamp" && "$(cat "$stamp")" == "$fingerprint" ]] && exit 0

if output="$(scripts/check.sh 2>&1)"; then
  echo "$fingerprint" >"$stamp"
  exit 0
fi

if [[ "$already_retried" == "true" ]]; then
  # Already pushed back once; let Claude stop rather than loop forever.
  jq -n '{systemMessage: "scripts/check.sh is still failing -- not done yet."}'
  exit 0
fi

{
  echo "scripts/check.sh failed. Fix it before finishing:"
  tail -n 40 <<<"$output"
} >&2
exit 2
