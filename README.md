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
| `launcher-qwen.sh` | Qwen 3.6 MTP — single instance with 5 routing tiers | 8080 |

### Preset Launchers (`launchers/`)

Each preset directory contains a launcher script and an INI configuration file for fine-tuned model settings.

| Launcher Path | Model / Family | Port | Notes |
| --- | --- | --- | --- |
| `qwen3.6-mtp/` | Qwen3.6 MTP — 5 routing tiers (flash, general, coder, +expert) | 8080 | Single instance with INI catalog configs |
| `gemma-4-mtp/` | Gemma-4 26B-A4B MTP (MoE) | 7080 | Primary daily-driver; Unsloth UD quantization |
| `nex-mini/` | Nex-N2-mini (nex-agi) | 8082 | Small-footprint model |

## Qwen3.6 Model Routing (MoE 35B-A3B / Dense 27B)

Five routing tiers are available across NT and Reasoning presets — see the full routing guide for benchmarks, KLD quality
measurements, and a detailed decision matrix.

| Tier | Alias | Mode | Est. tok/s | Use Case |
| --- | --- | --- | --- | --- |
| **flash** | `Qwen3.6-35B-A3B-Q5-IT` | NT | ~80–110 | Agentic / rapid chat; near-BF16 quality (KLD ~0.007) |
| **general** | `Qwen3.6-35B-A3B-Q5-general` | General | ~80–110 | Thinking mode + MTP for everyday reasoning |
| **general-expert** | `Qwen3.6-27B-Q5-Expert` | General | ~14–18 | 27B Dense with 150K context for deep reasoning |
| **coder** | `Qwen3.6-35B-A3B-Q5-Coder` | Coder | ~80–110 | MoE speed + thinking for coding and analysis |
| **coder-expert** | `Qwen3.6-27B-Q5-Coder` | Coder | ~14–18 | 27B Dense with 150K context for complex coding |

_See [qwen3.6-model-routing.md](launchers/qwen3.6-mtp/docs/qwen3.6-model-routing.md) for full benchmarks, quality analysis, and the complete decision matrix._

## Gemma-4 Model Routing (MoE 26B-A4B)

| Tier | Quantization | Task Profile | Use Case |
| --- | --- | --- | --- |
| **flash-lite** | Q4_K_M (UD) | High-Volume | Log analysis, data cleaning |
| **flash** | Q4_K_XL (UD) | Agentic / Rapid Chat | Boilerplate, documentation |
| **flash-high** | Q5_K_M | Logic / Math / Code | Debugging, math proofs |
| **pro** | Q5_K_XL | High-Stakes / Batch | Legal/medical, migration |

_See [gemma-4-model-routing.md](launchers/gemma-4-mtp/gemma-4-model-routing.md) for full benchmarks and analysis._

## Thinking Mode Configuration

Launcher presets use reasoning flags and/or chat template kwargs to control thinking mode.

- **Qwen3.6 flash** preset uses `reasoning = off` explicitly
- **Other Qwen tiers** rely on the inherited
  `chat-template-kwargs = {"enable_thinking":true}` base default
- **Gemma-4 presets** use `reasoning = on/off` per tier

| Approach | Example | Layer |
| --- | --- | --- |
| `reasoning` (preferred) | `reasoning = on` | llama.cpp native flag — integrates with output parser |
| `chat-template-kwargs` | `chat-template-kwargs = {"enable_thinking":true}` | Jinja template variable — no parser integration |

**Why `reasoning` is preferred:**

- **Parser integration** — llama.cpp knows reasoning is active, enabling features like extracting thoughts into `reasoning_content` and proper thinking marker handling
- **Cleaner syntax** — `on`/`off` is readable and unambiguous compared to inline JSON
- **Model-agnostic** — works even when the chat template doesn't explicitly support `enable_thinking`, because llama.cpp handles the thinking path at the parser level
- **Future-proof** — part of the evolving reasoning infrastructure alongside `reasoning-budget` and `reasoning-format`

`chat-template-kwargs` remains useful for per-request overrides via the OpenAI-compatible API endpoint.

## Supported Models (from `huggingface-scripts/models.json`)

| Model | Provider | Quantizations Available |
| --- | --- | --- |
| Qwen3.6-27B (Dense + MTP) | unsloth | UD-Q4_K_XL, UD-Q5_K_XL, UD-Q6_K |
| Qwen3.6-35B-A3B (MoE + MTP) | unsloth | UD-Q4_K_XL, UD-Q5_K_XL, UD-Q6_K |
| Gemma-4 26B-A4B-it | unsloth / bartowski | Q4_K_M/XL (UD), MTP drafter |
| Gemma-4 31B-it | unsloth / bartowski | Q4_K_XL (UD) + MTP drafter |
| Gemma-4 12B-it | unsloth | UD-Q8_K_XL |
| GLM-4.7-Flash | unsloth | UD-Q5_K_XL |
| Nex-N2-mini | bartowski | Q5_K_M |

## Testing OpenAI-Compatible Endpoints

After launching a server, test its endpoints with `curl`. Replace `PORT` with the
actual port (e.g., 8080, 8082, or 7080).

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
