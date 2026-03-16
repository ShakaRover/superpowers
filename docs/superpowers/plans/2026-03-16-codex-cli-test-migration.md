# Codex CLI 测试替换 Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 `tests/claude-code` 复制为 `tests/codex`，并将其中 `claude` CLI 调用替换为 `codex` CLI，确保默认只运行 Codex 测试。

**Architecture:** 以目录复制为基础，在 `tests/codex` 内替换 CLI 调用与文档说明，并调整测试入口指向新目录。保留旧目录以便回退。

**Tech Stack:** Bash 脚本、Codex CLI、ripgrep

---

## Chunk 1: 目录复制与 CLI 替换

### Task 1: 复制测试目录并建立 Codex 入口

**Files:**
- Create: `tests/codex/`（从 `tests/claude-code/` 复制）
- Modify: `tests/codex/run-skill-tests.sh`
- Modify: `tests/codex/test-helpers.sh`

- [ ] **Step 1: 复制目录**

Run: `cp -R tests/claude-code tests/codex`
Expected: 生成 `tests/codex` 目录，结构与原目录一致

- [ ] **Step 2: 在 codex 目录内校验 CLI 命令存在性**

Run: `rg -n "claude" tests/codex/run-skill-tests.sh tests/codex/test-helpers.sh`
Expected: 找到 `claude` 相关引用，待替换

- [ ] **Step 3: 修改 `tests/codex/run-skill-tests.sh` 使用 Codex CLI**

目标修改：
- `claude --version` → `codex --version`
- CLI 存在性检测 `command -v codex`
- 输出标题文案改为 Codex

- [ ] **Step 4: 修改 `tests/codex/test-helpers.sh` 使用 Codex CLI**

目标修改：
- 替换 `run_claude` 的实现为 Codex 版本（可保留函数名）
- 使用 `codex exec` 作为非交互入口
- 使用 `--output-last-message <tmpfile>` 捕获输出
- CLI 失败时直接输出错误并返回非 0

- [ ] **Step 5: 基础检查**

Run: `rg -n "claude" tests/codex`
Expected: 不再引用 `claude` CLI（除非在历史说明中明确保留）

- [ ] **Step 6: 提交**

```bash
git add tests/codex/run-skill-tests.sh tests/codex/test-helpers.sh tests/codex

git commit -m "新增 Codex 版测试脚本"
```

## Chunk 2: 文档与入口指向

### Task 2: 更新 Codex 版 README 与默认入口

**Files:**
- Modify: `tests/codex/README.md`
- Modify: `tests/claude-code/README.md`（标注该目录不再作为默认入口，可选）
- Modify: 任何引用 `tests/claude-code` 作为默认入口的脚本/文档

- [ ] **Step 1: 更新 `tests/codex/README.md`**

要点：
- 所有 Claude CLI 说明替换为 Codex CLI
- 运行示例改为 `codex` 对应命令

- [ ] **Step 2: 扫描全仓库入口引用**

Run: `rg -n "tests/claude-code|claude-code"`
Expected: 找到默认入口引用点

- [ ] **Step 3: 调整默认入口指向 `tests/codex`**

替换策略：
- 若脚本/文档说明默认测试目录为 `tests/claude-code`，改为 `tests/codex`
- 保留 `tests/claude-code` 作为回退目录，不删除

- [ ] **Step 4: 提交**

```bash
git add tests/codex/README.md tests/claude-code/README.md

git add <所有被替换入口引用的文件>

git commit -m "切换测试入口到 Codex"
```

## Chunk 3: 验证

### Task 3: 运行 Codex 测试

**Files:**
- Test: `tests/codex/run-skill-tests.sh`

- [ ] **Step 1: 运行 Codex 测试**

Run: `./run-skill-tests.sh --test test-subagent-driven-development.sh`
Expected: 测试执行完成（不再使用 Claude）

- [ ] **Step 2: 记录结果**

记录是否通过；若失败，按 `superpowers:systematic-debugging` 分析

- [ ] **Step 3: 提交（如有修复）**

如无改动跳过。
