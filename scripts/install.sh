#!/usr/bin/env bash
# Install for ALL Agent Skills–compatible hosts.
# Preferred: npx skills | Fallback: copy into common skill dirs
#
# Usage:
#   ./scripts/install.sh
#   ./scripts/install.sh npx
#   ./scripts/install.sh fallback
#   AGENTS=cursor,claude-code,codex ./scripts/install.sh npx

set -euo pipefail

MODE="${1:-auto}"   # auto | npx | fallback
AGENTS="${AGENTS:-*}"
PROJECT_SCOPE="${PROJECT_SCOPE:-0}"
SRC="$(cd "$(dirname "$0")/.." && pwd)"
REPO_SLUG="unieggy000-debug/project-interview-coach"

show_post_install() {
  local detail="$1"
  echo ""
  echo "========================================"
  echo "  project-interview-coach 已安装"
  echo "========================================"
  echo "$detail"
  echo ""
  echo "怎么用（任意已安装宿主）"
  echo "  1. 打开正式项目"
  echo "  2. 新开 Agent / Codex / Claude Code / Copilot 等对话"
  echo "  3. 发送：开始项目面试"
  echo "     或显式调用：\$project-interview-coach / @skill / /skills（视宿主而定）"
  echo ""
  echo "常用：菜单 | mock-pm | deep-dive Agent Loop | explain Agent Loop 30s | 继续"
  echo ""
  echo "推荐通用安装："
  echo "  npx skills add $REPO_SLUG -g --agent '*' -y"
  echo "图文：$SRC/usage.html"
  echo ""
  if [[ -f "$SRC/usage.html" ]]; then
    if command -v open >/dev/null 2>&1; then open "$SRC/usage.html" >/dev/null 2>&1 || true
    elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$SRC/usage.html" >/dev/null 2>&1 || true
    fi
  fi
}

install_via_npx() {
  local scope=(-g)
  [[ "$PROJECT_SCOPE" == "1" ]] && scope=()

  local agent_args=()
  if [[ "$AGENTS" == "*" ]]; then
    agent_args=(--agent '*')
  else
    IFS=',' read -ra parts <<< "$AGENTS"
    for a in "${parts[@]}"; do
      a="$(echo "$a" | xargs)"
      [[ -n "$a" ]] && agent_args+=(--agent "$a")
    done
  fi

  echo "使用 npx skills 安装到 Agent Skills 兼容宿主..."
  if ! npx --yes skills add "$SRC" "${scope[@]}" "${agent_args[@]}" -y --copy; then
    echo "本地路径失败，改用 GitHub：$REPO_SLUG"
    npx --yes skills add "$REPO_SLUG" "${scope[@]}" "${agent_args[@]}" -y --copy
  fi
}

install_fallback() {
  echo "离线兜底：复制到常见技能目录..."
  local home="${HOME}"
  local dirs=(
    ".agents/skills"
    ".cursor/skills"
    ".claude/skills"
    ".codex/skills"
    ".copilot/skills"
    ".codeium/windsurf/skills"
    ".gemini/skills"
    ".config/opencode/skills"
    ".continue/skills"
    ".config/goose/skills"
    ".kiro/skills"
    ".roo/skills"
    ".trae/skills"
    ".augment/skills"
    ".factory/skills"
    ".kilo/skills"
    ".aider-desk/skills"
    ".config/agents/skills"
  )
  local seen=""
  for rel in "${dirs[@]}"; do
    local dest_root="$home/$rel"
    case " $seen " in
      *" $dest_root "*) continue ;;
    esac
    seen="$seen $dest_root"
    local dest="$dest_root/project-interview-coach"
    mkdir -p "$dest_root"
    rm -rf "$dest"
    cp -R "$SRC" "$dest"
    rm -rf "$dest/.git" 2>/dev/null || true
    echo "  OK  $dest_root"
  done

  if [[ "$PROJECT_SCOPE" == "1" ]]; then
    local proj="$(pwd)/.agents/skills/project-interview-coach"
    mkdir -p "$(dirname "$proj")"
    rm -rf "$proj"
    cp -R "$SRC" "$proj"
    echo "  OK  project $proj"
  fi
}

has_npm=0
command -v npm >/dev/null 2>&1 && has_npm=1

use_npx=0
case "$MODE" in
  npx) use_npx=1 ;;
  fallback) use_npx=0 ;;
  *) [[ "$has_npm" == "1" ]] && use_npx=1 || use_npx=0 ;;
esac

if [[ "$use_npx" == "1" ]]; then
  if install_via_npx; then
    show_post_install "方式: npx skills（推荐，适配官方列表中的全部宿主）"
  else
    echo "npx skills 失败，改用兜底复制"
    install_fallback
    show_post_install "方式: 多目录复制兜底。完整列表请运行: npx skills add $REPO_SLUG -g --agent '*' -y"
  fi
else
  install_fallback
  show_post_install "方式: 多目录复制兜底。建议: npx skills add $REPO_SLUG -g --agent '*' -y"
fi
