# Installs all of Asher's Claude Code plugins on this computer.
# Run in PowerShell:  irm https://raw.githubusercontent.com/asherniedzwiedz-sys/my-plugins/main/install.ps1 | iex

# Claude Code installs to <user folder>\.local\bin, which isn't always on PATH.
# Some apps change HOME/USERPROFILE, so check the real user folder too.
$candidates = @(
    (Join-Path "$env:SystemDrive\Users\$env:USERNAME" ".local\bin"),
    (Join-Path $env:USERPROFILE ".local\bin"),
    (Join-Path $HOME ".local\bin")
)
if ($env:HOME) { $candidates += (Join-Path $env:HOME ".local\bin") }
$candidates = $candidates | Select-Object -Unique
foreach ($claudeBin in $candidates) {
    if (-not (Get-Command claude -ErrorAction SilentlyContinue) -and (Test-Path (Join-Path $claudeBin "claude.exe"))) {
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$claudeBin*") {
            [Environment]::SetEnvironmentVariable("Path", "$userPath;$claudeBin", "User")
            Write-Host "Added $claudeBin to your PATH."
        }
        $env:Path = "$env:Path;$claudeBin"
    }
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "Claude Code not found. Installing it..."
    irm https://claude.ai/install.ps1 | iex
    Write-Host "Done. Close PowerShell, open a new window and run this script again."
    return
}

# Plugins are downloaded with git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Installing it..."
    winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements
    Write-Host "Done. Close PowerShell, open a new window and run this script again."
    return
}

# This repo: my own skills + agent-skills
claude plugin marketplace add asherniedzwiedz-sys/my-plugins
claude plugin install asher-skills@asher-plugins
claude plugin install agent-skills@asher-plugins
claude plugin install resume-skills@asher-plugins
claude plugin install ponytail@asher-plugins
claude plugin install founder-skill@asher-plugins

# Anthropic's official plugins
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install claude-code-setup@claude-plugins-official
claude plugin install superpowers@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install context7@claude-plugins-official
claude plugin install security-guidance@claude-plugins-official
claude plugin install claude-md-management@claude-plugins-official

# claude-mem needs its own marketplace (it runs a background service)
claude plugin marketplace add thedotmack/claude-mem
claude plugin install claude-mem@thedotmack

# REA: reverse-engineering tools (MCP server + skill), needs Node 22.19+
if (Get-Command npx -ErrorAction SilentlyContinue) {
    npx -y rea-agents@latest setup --client claude_code --yes
}

# find-skills (needs Node)
if (Get-Command npx -ErrorAction SilentlyContinue) {
    npx skills add vercel-labs/skills --skill find-skills -g -y
} else {
    Write-Host "Skipped find-skills: install Node first (winget install OpenJS.NodeJS.LTS), then rerun."
}

# Python tools (markitdown, graphify) are installed with uv
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "uv not found. Installing it for markitdown and graphify..."
    winget install --id astral-sh.uv -e --source winget --accept-source-agreements --accept-package-agreements
    Write-Host "Everything else is installed. Close PowerShell, open a new window and run this script once more to add markitdown and graphify."
    return
}
uv tool install --upgrade "markitdown[all]"
uv tool install --upgrade graphifyy
graphify install --platform windows

Write-Host "All set. Restart Claude Code."
