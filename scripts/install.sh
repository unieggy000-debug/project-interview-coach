#!/usr/bin/env bash
set -euo pipefail
SRC="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${HOME}/.cursor/skills/project-interview-coach"
mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
cp -R "$SRC" "$DEST"
rm -rf "$DEST/.git" 2>/dev/null || true

USAGE="$DEST/usage.html"

echo ""
echo "========================================"
echo "  project-interview-coach 已安装"
echo "========================================"
echo ""
echo "安装位置: $DEST"
echo ""
echo "怎么用（3 步）"
echo "  1. 用 Cursor 打开你的正式项目仓库"
echo "  2. 新开一个 Agent Chat（建议新对话）"
echo "  3. 发送："
echo ""
echo "       开始项目面试"
echo ""
echo "也会自动在项目里创建 .interview-coach/ 练习笔记。"
echo ""
echo "常用指令"
echo "  菜单                 再看启动面板"
echo "  mock-pm              产品经理模拟面"
echo "  deep-dive Agent Loop 深挖一个模块"
echo "  explain Agent Loop 30s  闭卷口述"
echo "  pressure / 继续"
echo ""
echo "图文说明（浏览器打开）:"
echo "  $USAGE"
echo ""
echo "提示: 安装后请新开 Agent 对话再开始，旧对话可能还没加载到 Skill。"
echo ""

# Best-effort open usage page
if [[ -f "$USAGE" ]]; then
  if command -v open >/dev/null 2>&1; then
    open "$USAGE" >/dev/null 2>&1 || true
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$USAGE" >/dev/null 2>&1 || true
  fi
fi
