# Zero-Config Bootstrap

## 目标

用户只做两件事：

1. 安装本 Skill 一次  
2. 用 Cursor 打开正式项目，在 Agent Chat 说「开始项目面试」

之后全部自动：练习区、状态、模式选择、开场。

## 路径约定

```text
<workspace>/                    ← 正式项目（只读查证）
  .interview-coach/             ← 自动练习区
    session-state.md
    project-map.md
    knowledge-gaps.md
    ...
  .gitignore                    ← 自动追加 .interview-coach/
  .cursor/rules/                ← 可选写入轻量 rule
```

不要再要求 `vision-agent-interview` 独立仓（用户仍可手动指定，但非默认）。

## Bootstrap 检查清单

Agent 按序执行，缺啥补啥：

- [ ] `.interview-coach/` 存在  
- [ ] `session-state.md` 存在且含源路径=workspace、练习区=`.interview-coach`  
- [ ] 其余骨架 md 存在（可先空标题）  
- [ ] 根 `.gitignore` 含 `.interview-coach/`  
- [ ] （可选）`.cursor/rules/project-interview-coach.mdc` 存在  
- [ ] `.interview-coach/怎么用.html` 存在（从技能包 `usage.html` 复制）  

然后读 state → 展示启动面板（若需要）→ 开练。**禁止停下来问「练习区建在哪」。**  
独立 GUI / 仪表盘：**不做**；Chat 启动面板即界面。

## 模式自动选择

```text
if state.下次启动句 → 执行
else if state.待解决 GAP 非空 → deep-dive 第一个
else if project-map 几乎为空或从未 diagnose → diagnose
else → mock-pm（岗位默认）或用户刚指定的模式
```

## 与「另开练习仓」的关系

旧工作流（独立 interview 文件夹）仍兼容：若用户消息里显式给了练习区路径，或 state 里练习区不在当前仓库，则尊重用户配置。  
**默认零配置优先。**

## 安装（用户侧）

**普通用户：** 把仓库根目录 [`INSTALL-PROMPT.md`](../INSTALL-PROMPT.md) 复制发给当前智能体，让它安装。

**会用终端：** `npx skills add unieggy000-debug/project-interview-coach -g --agent '*' -y`  
或运行 `scripts/install.ps1` / `install.sh`。

安装后新开对话即可。
