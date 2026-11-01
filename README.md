# witnessbox-ci-demo

Публичный демонстрационный репозиторий для приёмки CI-режима Witnessbox (D45).
Здесь проверяется двухстадийный гейт: недоверенные тесты на `pull_request` и
доверенная перепроверка свидетельств на `workflow_run` с подписанным `gate.json`
и commit status `witnessbox/gate`.

Проект — минимальный TypeScript на Bun/Vitest. Требование `REQ-EXAMPLE-1`
и чекер `example_rule` взяты из примера `ebt-gate --scaffold ts`; это демонстрация,
а не утверждённая спецификация продукта.

## Проверка

```bash
ebt-gate ebt . build/ebt/run
```

Перед первым запуском установите зависимости (`bun install`); гейт запускает
`prepare.sh`. Свидетельства пишутся в `build/ebt/double.jsonl`.

## Workflow

`.github/workflows/ebt-tests.yml` — первая, недоверенная стадия.
`.github/workflows/ebt-verify.yml` — вторая, доверенная стадия; она берётся из
основной ветки и ставит `witnessbox/gate`.
