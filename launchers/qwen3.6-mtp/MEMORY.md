# MEMORY

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
