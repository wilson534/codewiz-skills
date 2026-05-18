---
name: skills-pull
description: "从远端 codewiz-skills git 仓库拉最新 skill，同步回 ~/.claude/skills/。换机器恢复或拉同事改动用。"
---

# skills-pull

从远端 `pengzhiwei1/codewiz-skills`（GitHub origin）拉最新 skill 内容，同步回本地 `~/.claude/skills/`。

## 行为

调用 `~/codewiz-skills/scripts/sync.sh pull`。脚本内部：

1. `git pull origin main` 拿到最新
2. 对 repo 里每个 skill 目录（除 `scripts/`），rsync 到 `~/.claude/skills/<name>/`（删本地多余文件保持严格同步）

## 执行步骤

1. **检查 codewiz-skills 仓库存在**：跑 `[ -d ~/codewiz-skills/.git ] && echo "OK" || echo "MISSING"`
2. **如果缺失**：告诉用户先 clone，不继续：
   ```
   git clone git@github.com:wilson534/codewiz-skills.git ~/codewiz-skills
   ```
3. **调底层脚本**：
   ```bash
   bash ~/codewiz-skills/scripts/sync.sh pull
   ```
4. **stdout 完整原样展示给用户**（不要总结、不要省略）

## 不做的事

- 不从 GitLab 拉（GitHub 是默认 / 优先真源；GitLab 是镜像）。如需从 GitLab 拉，手动 `git pull gitlab main` 再跑 pull
- 不解决冲突（如本地 `~/.claude/skills/<name>/` 有未提交改动），rsync `--delete` 直接覆盖。冲突场景需要用户先 push 或自行 backup
