# Engineering quality bar

Apply this short, checkable standard to every code project. `quality-audit.sh` checks the mechanical criteria; manual checks remain the project's responsibility.

| ID | Rule | Why | How to check | Level |
|---|---|---|---|---|
| Q1 | Provide an executable `scripts/check.sh` that runs lint and tests and exits non-zero on failure. | One command makes verification repeatable. | `test -x scripts/check.sh` (inspect that it runs lint and tests) | all |
| Q2 | Keep automated tests for the project's important behavior. | Tests catch regressions consistently. | `test -d tests` or `test -d test` | all |
| Q3 | Commit a dependency lockfile or pin requirements. | Reproducible dependencies reduce environment drift. | `git ls-files` (inspect lockfiles / pinned requirements) | all |
| Q4 | Track no `.env*` files except `.env.example`, and ignore `.env`. | Secrets must not enter git history. | `git ls-files` and `git check-ignore -q .env` | all |
| Q5 | README explains what the project is, how to run and test it, and how to deploy it when deployed. | Contributors need a usable starting point. | `manual` | all |
| Q6 | Include `AGENTS.md` or `CLAUDE.md` with project-specific agent rules. | Agents need local conventions and constraints. | `test -f AGENTS.md -o -f CLAUDE.md` | all |
| Q7 | Configure a git remote and have no commits ahead of the upstream. | Shared work must be reachable and pushed. | `git remote -v` and `git rev-list @{upstream}..HEAD` | all |
| Q8 | Configure an actual linter or formatter. | Consistent style is easier to review and maintain. | `quality-audit.sh` checks Ruff/Black, ESLint, Prettier, Biome, or a `lint` package script | all |
| Q9 | For deployed projects, document a health check, log location and rollback note. | Operators need to diagnose and recover production safely. | `manual` | deployed |
