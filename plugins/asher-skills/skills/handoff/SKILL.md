---
name: handoff
description: Write a HANDOFF.md capturing goal, current state, files touched, failed attempts and next steps so a fresh Claude session can pick up where this one left off. Use when the user runs /handoff, a session is getting long, or Claude keeps retrying the same broken fix.
---

# Handoff

Adapted from thedotmack/claude-mem (plugin/skills/handoff).

Write a structured `HANDOFF.md` that gives a fresh Claude session everything it needs to continue this work, without dragging the current degraded context forward.

## When to use

- The session is long and Claude feels confused or repetitive
- Claude keeps trying the same failing solution
- The user wants to step away and resume later, or move the work to another session
- The user says "handoff", "write a handoff" or "I want to start fresh"

## What to capture

Think through the full arc of the conversation before writing. The handoff must work for a Claude that has never seen this conversation.

1. **Goal**: one paragraph on what the user is actually trying to accomplish. State the end state, not the current sub-task.
2. **Current state**: what works, what's broken, and the exact symptom. Quote error messages verbatim.
3. **Files in play**: every relevant file read, edited or created, with a one-line note on why it matters. Use full paths.
4. **What has been tried, and why it failed**: the most important section. List every approach that didn't work and the root cause, not just "it didn't work".
5. **Current best theory**: what you believe the right path is, even if it's unproven, plus the evidence for it.
6. **Next steps**: concrete, ordered actions with file paths, function names and commands, so step 1 can start immediately.
7. **Key constraints**: environment details, the user's stated preferences, things the user said not to do, and dependencies.

## Writing rules

- Write for the incoming Claude, not for the user.
- Be ruthlessly specific. "Fix the auth" is useless; "in `src/auth/middleware.ts:47` the expiry check uses `Date.now()`, change it to `req.timestamp`" is useful.
- Include exact errors, stack traces or test output.
- No padding: every sentence must carry information the next agent needs.

## Output

Write `HANDOFF.md` in the project root (or the working directory) using this structure:

```markdown
# Handoff

> Generated: [timestamp]
> Project: [name or directory]
> Session summary: [one sentence]

## Goal

## Current state
**Working:**
- ...
**Broken:**
- ...

## Files in play
| File | Why it matters |
|------|----------------|

## What has been tried (and why it failed)
### Attempt 1: [name]
- What:
- Why it failed:

## Current best theory

## Next steps
1. ...

## Key constraints
- ...
```

## After writing

Tell the user, briefly: run `/clear` or start a new session, then say "Read HANDOFF.md and continue from where we left off." Note that it's a scratch file and shouldn't be committed. Keep the message short.
