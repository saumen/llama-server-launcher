# llama-server launcher

Scripts and INI presets for launching [`llama.cpp`](https://github.com/ggml-org/llama.cpp) servers with GGUF models,
including Multi-Token Prediction (MTP) speculative decoding.

## Setup

### 1. Build or Obtain llama-server

If you need to build `llama-server` from source on DGX Spark, use the compiler script:

```bash
ssh saumen@dgx-spark
cd /home/saumen/workspace/github/ggml-org
bash /path/to/llama-server-launcher/compiler.sh
```

This clones/checks out llama.cpp at a configurable tag (default `v0.3.0`), builds with CUDA, and copies binaries into
the source tree. The build output path is printed on success.

Alternatively, use a pre-built `llama-server` binary from a llama.cpp release.

### 2. Configure Server Path

Create a `.env.launcher` file at the repo root:

```bash
cp .env.launcher.example .env.launcher
```

Edit `.env.launcher` and set `LLAMA_SERVER_BIN` to your actual `llama-server` binary path. The `.env.launcher` file is
git-ignored and will not be committed.

The default example also sets:

- `HF_CACHE_DIR` — HuggingFace model cache root (default: `~/.cache/huggingface/hub`)
- `HF_UNSLOTH_DIR` — Unsloth-specific models subdirectory (derived from `HF_CACHE_DIR`)
- `LLAMA_CACHE` — Redirects llama.cpp's HF cache scan to `/tmp/llama-cpp-empty-cache` so only INI presets appear

### 3. Launch a Server

Run one of the launcher scripts below to start `llama-server` with pre-configured settings.

## Available Launchers

| Script | Description | Default Port |
| --- | --- | --- |
| `./launcher-qwen3.6.sh` | Qwen3.6 MTP — NT/flash preset (Q6_K quantization) | 8036 |
| `./launcher-qwen3.8.sh` | Qwen3.8-27B MTP — expert preset (Q6_K_XL quantization) | 8888 |
| `./launcher-qwen-hybrid.sh` | Hybrid — Qwen3.6 + Qwen3.8 in one server (two presets) | 8888 |

All three launchers run on `0.0.0.0`, use flash attention, continuous batching, Jinja chat template, full GPU offload,
and emit Prometheus metrics (`--metrics`). Logs are written to `/tmp/YYYY-MM-DD-llama-qwen3.N/qwen3.N-catalog.log`.

## Expected Workspace Structure

```text
llama-server-launcher/
├── .env.launcher.example          # Template — copy to .env.launcher and set LLAMA_SERVER_BIN
├── .env.launcher                  # Git-ignored; your actual server binary path
├── .gitignore                     # Ignores .env.launcher
├── .markdownlint.json             # Markdown lint configuration (line length 120)
├── AGENTS.md                      # Developer/AI guidelines
├── README.md                      # User-facing documentation
├── launcher-qwen3.6.sh            # Start Qwen3.6 MTP server (port 8036)
├── launcher-qwen3.8.sh            # Start Qwen3.8-27B MTP server (port 8888)
├── launcher-qwen-hybrid.sh        # Start hybrid Qwen3.6+Qwen3.8 server (port 8888)
├── compiler.sh                    # Build llama.cpp from source on DGX Spark
│
├── launchers/                     # Preset directories — INI configs + dev docs
│   ├── qwen-hybrid/
│   │   └── qwen-hybrid-catalog.ini  # Hybrid preset catalog (Qwen3.6 + Qwen3.8)
│   │
│   ├── qwen3.6-mtp/
│   │   ├── qwen3.6-catalog.ini    # Qwen3.6 preset catalog (single NT preset)
│   │   ├── README.md              # Dev memory: preset values, trial notes
│   │   └── docs/
│   │       └── qwen3.6-recommendations.md    # Cached official Qwen3.6 settings
│   │
│   └── qwen3.8-mtp/
│       ├── qwen3.8-catalog.ini    # Qwen3.8-27B preset catalog (single expert preset)
│       ├── README.md              # Dev memory: preset values, per-mode settings
```

## Qwen3.6 Model Routing (MoE 35B-A3B)

Currently configured with a single NT (non-thinking) preset using `Q6_K` quantization and MTP speculative decoding.

| Preset | Alias | Mode | Est. tok/s | Use Case |
| --- | --- | --- | --- | --- |
| **NT** | `qwen3.6-flash` | Non-thinking (`reasoning=off`) | ~80-110 | Agentic / rapid chat; high throughput |

## Qwen3.8 Model Routing (Dense 27B)

Currently configured with a single expert preset using `Q6_K_XL` quantization and MTP speculative decoding. Qwen3.8-27B
is a hybrid thinking model, so the preset follows
[Unsloth recommended settings](https://unsloth.ai/docs/models/qwen3.8#recommended-settings) for its mode:

| Preset | Alias | Mode | temp | top-p | presence-penalty | Use Case |
| --- | --- | --- | --- | --- | --- | --- |
| **expert** | `qwen3.8-expert` | Non-thinking (`reasoning=off`) | 0.6 | 0.90 | 1.5 | Proofreading / ASR repair; deterministic workflow |

The preset shares `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, and `ctx-size=262144` from the base preset defaults.
See [qwen3.8-catalog.ini](launchers/qwen3.8-mtp/qwen3.8-catalog.ini) for full settings.

## Hybrid Model Routing (Qwen3.6 + Qwen3.8)

The hybrid launcher (`launcher-qwen-hybrid.sh`) runs both models on a single server using two presets from
[qwen-hybrid-catalog.ini](launchers/qwen-hybrid/qwen-hybrid-catalog.ini). The server exposes both `qwen3.6-flash` and
`qwen3.8-expert` model aliases via the OpenAI-compatible API.

| Preset | Alias | Model | Quantization | Port |
| --- | --- | --- | --- | --- |
| **NT (flash)** | `qwen3.6-flash` | Qwen3.6-35B-A3B | Q6_K | 8888 |
| **Expert** | `qwen3.8-expert` | Qwen3.8-27B | Q6_K_XL | 8888 |

## Testing OpenAI-Compatible Endpoints

After launching a server, test its endpoints with `curl`. Replace `PORT` with the actual port — Qwen3.6 runs on 8036,
Qwen3.8 and hybrid both run on 8888.

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

_Note: This directory is managed by the docs-sync skill. Manual edits should be handled with care to avoid disrupting
system-managed files._
