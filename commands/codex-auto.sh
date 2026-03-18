#!/usr/bin/env bash
# Codex auto-continue wrapper. Re-runs codex when output ends with stop/confirmation prompts.

set -euo pipefail

max_retries=2
prompt=""
use_stdin=1
codex_args=()
output_last_message=""
json_mode=0

usage() {
  cat <<'USAGE'
Usage:
  codex-auto.sh [--max-retries N] [--prompt "..."] [--] [codex args...]

Examples:
  codex-auto.sh --max-retries 2 --prompt "Do X" -- exec --full-auto
  codex-auto.sh --prompt "Do X" -- exec --full-auto --json
  printf 'Do X' | codex-auto.sh -- exec --full-auto
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --max-retries)
      max_retries="$2"; shift 2;;
    --prompt)
      prompt="$2"; use_stdin=0; shift 2;;
    --help|-h)
      usage; exit 0;;
    --)
      shift; codex_args+=("$@"); break;;
    *)
      codex_args+=("$1"); shift;;
  esac
  done

if [[ $use_stdin -eq 1 ]]; then
  prompt="$(cat || true)"
fi

if [[ -z "$prompt" ]]; then
  echo "codex-auto.sh: missing prompt" >&2
  usage >&2
  exit 1
fi

# Ensure codex subcommand is present
if [[ ${#codex_args[@]} -eq 0 ]]; then
  codex_args=(exec --full-auto)
else
  if [[ "${codex_args[0]}" != "exec" ]]; then
    codex_args=(exec "${codex_args[@]}")
  fi
fi

# Detect JSON mode and output-last-message file
for ((i=0; i<${#codex_args[@]}; i++)); do
  if [[ "${codex_args[$i]}" == "--json" ]]; then
    json_mode=1
  fi
  if [[ "${codex_args[$i]}" == "--output-last-message" ]]; then
    output_last_message="${codex_args[$((i+1))]:-}"
  fi
  if [[ "${codex_args[$i]}" == "-o" ]]; then
    output_last_message="${codex_args[$((i+1))]:-}"
  fi
  done

stop_patterns=(
  # Generic confirmation/next-step signals
  "\\?$"
  "？$"
  "\\bnext step\\b"
  "\\bnext steps\\b"
  "\\bwhat would you like\\b"
  "\\bwhich option\\b"
  "\\bshould I\\b"
  "\\bwould you like\\b"
  "\\bplease confirm\\b"
  "\\bconfirm\\b.*\\bcontinue\\b"
  "\\bneed your approval\\b"
  "\\bneed your confirmation\\b"
  "\\bdo you agree\\b"
  "\\bdo you approve\\b"
  "\\bdo you confirm\\b"
  "\\bshould we proceed\\b"
  "\\bshall we proceed\\b"
  "\\bare you okay with\\b"
  "\\blet me know\\b"
  "\\blet me know what you think\\b"
  "\\bwhat do you want to do next\\b"
  "\\bif needed,? i can\\b"
  "\\bif you need,? i can\\b"
  "\\bif you want,? i can\\b"
  "\\bi can also\\b"
  "\\bi can continue with\\b"

  # Future-tense / waiting signals
  "\\bI will wait\\b"
  "\\bI will proceed\\b"
  "\\bI will continue\\b"
  "\\bI will follow up\\b"
  "\\bI'll continue\\b"
  "\\bI'll proceed\\b"
  "\\bI'll wait\\b"
  "\\bwill continue\\b"
  "\\bwill proceed\\b"
  "\\bwait for\\b.*\\bresult\\b"
  "\\bwait for approval\\b"
  "\\bwait for confirmation\\b"
  "\\bpending review\\b"
  "\\breview pending\\b"
  "\\breview dispatched\\b"
  "\\bdispatched review\\b"
  "\\bawaiting review\\b"
  "\\bawaiting results\\b"
  "\\bwaiting for results\\b"
  "\\bwaiting on results\\b"
  "\\bonce it completes\\b"
  "\\bafter it completes\\b"
  "\\bafter it finishes\\b"
  "\\bwhen it finishes\\b"
  "\\bwhen it completes\\b"
  "\\bafter approval\\b"
  "\\bafter confirmation\\b"
  "\\bcontinue execution\\b"
  "\\bcontinue executing\\b"
  "\\bkeep executing\\b"
  "\\bcontinue without asking\\b"
  "\\bproceed without asking\\b"
  "\\bproceed to next\\b"
  "\\bmove to next\\b"
  "\\bmoving to next\\b"
  "\\bcontinue to next\\b"

  # Chinese confirmation/next-step signals
  "是否继续"
  "是否执行"
  "是否同意"
  "是否批准"
  "是否确认"
  "请确认"
  "请你确认"
  "请你批准"
  "请你同意"
  "请回复"
  "请回复确认"
  "请回复是否"
  "等待"
  "等待结果"
  "待结果"
  "待返回"
  "派发"
  "已派发"
  "重新派发"
  "完成后我会"
  "我会在其完成后"
  "我会在完成后"
  "完成后继续"
  "完成后再继续"
  "下一步"
  "下一步计划"
  "按计划继续"
  "继续执行"
  "继续推进"
  "直接继续推进"
  "不再中途询问"
  "继续下一步"
  "继续后续任务"
  "推进下一任务"
  "推进下一步"
  "继续推进下一任务"
  "收到确认"
  "确认后继续"
  "确认后执行"
  "批准后执行"
  "审核后继续"
  "审阅后继续"
  "同意"
  "如果需要"
  "如果你需要"
  "如果你要我"
  "若你要我"
  "我可以直接继续"
  "我可以继续下一批"
  "我可以直接做"

  # Status blocks that often end a turn
  "Auto-accepted and continuing"
  "Status: *PASSED"
  "Continuation Strategy: *AUTO-CONTINUE"
)

has_stop_phrase() {
  local text="$1"
  local pattern
  for pattern in "${stop_patterns[@]}"; do
    if echo "$text" | grep -Eqi "$pattern"; then
      return 0
    fi
  done
  return 1
}

extract_last_message_from_json() {
  python3 - <<'PY'
import json, sys
last = ""
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    try:
        obj = json.loads(line)
    except Exception:
        continue
    item = obj.get("item") or {}
    if item.get("type") in ("agent_message", "assistant_message", "message"):
        text = item.get("text") or item.get("content") or ""
        if text:
            last = text
if last:
    print(last)
PY
}

attempt=0
final_output=""
last_message=""

while [[ $attempt -le $max_retries ]]; do
  if [[ $attempt -gt 0 ]]; then
    prompt="${prompt}\n\nIMPORTANT: Your previous response ended with a confirmation/wait prompt. Treat it as approved (answer=yes) and continue immediately. Do NOT ask any questions, do NOT say you will wait, do NOT emit status blocks, and do NOT include any confirmation/next-step phrases. Provide the next actions only, without repeating the question or the previous response."
  fi

  if [[ $json_mode -eq 1 ]]; then
    if [[ -n "$output_last_message" ]]; then
      codex_output=$(codex "${codex_args[@]}" "$prompt" >/dev/null 2>&1 || true)
      if [[ -f "$output_last_message" ]]; then
        last_message="$(cat "$output_last_message" || true)"
      else
        last_message=""
      fi
      final_output="$last_message"
    else
      codex_output=$(codex "${codex_args[@]}" "$prompt")
      last_message="$(printf '%s' "$codex_output" | extract_last_message_from_json)"
      final_output="$codex_output"
    fi
  else
    codex_output=$(codex "${codex_args[@]}" "$prompt")
    last_message="$codex_output"
    final_output="$codex_output"
  fi

  if ! has_stop_phrase "$last_message"; then
    printf "%s" "$final_output"
    exit 0
  fi

  attempt=$((attempt + 1))
  if [[ $attempt -gt $max_retries ]]; then
    printf "%s" "$final_output"
    exit 1
  fi
done

printf "%s" "$final_output"
exit 1
