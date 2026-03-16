# Codex CLI Test Migration Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Copy `tests/claude-code` to `tests/codex`, replace CLI calls with Codex, and make Codex tests the default.

**Architecture:** Copy the directory, replace CLI usage inside `tests/codex`, update docs and default entry points. Keep the Claude directory for fallback.

**Tech Stack:** Bash, Codex CLI, ripgrep

---

## Chunk 1: Directory Copy and CLI Replacement

### Task 1: Copy tests and switch CLI calls

**Files:**
- Create: `tests/codex/` (copied from `tests/claude-code/`)
- Modify: `tests/codex/run-skill-tests.sh`
- Modify: `tests/codex/test-helpers.sh`

- [ ] **Step 1: Copy directory**

Run: `cp -R tests/claude-code tests/codex`
Expected: `tests/codex` exists with the same structure

- [ ] **Step 2: Locate claude CLI usage**

Run: `rg -n "claude" tests/codex/run-skill-tests.sh tests/codex/test-helpers.sh`
Expected: `claude` references found for replacement

- [ ] **Step 3: Update `tests/codex/run-skill-tests.sh` to use Codex CLI**

Changes:
- `claude --version` → `codex --version`
- CLI availability check → `command -v codex`
- Header text updated to Codex

- [ ] **Step 4: Update `tests/codex/test-helpers.sh` to use Codex CLI**

Changes:
- Use `codex exec` for headless execution
- Capture output with `--output-last-message`
- Fail fast on CLI errors

- [ ] **Step 5: Sanity check**

Run: `rg -n "claude" tests/codex`
Expected: no `claude` CLI references remain

- [ ] **Step 6: Commit**

```bash
git add tests/codex/run-skill-tests.sh tests/codex/test-helpers.sh tests/codex

git commit -m "Add Codex test runner"
```

## Chunk 2: Docs and default entry points

### Task 2: Update docs and default test entry

**Files:**
- Modify: `tests/codex/README.md`
- Modify: `tests/claude-code/README.md` (mark as fallback)
- Modify: any docs/scripts referencing `tests/claude-code` as default

- [ ] **Step 1: Update `tests/codex/README.md`**

Replace Claude references with Codex and update examples.

- [ ] **Step 2: Scan for default entry references**

Run: `rg -n "tests/claude-code|claude-code"`
Expected: find default-entry references

- [ ] **Step 3: Point defaults to `tests/codex`**

Replace default test directory references to `tests/codex`. Keep `tests/claude-code` as fallback only.

- [ ] **Step 4: Commit**

```bash
git add tests/codex/README.md tests/claude-code/README.md

git add <updated entrypoint docs/scripts>

git commit -m "Switch default tests to Codex"
```

## Chunk 3: Verification

### Task 3: Run Codex tests

**Files:**
- Test: `tests/codex/run-skill-tests.sh`

- [ ] **Step 1: Run Codex test**

Run: `./run-skill-tests.sh --test test-subagent-driven-development.sh`
Expected: Test executes using Codex

- [ ] **Step 2: Record results**

If failures occur, follow `superpowers:systematic-debugging`.

- [ ] **Step 3: Commit (if fixes were required)**

Skip if no changes.
