# project-interview-coach

面向这种真实情况：

> 项目大部分由 Cursor / AI 协助实现 → 能跑，但面试一追问只剩功能名。

这是一个 **Cursor Skill**：在正式项目里做「反向拆解 + 证据验证 + 模拟面试」。  
**零配置**：打开项目说话即可，练习笔记自动落在 `.interview-coach/`。

**不做**独立网页 App。界面 = **Agent Chat 启动面板** + 可选 [`usage.html`](usage.html)。

---

## 30 秒上手

```text
安装 Skill → 打开正式项目 → 新开 Agent Chat → 发送：开始项目面试
```

| 你再说 | 作用 |
|--------|------|
| `菜单` | 启动面板 |
| `mock-pm` | AI 产品经理模拟面 |
| `mock-technical` | 技术面 |
| `deep-dive Agent Loop` | 深挖模块 |
| `deep-dive GAP-007` | 深挖某个漏洞 |
| `explain Agent Loop 30s` | 闭卷口述（也可用 2min / 5min） |
| `pressure` | 压力追问（效果/数据） |
| `继续` | 按上次进度续练 |

装完后的精简提示见 [`POST-INSTALL.md`](POST-INSTALL.md)。图文说明见 [`usage.html`](usage.html)。

---

## 安装（一次）

**Windows**

```powershell
git clone https://github.com/unieggy000-debug/project-interview-coach.git
cd project-interview-coach
.\scripts\install.ps1
```

**macOS / Linux**

```bash
git clone https://github.com/unieggy000-debug/project-interview-coach.git
cd project-interview-coach
chmod +x scripts/install.sh && ./scripts/install.sh
```

脚本会：

1. 复制到 `~/.cursor/skills/project-interview-coach/`
2. 在终端打印使用说明
3. 尽量打开 `usage.html`

安装后请 **新开 Agent 对话**（旧对话可能还没加载到 Skill）。

---

## 使用时发生了什么

```text
当前仓库（正式项目，只读查证）
        │
        ▼
自动创建 .interview-coach/   ← session-state / gaps / answers
        │
        ▼
Agent Chat：启动面板 → 追问 → 你查代码 → 再讲 → 重测
```

- **不会**上来给你标准答案  
- **会**在你说「提高效率」却没数据时打断  
- **会**区分：产品决策 (A) / 系统理解 (B) / 实现细节 (C)  
- 进度靠 `.interview-coach/session-state.md` 跨天续练  

---

## 仓库结构

```text
project-interview-coach/
├── SKILL.md                 # Agent 行为规则
├── usage.html               # 给人类看的说明页
├── POST-INSTALL.md          # 安装后提示文案
├── scripts/install.ps1|.sh  # 一键装到 Cursor skills
├── agents/openai.yaml       # 技能面板展示名
├── bundled/*.mdc            # 可选写入项目的 rule
├── references/              # 方法 / 题型 / 证据协议
└── examples/                # 练习区模板
```

---

## 设计原则（摘要）

1. **代码事实 > 用户记忆 > AI 猜测**  
2. 卡住 → 查代码 → 自己解释 → 换题重测  
3. Interview Status：`SAFE` / `QUALIFIED` / `FRAGILE` / `DO NOT CLAIM`  
4. 核心链路冲深度，外围组件不必刷满  

细节见 `SKILL.md` 与 `references/`。

---

## License

MIT
