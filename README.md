# project-interview-coach

项目主要由 AI 写完了，但面试讲不清？用这个 Skill 做：**反向拆解 + 证据验证 + 模拟面试**。

---

## 怎么安装（复制发给你的 AI）

**不用自己敲命令。** 把下面整段复制，粘贴给你正在用的智能体（Cursor / Codex / Claude Code / Copilot / Windsurf …），让它帮你装：

```text
请帮我安装这个 Agent Skill（项目面试教练）：

https://github.com/unieggy000-debug/project-interview-coach

安装要求：
1. 识别你当前是哪个宿主，把 Skill 装到你能加载到的用户技能目录。
2. 优先执行：npx skills add unieggy000-debug/project-interview-coach -g --agent '*' -y
3. 若没有 Node：克隆仓库后运行 scripts/install.ps1（Windows）或 scripts/install.sh（Mac/Linux）；再不行就拷贝到你支持的 skills 路径（需含 SKILL.md）。
4. 不要改我的业务代码。
5. 装完后用中文告诉我：装到哪了、请我新开对话、下一句发送「开始项目面试」。
```

单行文件版：[`INSTALL-PROMPT.md`](INSTALL-PROMPT.md)

装完后：**新开一个对话**，打开正式项目，发送：

```text
开始项目面试
```

---

## 装好后怎么用

| 你发送 | 作用 |
|--------|------|
| `开始项目面试` | 自动开练（建 `.interview-coach/`） |
| `菜单` | 看启动面板 |
| `mock-pm` | 产品经理模拟面 |
| `deep-dive Agent Loop` | 深挖一个模块 |
| `explain Agent Loop 30s` | 闭卷口述 |
| `pressure` / `继续` | 压力追问 / 按进度续练 |

图文说明：[`usage.html`](usage.html)

---

## 高级：自己装（可选）

```bash
npx skills add unieggy000-debug/project-interview-coach -g --agent '*' -y
```

或克隆后运行 `scripts/install.ps1` / `scripts/install.sh`。

---

## 它做什么

```text
正式项目（只读）→ .interview-coach/ 笔记
→ 你先讲 → 追问 → 你查代码 → 再讲 → 重测
```

**不会**直接给你标准答案。代码事实优先于猜测。

## License

MIT
