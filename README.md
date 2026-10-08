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
| `asher-skills` | My skills: `/apply` (full resume + cover letter pass for a job posting; uses resume-skills), `/clean`, `/humanizer`, `/cli-anything`, `/anydoc`, `/handoff`, `/make-plan`, `/do` |
| `agent-skills` | addyosmani/agent-skills: spec, plan, build, test, review, ship |
| `resume-skills` | paramchoudhary/resumeskills: resume, cover letter, LinkedIn, interview and offer skills |
| `claude-code-setup` | Anthropic's project setup recommender (installed from Anthropic's official marketplace) |
| `claude-mem` | thedotmack/claude-mem: automatic memory across sessions (installed from its own marketplace) |
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
