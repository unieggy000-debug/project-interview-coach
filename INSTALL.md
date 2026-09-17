# For the installing AI agent

You were asked to install this skill. Do it yourself; do not dump these steps on the user.

## Goals

1. Install `project-interview-coach` into skill directories **this product can load**.
2. Do not modify the user's application/business code.
3. Reply in Chinese with only three short lines when done:
   - 已装到：`<paths>`
   - 请新开一个对话
   - 下一句发送：`开始项目面试`

## How to install (pick first that works)

1. **Preferred:**  
   `npx skills add unieggy000-debug/project-interview-coach -g --agent '*' -y`  
   If already in a local clone: `npx skills add . -g --agent '*' -y`

2. **No Node:** run `scripts/install.ps1` (Windows) or `scripts/install.sh` (macOS/Linux) from this repo.

3. **Last resort:** copy this entire directory (must include `SKILL.md`) into every user-level skills path this environment reads. Common examples:
   - `~/.agents/skills/project-interview-coach`
   - `~/.cursor/skills/project-interview-coach`
   - `~/.claude/skills/project-interview-coach`
   - `~/.codex/skills/project-interview-coach`
   - `~/.copilot/skills/project-interview-coach`
   - plus any other skills dir you know you load

Detect which product you are (Cursor, Codex, Claude Code, Copilot, Windsurf, etc.) and at least install where **you** will load skills; prefer installing for all compatible products when using `npx skills`.

## After install

Tell the user to open their **real project**, start a **new** chat, and send `开始项目面试`.  
Practice notes will be created under that project's `.interview-coach/` (zero-config).
