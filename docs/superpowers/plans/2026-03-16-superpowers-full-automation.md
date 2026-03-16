# Superpowers Full Automation Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make all superpowers skills run fully automatically by default (no waiting), while preserving existing flow strength and documenting consistent AUTO-CONTINUE behavior.

**Architecture:** Add a single AUTO-CONTINUE block per skill, replace confirmation-gate wording with auto-continue wording, and add STOP-TYPE annotations where needed. Keep workflow structure intact while changing “wait for approval” semantics to “auto-continue with traceable status.”

**Tech Stack:** Markdown skills (`SKILL.md`), git, ripgrep (`rg`)

---

## Chunk 1: Skill Automation Updates

### Task 1: Create Automation Worktree

**Files:**
- None (worktree directory created externally)

- [ ] **Step 1: Create a dedicated worktree**

Run: `git worktree add ../superpowers-auto-$(date +%Y%m%d) -b superpowers-auto-$(date +%Y%m%d)`
Expected: A new worktree directory is created and checked out at `../superpowers-auto-YYYYMMDD`

- [ ] **Step 2: Verify repo status in worktree**

Run: `git status --short`
Expected: Clean working tree

### Task 2: Add AUTO-CONTINUE Block Template to All Skills

**Files:**
- Modify: `skills/brainstorming/SKILL.md`
- Modify: `skills/dispatching-parallel-agents/SKILL.md`
- Modify: `skills/executing-plans/SKILL.md`
- Modify: `skills/finishing-a-development-branch/SKILL.md`
- Modify: `skills/receiving-code-review/SKILL.md`
- Modify: `skills/requesting-code-review/SKILL.md`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Modify: `skills/systematic-debugging/SKILL.md`
- Modify: `skills/test-driven-development/SKILL.md`
- Modify: `skills/using-git-worktrees/SKILL.md`
- Modify: `skills/using-superpowers/SKILL.md`
- Modify: `skills/verification-before-completion/SKILL.md`
- Modify: `skills/writing-plans/SKILL.md`
- Modify: `skills/writing-skills/SKILL.md`

- [ ] **Step 1: Insert AUTO-CONTINUE block in each skill**

Add this block once per skill. Place it per spec priority:
1) Overview paragraph下方
2) Key Principles 段落上方
3) 若无以上段落，放在首个 H2 前
4) 若无 H2，放在首段之后

```markdown
AUTO-CONTINUE: ON
- 默认值/推荐答案：如有则写明；无则写 N/A
- 推荐原因：如有则写明；无则写 N/A
- 假设与适用范围：默认全自动；慢速模式例外
- 风险提示（如有）：高风险动作将记录提示
- 完成宣称约束：若验证失败/审阅未通过，只记录失败，不宣称完成
```

- [ ] **Step 2: Ensure each skill has only one AUTO-CONTINUE block**

Run:
```bash
for f in $(rg --files -g "SKILL.md" skills); do
  c=$(rg -n "AUTO-CONTINUE: ON" -c "$f")
  echo "$f:$c"
done | rg -v ":1$"
```
Expected: No output (all skills have exactly 1 match)

- [ ] **Step 3: Add new-skill onboarding rule**

In BOTH `skills/using-superpowers/SKILL.md` and `skills/writing-skills/SKILL.md`, add:
- New skills must include AUTO-CONTINUE.
- Acceptance checklist: AUTO-CONTINUE position, confirmation replacement, STOP coverage.

### Task 3: Replace Confirmation Gates with Auto-Continue Wording

**Files:**
- Modify: same 14 skill files as Task 2

- [ ] **Step 1: Locate confirmation gates (keywords + phrases)**

Run: `rg -n "请确认|请审阅|是否继续|等你确认|等待批准|review gate|must wait|wait for approval|ask user to review" skills`
Expected: Matches listed for manual edit

- [ ] **Step 2: Semantic gate scan (manual)**

Search for semantic gates even without keywords, e.g.:
- “需要/必须 + 用户 + 同意/批准/确认/审阅 + 才能继续/执行”
- “等待用户反馈/批准后继续”

- [ ] **Step 3: Apply decision rules (gate vs explanatory)**

Decision rules from spec (order matters):
- Exclusion first: explanatory-only → append “（已默认继续）”.
- Then semantic gate → replace with “已默认接受并继续”.
- Then keyword gate (only if exclusion not triggered) → replace.
- Mixed phrasing always treated as gate → replace.
- Output rule: each line is either replacement or append, never both.

- [ ] **Step 4: Manual confirmation-point labeling when ambiguous**

Add `CONFIRMATION-POINT: <原话术>` line above ambiguous gates to force replacement.

- [ ] **Step 5: Special case — Visual Companion**

Replace any visual-companion prompts with:
“已默认不启用视觉伴侣并继续”

同时在视觉伴侣定义处增加慢速模式提示语：
“慢速模式下恢复视觉伴侣询问并等待确认。”

- [ ] **Step 6: Re-scan for semantic gates**

After edits, re-scan the same patterns to ensure no semantic gates remain.

### Task 4: STOP-TYPE Annotations and Behavior Alignment

**Files:**
- Modify: all skill files that contain STOP language (use `rg -n "STOP" skills` to locate)

- [ ] **Step 1: Add STOP-TYPE labels**

Use these annotations near STOP blocks:
- `STOP-TYPE: TERMINAL`
- `STOP-TYPE: RECOVERABLE`

- [ ] **Step 2: Apply STOP handling rules**

Ensure STOP semantics match spec:
- TERMINAL: end flow, output failure state
- RECOVERABLE: perform action, auto-continue; if fail/unexecutable, mark “未通过” and continue
- High-risk STOP action: in auto mode still execute but must label “高风险自动执行”; in slow mode wait for confirmation
- Unlabeled STOP defaults to TERMINAL and logs a warning

- [ ] **Step 3: Add STOP判定准则**

Add to STOP guidance:
- “终止/停止继续/不得继续” → TERMINAL
- “修复后继续/重做后继续” → RECOVERABLE

- [ ] **Step 4: Verify STOP coverage**

Run: `rg -n "STOP" skills` and confirm each STOP block has `STOP-TYPE:` nearby.
Expected: No STOP without STOP-TYPE

### Task 5: Slow Mode Overrides and High-Risk Behavior

**Files:**
- Modify: `skills/using-superpowers/SKILL.md` (global rule)
- Modify: all skills containing irreversible actions (expand based on Step 3 scan)

- [ ] **Step 1: Add slow-mode trigger list + detection**

Add explicit trigger phrases, detection, and scope:
- “慢一点，一次问一个问题”
- “每一步都需要我确认再继续”
- “暂停并等我确认”
- Detection: current user message text match; applies to current task chain.
- Task boundary: one user request = one task chain; new request starts a new task.
- Also add cross-skill propagation rule: all skills must reference slow-mode priority for irreversible actions.

- [ ] **Step 2: Add slow-mode recovery + session recovery**

Add explicit rule: “恢复自动/别停” restores auto mode from the current step within the same task.
Add session rule: If later in the same session user says “自动继续/别停”, restore auto mode for subsequent new tasks.
Task end restores default auto mode.

- [ ] **Step 3: Scan for irreversible actions and ensure slow-mode coverage**

Run: `rg -n "删除|发布|支付|不可逆|重置|清空|覆盖|卸载|发送|destroy|wipe" skills`
Expected: Any skill with such terms includes slow-mode wait-for-confirmation rule. If no matches, no additional slow-mode edits required.

- [ ] **Step 4: Add high-risk platform block**

Include clause: if external platform blocks approval, do not attempt; record “被平台阻断”，并标记状态为“未知（超时/缺失）”。
Also require: high-risk auto execution must include fixed label “高风险自动执行” + downgrade/alternative path + responsibility note; A/B级按规范执行回滚/替代。

### Task 6: Consistent Status Output Language

**Files:**
- Modify: `skills/verification-before-completion/SKILL.md`
- Modify: `skills/executing-plans/SKILL.md`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Modify: `skills/using-superpowers/SKILL.md`
- Modify: `skills/requesting-code-review/SKILL.md`
- Modify: `skills/receiving-code-review/SKILL.md`
- Modify: `skills/dispatching-parallel-agents/SKILL.md`

- [ ] **Step 1: Add full status output format snippet**

Add snippet:
- `状态：未通过` / `状态：未知（超时/缺失）` / `状态：已跳过（缺失输入）`
- `原因：...`
- `影响：...`
- `继续策略：已自动继续`

- [ ] **Step 2: Add late-response handling**

Add line: late responses only append “迟到响应” notes and never update prior status.

- [ ] **Step 3: Add record ownership/location**

Add line: status records are written only in the assistant reply (no mandatory persistence).

### Task 7A: Missing-Input + Downgrade + Timeout/Idempotency Rules (Explicit)

**Files:**
- Modify: `skills/using-superpowers/SKILL.md`
- Modify: `skills/executing-plans/SKILL.md`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Modify: `skills/requesting-code-review/SKILL.md`
- Modify: `skills/receiving-code-review/SKILL.md`
- Modify: `skills/verification-before-completion/SKILL.md`
- Modify: `skills/dispatching-parallel-agents/SKILL.md`

- [ ] **Step 1: 明确“必需输入缺失”处理**

写明：有默认值则使用并记录“使用默认值”；无默认值则记录“缺失输入-不可执行”，状态为“已跳过（缺失输入）”；验证/审阅步骤不适用此规则。

- [ ] **Step 2: 明确“默认降级策略”**

写明：优先使用最近一次可用输出；否则使用默认值占位并记录来源与对下游影响。

- [ ] **Step 3: 明确“超时 + 重试 + 幂等”**

写明：审阅/子代理超时→未知；验证超时/失败→未通过；60s 超时触发一次幂等重试；迟到响应仅记录不更新状态。

### Task 7: Apply Core Execution Rules (timeouts, retries, idempotency, defaults)

**Files:**
- Modify: `skills/using-superpowers/SKILL.md`
- Modify: `skills/executing-plans/SKILL.md`
- Modify: `skills/subagent-driven-development/SKILL.md`
- Modify: `skills/requesting-code-review/SKILL.md`
- Modify: `skills/receiving-code-review/SKILL.md`
- Modify: `skills/verification-before-completion/SKILL.md`
- Modify: `skills/dispatching-parallel-agents/SKILL.md`

- [ ] **Step 1: Add timeout + retry rules**

Document: review/subagent timeout → 状态“未知”; verification timeout/失败 → 状态“未通过”.
Process: wait 60s, retry once (idempotent), wait another 60s, then apply the correct status above. If a skill already defines stricter timeouts/blocking, follow the skill rule.

- [ ] **Step 2: Add idempotency key rule**

Document: key = skill name + step name + action ID + 60s window (start at first trigger). Late responses are discarded with a note.

- [ ] **Step 3: Add default downgrade rules**

Document: use last available output; if none, use default value and record “使用默认值” + “输入缺失” + downgrade source + downstream impact.
If default is `N/A`, record “缺失输入-不可执行”，状态为“已跳过（缺失输入）”.
Validation/review steps are excluded from this rule; they must follow failure/unknown status paths.

### Task 8: Coverage Checklist and Commit

**Files:**
- Modify: all changed skill files
- Create: `docs/superpowers/plans/2026-03-16-superpowers-full-automation-coverage.md`

- [ ] **Step 1: Build coverage checklist**

Record per-skill summary in `docs/superpowers/plans/2026-03-16-superpowers-full-automation-coverage.md`:
- AUTO-CONTINUE 位置
- 确认点替换完成
- STOP 标注覆盖率
- 慢速模式规则
- 审阅/验证非阻塞规则

- [ ] **Step 2: Scan for missing AUTO-CONTINUE**

Run:
```bash
for f in $(rg --files -g "SKILL.md" skills); do
  c=$(rg -n "AUTO-CONTINUE: ON" -c "$f")
  echo "$f:$c"
done | rg -v ":1$"
```
Expected: No output (all skills have exactly 1 match)

- [ ] **Step 3: Ensure no residual confirmation gates remain**

Run: `rg -n "请确认|请审阅|是否继续|等你确认|等待批准|review gate|must wait|wait for approval|ask user to review" skills`
Expected: No gate phrases except explanatory cases with “（已默认继续）”

- [ ] **Step 4: Ensure no visual-companion prompts remain**

Run: `rg -n "视觉伴侣|visual companion" skills`
Expected: Only informational statements; no questions/prompts except in slow-mode note

- [ ] **Step 5: Commit changes**

Run:
```bash
git add skills docs/superpowers/plans/2026-03-16-superpowers-full-automation-coverage.md
git commit -m "实现 superpowers 全自动执行规则"
```
Expected: Commit created

### Task 9: Acceptance Scenario Checks

**Files:**
- Modify: `skills/brainstorming/SKILL.md`
- Modify: `skills/writing-skills/SKILL.md`
- Modify: `skills/verification-before-completion/SKILL.md`

- [ ] **Step 1: Brainstorming scenario**

Verify `skills/brainstorming/SKILL.md` contains:
- AUTO-CONTINUE block
- Visual companion default skip text
- No “请确认/是否继续” gates
Expected: All present

- [ ] **Step 2: Writing-skills scenario**

Verify `skills/writing-skills/SKILL.md` contains:
- STOP-TYPE labels
- RECOVERABLE/TERMINAL handling
Expected: All present

- [ ] **Step 3: Verification-before-completion scenario**

Verify `skills/verification-before-completion/SKILL.md` contains:
- Status output format
- Timeout/failed handling
Expected: All present

- [ ] **Step 4: 完成计划审阅循环**

使用 `skills/writing-plans/plan-document-reviewer-prompt.md` 派发 Chunk 1 审阅，引用规格 `docs/superpowers/specs/2026-03-16-superpowers-full-automation-design.md`，修复问题并复审直到 Approved。

Note: Chunk 1 already includes missing-input handling, review/verification timeout+retry, idempotency keys, and downgrade strategy in Task 7.

