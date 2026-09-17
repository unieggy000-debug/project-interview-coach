# Install project-interview-coach for ALL Agent Skills–compatible hosts
#
# Preferred: npx skills (vercel-labs/skills) → 40+ agents
# Fallback: copy into common skill directories when Node/npm unavailable
#
# Usage:
#   .\scripts\install.ps1
#   .\scripts\install.ps1 -Mode npx        # force npx skills
#   .\scripts\install.ps1 -Mode fallback   # force multi-path copy
#   .\scripts\install.ps1 -Agents cursor,claude-code,codex

param(
  [ValidateSet("auto", "npx", "fallback")]
  [string]$Mode = "auto",
  [string]$Agents = "*",  # '*' = all agents known to npx skills; or comma list
  [switch]$ProjectScope   # install into current repo .agents/skills (and peers via npx)
)

$ErrorActionPreference = "Stop"
$src = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
  Write-Error "SKILL.md not found. Run from the skill repo."
}

$RepoSlug = "unieggy000-debug/project-interview-coach"

function Show-PostInstall {
  param([string]$Detail)
  Write-Host ""
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  project-interview-coach 已安装" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host $Detail
  Write-Host ""
  Write-Host "怎么用（任意已安装宿主）" -ForegroundColor Yellow
  Write-Host "  1. 打开正式项目"
  Write-Host "  2. 新开 Agent / Codex / Claude Code / Copilot 等对话"
  Write-Host "  3. 发送：开始项目面试"
  Write-Host "     或显式调用：$project-interview-coach / @skill / /skills（视宿主而定）"
  Write-Host ""
  Write-Host "常用：菜单 | mock-pm | deep-dive Agent Loop | explain Agent Loop 30s | 继续"
  Write-Host ""
  Write-Host "给朋友安装：让他们把 INSTALL-PROMPT.md 复制发给自己的 AI 即可。" -ForegroundColor DarkGray
Write-Host "图文：$(Join-Path $src 'usage.html')"
Write-Host ""
  $usage = Join-Path $src "usage.html"
  try { if (Test-Path $usage) { Start-Process $usage } } catch {}
}

function Test-NpxSkills {
  try {
    $null = Get-Command npm -ErrorAction Stop
    return $true
  } catch {
    return $false
  }
}

function Install-ViaNpx {
  $agentArgs = @()
  if ($Agents -eq "*") {
    $agentArgs = @("--agent", "*")
  } else {
    foreach ($a in ($Agents -split ",")) {
      $t = $a.Trim()
      if ($t) { $agentArgs += @("--agent", $t) }
    }
  }

  $scope = @("-g")
  if ($ProjectScope) { $scope = @() }

  # Prefer local path when installing from a clone; else GitHub slug
  $source = $src
  Write-Host "使用 npx skills 安装到 Agent Skills 兼容宿主..." -ForegroundColor Cyan
  Write-Host ("source={0} agents={1}" -f $source, $Agents)

  $npxArgs = @("skills", "add", $source) + $scope + $agentArgs + @("-y", "--copy")
  & npx --yes @npxArgs
  if ($LASTEXITCODE -ne 0) {
    Write-Host "本地路径失败，改用 GitHub：$RepoSlug" -ForegroundColor Yellow
    $npxArgs = @("skills", "add", $RepoSlug) + $scope + $agentArgs + @("-y", "--copy")
    & npx --yes @npxArgs
    if ($LASTEXITCODE -ne 0) { throw "npx skills add failed" }
  }
}

function Install-FallbackCopy {
  # Universal + major harness user dirs (Agent Skills ecosystem)
  $home = $env:USERPROFILE
  $targets = @(
    @{ Label = "Standard (cross-agent)"; Rel = ".agents\skills" },
    @{ Label = "Cursor"; Rel = ".cursor\skills" },
    @{ Label = "Claude Code"; Rel = ".claude\skills" },
    @{ Label = "Codex"; Rel = ".codex\skills" },
    @{ Label = "GitHub Copilot"; Rel = ".copilot\skills" },
    @{ Label = "Windsurf"; Rel = ".codeium\windsurf\skills" },
    @{ Label = "Gemini CLI"; Rel = ".gemini\skills" },
    @{ Label = "OpenCode"; Rel = ".config\opencode\skills" },
    @{ Label = "Continue"; Rel = ".continue\skills" },
    @{ Label = "Cline/Warp/Zed shared"; Rel = ".agents\skills" },
    @{ Label = "Goose"; Rel = ".config\goose\skills" },
    @{ Label = "Kiro"; Rel = ".kiro\skills" },
    @{ Label = "Roo"; Rel = ".roo\skills" },
    @{ Label = "Trae"; Rel = ".trae\skills" },
    @{ Label = "Augment"; Rel = ".augment\skills" },
    @{ Label = "Droid/Factory"; Rel = ".factory\skills" },
    @{ Label = "Kilo"; Rel = ".kilo\skills" },
    @{ Label = "AiderDesk"; Rel = ".aider-desk\skills" },
    @{ Label = "Amp/Universal config"; Rel = ".config\agents\skills" }
  )

  # Deduplicate by path
  $seen = @{}
  Write-Host "离线兜底：复制到常见技能目录（无法枚举全世界宿主时用 npx skills）..." -ForegroundColor Cyan
  foreach ($t in $targets) {
    $destRoot = Join-Path $home $t.Rel
    if ($seen.ContainsKey($destRoot)) { continue }
    $seen[$destRoot] = $true
    $dest = Join-Path $destRoot "project-interview-coach"
    New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse -Force $src $dest
    $gitDir = Join-Path $dest ".git"
    if (Test-Path $gitDir) { Remove-Item -Recurse -Force $gitDir }
    Write-Host ("  OK  {0}" -f $destRoot) -ForegroundColor Green
  }

  if ($ProjectScope) {
    $proj = Join-Path (Get-Location) ".agents\skills\project-interview-coach"
    New-Item -ItemType Directory -Force -Path (Split-Path $proj) | Out-Null
    if (Test-Path $proj) { Remove-Item -Recurse -Force $proj }
    Copy-Item -Recurse -Force $src $proj
    Write-Host ("  OK  project {0}" -f $proj) -ForegroundColor Green
  }
}

$useNpx = $false
if ($Mode -eq "npx") { $useNpx = $true }
elseif ($Mode -eq "fallback") { $useNpx = $false }
else { $useNpx = Test-NpxSkills }

if ($useNpx) {
  try {
    Install-ViaNpx
    Show-PostInstall "方式: npx skills（推荐，适配官方列表中的全部宿主）"
  } catch {
    Write-Host ("npx skills 失败，改用兜底复制: {0}" -f $_) -ForegroundColor Yellow
    Install-FallbackCopy
    Show-PostInstall "方式: 多目录复制兜底（常见宿主）。完整列表请装 Node 后运行: npx skills add $RepoSlug -g --agent '*' -y"
  }
} else {
  Install-FallbackCopy
  Show-PostInstall "方式: 多目录复制兜底。建议安装 Node.js 后执行: npx skills add $RepoSlug -g --agent '*' -y"
}
