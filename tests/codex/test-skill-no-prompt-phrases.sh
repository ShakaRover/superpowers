#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

paths=()
while IFS= read -r file; do
  paths+=("$file")
done < <(rg --files -g 'SKILL.md' skills)

if [ -f "skills/brainstorming/visual-companion.md" ]; then
  paths+=("skills/brainstorming/visual-companion.md")
fi

# Forbidden prompt phrase list for stop/confirmation style outputs.
pattern='auto-accepted and continuing|Auto-accepted and continuing|\\bnext step\\b|\\bnext steps\\b|\\bwhat should i do next\\b|\\bwhat would you like to do\\b|下一步|继续执行|继续推进|请确认|是否继续|已派发|重新派发|派发|\\bif needed,? i can\\b|\\bif you need,? i can\\b|\\bif you want,? i can\\b|如果需要'

matches=$(rg -n --no-heading -S "$pattern" "${paths[@]}" || true)

if [ -n "$matches" ]; then
  echo "Found forbidden prompt phrases in skill docs:"
  echo "$matches"
  exit 1
fi

echo "PASS: no forbidden prompt phrases found in skill docs."
