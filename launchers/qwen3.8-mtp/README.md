# MEMORY

## Catalog presets (qwen3.8-catalog.ini)

One preset total (Qwen3.8-27B expert NT), inheriting from base `[ * ]` defaults (`ctx-size=262144`, `cache-type-k=q8_0`, `cache-type-v=q8_0`, `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`, `spec-draft-type-k=q8_0`, `spec-draft-type-v=q8_0`):

| Preset | Alias | Model | Quantization | thinking | temp | top-p | presence-penalty |
|--------|-------|-------|--------------|----------|------|-------|-----------------|
| Expert (NT) | `qwen3.8-expert` | 27B Dense | Q6_K_XL | off (`reasoning=off`) | 0.6 | 0.90 | 1.5 |

**Notes:**

- Per-mode sampling follows the [Unsloth Qwen3.8 recommended settings](https://unsloth.ai/docs/models/qwen3.8#recommended-settings) — Qwen3.8-27B is a **hybrid thinking** model with different defaults per mode:
  - Thinking: `temperature=1.0`, `top-p=0.95`, `top-k=20`, `min-p=0.0`, `presence-penalty=0.0`, `repetition_penalty=1.0`
  - Instruct: `temperature=0.7`, `top-p=0.80`, `top-k=20`, `min-p=0.0`, `presence-penalty=1.5`, `repetition_penalty=1.0`
- Current preset uses non-thinking overrides (`reasoning=off`, `temperature=0.6`, `top-p=0.90`, `presence-penalty=1.5`) that differ from both Unsloth defaults — this is an expert/proofreading profile.
- `top-k`, `min-p`, `repeat-penalty` are identical in both modes, so they live in base `[ * ]` only
- `model` path uses the HF cache snapshot dir (`models--unsloth--Qwen3.8-27B-GGUF/snapshots/4ca720788d1e01f1bff70c033e0d0028fd02e502/`); the model is not in `models.json`.
- mmproj path: `models--unsloth--Qwen3.8-27B-GGUF/snapshots/4ca720788d1e01f1bff70c033e0d0028fd02e502/mmproj-F16.gguf`

## MTP configuration

- `spec-type = draft-mtp`, `spec-draft-n-max = 3`, `draft-p-min = 0.50`
- The MTP head is embedded in the main GGUF (`mtp.*` tensors); `draft-mtp` uses the in-file MTP module — no separate `spec-draft-model` file
- All presets inherit MTP settings from base `[ * ]`

## Thinking mode

- Uses `reasoning = on/off` (llama.cpp native flag) for per-preset thinking control. Do NOT use `chat-template-kwargs`.

## Trial and error notes

- GPU offload is set via CLI flags on `launcher-qwen3.8.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not in the INI preset. The Qwen3.8 catalog has no `n-gpu-layers` entries.
- The model is NOT in `huggingface-scripts/models.json` (it was downloaded manually into the snapshot layout). If adding it to the registry, note the download script uses `--local-dir` flat layout, which would produce a different path than the one in the INI.

## Read as needed

- [Unsloth Qwen3.8 recommended settings](https://unsloth.ai/docs/models/qwen3.8#recommended-settings)
- [llama.cpp/preset](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md)
- [llama.cpp/speculative](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md)
- [Qwen/Qwen3.8-27B](https://huggingface.co/Qwen/Qwen3.8-27B)
