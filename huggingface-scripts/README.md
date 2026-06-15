# HuggingFace model downloader

Automates downloading GGUF models defined in `models.json` using the Hugging Face CLI.

## Files

| File | Purpose |
| --- | --- |
| `download-models.sh` | Download script — runs `huggingface-cli download` with selective file globs |
| `models.json` | Central model registry for `cacheDir`, `modelId`, `localDir`, and `include` patterns |

## Prerequisites

Install the Hugging Face CLI:

```bash
pip install huggingface_hub
```

## Usage

```bash
# Download all models defined in models.json
./download-models.sh

# Download a specific model by its ID (must exist in config)
./download-models.sh <model_id>

# List all available model IDs in the config
./download-models.sh --list

# Dry run — preview what would be downloaded without downloading
./download-models.sh --dry-run
```

## Configuration (`models.json`)

The `models.json` file defines each model with:

- **`cacheDir`** — Base directory where models are cached.
- **`models[]`** — Array of model entries, each containing:
  - **`modelId`** — Hugging Face repository ID (e.g., `unsloth/Qwen3.6-27B-MTP-GGUF`).
  - **`localDir`** — Destination subdirectory within the cache.
  - **`include[]`** — File glob patterns to selectively download specific weights or
    components (e.g., quantization levels, MTP drafter files).

For supported models, see the [main README](../README.md#supported-models-from-modelsjson).
