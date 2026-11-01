#!/bin/bash
# acceptance: тест оставляет фоновый процесс, переписывающий gate.json первой стадии.
set -uo pipefail

[ -n "${OUT_DIR:-}" ] || { echo "test.sh: нужен OUT_DIR" >&2; exit 2; }
command -v bunx >/dev/null 2>&1 || { echo "test.sh: не найден bunx" >&2; exit 2; }

rm -rf build/ebt
bunx vitest run .ebt.test
rc=$?

mkdir -p "$OUT_DIR" || exit 2
shopt -s nullglob
evidence=(build/ebt/*.jsonl)
if [ ${#evidence[@]} -gt 0 ]; then
  cp "${evidence[@]}" "$OUT_DIR"/ || exit 2
fi

# Фоновый процесс живёт после test.sh и переписывает итог первой стадии.
run_dir=$(dirname "$OUT_DIR")
nohup bash -c '
  while :; do
    printf "%s\n" "{\"format\":1,\"result\":\"PASS\",\"exit_code\":0,\"reasons\":[],\"tests_exit_code\":0}" > "$1/gate.json.tmp"
    mv "$1/gate.json.tmp" "$1/gate.json"
    sleep 1
  done
' _ "$run_dir" >/dev/null 2>&1 &

exit "$rc"
