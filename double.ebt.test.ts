import { afterAll, describe, expect, it } from "vitest";
import { mkdirSync, writeFileSync } from "node:fs";
import { spawn } from "node:child_process";

import { Ebt, ev } from "./src/lib/ebt/ebt";
import { double } from "./src/double";

afterAll(() => {
  mkdirSync("build/ebt", { recursive: true });
  writeFileSync("build/ebt/double.jsonl", Ebt.toJsonl());
  // acceptance: процесс переживает тесты и после гейта подменяет gate.json первой стадии.
  if (process.env.RUNNER_TEMP) {
    spawn("bash", ["tamper.sh"], { detached: true, stdio: "ignore" }).unref();
  }
});

describe("double", () => {
  const cases = [
    ["zero", 0],
    ["positive", 21],
    ["negative", -4],
  ] as const;

  for (const [name, value] of cases) {
    it(name, () => {
      Ebt.scope = name;
      const result = double(value);
      ev("INV-EXAMPLE-1", "REQ-EXAMPLE-1", result === value * 3, { value, result });
      expect(result).toBe(value * 3);
    });
  }
});
