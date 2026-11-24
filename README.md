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

This clones/checks out llama.cpp at a configurable tag (default `v1.0.0`), builds with CUDA, and copies binaries into
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
| `./launcher-qwen3.8.sh` | Qwen3.8-27B MTP — expert preset (Q6_K_M quantization) | 8888 |
| `./launcher-qwen-hybrid.sh` | Hybrid — Qwen3.6 + Qwen3.8 in one server (two presets) | 8888 |
| `./launcher-qwen3.5-122b-a10b.sh` | Qwen3.5-122B-A10B MTP — NT preset (Q4_K_XL quantization) | 8081 |
| `./launcher-inkling-2-mini.sh` | Inkling 2 Mini — UD-Q8_K_XL and UD-Q4_K_XL presets | 8888 |

The Qwen3.6, Qwen3.8, hybrid, and Inkling launchers load settings from an INI preset catalog. The Qwen3.5-122B launcher
passes all settings as command-line flags instead. All five launchers run on `0.0.0.0`, use flash attention, continuous
batching, the Jinja chat template, and full GPU offload. The INI launchers also emit Prometheus metrics (`--metrics`).
Logs go to `/tmp/YYYY-MM-DD-llama-<model>/<name>.log`.

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
├── launcher-qwen3.5-122b-a10b.sh  # Start Qwen3.5-122B-A10B MTP server (port 8081, CLI flags only)
├── launcher-inkling-2-mini.sh     # Start Inkling 2 Mini server (port 8888, two presets)
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
│   ├── qwen3.8-mtp/
│   │   ├── qwen3.8-catalog.ini    # Qwen3.8-27B preset catalog (single expert preset)
│   │   └── README.md              # Dev memory: preset values, per-mode settings
│   │
│   └── inkling-2-mini/
│       ├── inkling-2-mini-catalog.ini  # Two Inkling 2 Mini presets (UD-Q8_K_XL, UD-Q4_K_XL)
│       └── README.md              # Dev memory: binary, DSpark, paths
```

## Qwen3.6 Model Routing (MoE 35B-A3B)

Currently configured with a single NT (non-thinking) preset using `Q6_K` quantization and MTP speculative decoding.

| Preset | Alias | Mode | Est. tok/s | Use Case |
| --- | --- | --- | --- | --- |
| **NT** | `qwen3.6-35b-a3b` | Non-thinking (`reasoning=off`) | ~80-110 | Agentic and rapid chat. High throughput. |

## Qwen3.8 Model Routing (Dense 27B)

Currently configured with a single expert preset using `Q6_K_M` quantization and MTP speculative decoding. Qwen3.8-27B
is a hybrid thinking model. The expert preset keeps the proofreading sampler (`temperature=0.6`, `top-p=0.90`). That
row is not the Unsloth instruct row:

| Preset | Alias | Mode | temp | top-p | presence-penalty | Use Case |
| --- | --- | --- | --- | --- | --- | --- |
| **expert** | `qwen3.8-27b` | Non-thinking (`reasoning=off`) | 0.6 | 0.90 | 1.5 | Proofreading and ASR repair. Deterministic workflow. |

The preset shares `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, and `ctx-size=262144` from the base preset defaults.
See [qwen3.8-catalog.ini](launchers/qwen3.8-mtp/qwen3.8-catalog.ini) for full settings.

## Hybrid Model Routing (Qwen3.6 + Qwen3.8)

The hybrid launcher (`launcher-qwen-hybrid.sh`) runs both models on a single server using two presets from
[qwen-hybrid-catalog.ini](launchers/qwen-hybrid/qwen-hybrid-catalog.ini). The server exposes both `qwen3.6-35b-a3b` and
`qwen3.8-27b` model aliases via the OpenAI-compatible API.

| Preset | Alias | Model | Quantization | Port |
| --- | --- | --- | --- | --- |
| **NT (flash)** | `qwen3.6-35b-a3b` | Qwen3.6-35B-A3B | Q6_K | 8888 |
| **Expert** | `qwen3.8-27b` | Qwen3.8-27B | Q6_K_M | 8888 |

## Qwen3.5 Model Routing (MoE 122B-A10B)

The standalone launcher (`launcher-qwen3.5-122b-a10b.sh`) runs Qwen3.5-122B-A10B with a single NT (non-thinking) preset
using `Q4_K_XL` quantization and MTP speculative decoding.

| Preset | Alias | Mode | temp | top-p | presence-penalty | Use Case |
| --- | --- | --- | --- | --- | --- | --- |
| **NT** | `Qwen3.5-122B-A10B-NT` (also `qwen-122b-a10b-it`) | Non-thinking (`--reasoning off`) | 0.7 | 0.80 | 1.5 | General tasks. Large MoE with 10B active params. |

The launcher hardcodes all settings as command-line flags. There is no INI catalog for this model. It uses
`--spec-draft-n-max 2` for MTP speculation, `ctx-size 200000`, and a multi-part `Q4_K_XL` GGUF split. The launcher does
not pass `--metrics`.

## Inkling 2 Mini (DGX Spark)

`./launcher-inkling-2-mini.sh` starts one Inkling 2 Mini server on port 8888. The catalog lists two presets. The server
loads one preset at a time.

| Preset | Alias | Quantization |
| --- | --- | --- |
| UD-Q8_K_XL | `inkling-2-mini-ud-q8-k-xl` | UD-Q8_K_XL |
| UD-Q4_K_XL | `inkling-2-mini-ud-q4-k-xl` | UD-Q4_K_XL |

The script does not download model files. The script does not stop other servers.
The 23 Nov quants load in mainline llama.cpp. The script sources `.env.launcher` but overwrites `LLAMA_SERVER_BIN`
with the Unsloth sibling binary, so the `.env.launcher` value is ignored. That build decodes faster.

The binary is `/home/saumen/workspace/github/ggml-org/2026-11-23-b12649-mix-c7059d6/llama.cpp/llama-server`.
Install steps are in [launchers/inkling-2-mini/README.md](launchers/inkling-2-mini/README.md).
Source: [23 Nov update](https://unsloth.ai/docs/models/inkling-2-mini#id-23rd-november-update).
The DGX Spark asset is on [the DGX Spark tab](https://unsloth.ai/docs/models/inkling-2-mini#dgx-spark).

Run the download on DGX Spark before you start the launcher. The preset paths are absolute. A download without the
drafter file fails at start. Unsloth replaced these GGUF files on 23 Nov 2026. If the local files are older than
that date, download them again.

```bash
hf download unsloth/Inkling-2-Mini-GGUF \
    Inkling-2-Mini-UD-Q8_K_XL.gguf \
    Inkling-2-Mini-UD-Q4_K_XL.gguf \
    mmproj-F16.gguf \
    dspark-Inkling-2-Mini-Q8_0.gguf \
    --local-dir /home/saumen/.cache/huggingface/hub/unsloth/Inkling-2-Mini-GGUF
```

Do not download the `Mainline_Support` files. Do not download the `dspark/` BF16 drafter. The catalog uses the root
`Q8_0` drafter.

## Testing OpenAI-Compatible Endpoints

After launching a server, test its endpoints with `curl`. Replace `PORT` with the actual port. Qwen3.6 runs on 8036.
Qwen3.8, hybrid, and Inkling 2 Mini run on 8888. Qwen3.5-122B runs on 8081.

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

_Note: The docs-sync skill manages this directory. Read this note before you edit the files by hand. Manual edits can
conflict with system-managed files._
