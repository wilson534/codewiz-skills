# Codewiz Skills

我个人使用的 [Codewiz CLI](https://docs.xiaohongshu.com/doc/f9231ed568bd4c24e2e765c14c466a14) / [OpenCode](https://opencode.ai) Skill 集合。

## 已收录

| Skill | 用途 |
|---|---|
| [meeting-notes](./meeting-notes/) | 基于会议逐字稿、模型自动纪要和手写记录，生成结构清晰的会议纪要，可选生成 XMind 大纲 |
| [publish-research](./publish-research/) | 把技术调研草稿整理成对外可读的单文档：结构整合、语言打磨、证据核实、发布到 GitLab / GitHub |
| [skills-push](./skills-push/) | 把本地 `~/.claude/skills/` 同步到本 repo + push 双 remote（GitHub origin + 公司 GitLab gitlab） |
| [skills-pull](./skills-pull/) | 从远端拉最新 skill 同步回 `~/.claude/skills/`（换机器恢复或拉同事改动） |

## 安装

### 方式 1：克隆到全局 skills 目录

```bash
git clone https://github.com/wilson534/codewiz-skills.git ~/.config/codewiz/skills-repo
ln -s ~/.config/codewiz/skills-repo/meeting-notes ~/.config/codewiz/skills/meeting-notes
ln -s ~/.config/codewiz/skills-repo/publish-research ~/.config/codewiz/skills/publish-research
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

## 双向同步

repo 关联两个 remote：
- `origin` → GitHub `wilson534/codewiz-skills`（QQ 邮箱签 commit）
- `gitlab` → 公司 GitLab `pengzhiwei1/codewiz-skills`（公司邮箱签 commit，main 是 protected branch）

两条历史从初始 commit 起就独立（无共同祖先），靠 [scripts/sync.sh](./scripts/sync.sh) 维持内容一致：

```bash
# push：~/.claude/skills/ → repo → push 双 remote
bash scripts/sync.sh push

# pull：git pull origin → ~/.claude/skills/
bash scripts/sync.sh pull
```

或者在 cc 里直接调 `/skills-push` / `/skills-pull` skill（薄壳，最终调同一个 sync.sh）。

身份切换、protected branch 绕过、trap EXIT 兜底都封装在脚本里，使用者无需关心。

## 贡献

欢迎 fork 或提 issue。如果你有自己的常用工作流想沉淀，也可以参考 [meeting-notes/SKILL.md](./meeting-notes/SKILL.md) 的格式自己写一份。

## License

MIT
