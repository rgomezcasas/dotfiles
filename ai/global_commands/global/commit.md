---
name: commit
description: Create a git commit following Conventional Commits specification
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(git rev-parse:*), Bash(git branch:*), Bash(git stash:*), Bash(git rm:*)
disable-model-invocation: true
model: haiku
---

## Context

- Current git status: !`git status`
- Staged changes: !`git diff --cached`
- Unstaged changes: !`git diff`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`
- Repository root path: !`git rev-parse --show-toplevel`

## Conventional Commits

We use [Conventional Commits](https://www.conventionalcommits.org/) specification for all commit messages.

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

| Type       | Description                                                                       |
|------------|-----------------------------------------------------------------------------------|
| `feat`     | A new feature                                                                     |
| `fix`      | A bug fix                                                                         |
| `docs`     | Documentation only changes                                                        |
| `style`    | Changes that do not affect the meaning of the code (white-space, formatting, etc) |
| `refactor` | A code change that neither fixes a bug nor adds a feature                         |
| `perf`     | A code change that improves performance                                           |
| `test`     | Adding missing tests or correcting existing tests                                 |
| `build`    | Changes that affect the build system or external dependencies                     |
| `ci`       | Changes to CI configuration files and scripts                                     |
| `chore`    | Other changes that don't modify src or test files                                 |
| `revert`   | Reverts a previous commit                                                         |

### Rules

1. The description MUST be in lowercase and start with a verb in imperative mood (add, fix, change, etc.)
2. The description MUST NOT end with a period
3. Use scope to provide additional context (e.g., `feat(auth): add login endpoint`)
4. Breaking changes MUST be indicated by `!` after type/scope or `BREAKING CHANGE:` in footer
5. Keep the first line under 72 characters

### Examples

```
feat(api): add user authentication endpoint
fix(ui): resolve button alignment issue on mobile
docs: update installation instructions
refactor!: drop support for Node 14
chore(deps): update dependencies
```

## Task

Based on the changes shown above:

1. Stage relevant files if needed (ask first if there are unstaged changes)
2. Analyze the changes to determine the appropriate commit type and scope
3. Create a commit message following the Conventional Commits specification
4. Execute the commit

## Course Repository Scope Convention

This section ONLY applies when the last segment of the repository root path (shown above) ends in `-course`.

When in a course repository, the commit scope MUST always reflect the course module and lesson numbers derived from the folder path.

### Scope Format

The folder structure follows the pattern `<module>-<topic>/<lesson>-<name>`. Extract the module and lesson numbers to build the scope as `<module>-<lesson>`.

### Examples

| Changed folder         | Scope    | Full commit example                       |
|------------------------|----------|-------------------------------------------|
| `01-agents/2-init`     | `01-2`   | `feat(01-2): add agent initialization`    |
| `02-tools/3-search`    | `02-3`   | `fix(02-3): resolve search query parsing` |
| `03-prompts/1-basics`  | `03-1`   | `refactor(03-1): simplify prompt builder` |

### Rules

1. The scope MUST always include the module and lesson numbers — never omit them
2. If changes span multiple folders, use the most relevant one or split into separate commits
