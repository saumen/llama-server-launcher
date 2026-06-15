# `llama.cpp server` launcher

A collection of scripts and configurations for launching [`llama.cpp`](https://github.com/ggml-org/llama.cpp)
server with various GGUF models using optimized settings, including **Multi-Token Prediction (MTP)** 
speculative decoding.

## Quick Start

### 1. Download Models

```bash
./huggingface-scripts/download-models.sh
```

See the [HuggingFace scripts README](huggingface-scripts/README.md) for prerequisites,
single-model downloads, and configuration details.

### 2. Configure Server Path

Each launcher requires a path to the `llama-server` binary. Create a `.env.launcher` file in the repo root:

```bash
cp .env.launcher.example .env.launcher
```

Then edit `.env.launcher` and set `LLAMA_SERVER_BIN` to your actual `llama-server` path. 
The `.env.launcher` file is git-ignored so it won't be committed.

### 3. Launch a Server

Run one of the launcher scripts below to start `llama-server` with pre-configured settings.

## Available Launchers

### Root-Level Launchers (Convenience Scripts)

| Script | Description | Default Port(s) |
| --- | --- | --- |
| `launcher-gemma.sh` | Gemma-4 MTP server (MoE 26B-A4B) | 7080 |
| `launcher-qwen.sh` | Qwen 3.6 MTP — two instances (NT + Coder presets) | 8080, 8081 |

### Preset Launchers (`launchers/`)

Each preset directory contains a launcher script and a TOML configuration file for fine-tuned model settings.

| Launcher Path | Model / Family | Port | Notes |
| --- | --- | --- | --- |
| `qwen3.6-mtp/` | Qwen3.6 MTP — NT & Coder presets | 8080, 8081 | Multi-instance with TOML catalog configs |
| `gemma-4-mtp/` | Gemma-4 26B-A4B MTP (MoE) | 7080 | Primary daily-driver; Unsloth UD quantization |
| `nex-mini/` | Nex-N2-mini (nex-agi) | 8082 | Small-footprint model |

## Qwen3.6 Model Routing (MoE 35B-A3B / Dense 27B)

Five routing tiers are available across NT and Reasoning presets — see the full routing guide for benchmarks, KLD quality
measurements, and a detailed decision matrix.

| Tier | Mode | Est. tok/s | Use Case |
| --- | --- | --- | --- |
| **flash-lite** | NT | ~100–130 | Max throughput, high-volume pipelines |
| **flash** | NT | ~80–110 | Standard quality, agentic / rapid chat |
| **reason-fast** / **coder-fast** | Reasoning | ~100–130 | Everyday research, coding, analysis |
| **reason-pro** / **coder-pro** | Reasoning | ~80–110 | **Default for serious work.** Precision analysis |
| **expert** | Reasoning | ~14–18 | High-stakes tasks where Dense benchmark edge matters |

_See [qwen3.6-model-routing.md](launchers/qwen3.6-mtp/docs/qwen3.6-model-routing.md) for full benchmarks, quality analysis, and the complete decision matrix._

## Gemma-4 Model Routing (MoE 26B-A4B)

| Tier | Quantization | Task Profile | Use Case |
| --- | --- | --- | --- |
| **flash-lite** | Q4_K_M (UD) | High-Volume | Log analysis, data cleaning |
| **flash** | Q4_K_XL (UD) | Agentic / Rapid Chat | Boilerplate, documentation |
| **flash-high** | Q5_K_M | Logic / Math / Code | Debugging, math proofs |
| **pro** | Q5_K_XL | High-Stakes / Batch | Legal/medical, migration |

_See [gemma-4-model-routing.md](launchers/gemma-4-mtp/gemma-4-model-routing.md) for full benchmarks and analysis._

## Supported Models (from `models.json`)

| Model | Provider | Quantizations Available |
| --- | --- | --- |
| Qwen3.6-27B-MTP | unsloth | UD-Q4_K_XL, UD-Q5_K_XL, UD-Q6_K |
| Qwen3.6-35B-A3B-MTP | unsloth | UD-Q4_K_XL, UD-Q5_K_XL, UD-Q6_K |
| Gemma-4 26B-A4B-it | unsloth / bartowski | Q4_K_M/XL (UD), MTP drafter |
| Gemma-4 31B-it | unsloth / bartowski | Q4_K_XL (UD) + MTP drafter |
| Gemma-4 12B-it | unsloth | Q8_K_XL |
| GLM-4.7-Flash | unsloth | Q5_K_XL |
| Nex-N2-mini | bartowski | Q5_K_M |

## Testing OpenAI-Compatible Endpoints

After launching a server, test its endpoints with `curl`. Replace `PORT` with the
actual port (e.g., 8080, 8081, or 7080).

### Chat Completions

```bash
curl http://localhost:PORT/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "model-name",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Hello! Who are you?"}
    ]
  }'
```

### List Models

```bash
curl http://localhost:PORT/v1/models
```


