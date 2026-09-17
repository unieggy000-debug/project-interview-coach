# 安装完成后提示

## 已安装 · 怎么用

1. 打开**正式项目**  
2. **新开**对话（Cursor Agent / Codex / Claude Code / Copilot / Windsurf / …）  
3. 发送：`开始项目面试`  
   - 或显式：`$project-interview-coach` / `/skills` / `@` 选技能（视宿主）

自动创建 `.interview-coach/`，对话里会出现启动面板。

| 再说一句 | 作用 |
|----------|------|
| `菜单` | 启动面板 |
| `mock-pm` | 产品面 |
| `deep-dive Agent Loop` | 深挖 |
| `explain Agent Loop 30s` | 口述 |
| `pressure` / `继续` | 压力 / 续练 |

## 若还没装全

推荐一次装到全部兼容宿主：

```bash
npx skills add unieggy000-debug/project-interview-coach -g --agent '*' -y
```

图文：`usage.html`。新对话后再用（部分宿主需重启）。
