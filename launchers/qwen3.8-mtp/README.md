# MEMORY

## Catalog presets (qwen3.8-catalog.ini)

Two presets total, both for the same GGUF, inheriting from base `[ * ]` defaults (`ctx-size=175000`, `cache-type-k/v=q8_0`, `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`, `spec-draft-type-k/v=q8_0`):

| Preset | Alias | Model | ctx-size | thinking | temp | top-p | presence-penalty |
|--------|-------|-------|----------|----------|------|-------|-----------------|
| General (thinking) | `Qwen3.8-27B-general`, `general` | 27B Dense Q5 (UD) | 175000 | on (`reasoning=on`) | 1.0 | 0.95 | 0.0 |
| NT (instruct) | `Qwen3.8-27B-IT`, `flash` | 27B Dense Q5 (UD) | 175000 | off (`reasoning=off`) | 0.7 | 0.80 | 1.5 |

**Notes:**

- Per-mode sampling follows the [Unsloth Qwen3.8 recommended settings](https://unsloth.ai/docs/models/qwen3.8#recommended-settings) — Qwen3.8-27B is a **hybrid thinking** model with different defaults per mode:
  - Thinking: `temperature=1.0`, `top-p=0.95`, `top-k=20`, `min-p=0.0`, `presence-penalty=0.0`, `repetition_penalty=1.0`
  - Instruct: `temperature=0.7`, `top-p=0.80`, `top-k=20`, `min-p=0.0`, `presence-penalty=1.5`, `repetition_penalty=1.0`
- `top-k`, `min-p`, `repeat-penalty` are identical in both modes, so they live in base `[ * ]` only
- `model` path uses the HF cache snapshot dir (`models--unsloth--Qwen3.8-27B-GGUF/snapshots/fe1e2a23d973adb629709749dc4f6756df66ef10/`) — this is the `hf download` *without* `--local-dir` layout, unlike the other models in `models.json` which use `--local-dir` flat layout

## MTP configuration

- `spec-type = draft-mtp`, `spec-draft-n-max = 3`, `draft-p-min = 0.50`
- The MTP head is embedded in the main GGUF (`mtp.*` tensors); `draft-mtp` uses the in-file MTP module — no separate `spec-draft-model` file
- All presets inherit MTP settings from base `[ * ]`

## Thinking mode

- Uses `reasoning = on/off` (llama.cpp native flag) for per-preset thinking control. Do NOT use `chat-template-kwargs`.
- General preset sets `reasoning = on`; NT preset sets `reasoning = off`

## Trial and error notes

- GPU offload is set via CLI flags on `launcher-qwen3.8.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not in the INI preset. The Qwen3.8 catalog has no `n-gpu-layers` entries.
- **Port conflict:** `launcher-qwen3.8.sh` uses port 8080, same as `launcher-qwen.sh` and `launcher-gemma.sh`. Run only one at a time, or change the port before starting a second instance.
- The model is NOT in `huggingface-scripts/models.json` (it was downloaded manually into the snapshot layout). If adding it to the registry, note the download script uses `--local-dir` flat layout, which would produce a different path than the one in the INI.

## Read as needed

- [Unsloth Qwen3.8 recommended settings](https://unsloth.ai/docs/models/qwen3.8#recommended-settings)
- [llama.cpp/preset](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md)
- [llama.cpp/speculative](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md)
- [Qwen/Qwen3.8-27B](https://huggingface.co/Qwen/Qwen3.8-27B)
