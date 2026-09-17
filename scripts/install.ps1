# Install project-interview-coach (Windows PowerShell)
# ASCII-only script body to avoid Windows encoding parse errors.
#
#   .\scripts\install.ps1
#   .\scripts\install.ps1 -Mode current -Product cursor
#   .\scripts\install.ps1 -Mode npx
#   .\scripts\install.ps1 -Mode fallback

param(
  [ValidateSet("auto", "current", "npx", "fallback")]
  [string]$Mode = "auto",
  [ValidateSet("cursor", "codex", "claude", "copilot", "windsurf", "agents", "auto")]
  [string]$Product = "auto",
  [string]$Agents = "*",
  [switch]$ProjectScope
)

$ErrorActionPreference = "Stop"
try { [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false) } catch {}

$src = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
  Write-Error "SKILL.md not found. Run from the skill repo."
}

$RepoSlug = "unieggy000-debug/project-interview-coach"
$userProfile = $env:USERPROFILE
$placeholder = [string]::Concat([char]60, "path", [char]62)  # <path> without parser issues

function Copy-SkillTo([string]$destRoot) {
  $dest = Join-Path $destRoot "project-interview-coach"
  New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Copy-Item -Recurse -Force $src $dest
  $gitDir = Join-Path $dest ".git"
  if (Test-Path $gitDir) { Remove-Item -Recurse -Force $gitDir }
  return $dest
}

function Resolve-CurrentDest {
  switch ($Product) {
    "cursor" { return (Join-Path $userProfile ".cursor\skills") }
    "codex" { return (Join-Path $userProfile ".codex\skills") }
    "claude" { return (Join-Path $userProfile ".claude\skills") }
    "copilot" { return (Join-Path $userProfile ".copilot\skills") }
    "windsurf" { return (Join-Path $userProfile ".codeium\windsurf\skills") }
    "agents" { return (Join-Path $userProfile ".agents\skills") }
    default {
      if (Test-Path (Join-Path $userProfile ".cursor")) {
        return (Join-Path $userProfile ".cursor\skills")
      }
      return (Join-Path $userProfile ".agents\skills")
    }
  }
}

function Show-PostInstall([string]$installedPath) {
  $templatePath = Join-Path $src "POST-INSTALL.md"
  if (Test-Path $templatePath) {
    $raw = [System.IO.File]::ReadAllText($templatePath, [System.Text.UTF8Encoding]::new($false))
    $marker = '```text'
    $start = $raw.IndexOf($marker)
    if ($start -ge 0) {
      $start = $raw.IndexOf([char]10, $start) + 1
      $end = $raw.IndexOf('```', $start)
      if ($end -gt $start) {
        $body = $raw.Substring($start, $end - $start).Trim()
        $body = $body.Replace($placeholder, $installedPath)
        Write-Output $body
        return
      }
    }
  }
  Write-Output ("Installed: " + $installedPath)
  Write-Output "Open a NEW chat, then send: start project interview"
}

function Install-Current {
  $root = Resolve-CurrentDest
  $dest = Copy-SkillTo $root
  if ($root -like "*\.cursor\skills") {
    try { [void](Copy-SkillTo (Join-Path $userProfile ".agents\skills")) } catch {}
  }
  return $dest
}

function Install-ViaNpx {
  $agentArgs = @()
  if ($Agents -eq "*") { $agentArgs = @("--agent", "*") }
  else {
    foreach ($a in ($Agents -split ",")) {
      $t = $a.Trim()
      if ($t) { $agentArgs += @("--agent", $t) }
    }
  }
  $scope = @("-g")
  if ($ProjectScope) { $scope = @() }
  $npxArgs = @("skills", "add", $src) + $scope + $agentArgs + @("-y", "--copy")
  & npx --yes @npxArgs
  if ($LASTEXITCODE -ne 0) {
    $npxArgs = @("skills", "add", $RepoSlug) + $scope + $agentArgs + @("-y", "--copy")
    & npx --yes @npxArgs
    if ($LASTEXITCODE -ne 0) { throw "npx skills add failed" }
  }
  return (Join-Path (Resolve-CurrentDest) "project-interview-coach")
}

function Install-Fallback {
  $rels = @(
    ".agents\skills", ".cursor\skills", ".claude\skills", ".codex\skills",
    ".copilot\skills", ".codeium\windsurf\skills", ".gemini\skills",
    ".config\opencode\skills", ".continue\skills", ".config\goose\skills",
    ".kiro\skills", ".roo\skills", ".trae\skills", ".augment\skills",
    ".factory\skills", ".kilo\skills", ".aider-desk\skills", ".config\agents\skills"
  )
  $seen = @{}
  $first = $null
  foreach ($rel in $rels) {
    $destRoot = Join-Path $userProfile $rel
    if ($seen.ContainsKey($destRoot)) { continue }
    $seen[$destRoot] = $true
    $d = Copy-SkillTo $destRoot
    if (-not $first) { $first = $d }
  }
  return $first
}

$mode = $Mode
if ($mode -eq "auto") { $mode = "current" }

$path = $null
switch ($mode) {
  "current" { $path = Install-Current }
  "npx" {
    try { $path = Install-ViaNpx }
    catch { $path = Install-Current }
  }
  "fallback" { $path = Install-Fallback }
}

Show-PostInstall $path
