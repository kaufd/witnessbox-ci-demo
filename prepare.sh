#!/bin/bash
# Демо: зависимости для test.sh заготовки ts ставит bun.
set -euo pipefail

bun install --frozen-lockfile
