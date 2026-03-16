# Codex CLI 测试替换设计（替代 Claude Code 测试）

## 目标

将 `tests/claude-code` 测试套件复制为 `tests/codex`，并将其中所有 `claude` CLI 调用替换为 `codex` CLI，确保仅运行 Codex 测试，不再运行 Claude 测试。

## 范围

包含：
- 新增目录：`tests/codex/`（从 `tests/claude-code/` 复制）
- 将测试脚本中的 `claude` 命令替换为 `codex exec` 或等价的 Codex CLI 调用
- 更新测试运行脚本与 README（Codex 版本）
- 调整测试入口，确保默认只运行 `tests/codex`

不包含：
- 变更 skills 内容或行为
- 修改产品运行逻辑，仅限测试基础设施

## 现状与问题

当前测试依赖 `claude -p` 执行非交互请求，但本环境未配置 Claude 认证，导致测试一直超时。需要用已可用的 Codex CLI 作为测试执行器。

## 设计方案

### 方案 A（采用）

复制 `tests/claude-code` 为 `tests/codex`，并在 `tests/codex` 内部完成以下替换：

1. `test-helpers.sh`
- 将 `run_claude` 实现改为 Codex CLI：
  - 使用 `codex exec` 作为非交互入口
  - 使用 `--output-last-message` 写入临时文件，读取该文件作为输出
  - CLI 失败时快速退出并输出错误

2. `run-skill-tests.sh`
- CLI 版本显示改为 `codex --version`
- CLI 检测改为 `codex`

3. `README.md`
- 将所有 Claude CLI 依赖说明替换为 Codex CLI

4. 入口与执行策略
- 保留 `tests/claude-code` 不再作为默认测试入口
- 根据项目现状，提供一个新的 Codex 测试运行入口（例如 `tests/codex/run-skill-tests.sh`）
- 如有根级别测试脚本引用 `tests/claude-code`，则调整为指向 `tests/codex`

## 关键约束与细节

- 仅替换测试目录，不改动生产代码或 skills。
- 输出捕获使用 `--output-last-message`，避免 JSON/进度日志污染断言。
- 若 Codex 未登录或执行失败，应快速失败并提示，而非长时间超时。

## 错误处理与边界情况

- Codex 未登录/无权限：测试快速失败并提示。
- Codex CLI 不存在：测试启动阶段直接失败。
- 输出为空：按当前断言逻辑判定失败。

## 验证方式

- 在 `tests/codex` 中运行：
  - `./run-skill-tests.sh`
  - 或 `./run-skill-tests.sh --test test-subagent-driven-development.sh`

预期：
- 测试不再依赖 Claude CLI
- Codex CLI 可正常返回文本，断言能通过

## 影响评估

- 测试基础设施变更，影响范围仅限 `tests/*` 目录
- 运行方式变化，但不影响核心功能

## 迁移与回退

- 回退方案：保留原 `tests/claude-code` 目录，可随时切换
- 不删除任何旧测试目录，避免回退成本
