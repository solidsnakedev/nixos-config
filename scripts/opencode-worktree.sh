#!/usr/bin/env bash
set -euo pipefail

BRANCH="${1:-worktree-$(date +%s)}"
REPO_ROOT="$(git rev-parse --show-toplevel)" || exit 1
BASE_HEAD="$(git -C "$REPO_ROOT" rev-parse HEAD)"
WORKTREE_DIR="${REPO_ROOT}/.opencode/worktrees/${BRANCH}"
CREATED_WORKTREE=0

cleanup() {
  if [[ "$CREATED_WORKTREE" -ne 1 ]]; then
    return
  fi

  if [[ -z "$(git -C "$WORKTREE_DIR" status --porcelain)" ]] && [[ "$(git -C "$WORKTREE_DIR" rev-parse HEAD)" == "$BASE_HEAD" ]]; then
    git worktree remove "$WORKTREE_DIR"
    git branch -D "$BRANCH"
    echo "Worktree cleaned up."
  else
    echo "Worktree preserved: $WORKTREE_DIR"
    echo "Branch preserved: $BRANCH"
  fi
}

trap cleanup EXIT

git worktree add "$WORKTREE_DIR" -b "$BRANCH" HEAD
CREATED_WORKTREE=1
echo "Worktree created: $WORKTREE_DIR"

opencode "$WORKTREE_DIR"
