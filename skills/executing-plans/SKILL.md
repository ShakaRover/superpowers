---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints (Auto-continue)
---

# Executing Plans

## Overview

Load plan, review critically, execute all tasks, report when complete (Auto-continue).

AUTO-CONTINUE: ON
- Default/Recommended Answer: N/A
- Recommendation Rationale: N/A
- Assumptions/Scope: Full automation by default; slow mode is an exception
- Risk Note (if any): High-risk actions will be flagged
- Completion-claim constraint: If verification fails or review does not pass, record failure only; do not claim completion (auto-continue).

Status Output Language
- Status: PASSED / NOT-PASSED / UNKNOWN (TIMEOUT/MISSING) / SKIPPED (MISSING INPUT)
- Reason: ...
- Impact: ...
- Continuation Strategy: AUTO-CONTINUE

Status Output Rules
- Late responses only append a "late response" note and never update prior status.
- Status records are written only in the assistant reply (no mandatory persistence).

## Operational Rules

- Missing input: record status as `SKIPPED (MISSING INPUT)` with Reason/Impact, then auto-continue.
- Blocked or risky execution: prefer a safe downgrade/alternative path, record the decision and why.
- Timeout or missing result: record status as `UNKNOWN (TIMEOUT/MISSING)` and auto-continue.
- Retries must be idempotent, limited, and record attempt count/outcomes.
- Status linkage: missing input -> SKIPPED; timeout/missing -> UNKNOWN.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** Tell your human partner that Superpowers works much better with access to subagents. The quality of its work will be significantly higher if run on a platform with subagent support (such as Claude Code or Codex). If subagents are available, use superpowers:subagent-driven-development instead of this skill.

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use superpowers:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

STOP-TYPE: RECOVERABLE
**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without Auto-accepted and continuing

## Integration

**Required workflow skills:**
- **superpowers:using-git-worktrees** - REQUIRED: Set up isolated workspace before starting
- **superpowers:writing-plans** - Creates the plan this skill executes
- **superpowers:finishing-a-development-branch** - Complete development after all tasks
