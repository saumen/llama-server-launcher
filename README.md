# llama-server launcher

Scripts and INI presets for launching [`llama.cpp`](https://github.com/ggml-org/llama.cpp) servers with GGUF models, including Multi-Token Prediction (MTP) speculative decoding.

## Setup

### 1. Download Models

```bash
cd huggingface-scripts
./download-models.sh
```

Prerequisites: `jq` and the Hugging Face CLI (`pip install huggingface_hub`).

See [huggingface-scripts/README.md](huggingface-scripts/README.md) for single-model downloads, dry-run mode, and configuration.

### 2. Configure Server Path

Create a `.env.launcher` file at the repo root:

```bash
cp .env.launcher.example .env.launcher
```

Edit `.env.launcher` and set `LLAMA_SERVER_BIN` to your actual `llama-server` binary path. The `.env.launcher` file is git-ignored and will not be committed.

For the Gemma launcher, also create a `.env.launcher` inside `launchers/gemma-4-mtp/` with the same `LLAMA_SERVER_BIN` setting — it sources from its own directory, not the repo root.

### 3. Launch a Server

Run one of the launcher scripts below to start `llama-server` with pre-configured settings.

## Available Launchers

### Root-Level Launchers (Convenience Scripts)

| Script | Description | Default Port |
| --- | --- | --- |
| `./launcher-qwen.sh` | Qwen3.6 MTP — preset tiers (flash, general, coder) | 8080 |
| `./launcher-qwen3.5-122b-a10b.sh` | Qwen3.5-122B-A10B (122B MoE, 10B active) — standalone launcher | 8081 |
| `./launcher-gemma.sh` | Gemma-4 MTP server (MoE 26B-A4B) | 7080 |

### Preset Launchers (`launchers/`)

Each preset directory contains a launcher script and an INI configuration file with fine-tuned model settings.

| Launcher Path | Model / Family | Port | Notes |
| --- | --- | --- | --- |
| `launchers/qwen3.6-mtp/` | Qwen3.6 MTP — preset tiers (flash, general, coder) | 8080 | Single instance with INI catalog configs |
| `launchers/gemma-4-mtp/` | Gemma-4 26B-A4B MTP (MoE) | 7080 | Primary daily-driver; Unsloth UD quantization |

## Expected Workspace Structure

```
llama-server-launcher/
├── .env.launcher.example          # Template — copy to .env.launcher and set LLAMA_SERVER_BIN
├── .env.launcher                  # Git-ignored; your actual server binary path
├── .gitignore                     # Ignores .env.launcher
├── .markdownlint.json             # Markdown lint configuration
├── AGENTS.md                      # Developer/AI guidelines
├── README.md                      # User-facing documentation
├── launcher-qwen.sh               # Start Qwen3.6 MTP server (port 8080)
├── launcher-qwen3.5-122b-a10b.sh  # Start Qwen3.5-122B-A10B standalone (port 8081)
├── launcher-gemma.sh              # Start Gemma-4 MTP server (port 7080)
│
├── launchers/                     # Preset directories — INI configs + routing docs
│   ├── qwen3.6-mtp/
│   │   ├── qwen3.6-catalog.ini       # Qwen3.6 preset catalog (flash, general, coder)
│   │   ├── README.md                 # Dev memory: preset values, trial notes
│   │   └── docs/
│   │       ├── qwen3.6-model-routing.md      # Benchmarks, KLD, decision matrix
│   │       └── qwen3.6-recommendations.md    # Cached official Qwen3.6 settings
│   │
│   └── gemma-4-mtp/
│       ├── launcher-gemma-4-mtp.sh     # Gemma MTP server (port 7080)
│       ├── gemma-4-mtp.ini             # Gemma-4 preset catalog (flash-lite, flash, flash-high, pro)
│       ├── .env.launcher (create)    # Gemma-specific server binary path (copy from root .env.launcher.example)
│       └── gemma-4-model-routing.md    # Benchmarks, quantization analysis
│
├── docs/                          # Review and analysis documents
│   └── review/                    # Review artifacts
│
└── huggingface-scripts/
    ├── README.md                  # Download script usage docs
    ├── download-models.sh         # HF model downloader (reads models.json)
    └── models.json                # Central model registry: IDs, local dirs, include globs
```

## Qwen3.6 Model Routing (MoE 35B-A3B / Dense 27B / LWM)

Three preset tiers are available — see the full routing guide for benchmarks, KLD quality measurements, and a detailed decision matrix.

| Tier | Alias | Model | Mode | Est. tok/s | Use Case |
| --- | --- | --- | --- | --- | --- |
| **flash** | `Qwen3.6-35B-A3B-IT` | 35B-A3B MoE Q6_K | NT (non-thinking) | ~80–110 | Agentic / rapid chat; near-BF16 quality (KLD ~0.007) |
| **general** | `Qwen3.6-35B-A3B-general` | 35B-A3B MoE Q6_K | General | ~80–110 | Thinking mode + MTP for everyday reasoning |
| **coder** | `Qwen3.6-35B-A3B-Coder` | 35B-A3B MoE Q6_K | Coder | ~80–110 | MoE speed + thinking for coding and analysis |

See [qwen3.6-model-routing.md](launchers/qwen3.6-mtp/docs/qwen3.6-model-routing.md) for the full decision matrix including Dense 27B Expert tiers and AgentWorld LWM.

## Gemma-4 Model Routing (MoE 26B-A4B)

| Tier | Quantization | Task Profile | Use Case |
| --- | --- | --- | --- |
| **flash-lite** | Q4_K_M (UD) | High-Volume | Log analysis, data cleaning |
| **flash** | Q4_K_XL (UD) | Agentic / Rapid Chat | Boilerplate, documentation |
| **flash-high** | Q5_K_M | Logic / Math / Code | Debugging, math proofs |
| **pro** | Q5_K_XL | High-Stakes / Batch | Legal/medical, migration |

_See [gemma-4-model-routing.md](launchers/gemma-4-mtp/gemma-4-model-routing.md) for full benchmarks and analysis._

## Qwen3.5-122B-A10B Standalone Launcher

The `launcher-qwen3.5-122b-a10b.sh` script launches the Qwen3.5-122B-A10B MoE model (122B total, 10B active) as a standalone server on port 8081. All settings are hardcoded as CLI flags — there is no INI preset file. It uses the UD-Q4_K_XL quantization (sharded across 3 files) with MTP speculative decoding.

## Thinking Mode Configuration

Launcher presets use reasoning flags and/or chat template kwargs to control thinking mode.

- **Qwen3.6 flash** preset explicitly disables thinking (`reasoning = off`)
- **Qwen3.6 general & coder** presets enable thinking via `chat-template-kwargs` (each section defines them explicitly)
- **Gemma-4 presets** use `reasoning = on/off` per tier (default `off`; flash-high and pro set `on`)

## Supported Models (from `huggingface-scripts/models.json`)

| Model | Provider | Quantizations Available |
| --- | --- | --- |
| Qwen3.6-35B-A3B (MoE + MTP) | unsloth | UD-Q4_K_XL, UD-Q5_K_XL, UD-Q6_K, UD-Q8_K_XL |
| Qwen3.5-122B-A10B (MoE + MTP) | unsloth | UD-Q4_K_XL |
| Gemma-4 26B-A4B-it (MoE) | unsloth | UD-Q4_K_M, UD-Q4_K_XL, UD-Q5_K_M, UD-Q5_K_XL, MTP drafter |
| Gemma-4 31B-it (Dense) | unsloth | UD-Q4_K_XL, MTP drafter |

## Testing OpenAI-Compatible Endpoints

After launching a server, test its endpoints with `curl`. Replace `PORT` with the actual port (e.g., 8080 or 7080).

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

---

_Note: This directory is managed by the docs-sync prompt. Manual edits should be handled with care to avoid disrupting system-managed files._