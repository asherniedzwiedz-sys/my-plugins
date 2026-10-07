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

# This repo: my own skills + agent-skills
claude plugin marketplace add asherniedzwiedz-sys/my-plugins
claude plugin install asher-skills@asher-plugins
claude plugin install agent-skills@asher-plugins

# Anthropic's official plugins
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install claude-code-setup@claude-plugins-official

# claude-mem needs its own marketplace (it runs a background service)
claude plugin marketplace add thedotmack/claude-mem
claude plugin install claude-mem@thedotmack

# find-skills (needs Node)
if (Get-Command npx -ErrorAction SilentlyContinue) {
    npx skills add vercel-labs/skills --skill find-skills -g -y
} else {
    Write-Host "Skipped find-skills: install Node first (winget install OpenJS.NodeJS.LTS), then rerun."
}

Write-Host "All set. Restart Claude Code."
