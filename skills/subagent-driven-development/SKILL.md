---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks in the current session
---

# Subagent-Driven Development

Execute plan by dispatching fresh subagent per task, with two-stage review after each: spec compliance review first, then code quality review.

**Why subagents:** You delegate tasks to specialized agents with isolated context. By precisely crafting their instructions and context, you ensure they stay focused and succeed at their task. They should never inherit your session's context or history — you construct exactly what they need. This also preserves your own context for coordination work.

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

- Idempotency key: skill name + step name + action ID + 60s window (window starts at first trigger).

- Missing input: if required input is missing, use a default value if available and record "USED DEFAULT" with Reason/Impact. If the default is `N/A` or no default exists, record "MISSING INPUT - NOT EXECUTABLE" with Reason/Impact and set status to `SKIPPED (MISSING INPUT)`, then auto-continue. Review/verification steps are excluded from this missing-input rule.
- Default downgrade: prefer the most recent available output; otherwise use a default placeholder and record the source plus downstream impact.
- Timeout + retry + idempotency: on 60s timeout, perform one idempotent retry (no duplicate side effects), wait another 60s, then record status. Review/subagent timeouts -> `UNKNOWN (TIMEOUT/MISSING)`. Verification timeouts or failures -> `NOT-PASSED`. Late responses only append a note and never update prior status.
- Status linkage (non-review steps): missing input -> SKIPPED; timeout/missing -> UNKNOWN.
- Output rule: 不要叙述等待子代理的过程。启动子代理后在结果返回或超时后直接进入评审；避免任何等待或确认话术。
- No pause rule: Never end a turn after dispatching a subagent. Always wait for completion (or timeout + retry), then continue to review or next task in the same turn.
- Re-dispatch rule: When a task is re-dispatched, do not summarize and stop. Wait for the re-dispatch to complete in the same turn and proceed immediately to review/next task.
- Banned phrasing: 不要输出任何将来时占位语句（例如“我会等待/完成后再看/稍后继续”等）。如需等待工具结果，应等待完成并在同一回复给出结果。
- Tool-truth rule: Never claim a subagent was dispatched unless a Task/spawn_agent tool call actually occurred in this turn. If tool dispatch is unavailable or fails, immediately fall back to `executing-plans` and continue without mentioning subagents.
- Single-turn rule: Do not emit partial progress summaries. Only respond after all dispatched subagents for the current step have returned (or timed out + retried) and you have produced the review results or failure/unknown status.
- Progress output rule: Never state that you “will” review later. Report review outcomes or timeouts immediately in the same response.
- Dispatch wording rule: 不要输出仅说明已分配/已派送的中间状态行。只报告完成结果（任务 + 评审）或明确回退到 `executing-plans`。
- Review-dispatch rule: 除非在同一回复提供评审结果，否则不要说明评审已分配。若评审尚未完成，应等待（或超时重试）后再报告结果，不要描述分配过程。
- Banned phrases: 禁止输出任何“等待/后续再做/之后继续”的占位说法；只报告已完成结果。
- Also avoid standalone headings that imply a follow-on action at end of turn. Only mention follow-on tasks when you also provide completed review results in the same response.
- Capability gate: If the environment cannot actually execute subagent tools, do NOT use this skill. Immediately switch to `executing-plans` and continue without mentioning subagents or review dispatch.
- Output gate: Never output intermediate “in-progress” bullet summaries. Only output task results after reviews are complete or explicitly timed out.
## When to Use

```dot
digraph when_to_use {
    "Have implementation plan?" [shape=diamond];
    "Tasks mostly independent?" [shape=diamond];
    "Stay in this session?" [shape=diamond];
    "subagent-driven-development" [shape=box];
    "executing-plans" [shape=box];
    "Manual execution or brainstorm first" [shape=box];

    "Have implementation plan?" -> "Tasks mostly independent?" [label="yes"];
    "Have implementation plan?" -> "Manual execution or brainstorm first" [label="no"];
    "Tasks mostly independent?" -> "Stay in this session?" [label="yes"];
    "Tasks mostly independent?" -> "Manual execution or brainstorm first" [label="no - tightly coupled"];
    "Stay in this session?" -> "subagent-driven-development" [label="yes"];
    "Stay in this session?" -> "executing-plans" [label="no - parallel session"];
}
```

**vs. Executing Plans (parallel session):**
- Same session (no context switch)
- Fresh subagent per task (no context pollution)
- Two-stage review after each task: spec compliance first, then code quality
- Faster iteration (no human-in-loop between tasks)

## The Process

### Step 0: Subagent Tool Availability Probe

Attempt a minimal subagent dispatch (one-line acknowledgment). If the Task/spawn_agent tool is unavailable or errors, immediately switch to `executing-plans` and continue without mentioning subagents or dispatch. This is mandatory; do not attempt subagent-driven execution when the probe fails.

```dot
digraph process {
    rankdir=TB;

    subgraph cluster_per_task {
        label="Per Task";
        "Dispatch implementer subagent (./implementer-prompt.md)" [shape=box];
        "Implementer subagent blocked?" [shape=diamond];
        "Provide context, re-dispatch" [shape=box];
        "Implementer subagent implements, tests, commits, self-reviews" [shape=box];
        "Dispatch spec reviewer subagent (./spec-reviewer-prompt.md)" [shape=box];
        "规格符合并进入后续流程" [shape=diamond];
        "Implementer subagent fixes spec gaps" [shape=box];
        "Dispatch code quality reviewer subagent (./code-quality-reviewer-prompt.md)" [shape=box];
        "质量检查通过并进入后续流程" [shape=diamond];
        "Implementer subagent fixes quality issues" [shape=box];
        "Mark task complete in TodoWrite" [shape=box];
    }

    "Read plan, extract all tasks with full text, note context, create TodoWrite" [shape=box];
    "More tasks remain?" [shape=diamond];
    "Dispatch final code reviewer subagent for entire implementation" [shape=box];
    "Use superpowers:finishing-a-development-branch" [shape=box style=filled fillcolor=lightgreen];

    "Read plan, extract all tasks with full text, note context, create TodoWrite" -> "Dispatch implementer subagent (./implementer-prompt.md)";
    "Dispatch implementer subagent (./implementer-prompt.md)" -> "Implementer subagent blocked?";
    "Implementer subagent blocked?" -> "Provide context, re-dispatch" [label="yes"];
    "Provide context, re-dispatch" -> "Dispatch implementer subagent (./implementer-prompt.md)";
    "Implementer subagent blocked?" -> "Implementer subagent implements, tests, commits, self-reviews" [label="no"];
    "Implementer subagent implements, tests, commits, self-reviews" -> "Dispatch spec reviewer subagent (./spec-reviewer-prompt.md)";
    "Dispatch spec reviewer subagent (./spec-reviewer-prompt.md)" -> "规格符合并进入后续流程";
    "规格符合并进入后续流程" -> "Implementer subagent fixes spec gaps" [label="no"];
    "Implementer subagent fixes spec gaps" -> "Dispatch spec reviewer subagent (./spec-reviewer-prompt.md)" [label="re-review"];
    "规格符合并进入后续流程" -> "Dispatch code quality reviewer subagent (./code-quality-reviewer-prompt.md)" [label="yes"];
    "Dispatch code quality reviewer subagent (./code-quality-reviewer-prompt.md)" -> "质量检查通过并进入后续流程";
    "质量检查通过并进入后续流程" -> "Implementer subagent fixes quality issues" [label="no"];
    "Implementer subagent fixes quality issues" -> "Dispatch code quality reviewer subagent (./code-quality-reviewer-prompt.md)" [label="re-review"];
    "质量检查通过并进入后续流程" -> "Mark task complete in TodoWrite" [label="yes"];
    "Mark task complete in TodoWrite" -> "More tasks remain?";
    "More tasks remain?" -> "Dispatch implementer subagent (./implementer-prompt.md)" [label="yes"];
    "More tasks remain?" -> "Dispatch final code reviewer subagent for entire implementation" [label="no"];
    "Dispatch final code reviewer subagent for entire implementation" -> "Use superpowers:finishing-a-development-branch";
}
```

## Model Selection

Use the least powerful model that can handle each role to conserve cost and increase speed.

**Mechanical implementation tasks** (isolated functions, clear specs, 1-2 files): use a fast, cheap model. Most implementation tasks are mechanical when the plan is well-specified.

**Integration and judgment tasks** (multi-file coordination, pattern matching, debugging): use a standard model.

**Architecture, design, and review tasks**: use the most capable available model.

**Task complexity signals:**
- Touches 1-2 files with a complete spec → cheap model
- Touches multiple files with integration concerns → standard model
- Requires design judgment or broad codebase understanding → most capable model

## Handling Implementer Status

Implementer subagents report one of four statuses. Handle each appropriately:

**DONE:** Proceed to spec compliance review.

**DONE_WITH_CONCERNS:** The implementer completed the work but flagged doubts. Read the concerns before proceeding. If the concerns are about correctness or scope, address them before review. If they're observations (e.g., "this file is getting large"), note them and proceed to review.

**NEEDS_CONTEXT:** The implementer needs information that wasn't provided. Provide the missing context and re-dispatch.

**BLOCKED:** The implementer cannot complete the task. Assess the blocker:
1. If it's a context problem, provide more context and re-dispatch with the same model
2. If the task requires more reasoning, re-dispatch with a more capable model
3. If the task is too large, break it into smaller pieces
4. If the plan itself is wrong, escalate to the human

**Never** ignore an escalation or force the same model to retry without changes. If the implementer said it's stuck, something needs to change.

## Prompt Templates

- `./implementer-prompt.md` - Dispatch implementer subagent
- `./spec-reviewer-prompt.md` - Dispatch spec compliance reviewer subagent
- `./code-quality-reviewer-prompt.md` - Dispatch code quality reviewer subagent

## Example Workflow

```
You: I'm using Subagent-Driven Development to execute this plan.

[Read plan file once: docs/superpowers/plans/feature-plan.md]
[Extract all 5 tasks with full text and context]
[Create TodoWrite with all tasks]

Task 1: Hook installation script

[Get Task 1 text and context (already extracted)]
[Dispatch implementation subagent with full task text + context]

Implementer: Proceeds with user-level default (~/.config/superpowers/hooks/) and records the assumption.
[Later] Implementer:
  - Implemented install-hook command
  - Added tests, 5/5 passing
  - Self-review: Found I missed --force flag, added it
  - Committed

[Run spec compliance review and report result]
Spec reviewer: ✅ Spec compliant - all requirements met, nothing extra

[Run code quality review and report result]
Code reviewer: Strengths: Good test coverage, clean. Issues: None.

[Mark Task 1 complete]

Task 2: Recovery modes

[Get Task 2 text and context (already extracted)]
[Dispatch implementation subagent with full task text + context]

Implementer: [No questions, proceeds]
Implementer:
  - Added verify/repair modes
  - 8/8 tests passing
  - Self-review: All good
  - Committed

[Dispatch spec compliance reviewer]
Spec reviewer: ❌ Issues:
  - Missing: Progress reporting (spec says "report every 100 items")
  - Extra: Added --json flag (not requested)

[Implementer fixes issues]
Implementer: Removed --json flag, added progress reporting

[Spec reviewer reviews again]
Spec reviewer: ✅ Spec compliant now

[Dispatch code quality reviewer]
Code reviewer: Strengths: Solid. Issues (Important): Magic number (100)

[Implementer fixes]
Implementer: Extracted PROGRESS_INTERVAL constant

[Code reviewer reviews again]
Code reviewer: ✅ Approved

[Mark Task 2 complete]

...

[After all tasks]
[Dispatch final code-reviewer]
Final reviewer: All requirements met, ready to merge

Done!
```

## Advantages

**vs. Manual execution:**
- Subagents follow TDD naturally
- Fresh context per task (no confusion)
- Parallel-safe (subagents don't interfere)
- Subagent proceeds with explicit assumptions; only blocks if execution is impossible

**vs. Executing Plans:**
- Same session (no handoff)
- Continuous progress (no waiting)
- Review checkpoints automatic

**Efficiency gains:**
- No file reading overhead (controller provides full text)
- Controller curates exactly what context is needed
- Subagent gets complete information upfront
- Questions surfaced before work begins (not after)

**Quality gates:**
- Self-review catches issues before handoff
- Two-stage review: spec compliance, then code quality
- Review loops ensure fixes actually work
- Spec compliance prevents over/under-building
- Code quality ensures implementation is well-built

**Cost:**
- More subagent invocations (implementer + 2 reviewers per task)
- Controller does more prep work (extracting all tasks upfront)
- Review loops add iterations
- But catches issues early (cheaper than debugging later)

## Red Flags

**Never:**
- Start implementation on main/master branch without a worktree
- Skip reviews (spec compliance OR code quality)
- Proceed with unfixed issues
- Dispatch multiple implementation subagents in parallel (conflicts)
- Make subagent read plan file (provide full text instead)
- Skip scene-setting context (subagent needs to understand where task fits)
- Ignore subagent blocked/needs-context reports (resolve before letting them proceed)
- Accept "close enough" on spec compliance (spec reviewer found issues = not done)
- Skip review loops (reviewer found issues = implementer fixes = review again)
- Let implementer self-review replace actual review (both are needed)
- **Start code quality review before spec compliance is ✅** (wrong order)
- Move to next task while either review has open issues
- End the message right after dispatching a subagent (no pause rule)

**If subagent is blocked:**
- Answer clearly and completely
- Provide additional context if needed
- Don't rush them into implementation

**If reviewer finds issues:**
- Implementer (same subagent) fixes them
- Reviewer reviews again
- Repeat until approved
- Don't skip the re-review

**If subagent fails task:**
- Dispatch fix subagent with specific instructions
- Don't try to fix manually (context pollution)

## Integration

**Required workflow skills:**
- **superpowers:using-git-worktrees** - REQUIRED: Set up isolated workspace before starting
- **superpowers:writing-plans** - Creates the plan this skill executes
- **superpowers:requesting-code-review** - Code review template for reviewer subagents
- **superpowers:finishing-a-development-branch** - Complete development after all tasks

**Subagents should use:**
- **superpowers:test-driven-development** - Subagents follow TDD for each task

**Alternative workflow:**
- **superpowers:executing-plans** - Use for parallel session instead of same-session execution
