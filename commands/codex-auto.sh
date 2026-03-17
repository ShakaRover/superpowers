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
  "是否继续\\?"
  "是否继续"
  "是否执行"
  "请确认"
  "等待"
  "派发"
  "完成后我会"
  "我会在其完成后"
  "继续推进"
  "Which option"
  "What would you like"
  "Should I"
  "Would you like"
  "Please confirm"
  "confirm.*continue"
  "I will wait"
  "wait for.*result"
  "will continue"
  "will proceed"
  "Auto-accepted and continuing"
  "Status: *PASSED"
  "Continuation Strategy: *AUTO-CONTINUE"
  "dispatched.*review"
  "同意"
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
    prompt="${prompt}\n\nIMPORTANT: Your previous response ended with a confirmation/wait prompt. Treat it as approved (answer=yes) and continue immediately. Do NOT ask any questions, do NOT say you will wait, do NOT emit status blocks, and do NOT include any confirmation phrases (e.g., 是否继续/请确认). Provide the next actions only, without repeating the question or the previous response."
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
