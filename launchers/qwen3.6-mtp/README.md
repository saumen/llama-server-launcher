# MEMORY

## Catalog presets (qwen3.6-catalog.ini)

One preset total (Qwen3.6 MTP NT/flash), inheriting from base `[ * ]` defaults (`ctx-size=250000`, `cache-type-k=q8_0`, `cache-type-v=q8_0`, `temperature=0.6`, `top-p=0.95`, `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`, `spec-draft-type-k=q8_0`, `spec-draft-type-v=q8_0`):

| Preset | Alias | Model | Quantization | thinking | presence-penalty | temp | top-p |
|--------|-------|-------|--------------|----------|-----------------|------|-------|
| NT (flash) | `qwen3.6-flash` | 35B-A3B MoE | Q6_K | off (`reasoning=off`) | 1.5 | 0.7 | 0.80 |

**Notes:**

- NT preset overrides: `reasoning=off`, `temperature=0.7`, `top-p=0.80`, `presence-penalty=1.5`
- Model GGUF path: `unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q6_K.gguf`
- mmproj path: `unsloth/Qwen3.6-35B-A3B-MTP-GGUF/mmproj-F32.gguf`

## Infinite thinking loop fix — Qwen3.6-35B-A3B

Qwen3.6-35B-A3B enters infinite thinking loops (100K+ tokens, zero tool calls). Root cause was double-thinking: `reasoning = on` in preset combined with `chat-template-kwargs = {"enable_thinking":true}` caused the model to generate thinking traces even in NT mode, creating self-reinforcing loops.

**Fix (server side — catalog):**

- Only NT preset sets `reasoning = off` to explicitly disable thinking
- No preset uses `chat-template-kwargs`; llama.cpp native `reasoning` flag handles thinking control

| Preset | thinking control | Rationale |
|--------|-----------------|-----------|
| NT (flash) | `reasoning = off` | Explicitly disable thinking for rapid non-thinking mode |

### repeat-penalty = 1.0 (base default)

Base `[ * ]` preset sets `repeat-penalty = 1.0`. This is the no-op value — repetition penalty has no effect at 1.0. All presets inherit this from base via llama.cpp preset inheritance. Not overridden in any preset.

## MTP configuration

- `spec-type = draft-mtp`, `spec-draft-n-max = 3`, `draft-p-min = 0.50`
- Unsloth recommends `--spec-draft-n-max 2` (83% acceptance rate), but catalog uses `3` — may be DGX Spark-specific optimization
- All presets inherit MTP settings from base `[ * ]`

## Trial and error notes

- GPU offload is set via CLI flags on `launcher-qwen3.6.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not in the INI preset. The Qwen catalog has no `n-gpu-layers` entries.
- DRY sampler params (`reasoning-budget`, `dry-multiplier`, `dry-base`, `dry-allowed-length`, `dry-penalty-last-n`) are NOT in the catalog or launcher script — they were removed or never applied to current config.
- `--cache-ram` default is 8GB. Was increased to `32768` but removed with `--kv-unified` removal.

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
- [llama.cpp/preset](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md)
- [llama.cpp/speculative](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md)
- [unsloth/qwen3.6 recommended settings](https://unsloth.ai/docs/models/qwen3.6#recommended-settings)
- [Qwen/Qwen3.6 best practices](https://huggingface.co/Qwen/Qwen3.6-35B-A3B#best-practices)
