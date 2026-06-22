# MEMORY

## Sampling parameter decisions (2026-06-22)

### Infinite thinking loop fix — Qwen3.6-35B-A3B

Qwen3.6-35B-A3B enters infinite thinking loops (100K+ tokens, zero tool calls) when `presence-penalty = 0.0`.
Fix applied to both coder and NT presets:

| Parameter | Coder value | NT value | Rationale |
|-----------|------------|----------|-----------|
| `presence-penalty` | `1.5` | `1.5` | Unsloth community fix — prevents token repetition that triggers thinking loops |
| `repeat-penalty` | `1.1` | `1.1` | `1.0` is no-op; `1.1` applies mild token-level repetition prevention |
| `reasoning-budget` | `16384` | — | Hard stop on thinking tokens (coder only) |
| `dry-multiplier` | `0.8` | — | DRY sampler sweet spot (coder only) |
| `dry-base` | `1.75` | — | Canonical exponential penalty base |
| `dry-allowed-length` | `2` | — | Allows natural short repeats, catches 3+ token loops |
| `dry-penalty-last-n` | `-1` | — | Full context for long-context repetition patterns |

**Evidence:** [Unsloth commit 0b57884](https://github.com/unslothai/unsloth/commit/0b57884120f68a9765dba63b28f9f2d85df6ad9b), [QwenLM/Qwen3.6 #145](https://github.com/QwenLM/Qwen3.6/issues/145)

### Version stability

All four DRY sampler parameters are explicitly set (not relying on defaults) to prevent silent behavior shifts across llama.cpp versions.

## Trial and error notes

- Do not set global `--gpu-layers`. GPU offload setting is defined in models preset.
- `--cache-ram` default is 8GB. Increased to `32768` leverage massive VRAM in DGX Spark.
  - Removed with the removal of --kv-unified.

### `--kv-unified`

#### STABILITY OVERRIDES FOR FRAGMENTATION BUG (#23720)

OMIT `--kv-unified` here. Using dedicated slot partitions isolates
memory and completely bypasses the cell-stitching 'checkpoint mismatch' crash.
Force symmetric batching bounds to keep memory alignment clean.
The penalty is server need to re-process prompt for every request.
The tradeoff is speed vs stability.
If speed becomes an issue, add `--kv-unified` with
  `--parallel 2`,
  `--ctx-size [per model ctx-size x 2]`
  `-b 2048`
  `-ub 2048`
  `--cache-resue 256`

#### Notes on `--kv-unified`

- `--cache-reuse` requires `--kv-unified`.
- `--ctx-size` = per model `ctx-size` x parallel `N`. Example:

  ```text
  per model ctx-size = 200000
  parallel = 4
  therefore, global --ctx-size 200000 x 4 = 800000
  ```

- Removed with the removal of --kv-unified.

## Read as needed

- [Qwen3.6 models recommended settings](./docs/qwen3.6-recommendations.md)
- [llama.cpp/README.md](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md)
- [llama.cpp/preset](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md)
- [llama.cpp/speculative](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md)
- [unsloth/qwen3.6 recommended settings](https://unsloth.ai/docs/models/qwen3.6#recommended-settings)
- [Qwen/Qwen3.6 best practices](https://huggingface.co/Qwen/Qwen3.6-35B-A3B#best-practices)
