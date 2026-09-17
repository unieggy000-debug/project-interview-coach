#!/usr/bin/env bash
# Default: current-product copy. Optional: npx | fallback
#   ./scripts/install.sh
#   ./scripts/install.sh current
#   ./scripts/install.sh npx
#   ./scripts/install.sh fallback
#   PRODUCT=cursor ./scripts/install.sh current

set -euo pipefail

MODE="${1:-auto}"   # auto|current|npx|fallback
PRODUCT="${PRODUCT:-auto}"
AGENTS="${AGENTS:-*}"
PROJECT_SCOPE="${PROJECT_SCOPE:-0}"
SRC="$(cd "$(dirname "$0")/.." && pwd)"
REPO_SLUG="unieggy000-debug/project-interview-coach"
HOME_DIR="${HOME}"

copy_skill_to() {
  local dest_root="$1"
  local dest="$dest_root/project-interview-coach"
  mkdir -p "$dest_root"
  rm -rf "$dest"
  cp -R "$SRC" "$dest"
  rm -rf "$dest/.git" 2>/dev/null || true
  echo "$dest"
}

resolve_current_dest() {
  case "$PRODUCT" in
    cursor) echo "$HOME_DIR/.cursor/skills" ;;
    codex) echo "$HOME_DIR/.codex/skills" ;;
    claude) echo "$HOME_DIR/.claude/skills" ;;
    copilot) echo "$HOME_DIR/.copilot/skills" ;;
    windsurf) echo "$HOME_DIR/.codeium/windsurf/skills" ;;
    agents) echo "$HOME_DIR/.agents/skills" ;;
    *)
      if [[ -d "$HOME_DIR/.cursor" ]]; then echo "$HOME_DIR/.cursor/skills"
      else echo "$HOME_DIR/.agents/skills"
      fi
      ;;
  esac
}

show_post_install() {
  local path="$1"
  echo ""
  echo "✅ 项目面试教练已安装"
  echo "已装到：$path"
  echo ""
  echo "请【新开一个对话】，打开你的正式项目，然后发送指令开练。"
  echo ""
  echo "————————"
  echo "🧭 常用指令（不知道发什么就看这里）"
  echo "1. 开始项目面试 — 自动开练（第一次一般是摸底）"
  echo "2. 菜单 — 再看这份清单"
  echo "3. mock-pm — 产品经理模拟面试"
  echo "4. mock-technical — 偏技术追问"
  echo "5. deep-dive <模块名> — 专啃一个模块（如 Agent Loop）"
  echo "6. explain <主题> 30s — 闭卷口述（也可 2min / 5min）"
  echo "7. pressure — 压力追问"
  echo "8. 继续 — 按上次进度接着练"
  echo "————————"
  echo ""
  echo "建议下一句直接发送：开始项目面试"
  echo ""
}

install_current() {
  local root
  root="$(resolve_current_dest)"
  local dest
  dest="$(copy_skill_to "$root")"
  if [[ "$root" == *".cursor/skills" ]]; then
    copy_skill_to "$HOME_DIR/.agents/skills" >/dev/null 2>&1 || true
  fi
  echo "$dest"
}

install_via_npx() {
  local scope=(-g)
  [[ "$PROJECT_SCOPE" == "1" ]] && scope=()
  local agent_args=(--agent '*')
  if [[ "$AGENTS" != "*" ]]; then
    agent_args=()
    IFS=',' read -ra parts <<< "$AGENTS"
    for a in "${parts[@]}"; do
      a="$(echo "$a" | xargs)"
      [[ -n "$a" ]] && agent_args+=(--agent "$a")
    done
  fi
  npx --yes skills add "$SRC" "${scope[@]}" "${agent_args[@]}" -y --copy || \
    npx --yes skills add "$REPO_SLUG" "${scope[@]}" "${agent_args[@]}" -y --copy
  echo "npx skills (see CLI output)"
}

install_fallback() {
  local dirs=(
    ".agents/skills" ".cursor/skills" ".claude/skills" ".codex/skills"
    ".copilot/skills" ".codeium/windsurf/skills" ".gemini/skills"
    ".config/opencode/skills" ".continue/skills" ".config/goose/skills"
    ".kiro/skills" ".roo/skills" ".trae/skills" ".augment/skills"
    ".factory/skills" ".kilo/skills" ".aider-desk/skills" ".config/agents/skills"
  )
  local first="" seen=""
  for rel in "${dirs[@]}"; do
    local dest_root="$HOME_DIR/$rel"
    case " $seen " in *" $dest_root "*) continue ;; esac
    seen="$seen $dest_root"
    local d
    d="$(copy_skill_to "$dest_root")"
    [[ -z "$first" ]] && first="$d"
  done
  echo "$first"
}

[[ "$MODE" == "auto" ]] && MODE="current"

path=""
case "$MODE" in
  current) path="$(install_current)" ;;
  npx)
    if path="$(install_via_npx)"; then :; else path="$(install_current)"; fi
    ;;
  fallback) path="$(install_fallback)" ;;
  *) path="$(install_current)" ;;
esac

show_post_install "$path"
