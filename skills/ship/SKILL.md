---
name: ship
description: Verify, commit, push, and (if applicable) open/merge a PR and update handoff docs — adapting to each project's actual conventions instead of assuming a fixed flow.
---

# /ship

This skill runs the "I'm done, ship it" sequence. It does **not** assume every
project works the same way — detect each repo's real conventions first, then
act. Never invent a convention the repo doesn't already have.

## 1. Verify

- Detect and run the test suite (`package.json` scripts, `pytest`, `cargo test`,
  `go test`, etc.). If none exists, say so and skip — don't invent one.
- Detect and run the build (`npm run build`, `make`, etc.) if the project has one.
- Abort here and report if tests or build fail — do not continue to commit.
- For UI changes, if there's a running dev server or preview URL, verify
  visually in a browser before proceeding.
- Before pushing, run `quality-audit.sh <repo>` and report any FAILs to the user;
  this report does not block the push.

## 2. Detect the git workflow — do not assume

Before touching git, check:

- `git remote -v` — is there a remote at all? If not, this is local-only:
  commit and stop there.
- `git branch --show-current` and `git log --oneline -20` — does history show
  direct commits to the default branch, or does it always go through PRs?
  Look for merge commits / squash-merge patterns as a signal.
- Check recent merged PRs if the hosting service is available, to confirm
  whether PRs are actually used here.
- Is the current branch the default branch? If this repo's convention is
  PR-based and you're on the default branch, create a feature branch before
  committing — don't commit straight to default.

Branch-protection or PR-required repos get a PR. Repos with a history of
direct pushes to default get a direct push. When it's ambiguous, ask the user
once rather than guessing.

## 3. Commit and push

- Stage the relevant changes (don't blindly `git add -A` if the repo has
  unrelated dirty files).
- Write a conventional-commit-style message describing what changed.
- Push to the appropriate branch/remote as determined in step 2.

## 4. PR + merge (only if step 2 found a PR-based convention)

- Open the PR using the hosting service's supported tooling.
- Wait for CI checks if the repo has them configured.
- Merging a PR is outward-facing and hard to reverse — confirm with the user
  before merging, even on green checks, unless they've already told you to
  merge on green for this session/repo.

## 5. Handoff docs (only if the repo already has the convention)

- Look for an existing handoff/changelog convention: `HANDOFF.md`,
  `CHANGELOG.md`, a `docs/` entry, etc.
- If one exists, append a dated entry: what changed, what was verified, what's
  still pending.
- If none exists, don't create one — that's a new convention, not an existing
  one. Mention to the user that no such file was found, in case they want one.

## Notes

- This skill is intentionally a checklist of *detections*, not fixed shell
  commands — the specifics (test runner, build command, PR vs. direct push,
  handoff file name) come from what step 2 and the repo actually show.
- If detection is inconclusive on any step, ask rather than guessing —
  wrong guesses here (force-pushing, merging, committing to the wrong branch)
  are expensive to undo.
