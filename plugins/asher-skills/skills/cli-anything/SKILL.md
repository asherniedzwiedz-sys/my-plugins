---
name: "cli-anything"
description: "Drive desktop apps (draw.io, GIMP, Blender, LibreOffice, Inkscape, FreeCAD, Mermaid, Zotero, etc.) through HKUDS/CLI-Anything command-line harnesses. Use when the user runs /cli-anything or asks to do something in one of those apps."
---

# /cli-anything

Wrapper around github.com/HKUDS/CLI-Anything (Apache-2.0). Each supported app has an "agent harness": a Python CLI named `cli-anything-<app>` that controls the app from commands and supports `--json` output.

Usage: `/cli-anything <app> <what to do>`, e.g. `/cli-anything drawio make a block diagram of a buck converter`.

## 1. Get the repo

```bash
R="$HOME/repos/CLI-Anything"
[ -d "$R/.git" ] || GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://github.com/HKUDS/CLI-Anything "$R"
export PATH="$HOME/.local/bin:$PATH"
```

If cloning fails, call add_repo for HKUDS/CLI-Anything first.

## 2. Find the harness

Use the local registry, since the online CLI-Hub catalog (`cli-hub list/search`) is often blocked in the sandbox:

```bash
python3 -c "import json;[print(c['name'],'|',c['entry_point'],'|',c.get('requires'),'|',c['description'][:90]) for c in json.load(open('$R/registry.json'))]" | grep -i "<app>"
```

If no match turns up, run `ls $R` (each app has its own folder, `<app>/agent-harness`). If the app still isn't there, go to step 5.

## 3. Install it

```bash
SETUPTOOLS_USE_DISTUTILS=stdlib pip install -q --break-system-packages "$R/<app>/agent-harness"
cli-anything-<app> --help
```

The `SETUPTOOLS_USE_DISTUTILS=stdlib` prefix is required. Without it the build fails with `AttributeError: install_layout`.

Many harnesses also need the real app installed (check the `requires` field). Try `apt-get install -y <app>` or pip. If the network blocks it, tell the user plainly and suggest running it on their own PC instead: `pip install git+https://github.com/HKUDS/CLI-Anything.git#subdirectory=<app>/agent-harness`.

## 4. Use it

- Read `$R/skills/cli-anything-<app>/SKILL.md` (or the harness's README) for that app's commands before running anything.
- Pass `--json` on every call and parse the output. Typical flow: `project new` → edit commands → `export`.
- Save outputs under the working directory and send the final file to the user with SendUserFile. When the result is visual, render it (PNG/SVG/PDF) and check it with Read before sending.

## 5. Build a harness for a new app (only if asked)

This requires the app's source code (a repo URL or path); an app name alone isn't enough. Read `$R/cli-anything-plugin/HARNESS.md` in full and follow `$R/cli-anything-plugin/commands/cli-anything.md` phase by phase. This is a big job, so confirm with the user before starting.

## Keep it brief

Reply with the result file plus one line saying what was made. If something can't run here, say what's missing in one line.