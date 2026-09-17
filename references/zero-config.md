# Bootstrap / 项目与简历绑定

## 用户怎么给项目（白话）

1. Cursor「文件 → 打开文件夹」打开项目后再开练；或  
2. 直接发本地路径；或  
3. 发 Git 链接（有本地目录则用本地）

不要跟用户说 Workspace Root。当前窗口若是本 Skill 仓库或明显不是目标项目 → 追问路径。

## 用户怎么给简历

拖文件 / 发路径 / 粘贴 → 写入 `.interview-coach/resume.md`。

## 练习区

`<源项目>/.interview-coach/`，含 `resume.md`、`resume-feedback.md`、`session-state.md` 等。  
`.gitignore` 追加 `.interview-coach/`。

## 开练前检查

- [ ] 源项目路径已知且可读  
- [ ] 简历已收到  
- [ ] 练习区骨架已建  
- [ ] 再开问 / 展示面板  

安装后文案见 `POST-INSTALL.md`。简历追问见 `resume-interview.md`。
