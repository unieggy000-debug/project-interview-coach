# Agent / AI Product Projects — Extra Lenses

在 L1–L6 之外，对 Agent 类项目可穿插下列透镜。**每次只选一条**追问，并走证据验证。

## Agent vs Workflow / Pipeline

- 固定顺序还是模型选步？
- 终止条件在 prompt 还是代码？
- max steps / timeout 在哪？
- 与 n8n/Zapier 等编排层如何分工？（编排触发 vs 智能体决策）

## Tool Calling

- 工具如何注册？名字/schema 谁定义？
- 参数谁填？如何防胡参？
- 结果如何回灌上下文？
- 工具失败是否对模型可见？

## Prompt

- System prompt 约束了什么？
- 哪些约束其实在代码硬编码？
- 仅改 prompt 能否改变工具选择策略？

## Search / Browser / Vision

- 各自解决什么互不可替的问题？
- Vision 输入是 URL、HTML、截图还是图文件？
- 黑图/空白/无关图策略？
- Search 空结果时是否仍调用 Vision？

## Memory / RAG / Embedding / Chat History

四者禁止混用：

| 概念 | 典型问题 |
|------|----------|
| Chat history | 仅本会话吗？多长？ |
| Memory | 跨会话吗？写入触发？ | 
| RAG/Embedding | 嵌什么文档？命中后如何引用？ |
| 普通 Search | 对外网还是对内库？ |

## State

- state 有哪些键？
- 存在内存还是 DB？
- 与「去重 / 已访问 / 预算」相关的字段？

## Evaluation / Guardrail

- 如何判断 Agent 变好了？（金标、人工抽检、轨迹）
- 取消、超时、循环上限、越权工具
- 可回放的决策轨迹在哪？

## 产品取舍（常与 mock-pm 交叉）

- 为何某字段不进 Research Card？
- 延迟 vs 质量 vs 成本：默认偏向？
- MVP 时砍掉的第一条链路是什么？

## 诚实协作叙事（面试高频）

可练习的标准结构（需用户用自己项目填空，禁止替写假贡献）：

1. 问题与用户（A）  
2. 方案边界与取舍（A）  
3. 系统如何跑通（B，附证据）  
4. 实现与协作：Cursor 协助编码，我负责需求、验收、关键修改（C 边界）  
5. 已知局限与下一步（unknowns / 无数据则不说提升%）  

压力模式下专打第 5 点说过头。
