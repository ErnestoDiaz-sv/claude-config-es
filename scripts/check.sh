#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_dir"
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

while IFS= read -r -d '' file; do
  bash -n "$file" || fail "bash syntax: $file"
  if command -v shellcheck >/dev/null 2>&1; then
    shellcheck "$file" || fail "shellcheck: $file"
  fi
done < <(find . -type f -name '*.sh' -not -path './.git/*' -print0)
if ! command -v shellcheck >/dev/null 2>&1; then
  printf 'SKIP shellcheck (not installed)\n'
fi

while IFS= read -r -d '' file; do
  jq empty "$file" || fail "invalid JSON: $file"
done < <(find . -type f -name '*.json' -not -path './.git/*' -print0)

python3 - <<'PY'
from pathlib import Path
import re
import subprocess
import sys

root = Path.cwd()
errors = []
for skill in sorted((root / "skills").glob("*/SKILL.md")):
    text = skill.read_text()
    match = re.match(r"\A---\n(.*?)\n---\n", text, re.S)
    fields = dict(re.findall(r"^(name|description):\s*(.*?)\s*$", match.group(1), re.M)) if match else {}
    if fields.get("name") != skill.parent.name or not fields.get("description", "").strip():
        errors.append(f"invalid skill frontmatter: {skill.relative_to(root)}")
for agent in sorted((root / "agents").glob("*.md")):
    text = agent.read_text()
    match = re.match(r"\A---\n(.*?)\n---\n", text, re.S)
    fields = dict(re.findall(r"^(name|description):\s*(.*?)\s*$", match.group(1), re.M)) if match else {}
    if not fields.get("name", "").strip() or not fields.get("description", "").strip():
        errors.append(f"invalid agent frontmatter: {agent.relative_to(root)}")

tracked = subprocess.run(
    ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
    check=True,
    capture_output=True,
).stdout.split(b"\0")
tracked_paths = [root / item.decode() for item in tracked if item]
secret_patterns = [
    re.compile(r"/(?:home|Users)/[^/\s]+"),
    re.compile(r"(?<![\w.+-])[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}"),
    re.compile(r"(?:sk-|ghp_|AKIA)[A-Za-z0-9_-]{8,}"),
    re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    re.compile(r"[\"'](?:api_key|token|password)[\"']\s*[:=]\s*[\"'][^\"']+[\"']", re.I),
]
for path in tracked_paths:
    if not path.is_file() or path.suffix in {".png", ".jpg", ".gif", ".pdf"}:
        continue
    text = path.read_text(errors="replace")
    for pattern in secret_patterns:
        for match in pattern.finditer(text):
            value = match.group(0)
            if "@" in value and (value.startswith("noreply@") or value.endswith("example.com")):
                continue
            errors.append(f"possible sensitive value in {path.relative_to(root)}")
            break

link_pattern = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
for markdown in root.rglob("*.md"):
    if ".git" in markdown.parts:
        continue
    for target in link_pattern.findall(markdown.read_text()):
        target = target.split(" ", 1)[0].strip("<>")
        if not target or re.match(r"(?:[a-z]+:|#)", target, re.I):
            continue
        destination = (markdown.parent / target.split("#", 1)[0]).resolve()
        if not destination.exists():
            errors.append(f"broken Markdown link: {markdown.relative_to(root)} -> {target}")
if errors:
    print("\n".join(f"FAIL: {error}" for error in errors), file=sys.stderr)
    sys.exit(1)
print("PASS: frontmatter, leak scan, and Markdown links")
PY

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
home="$tmp/claude-home"
CLAUDE_HOME="$home" ./install.sh --dry-run >/dev/null
[[ ! -e "$home" ]] || fail "dry-run created the test destination"
CLAUDE_HOME="$home" ./install.sh >/dev/null
mapfile -t expected < <(./scripts/list-files.sh)
[[ ${#expected[@]} -gt 0 ]] || fail "installer file list is empty"
for relative in "${expected[@]}"; do
  [[ -f "$home/$relative" ]] || fail "installer omitted $relative"
  cmp -s "$relative" "$home/$relative" || fail "installed content differs: $relative"
done
actual="$(cd "$home" && find . -type f -print | sort)"
expected_paths="$(printf '%s\n' "${expected[@]}" | sort)"
actual_paths="$(printf '%s\n' "$actual" | sed 's#^./##')"
[[ "$actual_paths" == "$expected_paths" ]] || fail "installer created an unexpected file set"
before="$(find "$home" -type f -print0 | sort -z | xargs -0 sha256sum)"
CLAUDE_HOME="$home" ./install.sh >/dev/null
after="$(find "$home" -type f -print0 | sort -z | xargs -0 sha256sum)"
[[ "$before" == "$after" ]] || fail "second install changed files"
modified="${expected[0]}"
printf '\nlocal modification\n' >>"$home/$modified"
output="$(CLAUDE_HOME="$home" ./uninstall.sh)"
[[ "$output" == *"KEPT (modified): $home/$modified"* ]] || fail "uninstall did not report modified file"
[[ -f "$home/$modified" ]] || fail "uninstall removed modified file"
for relative in "${expected[@]:1}"; do
  [[ ! -e "$home/$relative" ]] || fail "uninstall left byte-identical file: $relative"
done

dry_home="$tmp/dry-home"
CLAUDE_HOME="$dry_home" ./install.sh >/dev/null
dry_output="$(CLAUDE_HOME="$dry_home" ./uninstall.sh --dry-run)"
[[ "$dry_output" == *"WOULD REMOVE:"* ]] || fail "uninstall dry-run did not preview removals"
for relative in "${expected[@]}"; do
  [[ -f "$dry_home/$relative" ]] || fail "uninstall dry-run removed $relative"
done
printf 'PASS: installer and uninstaller integration\n'
