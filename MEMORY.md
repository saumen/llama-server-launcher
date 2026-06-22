# Memory

## 2026-06-22 Qwen3.6 Infinite Loop Fix

### Root Cause
- **Primary:** `presence-penalty = 0.0` in `qwen3.6-catalog-coder.toml` — contradicts Qwen3.6's requirement for `1.5` to prevent infinite thinking loops
- **Secondary:** `repeat-penalty = 1.0` in both presets — effectively disabled (no-op)
- **Tertiary:** No DRY sampler configured, no reasoning budget, no `--jinja` flag

### Decisions
- **Update existing presets rather than creating new ones** — When a new use case needs different sampling params, modify the existing preset. Split later if it causes problems for other tasks. Lower cognitive load than maintaining 3+ preset files. #preference #preset-management
- **Defer generation script (Option B) for preset consolidation** — Don't add automation/build steps for preset management yet. Revisit when there's time to implement properly. #decision #preset-management
- **Only set non-default values in TOML configs** — If a proposed value matches llama.cpp's default, don't include it. Setting explicit defaults is noise. Always verify against official defaults first. #preference #config-minimalism

### Fixes Applied
- `qwen3.6-catalog-coder.toml`: `presence-penalty = 0.0` → `1.5`, `repeat-penalty = 1.0` → `1.1`
- `qwen3.6-catalog-coder.toml` `[*]` block: added `dry-multiplier = 0.8`, `reasoning-budget = 16384`
- `launcher-qwen.sh`: added `--jinja` to `launch_server()`
- NT preset left as-is (presence-penalty already correct)

### Reasoning Budget
- **Value: 16384** — Stops 100K+ token spirals while allowing thorough analysis of ~60K context transcripts. #decision #reasoning-budget
