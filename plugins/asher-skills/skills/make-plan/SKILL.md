---
name: make-plan
description: Create a detailed, phased implementation plan grounded in real docs and code before building anything. Use when the user runs /make-plan or asks to plan a feature, project or multi-step build, especially before running /do.
---

# Make plan

Adapted from thedotmack/claude-mem (plugin/skills/make-plan).

You are an orchestrator. Write a plan in phases that can each be executed in a fresh context. Save it as `PLAN.md` in the project root.

## Delegation

Use subagents for fact gathering: docs, examples, function signatures, grep results. Keep the synthesis and plan writing yourself. If a subagent report lacks evidence, check it with targeted reads before using it.

Each subagent report must include:
1. The sources consulted (files or URLs) and what was read
2. Concrete findings: exact API names, signatures and file paths
3. Where to find copy-ready snippets
4. A confidence note and known gaps

Reject and redo any report that gives conclusions without sources.

## Plan structure

### Phase 0: Documentation discovery (always first)

Before planning the build:
1. Find and read the relevant docs, examples and existing patterns.
2. Identify the APIs, methods and signatures that actually exist; don't assume.
3. Write a short "Allowed APIs" list citing the docs for each.
4. Note anti-patterns: methods that don't exist and deprecated parameters.

### Each implementation phase must include

1. **What to implement**, framed as copying from docs rather than transforming code. Good: "Copy the session pattern from docs/examples.ts:45-60". Bad: "Migrate the code to V2".
2. **Documentation references**, citing specific files and lines to follow.
3. **A verification checklist** proving the phase worked (tests, commands, grep checks).
4. **Anti-pattern guards** stating what not to do.

### Final phase: verification

1. Check that every implementation matches the docs.
2. Grep for the known bad patterns.
3. Run the tests.

## Principles

- Having docs available isn't the same as using them; require reading them.
- Point each task at docs, not just at an outcome.
- Verify instead of assuming.
- Each phase must be self-contained, with its own doc references, so it can run in a fresh context.

## Anti-patterns to prevent

- Inventing API methods that "should" exist
- Adding parameters the docs don't list
- Skipping verification
- Assuming a structure without checking examples

When done, tell the user in one line that `PLAN.md` is ready for `/do`.
