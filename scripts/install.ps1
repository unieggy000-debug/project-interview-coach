# Install project-interview-coach
#
# Default: current-product copy (fast, sandbox-friendly)
# Optional: npx all agents | multi-dir fallback
#
#   .\scripts\install.ps1
#   .\scripts\install.ps1 -Mode current
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
$src = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
  Write-Error "SKILL.md not found. Run from the skill repo."
}

$RepoSlug = "unieggy000-debug/project-interview-coach"
$home = $env:USERPROFILE

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
    "cursor" { return (Join-Path $home ".cursor\skills") }
    "codex" { return (Join-Path $home ".codex\skills") }
    "claude" { return (Join-Path $home ".claude\skills") }
    "copilot" { return (Join-Path $home ".copilot\skills") }
    "windsurf" { return (Join-Path $home ".codeium\windsurf\skills") }
    "agents" { return (Join-Path $home ".agents\skills") }
    default {
      # Heuristic: Cursor is the most common install path for this workflow
      if (Test-Path (Join-Path $home ".cursor")) {
        return (Join-Path $home ".cursor\skills")
      }
      return (Join-Path $home ".agents\skills")
    }
  }
}

function Show-PostInstall([string]$path) {
  Write-Host ""
  Write-Host "✅ 项目面试教练已安装"
  Write-Host "已装到：$path"
  Write-Host ""
  Write-Host "请【新开一个对话】，打开你的正式项目，然后发送指令开练。"
  Write-Host ""
  Write-Host "————————"
  Write-Host "🧭 常用指令（不知道发什么就看这里）"
  Write-Host "1. 开始项目面试 — 自动开练（第一次一般是摸底）"
  Write-Host "2. 菜单 — 再看这份清单"
  Write-Host "3. mock-pm — 产品经理模拟面试"
  Write-Host "4. mock-technical — 偏技术追问"
  Write-Host "5. deep-dive <模块名> — 专啃一个模块（如 Agent Loop）"
  Write-Host "6. explain <主题> 30s — 闭卷口述（也可 2min / 5min）"
  Write-Host "7. pressure — 压力追问"
  Write-Host "8. 继续 — 按上次进度接着练"
  Write-Host "————————"
  Write-Host ""
  Write-Host "建议下一句直接发送：开始项目面试"
  Write-Host ""
}

function Install-Current {
  $root = Resolve-CurrentDest
  $dest = Copy-SkillTo $root
  # Also drop a copy into .agents/skills when installing for Cursor (shared convention)
  if ($root -like "*\.cursor\skills") {
    try { Copy-SkillTo (Join-Path $home ".agents\skills") | Out-Null } catch {}
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
  return "npx skills (see CLI output)"
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
    $destRoot = Join-Path $home $rel
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
