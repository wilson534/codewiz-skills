# Codewiz Skills

我个人使用的 [Codewiz CLI](https://docs.xiaohongshu.com/doc/f9231ed568bd4c24e2e765c14c466a14) / [OpenCode](https://opencode.ai) Skill 集合。

## 已收录

| Skill | 用途 |
|---|---|
| [meeting-notes](./meeting-notes/) | 基于会议逐字稿、模型自动纪要和手写记录，生成结构清晰的会议纪要，可选生成 XMind 大纲 |

## 安装

### 方式 1：克隆到全局 skills 目录

```bash
git clone https://github.com/wilson534/codewiz-skills.git ~/.config/codewiz/skills-repo
ln -s ~/.config/codewiz/skills-repo/meeting-notes ~/.config/codewiz/skills/meeting-notes
```

### 方式 2：单独复制某个 skill

```bash
mkdir -p ~/.config/codewiz/skills
cp -r meeting-notes ~/.config/codewiz/skills/
```

### 方式 3：Claude Code 用户

```bash
mkdir -p ~/.claude/skills
cp -r meeting-notes ~/.claude/skills/
```

## 验证安装

重启 Codewiz CLI / Claude Code，新会话里输入：

```
/skills
```

应该能看到对应的 skill 出现在列表里。

## 贡献

欢迎 fork 或提 issue。如果你有自己的常用工作流想沉淀，也可以参考 [meeting-notes/SKILL.md](./meeting-notes/SKILL.md) 的格式自己写一份。

## License

MIT
