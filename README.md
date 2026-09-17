# project-interview-coach

面向：项目大量由 AI 协助实现 → 面试却讲不清。

这是符合 [Agent Skills](https://agentskills.io/) 规范的 Skill：反向拆解 + 证据验证 + 模拟面试。  
零配置：打开正式项目说话即可，笔记写入 `.interview-coach/`。

---

## 推荐安装

有 Node.js 时，用开放生态安装器（[vercel-labs/skills](https://github.com/vercel-labs/skills)），一次装到 **当前环境支持的全部 Agent**：

```bash
npx skills add unieggy000-debug/project-interview-coach -g --agent '*' -y
```

覆盖 Cursor、Codex、Claude Code、GitHub Copilot、Windsurf、Gemini CLI、OpenCode、Cline、Continue、Roo、Trae、Goose、Kiro…等官方列表中的宿主（随 `skills` CLI 更新而增加）。

| 常用变体 | 命令 |
|----------|------|
| 只看会装到哪些 Agent | `npx skills add unieggy000-debug/project-interview-coach -l` |
| 指定若干宿主 | `npx skills add unieggy000-debug/project-interview-coach -g -a cursor -a claude-code -a codex -y` |
| 装进当前仓库（团队共享） | `npx skills add unieggy000-debug/project-interview-coach --agent '*' -y`（不加 `-g`） |
| 本地克隆后安装 | `cd project-interview-coach && npx skills add . -g --agent '*' -y` |

Codex 也可用内置：`$skill-installer` → 从本 GitHub 仓库安装。

---

## 一键脚本（Windows / macOS / Linux）

脚本优先走 `npx skills`；没有 Node 时再**复制到常见技能目录**作兜底。

```powershell
git clone https://github.com/unieggy000-debug/project-interview-coach.git
cd project-interview-coach
.\scripts\install.ps1
```

```bash
git clone https://github.com/unieggy000-debug/project-interview-coach.git
cd project-interview-coach
chmod +x scripts/install.sh && ./scripts/install.sh
```

```powershell
.\scripts\install.ps1 -Mode npx                 # 强制 npx
.\scripts\install.ps1 -Mode fallback            # 强制多目录复制
.\scripts\install.ps1 -Agents cursor,claude-code,codex
```

装完会打印精简用法，并尽量打开 [`usage.html`](usage.html)。全文提示见 [`POST-INSTALL.md`](POST-INSTALL.md)。

> 为何不只写 Cursor / Codex？  
> Skill 格式是跨宿主的；正确做法是用 **标准安装器装全部兼容 Agent**，而不是为每个产品维护一份互斥说明。

---

## 30 秒上手

```text
安装 → 打开正式项目 → 新开对话 → 发送：开始项目面试
```

显式调用（视宿主）：`$project-interview-coach` · `/skills` · `@` 选技能 · 技能面板「项目面试教练」

| 指令 | 作用 |
|------|------|
| `菜单` | 启动面板 |
| `mock-pm` / `mock-technical` | 产品面 / 技术面 |
| `deep-dive Agent Loop` | 深挖模块 |
| `deep-dive GAP-007` | 深挖漏洞 |
| `explain Agent Loop 30s` | 闭卷口述 |
| `pressure` / `继续` | 压力 / 续练 |

装完后请 **新开对话**（部分宿主需重启才刷新技能列表）。

---

## 使用时发生了什么

```text
正式项目（只读查证）
  → 自动 .interview-coach/
  → 启动面板 → 追问 → 你查代码 → 再讲 → 重测
```

代码事实 > 用户记忆 > AI 猜测。不替你背标准答案。

---

## 仓库结构

```text
SKILL.md            Agent 规则
usage.html          人类说明页
POST-INSTALL.md     安装后提示
scripts/install.*   全宿主安装（npx + 兜底）
agents/openai.yaml  面板元数据
references/         方法与题库
examples/           练习区模板
```

---

## 设计原则

1. 证据优先  
2. 卡住 → 查代码 → 自己解释 → 换题重测  
3. A/B/C 贡献边界 · Interview Status · Session State  
4. 核心链路深挖，外围不必刷满  

详见 `SKILL.md`、`references/`。

## License

MIT
