---
name: do
description: Execute a phased implementation plan (such as a PLAN.md from /make-plan) phase by phase, verifying each phase before moving on. Use when the user runs /do or asks to execute or carry out a plan.
---

# Do plan

Adapted from thedotmack/claude-mem (plugin/skills/do).

You are an orchestrator. Find the plan (usually `PLAN.md` in the project root) and read it in full. Where subagents are available, have them do the work while you coordinate, pass context and check each one against its checklist. Without subagents, do each step yourself but keep the same checks.

## Rules

- Give each phase fresh subagents when context is large or unclear.
- Give each subagent one clear objective and require evidence: commands run, output, files changed.
- Don't move to the next step until the current one is reported done and you've confirmed it matches the plan.
- Track the phases in the task list so the user can see progress.

## During each phase

The implementation subagent must:
1. Do the work exactly as the plan specifies.
2. Copy patterns from the docs instead of inventing them.
3. Cite the doc source in a code comment when using an unfamiliar API.
4. Stop and verify if an API seems to be missing, rather than assuming it exists.

## After each phase

1. **Verify**: run the phase's verification checklist and show that it passed.
2. **Anti-pattern check**: grep for the bad patterns the plan lists.
3. **Quality review**: review the changed code.
4. **Commit only if verified**, and only when the project uses git and the user wants commits. Never push unless the user asked.

If verification fails, fix it or stop and report; never skip ahead.

## Failure modes to prevent

- Inventing APIs that "should" exist
- Adding undocumented parameters
- Skipping verification
- Committing before verification passes

When finished, tell the user in a few lines which phases are done, what was verified, and anything left open.
