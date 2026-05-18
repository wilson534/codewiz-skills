#!/usr/bin/env bash
# sync.sh — codewiz-skills 双向同步
#
# Usage:
#   ./scripts/sync.sh push   # ~/.claude/skills/* → repo → commit + push 双 remote
#   ./scripts/sync.sh pull   # git pull origin → 复制回 ~/.claude/skills/
#
# 设计要点：
# - 真源是 ~/.claude/skills/<name>/（cc 加载的位置），repo 是镜像
# - repo 关联两个 remote：origin (GitHub, QQ 邮箱) + gitlab (公司 GitLab, 公司邮箱)
# - GitLab main 是 protected branch，禁止 force push → push 时新建临时分支
#   sync-gitlab（基于 gitlab/main），用公司邮箱签 commit，fast-forward push
# - 双 remote 历史从一开始就独立（无共同祖先），脚本不试图统一历史
# - trap EXIT 强保证身份恢复为 GitHub，不污染下次 commit
#
# 同步范围：repo 里已存在的每个顶层目录（除 scripts/）。
# push 时如果 ~/.claude/skills/<name>/ 不存在，跳过该 skill 不动 repo 里的版本。

set -euo pipefail

cmd="${1:-}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_LOCAL="$HOME/.claude/skills"

GITHUB_EMAIL="3098848445@qq.com"
GITHUB_NAME="wilson534"
GITLAB_EMAIL="pengzhiwei1@xiaohongshu.com"
GITLAB_NAME="pengzhiwei1"

cd "$REPO_ROOT"

use_github_identity() {
  git config user.email "$GITHUB_EMAIL"
  git config user.name "$GITHUB_NAME"
}

use_gitlab_identity() {
  git config user.email "$GITLAB_EMAIL"
  git config user.name "$GITLAB_NAME"
}

# 列 repo 里的 skill 目录（排除 scripts/、.git/）
list_skills() {
  for d in "$REPO_ROOT"/*/; do
    name=$(basename "$d")
    [ "$name" = "scripts" ] && continue
    echo "$name"
  done
}

case "$cmd" in
  push)
    # 兜底：脚本因任何原因退出时，把身份恢复为 GitHub
    trap "use_github_identity 2>/dev/null || true" EXIT
    use_github_identity

    echo "📦 同步 ~/.claude/skills/ → repo..."
    n=0
    for name in $(list_skills); do
      local_skill="$SKILLS_LOCAL/$name"
      repo_skill="$REPO_ROOT/$name"
      if [ -d "$local_skill" ]; then
        rsync -a --delete --exclude='.DS_Store' "$local_skill/" "$repo_skill/"
        echo "  ↑ $name"
        n=$((n+1))
      else
        echo "  ⏭️  $name（~/.claude/skills/ 不存在，跳过）"
      fi
    done
    [ "$n" -eq 0 ] && { echo "ℹ️  没有 skill 可同步"; exit 0; }

    git add -A
    if git diff --cached --quiet; then
      echo "ℹ️  没有变更，无需 commit + push"
      exit 0
    fi

    msg="sync: push skills from local ($(date '+%Y-%m-%d %H:%M'))"
    git commit -m "$msg"
    git push origin "$(git branch --show-current)"
    echo "✅ pushed to GitHub (origin)"

    echo ""
    echo "📦 同步到 GitLab（公司邮箱独立 commit，绕过 protected branch + 邮箱 hook）..."
    git fetch gitlab
    # 清掉残留的临时分支（上次中断时遗留）
    git branch -D sync-gitlab 2>/dev/null || true
    git checkout -b sync-gitlab gitlab/main
    use_gitlab_identity
    git checkout main -- .
    git add -A
    if git diff --cached --quiet; then
      echo "ℹ️  GitLab 已是最新（内容与 main 一致）"
    else
      git commit -m "$msg"
      git push gitlab sync-gitlab:main
      echo "✅ pushed to GitLab (gitlab)"
    fi
    git checkout main
    git branch -D sync-gitlab
    # trap EXIT 自动把身份切回 GitHub
    ;;

  pull)
    use_github_identity
    echo "📥 git pull origin main..."
    git pull origin main

    echo ""
    echo "📦 同步 repo → ~/.claude/skills/..."
    n=0
    for name in $(list_skills); do
      local_skill="$SKILLS_LOCAL/$name"
      repo_skill="$REPO_ROOT/$name"
      mkdir -p "$local_skill"
      rsync -a --delete --exclude='.DS_Store' "$repo_skill/" "$local_skill/"
      echo "  ↓ $name"
      n=$((n+1))
    done
    echo "✅ pulled $n skills from repo to ~/.claude/skills/"
    ;;

  *)
    echo "Usage: $0 {push|pull}"
    exit 1
    ;;
esac
