---
name: global-clean-pr-commits
description: Reorganize all branch commits into clean, logical groups following Conventional Commits
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(git rev-parse:*), Bash(git branch:*), Bash(git stash:*), Bash(git rm:*), Bash(git reset:*), Bash(git merge-base:*)
disable-model-invocation: true
---

## Context

- Current git status: !`git status`
- Current branch: !`git branch --show-current`
- Upstream tracking: !`git rev-parse --abbrev-ref HEAD@{upstream} 2>/dev/null`
- Merge base with main: !`git merge-base HEAD main`
- Commits on this branch (run manually): `git log --oneline <merge-base>..HEAD`
- Full diff from base (run manually): `git diff <merge-base>..HEAD`
- Repository root path: !`git rev-parse --show-toplevel`

## Conventional Commits

We use [Conventional Commits](https://www.conventionalcommits.org/) specification for all commit messages.

## Task

Reorganize all commits on the current branch into clean, logical commits.

### Steps

1. **Analyze** the full diff and existing commits to understand all changes
2. **Propose** a list of final commits grouping changes logically — present this to the user as a numbered list with the commit message and which files/changes each commit includes
3. **Wait for approval** — the user may request changes to the grouping, do NOT proceed until they confirm
4. **Execute** once approved:
   a. `git reset --soft $(git merge-base HEAD <base-branch>)` to undo all commits while keeping changes staged
   b. `git reset HEAD .` to unstage everything
   c. For each proposed commit: stage the relevant files with `git add` and create the commit
   d. Run `git log --oneline $(git merge-base HEAD <base-branch>)..HEAD` to show the final result

### Important

- NEVER force push — that is the user's responsibility
- If there are uncommitted changes at the start, abort and tell the user to commit or stash first
- Preserve ALL changes — no code should be lost in the process
- If a file has changes that belong to different commits, use `git add -p` or stage specific hunks
