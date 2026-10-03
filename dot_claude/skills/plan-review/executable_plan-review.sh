#!/usr/bin/env bash
# Open a plan in Plannotator with an Approve button.
# Usage: plan-review.sh [plan.md]  (default: newest plan in ~/.claude/plans)
set -euo pipefail

plan="${1:-}"
if [ -z "$plan" ]; then
    plan=$(ls -t "$HOME"/.claude/plans/*.md 2>/dev/null | head -n 1) || true
fi
if [ -z "$plan" ] || [ ! -f "$plan" ]; then
    echo "plan-review: no plan file found (${plan:-~/.claude/plans/*.md})" >&2
    exit 1
fi

exec plannotator annotate "$plan" --gate --json
