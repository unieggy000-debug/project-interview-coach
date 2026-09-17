# Install project-interview-coach into Cursor personal skills (Windows)

$ErrorActionPreference = "Stop"
$src = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
  Write-Error "SKILL.md not found next to scripts/. Run from the skill repo."
}
$dest = Join-Path $env:USERPROFILE ".cursor\skills\project-interview-coach"
New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
Copy-Item -Recurse -Force $src $dest
$gitDir = Join-Path $dest ".git"
if (Test-Path $gitDir) { Remove-Item -Recurse -Force $gitDir }

$usage = Join-Path $dest "usage.html"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  project-interview-coach 已安装" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "安装位置: $dest"
Write-Host ""
Write-Host "怎么用（3 步）" -ForegroundColor Yellow
Write-Host "  1. 用 Cursor 打开你的正式项目仓库"
Write-Host "  2. 新开一个 Agent Chat（建议新对话）"
Write-Host "  3. 发送："
Write-Host ""
Write-Host "       开始项目面试" -ForegroundColor Green
Write-Host ""
Write-Host "也会自动在项目里创建 .interview-coach/ 练习笔记。"
Write-Host ""
Write-Host "常用指令" -ForegroundColor Yellow
Write-Host "  菜单                 再看启动面板"
Write-Host "  mock-pm              产品经理模拟面"
Write-Host "  deep-dive Agent Loop 深挖一个模块"
Write-Host "  explain Agent Loop 30s  闭卷口述"
Write-Host "  pressure / 继续"
Write-Host ""
Write-Host "图文说明（浏览器打开）:" -ForegroundColor Yellow
Write-Host "  $usage"
Write-Host ""
Write-Host "提示: 安装后请新开 Agent 对话再开始，旧对话可能还没加载到 Skill。" -ForegroundColor DarkGray
Write-Host ""

# Best-effort: open the usage page so the tip is visible immediately
try {
  if (Test-Path $usage) {
    Start-Process $usage
  }
} catch {
  # ignore
}
