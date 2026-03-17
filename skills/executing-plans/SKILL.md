---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load the plan, review critically, execute all tasks, report when complete and continue automatically.

AUTO-CONTINUE: ON
- Default/Recommended Answer: N/A
- Recommendation Rationale: N/A
- Assumptions/Scope: Full automation by default; slow mode is an exception
- Risk Note (if any): High-risk actions will be flagged
- Completion-claim constraint: If verification fails or review does not pass, record failure only; do not claim completion (auto-continue).

Status output (internal only)
- Do not output any status blocks labeled `Status/Reason/Impact/Continuation Strategy`.
- If you must express not-passed or unknown, state the reason and impact in one sentence and continue with results in the same reply.

## Operational Rules

- Idempotency key: skill name + step name + action ID + 60s window (window starts at first trigger).
- No-meta-response: Do not describe how you will structure or report output; provide completed results and necessary notes directly.
- Pre-authorized approvals: If the user has explicitly instructed that approvals/confirmations should be auto-accepted for the session, treat that as standing permission for handling unexpected existing changes. Keep existing changes and proceed without asking.

- Missing input: if required input is missing, use a default value if available and record "USED DEFAULT" with Reason/Impact. If the default is `N/A` or no default exists, record "MISSING INPUT - NOT EXECUTABLE" with Reason/Impact and set status to `SKIPPED (MISSING INPUT)`, then auto-continue. Review/verification steps are excluded from this missing-input rule.
- Default downgrade: prefer the most recent available output; otherwise use a default placeholder and record the source plus downstream impact.
- Timeout + retry + idempotency: on 60s timeout, perform one idempotent retry (no duplicate side effects), wait another 60s, then record status. Review/subagent timeouts -> `UNKNOWN (TIMEOUT/MISSING)`. Verification timeouts or failures -> `NOT-PASSED`. Late responses only append a note and never update prior status.
- Status linkage (non-review steps): missing input -> SKIPPED; timeout/missing -> UNKNOWN.
## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Record assumptions and proceed unless the concern makes execution impossible
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to wrap up this work."
- **REQUIRED SUB-SKILL:** Use superpowers:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice
 - Do not emit "next steps" or recommendation lists; execute the default option immediately in the same reply.

## When to Stop and Ask for Help

STOP-TYPE: RECOVERABLE
**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Do not ask for clarification unless execution is impossible.** Prefer proceeding with explicit assumptions and record them.

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask only if there is no safe default or workaround.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch; always use a worktree/feature branch

## Integration

**Required workflow skills:**
- **superpowers:using-git-worktrees** - REQUIRED: Set up isolated workspace before starting
- **superpowers:writing-plans** - Creates the plan this skill executes
- **superpowers:finishing-a-development-branch** - Complete development after all tasks
