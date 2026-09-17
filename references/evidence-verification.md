# Evidence Verification

## 原则

任何机制性陈述，在教给用户或写入「可口述答案」之前，必须经历验证。

```text
用户说法 / AI 印象
    ↓
在仓库中定位证据
    ↓
标等级：PROJECT FACT | USER CLAIM | INFERENCE | UNKNOWN
    ↓
不足则布置查证任务
    ↓
用户复述 → 更新 evidence-map
```

## 证据等级

| 标签 | 何时用 | 可否写人口述定稿 |
|------|--------|------------------|
| `[PROJECT FACT]` | 源码、migration、类型定义、README 明确句、可复现行为 | 还须看 Interview Status |
| `[USER CLAIM]` | 仅用户口述，未核对 | 否；先验证 |
| `[INFERENCE]` | 代码强烈暗示但未写明 | 口述须说「从实现推断」 |
| `[UNKNOWN]` | 搜过仍无 | 诚实说不知道；写入 unknowns.md |

Git history：可证明「何时引入/谁改过」，**不能单独**证明运行时行为；行为以当前代码为准。

## Interview Status（与证据正交）

```text
项目存在 [PROJECT FACT]
    ≠ 你做过
    ≠ 你现在记得
    ≠ 你能解释（B/C 达到目标等级）
    ≠ 你能在压力下讲清楚（SAFE）
```

| Status | 何时 | 面试怎么说 |
|--------|------|------------|
| `SAFE` | 目标等级达到且重测过关 | 自然主叙事 |
| `QUALIFIED` | 达到目标，但贡献或深度需限定 | 限定句：流程/选型归我；实现协助；我讲 I/O 与失败 |
| `FRAGILE` | 未达目标或一追就散 | 不进主稿；先 deep-dive |
| `DO NOT CLAIM` | 无参与/无理解/无效果证据 | 不提，或只说「用了、细节不熟」 |

**PROJECT FACT + DO NOT CLAIM** 很常见：仓库里有 Browserless，但你不该在面试里装成手写客户端专家。

写入 `interview-answers.md` 前检查：证据级 + Status 双绿（SAFE 或 QUALIFIED+限定语）。

## 验证清单（对「组件 A 把结果交给组件 B」类主张）

逐项核对，缺一项就继续追问或查证：

1. **调用什么**：API / 函数 / 外部服务名  
2. **谁触发**：写死分支 / LLM tool call / 人工 / 调度器（如 n8n）  
3. **输入形状**：参数字段  
4. **输出形状**：返回类型 / schema  
5. **落盘位置**：内存 state / DB 表 / 文件 / 仅消息气泡  
6. **下游消费**：哪个函数读、读什么字段  
7. **失败路径**：异常、空结果、重试、跳过、对用户可见性  
8. **生命周期**：进程重启后是否还在（持久 vs 易失）

示例主张：「Agent 自动避免重复网站」

应追到：

- 是否存在 `visited_urls`（或同等）？
- 在哪初始化？
- 何时 append？
- 下一轮如何读取并影响 tool 选择？
- 重启后是否仍有效？若只在内存 → 口述不能说「永久去重」。

## 查证任务写法

好：

> 打开 `agent/loop.py`，找到工具结果写回 messages/state 的位置。用自己的话回答：下一轮是模型根据更新后的上下文再选工具，还是 Python if/else 指定下一个工具？

坏：

> 把 Agent 目录都读完再来。

规则：单次任务 **一个文件（或一条短调用链）**，预期 5–10 分钟。

## evidence-map 条目格式

```markdown
### Claim
Agent 可以自主决定调用工具

### Evidence
- agent/loop.py
- tool_registry.py
- prompts/system.md

### Mechanism
LLM 输出 tool call → 注册表执行 → 结果写回 → 下一轮迭代

### Confidence
Confirmed | Partial | Unconfirmed | Contradicted

### Knowledge type
B (System Understanding) / C (Implementation Detail)

### Understanding
代码理解：4/5
已证明：…
缺口：…
升到下一级：…

### Interview Status
SAFE | QUALIFIED | FRAGILE | DO NOT CLAIM
```

`Confirmed` = 有 PROJECT FACT 支撑机制。  
`Contradicted` = 用户说法与代码冲突；优先让用户重读代码，再短解释冲突点。  
有 FACT 仍可能是 `DO NOT CLAIM`（存在≠可讲）。

## Agent 侧自检（防 AI 编造）

在把某句标成 PROJECT FACT 之前问自己：

- 我是读到了符号/字符串，还是「按常见 Agent 项目猜的」？
- 若是猜的 → `[INFERENCE]` 或先搜索仓库。
- 找不到 → `[UNKNOWN]`，不要用通用 Agent 教材填坑。

## 与面试措辞

| 危险措辞 | 验证后应变成 |
|----------|----------------|
| 「大幅提升效率」 | 有指标 → 报指标与口径；无 → 改口为「减少了手工步骤 X」或「尚未量化」 |
| 「我实现了 Agent」 | 拆 A/B/C：方案/理解/代码作者 |
| 「会自动…」 | 指出具体状态变量与失败边界 |
