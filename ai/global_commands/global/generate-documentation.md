---
name: generate-documentation
description: Generate documentation based on the current conversation
allowed-tools: Bash(ls:*), Bash(tree:*), Bash(fd:*), Read, Write, Edit, Glob, Grep
model: haiku
---

## Context

- Project root: !`git rev-parse --show-toplevel`
- Existing docs structure: !`tree -d --noreport docs/ 2>/dev/null || echo "No docs/ directory found"`
- Existing doc files: !`fd -e md . docs/ 2>/dev/null || echo "No documentation files found"`

## Guidelines

1. Write documentation in English
2. Place the file inside the `docs/` folder. If subfolders exist, choose the most relevant one. Create a new subfolder only if no existing one fits
3. Use a descriptive kebab-case filename that clearly communicates the content (e.g., `nix-flake-structure.md`, `karabiner-custom-shortcuts.md`)
4. Structure the document with a clear title (`#`), an introductory paragraph, and organized sections (`##`, `###`)
5. Prefer practical examples and concrete commands over abstract explanations
6. Keep it concise: document the "what" and "how", skip obvious details

## Task

Based on the current conversation:

1. Identify the key topic or knowledge worth documenting
2. Explore the existing `docs/` structure to find the best location
3. Write the documentation file following the guidelines above
4. Check `AGENTS.md` — if the new doc belongs to an existing referenced folder, no update needed. If it creates a new `docs/` subfolder, add a reference line in the Documentation section of `AGENTS.md`
5. Confirm the file path and a brief summary of what was documented
