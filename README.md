# my-plugins

My master list of Claude Code plugins.

## Set up a new computer

In PowerShell:

```powershell
irm https://raw.githubusercontent.com/asherniedzwiedz-sys/my-plugins/main/install.ps1 | iex
```

If it installs Claude Code first, open a new PowerShell window and run it again. Then restart Claude Code.

## What's included

| Plugin | What it does |
|---|---|
| `asher-skills` | My skills: `/apply` (full resume + cover letter pass for a job posting; uses resume-skills), `/quick-apply` (same without the cover letter), `/clean`, `/humanizer`, `/prompt-master` (from nidhinjs/prompt-master), `/cli-anything`, `/anydoc`, `/handoff`, `/make-plan`, `/do` |
| `agent-skills` | addyosmani/agent-skills: spec, plan, build, test, review, ship |
| `resume-skills` | paramchoudhary/resumeskills: resume, cover letter, LinkedIn, interview and offer skills |
| `ponytail` | DietrichGebert/ponytail: always-on "simplest code that works" mode, plus /ponytail-review and /ponytail-audit (say "stop ponytail" to turn it off) |
| `founder-skill` | Jakeschincariol/founder-skill: test a business idea before launch (board, competitors, consumer panel, pricing, CFO, marketing, launch plan) |
| Anthropic official | From `claude-plugins-official`: `claude-code-setup` (setup recommender), `superpowers` (brainstorm, plan, TDD workflow), `feature-dev` (guided feature building), `commit-commands` (commit/push/PR), `context7` (up-to-date library docs), `security-guidance` (security checks on edits), `claude-md-management` (keeps CLAUDE.md files current) |
| `claude-mem` | thedotmack/claude-mem: automatic memory across sessions (installed from its own marketplace) |
| `rea` | Morluto/rea: reverse-engineer apps, binaries and websites (MCP server + skill, set up by install.ps1; native binaries on Windows need Ghidra) |
| `markitdown` | microsoft/markitdown: files and URLs to Markdown (CLI via uv; `/anydoc` uses it as a fallback) |
| `graphify` | Graphify-Labs/graphify: `/graphify .` maps a project into a clickable knowledge graph (CLI via uv + skill) |
| `find-skills` | vercel-labs/skills: finds and installs skills on request |

## Add a plugin later

- Another GitHub plugin: add an entry to `.claude-plugin/marketplace.json`, e.g.
  `{ "name": "x", "source": { "source": "url", "url": "https://github.com/owner/repo.git" } }`
  (use the https `url` form: the `github` form tries SSH first, which fails on PCs without SSH keys)
- A new skill of my own: add a folder with a `SKILL.md` under `plugins/asher-skills/skills/`, and bump `version` in `plugins/asher-skills/.claude-plugin/plugin.json`.

Then on each computer: `claude plugin marketplace update asher-plugins` and install or update the plugin.

## Notes

- Plugins only load on my own computers (terminal and local desktop sessions), not in cloud sessions.
- `/clean` needs Python and git on the computer.
