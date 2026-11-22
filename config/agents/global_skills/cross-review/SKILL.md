---
name: cross-review
description: Cross-agent code review. Delegates the review of the current changes to the other coding agent (Claude Code hands it to Codex, Codex hands it to Claude Code), reusing the project's own review skill and review.md guidelines when they exist, and iterates review and fix rounds until only low severity findings remain (3 rounds max by default). Use when the user asks to review their changes, the current branch, or a second opinion from the other agent.
---

# Cross-agent review

Delegate the review to the other agent with the bundled script, fix what it finds and ask for another review, up to 3 rounds.

If the environment variable `CROSS_REVIEW_DELEGATED` is `1`, you are already the delegated reviewer: do not run the script or any of the steps below, just do the review you were asked for.

## Running the reviewer

```bash
~/.agents/skills/cross-review/scripts/delegate-review [--from claude|codex] [extra instructions...]
```

- The script detects the current agent (`CLAUDECODE=1` means Claude Code, anything else means Codex). Pass `--from` explicitly if you know the detection would be wrong.
- Run it from the directory where the user invoked the skill.
- Each review takes several minutes: use a long timeout (10 minutes) or run it in the background and wait for it.
- The delegated agent needs network access to reach its API. If a sandbox blocks it, rerun outside the sandbox.
- The output starts with the project review skill and `review.md` it used, then the review. Every finding is tagged `[high]`, `[medium]` or `[low]`, and the last line is `MAX_SEVERITY: high|medium|low|none`.

## Review loop

The maximum is 3 rounds unless the user asks for a different number. For each round:

1. Run the reviewer. In round 1 pass anything the user added to the request (scope, base branch, focus areas) as extra instructions. From round 2 on, also pass the round number, a short list of the findings you fixed and the findings you deliberately did not fix with the reason, so the reviewer checks the fixes and does not repeat dismissed findings.
2. Apply the fixes for the `[high]` and `[medium]` findings you agree with. Apply `[low]` findings only when they are cheap and clearly right. If you disagree with a finding, do not apply it and note why.
3. Decide whether to continue:
   - `MAX_SEVERITY` is `low` or `none`: stop, the review has converged.
   - It is `high` or `medium` and this was not the last round: start the next round.
   - It was the last round: stop. The fixes from this round were not reviewed again.

Do not commit between rounds.

## Final report

Tell the user, per round, what the reviewer found (with severities and file:line references), what you fixed and what you dismissed and why. Say why the loop stopped (converged or round limit reached) and list any `[high]` or `[medium]` finding still open or fixed without a follow-up review.
