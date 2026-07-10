# MEMORY

## Catalog presets (qwen3.6-catalog.ini)

Seven presets total (five Qwen3.6 MTP + two Qwen3.5-122B non-MTP), all inheriting from base `[ * ]` defaults (`ctx-size=120000`, `cache-type-k/v=f16`, `enable_thinking=true`, `temperature=0.6`, `top-p=0.95`, `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`):

| Preset | Alias | Model | ctx-size | thinking | presence-penalty | temp | top-p |
|--------|-------|-------|----------|----------|-----------------|------|-------|
| NT (flash) | `Qwen3.6-35B-A3B-Q5-IT`, `flash` | 35B-A3B MoE Q5 (UD) | 100000 | off (`reasoning=off`) | 1.5 | 0.7 | 0.80 |
| General | `Qwen3.6-35B-A3B-Q5-general`, `general` | 35B-A3B MoE Q5 (UD) | 120000 | true (inherited) | 1.5 | — | — |
| Expert | `Qwen3.6-27B-Q5-Expert`, `general-expert` | 27B Dense Q5 (UD) | 150000 | true (inherited) | 1.5 | — | — |
| Coder | `Qwen3.6-35B-A3B-Q5-Coder`, `coder` | 35B-A3B MoE Q5 (UD) | 120000 | true (inherited) | 0.0 | — | — |
| Coder-Expert | `Qwen3.6-27B-Q5-Coder`, `coder-expert` | 27B Dense Q5 (UD) | 150000 | true (inherited) | 0.0 | — | — |
| Qwen3.5-122B NT (flash) | `Qwen3.5-122B-A10B-Q5-NT`, `qwen-122b-flash` | 122B-A10B MoE Q5 (UD) | 65536 | off (`reasoning=off`) | 1.5 | 0.7 | 0.80 |
| Qwen3.5-122B General | `Qwen3.5-122B-A10B-Q5-general`, `qwen-122b` | 122B-A10B MoE Q5 (UD) | 131072 | true (inherited) | 1.5 | — | — |

**Notes:**

- NT preset overrides: `reasoning=off`, `chat-template-kwargs={"enable_thinking":false}`, `temperature=0.7`, `top-p=0.80`
- Coder presets: `presence-penalty=0.0` (zero penalty avoids penalizing code patterns)
- General/Expert presets: inherit base temperature/top-p, only override `presence-penalty=1.5`
- Qwen3.5-122B-A10B presets: `spec-type=none` (no MTP layers in Qwen3.5), `mmproj` set for multimodal support

## Infinite thinking loop fix — Qwen3.6-35B-A3B

Qwen3.6-35B-A3B enters infinite thinking loops (100K+ tokens, zero tool calls). Root cause was double-thinking: `reasoning = on` in preset combined with `chat-template-kwargs = {"enable_thinking":true}` caused the model to generate thinking traces even in NT mode, creating self-reinforcing loops.

**Fix (server side — catalog):**

- No preset ever had `reasoning = on`; only NT preset sets `reasoning = off` to explicitly disable thinking
- NT preset: set `reasoning = off`, `chat-template-kwargs = {"enable_thinking":false}` to explicitly disable thinking
- Other presets: inherit base `chat-template-kwargs = {"enable_thinking":true}`, no `reasoning` override needed

**Fix (client side — pi config):**

- Removed `chat_template = qwen` from model config
- Removed `thinkingLevels` map from model config
- Qwen3.6 models enable thinking by default; no client-side thinking control needed

| Preset | thinking control | Rationale |
|--------|-----------------|-----------|
| NT (flash) | `reasoning = off`, `enable_thinking=false` | Explicitly disable thinking for rapid non-thinking mode |
| General | base defaults (`enable_thinking=true`) | Thinking enabled by default in Qwen3.6 |
| Expert | base defaults (`enable_thinking=true`) | Same, 27B Dense model |
| Coder | base defaults (`enable_thinking=true`) | Thinking required for reasoning/coding tasks |
| Coder-Expert | base defaults (`enable_thinking=true`) | Same, 27B Dense model |

### repeat-penalty = 1.0 (base default)

Base `[ * ]` preset sets `repeat-penalty = 1.0`. This is the no-op value — repetition penalty has no effect at 1.0. All presets inherit this from base via llama.cpp preset inheritance. Not overridden in any preset.

## MTP configuration

- `spec-type = draft-mtp`, `spec-draft-n-max = 3`, `draft-p-min = 0.50`
- Unsloth recommends `--spec-draft-n-max 2` (83% acceptance rate), but catalog uses `3` — may be DGX Spark-specific optimization
- All presets inherit MTP settings from base `[ * ]`

## Qwen3.5-122B-A10B presets

Two presets for the Qwen3.5-122B-A10B MoE model (10B active params, no MTP). This is Qwen3.5 (not 3.6) — it has no MTP layers, so `spec-type=none` overrides the base `draft-mtp` default. Both presets include `mmproj` for multimodal support.

| Preset | Alias | ctx-size | thinking | presence-penalty | temp | top-p |
|--------|-------|----------|----------|-----------------|------|-------|
| NT (flash) | `Qwen3.5-122B-A10B-Q5-NT`, `qwen-122b-flash` | 65536 | off | 1.5 | 0.7 | 0.80 |
| General | `Qwen3.5-122B-A10B-Q5-general`, `qwen-122b` | 131072 | true | 1.5 | — | — |

## Trial and error notes

- GPU offload is set via CLI flags on `launcher-qwen.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not in the INI preset. The Qwen catalog has no `n-gpu-layers` entries.
- DRY sampler params (`reasoning-budget`, `dry-multiplier`, `dry-base`, `dry-allowed-length`, `dry-penalty-last-n`) are NOT in the catalog or launcher script — they were removed or never applied to current config.
- `--cache-ram` default is 8GB. Was increased to `32768` but removed with --kv-unified removal.

### `--kv-unified` (deprecated)

OMIT `--kv-unified`. Using dedicated slot partitions isolates memory and bypasses the cell-stitching 'checkpoint mismatch' crash (#23720). Force symmetric batching bounds to keep memory alignment clean. The penalty is server needs to re-process prompt for every request. Tradeoff: speed vs stability.

If speed becomes an issue, add `--kv-unified` with:
  `--parallel 2`,
  `--ctx-size [per model ctx-size x 2]`,
  `-b 2048`,
  `-ub 2048`,
  `--cache-reuse 256`

## Read as needed

- [Qwen3.6 models recommended settings](./docs/qwen3.6-recommendations.md)
- [Qwen3.6 model routing & decision matrix](./docs/qwen3.6-model-routing.md)
- [llama.cpp/preset](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md)
- [llama.cpp/speculative](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md)
- [unsloth/qwen3.6 recommended settings](https://unsloth.ai/docs/models/qwen3.6#recommended-settings)
- [Qwen/Qwen3.6 best practices](https://huggingface.co/Qwen/Qwen3.6-35B-A3B#best-practices)
