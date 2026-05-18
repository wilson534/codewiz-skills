---
name: skills-push
description: "把本地 ~/.claude/skills/ 同步到远端 codewiz-skills git 仓库（push）。扫 repo 里已有的每个 skill 目录，从本地 cp 内容、commit、push 双 remote（GitHub + 公司 GitLab，公司 GitLab 用公司邮箱独立 commit 绕过 protected branch + 邮箱 hook）。"
---

# skills-push

把本地 cc 写过的 skill 同步到远端 `pengzhiwei1/codewiz-skills`（双 remote：GitHub origin + 公司 GitLab gitlab）。

## 行为

调用 `~/codewiz-skills/scripts/sync.sh push`。脚本内部：

1. 把 `~/.claude/skills/<name>/` 用 rsync 同步到 `~/codewiz-skills/<name>/`（只针对 repo 里已存在的 skill 目录）
2. 用 GitHub 身份（wilson534 / QQ 邮箱）commit + push origin（GitHub）
3. fetch gitlab，新建临时分支 `sync-gitlab` 基于 `gitlab/main`
4. 切到公司邮箱身份（pengzhiwei1 / @xiaohongshu.com），把 main 的内容搬到 sync-gitlab 工作树，重新 commit
5. push gitlab sync-gitlab:main（fast-forward 通过 protected branch + 邮箱 hook）
6. 切回 main、删 sync-gitlab，trap EXIT 强保证身份恢复为 GitHub

## 执行步骤

1. **检查 codewiz-skills 仓库存在**：跑 `[ -d ~/codewiz-skills/.git ] && echo "OK" || echo "MISSING"`
2. **如果缺失**：告诉用户先 clone，不继续：
   ```
   git clone git@github.com:wilson534/codewiz-skills.git ~/codewiz-skills
   cd ~/codewiz-skills
   git remote add gitlab git@code.devops.xiaohongshu.com:pengzhiwei1/codewiz-skills.git
   ```
3. **调底层脚本**：
   ```bash
   bash ~/codewiz-skills/scripts/sync.sh push
   ```
4. **stdout 完整原样展示给用户**（不要总结、不要省略）

## 不做的事

- 不自动添加新 skill 到 repo（repo 没有该 skill 目录就跳过）。新增需要用户先在 `~/codewiz-skills/` 下 `mkdir <name>/` 再跑 push
- 不试图统一 GitHub / GitLab 的 git history（两条线从初始 commit 起就独立，脚本接受这个现实）
- 脚本失败时不尝试"修复"——直接展示错误，等用户处理
