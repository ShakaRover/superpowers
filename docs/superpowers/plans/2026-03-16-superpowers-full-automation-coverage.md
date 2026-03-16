# Superpowers Full Automation Coverage Checklist (2026-03-16)

Scope: skills changed on this branch and covered by this checklist.

Skills in scope:
- brainstorming
- dispatching-parallel-agents
- executing-plans
- finishing-a-development-branch
- receiving-code-review
- requesting-code-review
- subagent-driven-development
- systematic-debugging
- test-driven-development
- using-git-worktrees
- using-superpowers
- verification-before-completion
- writing-plans
- writing-skills

Coverage checklist (all entries verified in the current `skills/*/SKILL.md` files):

| Skill | AUTO-CONTINUE position | Confirmation replacement complete | STOP coverage | Slow mode rule | Review/verification non-blocking rule |
| --- | --- | --- | --- | --- | --- |
| brainstorming | `AUTO-CONTINUE: ON` block near top (after intro) | Multiple “Auto-accepted and continuing” steps in checklist and flow | N/A (no STOP block in this skill) | Header scope states slow mode exception; explicit slow-mode switch for one-at-a-time questioning | Completion-claim constraint line in header (review/verification failures recorded, auto-continue) |
| dispatching-parallel-agents | `AUTO-CONTINUE: ON` block under Overview | “Continuation Strategy: AUTO-CONTINUE” in Status Output Rules | N/A (no STOP block in this skill) | Header scope states slow mode exception | Completion-claim constraint + review/verification timeout outcomes in Operational Rules |
| executing-plans | `AUTO-CONTINUE: ON` block near top | “Continuation Strategy: AUTO-CONTINUE” in Status Output | STOP-TYPE: RECOVERABLE in “STOP executing immediately when” block | Header scope states slow mode exception | Completion-claim constraint + review/verification timeout outcomes in Operational Rules |
| finishing-a-development-branch | `AUTO-CONTINUE: ON` block near top | “Auto-accepted and continuing” options and fix paths | N/A (no STOP block in this skill) | Header scope + explicit “If slow mode is active, wait for confirmation before irreversible actions.” | Completion-claim constraint line in header |
| receiving-code-review | `AUTO-CONTINUE: ON` block near top | “Continuation Strategy: AUTO-CONTINUE” in Status Output | STOP-TYPE: RECOVERABLE in “STOP - do not implement anything yet” | Header scope states slow mode exception | Completion-claim constraint + review/verification timeout outcomes |
| requesting-code-review | `AUTO-CONTINUE: ON` block near top | “Continuation Strategy: AUTO-CONTINUE” in Status Output | N/A (no STOP block in this skill) | Header scope states slow mode exception | Completion-claim constraint + review/verification timeout outcomes |
| subagent-driven-development | `AUTO-CONTINUE: ON` block near top | “Continuation Strategy: AUTO-CONTINUE” + flow nodes “auto-accepted and continuing” | N/A (no STOP block in this skill) | Header scope states slow mode exception | Completion-claim constraint + review/verification timeout outcomes |
| systematic-debugging | `AUTO-CONTINUE: ON` block near top | Auto-continue in completion-claim constraint; flow does not require confirmation | STOP-TYPE: RECOVERABLE blocks in red flags and “question fundamentals” sections | Header scope states slow mode exception | Completion-claim constraint line in header |
| test-driven-development | `AUTO-CONTINUE: ON` block near top | Auto-continue in completion-claim constraint; flow avoids confirmation gates | STOP-TYPE: RECOVERABLE in “Red Flags - STOP and Start Over” | Header scope + explicit “If slow mode is active, wait for confirmation before irreversible actions.” | Completion-claim constraint line in header |
| using-git-worktrees | `AUTO-CONTINUE: ON` block near top | “Auto-accepted and continuing” decisions and fallbacks across rules | N/A (no STOP block in this skill) | Header scope states slow mode exception | Completion-claim constraint line in header |
| using-superpowers | `AUTO-CONTINUE: ON` block near top | “Continuation Strategy: AUTO-CONTINUE” + auto-continue semantics | SUBAGENT-STOP + STOP-TYPE semantics + STOP criteria blocks | Explicit slow-mode detection and “wait for confirmation before irreversible actions” | Completion-claim constraint + review/verification timeout outcomes |
| verification-before-completion | `AUTO-CONTINUE: ON` block near top | “Continuation Strategy: AUTO-CONTINUE” in Status Output | STOP-TYPE: RECOVERABLE in Red Flags - STOP | Header scope states slow mode exception | Completion-claim constraint + review/verification timeout outcomes |
| writing-plans | `AUTO-CONTINUE: ON` block near top | “Auto-accepted and continuing” gates in plan-chunk loop | N/A (no STOP block in this skill) | Header scope states slow mode exception | Completion-claim constraint line in header |
| writing-skills | `AUTO-CONTINUE: ON` block near top | “Auto-accepted and continuing” in deployment flow | STOP-TYPE: RECOVERABLE in red flags + “STOP: Before Moving to Next Skill” | Header scope + explicit “If slow mode is active, wait for confirmation before irreversible actions.” | Completion-claim constraint line in header |
