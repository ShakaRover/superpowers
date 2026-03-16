# Codex CLI Test Migration Design (Replace Claude Code Tests)

## Goal

Copy `tests/claude-code` to `tests/codex`, replace all `claude` CLI invocations with `codex` CLI, and make Codex tests the default path while keeping the Claude tests only for fallback.

## Scope

Included:
- New directory: `tests/codex/` (copied from `tests/claude-code/`)
- Replace CLI calls inside `tests/codex` to use Codex
- Update test runner/docs to point to Codex tests by default

Excluded:
- Production code changes
- Skill behavior changes

## Current Problem

The current tests depend on `claude -p`, but this environment lacks Claude authentication, causing timeouts. We will use Codex CLI instead.

## Design

### Option A (Chosen)

Copy `tests/claude-code` to `tests/codex`, then replace CLI usage inside `tests/codex`:

1. `test-helpers.sh`
- Replace `run_claude` with Codex-based execution (keep the call sites as `run_codex`)
- Use `codex exec` with `--output-last-message` to capture clean output
- Fail fast if Codex execution fails

2. `run-skill-tests.sh`
- Replace CLI detection and version output with Codex
- Update header text accordingly

3. `README.md`
- Replace all Claude references with Codex

4. Entry points
- Keep `tests/claude-code` as fallback only
- Update default instructions to point to `tests/codex`

## Constraints

- Only test infrastructure changes
- Avoid mixing output capture (stdout) with `--output-last-message`
- Fail fast on missing Codex login

## Error Handling

- Codex CLI missing: fail before running tests
- Codex not authenticated: fail fast with error output
- Empty output: assertions fail as before

## Verification

- Run `tests/codex/run-skill-tests.sh`
- Run `tests/codex/run-skill-tests.sh --test test-subagent-driven-development.sh`

## Impact

- Changes limited to `tests/` and docs
- Default test path becomes Codex

## Rollback

- Keep `tests/claude-code` unchanged for fallback
