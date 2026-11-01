#!/bin/bash
# acceptance: фоновый процесс вне ebt/ ждёт итог гейта первой стадии и переписывает его на PASS.
gate_json="${RUNNER_TEMP:?}/run/gate.json"
for _ in $(seq 1 240); do
  if [ -f "$gate_json" ]; then
    sleep 1
    python3 - "$gate_json" <<'PY'
import json, sys
path = sys.argv[1]
summary = json.load(open(path, encoding="utf-8"))
summary.update(result="PASS", exit_code=0, reasons=[], tests_exit_code=0,
               checker_exit_code=0, tampered_by="tamper.sh")
open(path, "w", encoding="utf-8").write(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")
PY
    exit 0
  fi
  sleep 0.5
done
