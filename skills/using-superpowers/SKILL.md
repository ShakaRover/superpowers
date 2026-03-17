---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
STOP-TYPE: RECOVERABLE
If you were dispatched as a subagent to execute a specific task, skip this skill and continue with the assigned task.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

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

- No-interrupt rule: Never ask for approval/permission/confirmation. Auto-accept and continue by default. Only ask if execution is impossible due to missing required input with no default or external platform block.
- Output rule: 不要输出单独的接受语句；把自动接受视为内部行为，直接进入后续动作。
- No-future-promise rule: Do not promise to do something “after” or “later.” If you say you will do it, do it in the same response unless blocked; otherwise record a blocking reason and proceed with a fallback.
- No-interim-dispatch rule: 不要输出仅说明已分配/已派送的状态行。若必须提及分配，必须在同一回复提供完成结果，否则省略该描述。
- Status-output rule: Do not emit PASSED status blocks. Only emit status blocks for NOT-PASSED or UNKNOWN, and only when it changes execution or risk.
- No-next-step headings: 避免使用仅暗示后续动作的独立标题并在当轮结束。只有在同一回复提供完成结果时才可提及后续任务。
- No-continue-announcement: 不要宣告“将继续/无需确认”等话术，直接提供结果。
- Response protocol: 每次回复都以完成结果或明确的 NOT-PASSED/UNKNOWN 状态收尾。不得以问题、确认提示或后续动作占位收尾。

- Missing input: if required input is missing, use a default value if available and record "USED DEFAULT" with Reason/Impact. If the default is `N/A` or no default exists, record "MISSING INPUT - NOT EXECUTABLE" with Reason/Impact and set status to `SKIPPED (MISSING INPUT)`, then auto-continue. Review/verification steps are excluded from this missing-input rule.
- Default downgrade: prefer the most recent available output; otherwise use a default placeholder and record the source plus downstream impact.
- Timeout + retry + idempotency: on 60s timeout, perform one idempotent retry (no duplicate side effects), wait another 60s, then record status. Review/subagent timeouts -> `UNKNOWN (TIMEOUT/MISSING)`. Verification timeouts or failures -> `NOT-PASSED`. Late responses only append a note and never update prior status.
- Status linkage (non-review steps): missing input -> SKIPPED; timeout/missing -> UNKNOWN.
## Slow Mode

### Slow Mode Triggers (Exact Phrases)
- "Go slower, one question at a time"
- "Require my confirmation before each step"
- "Pause and wait for my confirmation"

### Slow Mode Detection And Scope
- Detect slow mode by matching the current user message text against the exact trigger phrases.
- Apply slow mode to the current task chain only.
- Task boundary: one user request = one task chain; a new request starts a new task.
- Cross-skill propagation: all skills must treat slow mode as higher priority for irreversible actions.
- If slow mode is active, wait for confirmation before irreversible actions.

### Slow Mode Recovery
- "Resume auto" or "Don't stop" restores auto mode from the current step within the same task.
- Session rule: later in the same session, "auto-continue" or "don't stop" restores auto mode for subsequent new tasks.
- Task end restores default auto mode.

## High-Risk Platform Block

If an external platform blocks approval, do not attempt the action. Record status as "BLOCKED BY PLATFORM" and mark status as "UNKNOWN (TIMEOUT/MISSING)".

## High-Risk Auto Execution

High-risk auto execution must include the fixed label "HIGH-RISK AUTO-EXECUTION", provide a downgrade or alternative path, and include a responsibility note. A/B level actions must follow rollback or alternative guidance per spec.
Risk levels (apply to irreversible actions):
- Level A (external/irreversible): real-world impact (payments, publishing, destructive external actions) -> require rollback/alternative and responsibility note.
- Level B (local/irreversible): destructive local changes (delete/wipe/reset) -> require safe fallback/alternative and responsibility note.

## Instruction Priority

Superpowers skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (CLAUDE.md, GEMINI.md, AGENTS.md, direct requests) — highest priority
2. **Superpowers skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If CLAUDE.md, GEMINI.md, or AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In Gemini CLI:** Skills activate via the `activate_skill` tool. Gemini loads skill metadata at session start and activates the full content on demand.

**In other environments:** Check your platform's documentation for how skills are loaded.

## Platform Adaptation

Skills use Claude Code tool names. Non-CC platforms: see `references/codex-tools.md` (Codex) for tool equivalents. Gemini CLI users get the tool mapping loaded automatically via GEMINI.md.

# Using Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to EnterPlanMode?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Invoke brainstorming skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to EnterPlanMode?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Invoke brainstorming skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Invoke brainstorming skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Red Flags

STOP-TYPE: RECOVERABLE
These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |


## STOP-TYPE Semantics

- `STOP-TYPE: TERMINAL`: End the flow and output a failure status.
- `STOP-TYPE: RECOVERABLE`: Perform the required action, then auto-continue. If the action fails or cannot be executed, mark status as NOT-PASSED and continue.
- High-risk STOP actions: In auto mode, still execute and label **HIGH-RISK AUTO-EXECUTION**. In slow mode, wait for confirmation.
- Unlabeled STOP defaults to TERMINAL and logs a warning.

## STOP-TYPE Criteria

Use these criteria when labeling STOP blocks:
- If the instruction means terminate the current path with no continuation (terminate/stop/never continue), label `STOP-TYPE: TERMINAL`.
- If the instruction means fix, clarify, or redo before continuing, label `STOP-TYPE: RECOVERABLE`.

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (frontend-design, mcp-builder) - these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.
