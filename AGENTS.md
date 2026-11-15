# llama-server-launcher — Repository Guidelines

## Documentation & File Purposes

This project uses multiple markdown files, each with a distinct audience and scope. Do not duplicate content across
them.

| File | Audience | Scope |
| --- | --- | --- |
| [`README.md`](README.md) | End users | Setup, workspace layout, workflow, feature usage |
| `AGENTS.md` (this file) | Developers & AI assistants | Project structure, conventions, development guidance |
| [`launchers/qwen3.6-mtp/README.md`](launchers/qwen3.6-mtp/README.md) | Developers | Qwen3.6 catalog preset memory: config values, inheritance, trial notes |
| [`launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md`](launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md) | Developers | Cached official Qwen3.6 recommended settings from HuggingFace |
| [`launchers/qwen3.8-mtp/README.md`](launchers/qwen3.8-mtp/README.md) | Developers | Qwen3.8 catalog preset memory: config values, per-mode settings |
| [`launchers/qwen-hybrid/qwen-hybrid-catalog.ini`](launchers/qwen-hybrid/qwen-hybrid-catalog.ini) | Developers | Hybrid catalog: combined Qwen3.6 + Qwen3.8 presets + base defaults |
| [`.markdownlint.json`](.markdownlint.json) | All developers | Markdown lint config: line length 120, compact style, allowed `<br/>` |

**Rule:** If content belongs to a user-facing guide (setup, usage), it goes in README. If it's developer/AI guidance
(standards, conventions, structure), it goes here. Routing docs and benchmark analysis stay in their respective
`launchers/*/docs/` directories.

## Project Structure & Module Organization

```text
llama-server-launcher/
├── .env.launcher.example      # Template for .env.launcher (set LLAMA_SERVER_BIN)
├── .env.launcher              # Git-ignored; actual server binary path
├── .gitignore                 # Ignores .env.launcher
├── .markdownlint.json         # Markdown lint configuration
├── README.md                  # User-facing documentation
├── AGENTS.md                  # This file — developer/AI guidelines
├── launcher-qwen3.6.sh        # Root launcher: Qwen3.6 MTP server on port 8036
├── launcher-qwen3.8.sh        # Root launcher: Qwen3.8-27B MTP server on port 8888
├── launcher-qwen-hybrid.sh    # Root launcher: hybrid Qwen3.6+Qwen3.8 server on port 8888
├── launcher-qwen3.5-122b-a10b.sh # Standalone launcher: Qwen3.5-122B-A10B on port 8081, CLI flags only
├── compiler.sh                # Build llama.cpp from source on DGX Spark
│
├── launchers/
│   ├── qwen-hybrid/
│   │   └── qwen-hybrid-catalog.ini # INI preset catalog: Qwen3.6 + Qwen3.8 presets
│   │
│   ├── qwen3.6-mtp/
│   │   ├── README.md          # Dev memory: catalog preset values, inheritance, trial notes
│   │   ├── qwen3.6-catalog.ini # INI preset catalog: 1 Qwen3.6 NT preset + base defaults
│   │   └── docs/
│   │       └── qwen3.6-recommendations.md # Cached official Qwen settings
│   │
│   └── qwen3.8-mtp/
│       ├── README.md          # Dev memory: catalog preset values, per-mode settings
│       └── qwen3.8-catalog.ini # INI preset catalog: 1 Qwen3.8 expert preset + base defaults
```

**Note:** The following items were removed in a refactor and are no longer present:

- `launcher-qwen.sh` → replaced by `launcher-qwen3.6.sh` (port changed from 8080 to 8036)
- `launcher-gemma.sh` and `launchers/gemma-4-mtp/` — Gemma launcher consolidated away
- `huggingface-scripts/` — model download script directory removed

## Build, Test, and Development Commands

This is a shell/INI configuration project — there is no build step or test suite.

| Command | Purpose |
| --- | --- |
| `./launcher-qwen3.6.sh` | Start Qwen3.6 MTP server on port 8036 |
| `./launcher-qwen3.8.sh` | Start Qwen3.8-27B MTP server on port 8888 |
| `./launcher-qwen-hybrid.sh` | Start hybrid Qwen3.6+Qwen3.8 server on port 8888 (two presets, one server) |
| `./launcher-qwen3.5-122b-a10b.sh` | Start Qwen3.5-122B-A10B MTP server on port 8081 (no INI, CLI flags only) |
| `bash compiler.sh` | Build llama.cpp from source on DGX Spark (default tag v1.0.0) |
| `LLAMA_CPP_TAG=vX.Y.Z bash compiler.sh` | Build a specific llama.cpp version |

### Context-Specific Notes

- Both root launchers (`launcher-qwen3.6.sh`, `launcher-qwen3.8.sh`) source `.env.launcher` from repo root and point at
  their respective INI catalogs in `launchers/qwen3.6-mtp/` and `launchers/qwen3.8-mtp/`.
- The standalone launcher (`launcher-qwen3.5-122b-a10b.sh`) has no INI catalog. It hardcodes every setting as a
  command-line flag and builds the model path from `HF_UNSLOTH_DIR` (defined in `.env.launcher`). It does not pass
  `--metrics` or `--image-min-tokens`.
- The hybrid launcher (`launcher-qwen-hybrid.sh`) sources `.env.launcher` and points to the combined catalog in
  `launchers/qwen-hybrid/qwen-hybrid-catalog.ini`. It uses `--models-max 2` to load both presets into one server on
  port 8888.
- INI configs use **hardcoded absolute paths** (`/home/saumen/.cache/huggingface/hub/...`). These will fail on other
  machines. Before deploying elsewhere, update all `model` and `mmproj` paths in the INI files.
- Logs are written to `/tmp/YYYY-MM-DD-llama-qwen3.N/qwen3.N-catalog.log`. Qwen3.6 uses port 8036. Qwen3.8 uses port
  8888.
- Both launchers use `--device CUDA0` and `--spec-draft-device CUDA0`. If your GPU is on a different device, update the
  `--device` flags in the launcher scripts.
- Both launchers include `--image-min-tokens 1024` for vision/multimodal support.

## Commit & Pull Request Guidelines

- Use conventional commit prefixes (`feat:`, `fix:`, `docs:`, `refactor:`). Imperative mood, subject line under 72
  characters, no trailing period.
- Example: `feat: Add coder tier to Qwen3.6 catalog`
- Each pull request must include a clear description. Link each related issue, and note any environment variable or
  path changes.

## Documentation & Planning

- [Qwen3.6 official recommended settings](launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md)
- [Unsloth Qwen3.8 recommended settings](https://unsloth.ai/docs/models/qwen3.8#recommended-settings)
- [llama.cpp preset docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md)
- [llama.cpp speculative decoding docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md)

## Agent-Specific Instructions

### Before modifying code

1. Read the relevant INI catalog (`qwen3.6-catalog.ini`, `qwen3.8-catalog.ini`, or `qwen-hybrid-catalog.ini`) to
   understand preset inheritance from the `[ * ]` base defaults.
2. Read the corresponding launcher script to understand CLI flags set outside the INI (e.g., `--gpu-layers all` is set
   in the launcher scripts, not the INI).
3. Before you change model tiers, read the routing docs for benchmark data and decision rationale.

### Patterns to follow

- **INI preset inheritance:** All presets inherit from `[ * ]` base defaults. Override only what differs. Do not repeat
  base values in every preset.
- **Thinking mode:** Use `reasoning = on/off` (llama.cpp native flag) for per-preset thinking control. Do NOT use
  `chat-template-kwargs`.
- **MTP config:** Both Qwen3.6 and Qwen3.8 use `spec-draft-n-max = 3` (DGX Spark-specific). The MTP head is embedded in
  the main GGUF — `draft-mtp` uses the in-file MTP module, no separate `spec-draft-model`.
- **Model paths:** INI configs use absolute paths. When a model re-download changes the paths, update them manually.
- **Launcher scripts:** Both root launchers are self-contained entry points that run `llama-server` directly. The
  `launchers/` directory holds the INI catalogs and routing docs they reference.

### INI config conventions

Section names follow the pattern `[unsloth/<model-name>]` for MTP models.

- `alias` field defines the model name exposed via the API.
- `model` and `mmproj` paths are absolute. Do not use `spec-draft-model` (the MTP head is in-file).

## Domain-Specific Guidelines

### Qwen3.6 Catalog (`qwen3.6-catalog.ini`)

Verified against `launchers/qwen3.6-mtp/qwen3.6-catalog.ini`:

- **Base `[ * ]` defaults:** `ctx-size=250000`, `cache-type-k=q8_0`, `cache-type-v=q8_0`, `temperature=0.6`,
  `top-p=0.95`, `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`,
  `draft-p-min=0.50`, `spec-draft-type-k=q8_0`, `spec-draft-type-v=q8_0`.
- **NT preset (`unsloth/Qwen3.6-35B-A3B`):** The alias is `qwen3.6-35b-a3b`. The preset uses `Q6_K` quantization. These
  values override the base defaults:
  `reasoning=off`, `temperature=0.7`, `top-p=0.80`, `presence-penalty=1.5`.
- GPU offload is set via CLI flags in `launcher-qwen3.6.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not in the
  INI.

### Qwen3.8 Catalog (`qwen3.8-catalog.ini`)

Verified against `launchers/qwen3.8-mtp/qwen3.8-catalog.ini`:

- **Base `[ * ]` defaults:** `ctx-size=262144`, `cache-type-k=q8_0`, `cache-type-v=q8_0`, `top-k=20`, `min-p=0.0`,
  `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`, `spec-draft-type-k=q8_0`,
  `spec-draft-type-v=q8_0`.
- **Expert preset (`unsloth/Qwen3.8-27B`):** The alias is `qwen3.8-27b`. The preset uses `Q6_K_M` quantization. These
  values override the base defaults:
  `reasoning=off`, `temperature=0.6`, `top-p=0.90`, `presence-penalty=1.5`.
- The expert preset is a proofreading sampler. It does not copy the Unsloth instruct row. See README.md for the
  proofreading note and the Unsloth link.
- Qwen3.8-27B is a dense Qwen3.5-family model with an MTP head embedded in the main GGUF — `draft-mtp` uses the in-file
  MTP module, no separate `spec-draft-model`.
- `model` path uses the HF cache snapshot layout
  (`models--unsloth--Qwen3.8-27B-GGUF/snapshots/4af51b3542f775b0a8e4b310bfb3f17e01c306c9/`). The model does not appear
  in `models.json`.
- GPU offload is set via CLI flags in `launcher-qwen3.8.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not the INI.

### Hybrid Catalog (`qwen-hybrid-catalog.ini`)

Verified against `launchers/qwen-hybrid/qwen-hybrid-catalog.ini`:

- **Base `[ * ]` defaults:** Inherits from Qwen3.8 base — `ctx-size=262144`, `cache-type-k=q8_0`, `cache-type-v=q8_0`,
  `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`,
  `spec-draft-type-k=q8_0`, `spec-draft-type-v=q8_0`. (`ctx-size` uses Qwen3.8's 262144, not Qwen3.6's 250000. The base
  also carries Qwen3.6-style `temperature=0.6` and `top-p=0.95`, which both presets override.)
- Contains **both** Qwen3.6 NT preset and Qwen3.8 expert preset in a single file — each is an exact copy of the original
  catalog entries with no modifications.
- GPU offload uses CLI flags in `launcher-qwen-hybrid.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not the INI.
- Uses `--models-max 2` to load both presets into a single server instance.

### Standalone Qwen3.5-122B Launcher (`launcher-qwen3.5-122b-a10b.sh`)

Verified against `launcher-qwen3.5-122b-a10b.sh`:

- No INI catalog. Every setting is a command-line flag on the `llama-server` invocation.
- Model: `unsloth/Qwen3.5-122B-A10B-MTP-GGUF` `UD-Q4_K_XL` multi-part GGUF (shard 1 of 3). The path is relative to
  `HF_UNSLOTH_DIR` from `.env.launcher`, not a hardcoded absolute path like the INI catalogs use.
- Aliases: `Qwen3.5-122B-A10B-NT` with secondary alias `qwen-122b-a10b-it`.
- Runs on port 8081. Sampling: `temp=0.7`, `top-p=0.80`, `top-k=20`, `min-p=0.0`, `presence-penalty=1.5`.
- MTP: `spec-type=draft-mtp`, `spec-draft-n-max=2` (not 3 like the INI catalogs), `spec-draft-p-min=0.50`.
- `ctx-size=200000`, `cache-type-k/v=q8_0`, `reasoning off`, `--log-verbosity 4`. No `--metrics` flag.
