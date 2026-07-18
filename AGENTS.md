# llama-server-launcher — Repository Guidelines

## Documentation & File Purposes

This project uses multiple markdown files, each with a distinct audience and scope. Do not duplicate content across them.

|File|Audience|Scope|
|---|---|---|
|[`README.md`](README.md)|End users|Setup, workspace layout, workflow, feature usage|
|`AGENTS.md` (this file)|Developers & AI assistants|Project structure, conventions, development guidance|
|[`huggingface-scripts/README.md`](huggingface-scripts/README.md)|End users|Model download script usage and configuration|
|[`launchers/qwen3.6-mtp/README.md`](launchers/qwen3.6-mtp/README.md)|Developers|Qwen3.6 catalog preset memory: config values, inheritance, trial notes|
|[`launchers/qwen3.6-mtp/docs/qwen3.6-model-routing.md`](launchers/qwen3.6-mtp/docs/qwen3.6-model-routing.md)|Developers|Qwen3.6 benchmark data, KLD analysis, decision matrix|
|[`launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md`](launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md)|Developers|Cached official Qwen3.6 recommended settings from HuggingFace|
|[`launchers/gemma-4-mtp/gemma-4-model-routing.md`](launchers/gemma-4-mtp/gemma-4-model-routing.md)|Developers|Gemma-4 benchmark data, quantization analysis, decision matrix|
|[`.markdownlint.json`](.markdownlint.json)|All developers|Markdown lint config: line length 120, compact style, allowed `<br>`|

**Rule:** If content belongs to a user-facing guide (setup, usage), it goes in README. If it's developer/AI guidance (standards, conventions, structure), it goes here. Routing docs and benchmark analysis stay in their respective `launchers/*/docs/` directories.

## Project Structure & Module Organization

```
llama-server-launcher/
├── .env.launcher.example      # Template for .env.launcher (set LLAMA_SERVER_BIN)
├── .env.launcher              # Git-ignored; actual server binary path
├── .gitignore                 # Ignores .env.launcher
├── .markdownlint.json         # Markdown lint configuration
├── README.md                  # User-facing documentation
├── AGENTS.md                  # This file — developer/AI guidelines
├── launcher-qwen.sh           # Root launcher: Qwen3.6 MTP server on port 8080
├── launcher-qwen3.5-122b-a10b.sh  # Standalone launcher: Qwen3.5-122B-A10B on port 8081
├── launcher-gemma.sh          # Root launcher: delegates to launchers/gemma-4-mtp/
│
├── launchers/
│   ├── qwen3.6-mtp/
│   │   ├── README.md          # Dev memory: catalog preset values, inheritance, trial notes
│   │   ├── qwen3.6-catalog.ini # INI preset catalog: 3 Qwen presets + base defaults
│   │   └── docs/
│   │       ├── qwen3.6-model-routing.md   # Benchmarks, KLD, decision matrix
│   │       └── qwen3.6-recommendations.md # Cached official Qwen settings
│   │
│   └── gemma-4-mtp/
│       ├── launcher-gemma-4-mtp.sh  # Gemma MTP server on port 7080
│       ├── gemma-4-mtp.ini          # INI preset catalog: 4 Gemma tiers + base defaults
│       └── gemma-4-model-routing.md # Benchmarks, quantization analysis, decision matrix
│
├── docs/
│   └── review/                      # Review artifacts
│
└── huggingface-scripts/
    ├── README.md              # Download script usage docs
    ├── download-models.sh     # HF model downloader (reads models.json)
    └── models.json            # Central model registry: IDs, local dirs, include globs
```

## Build, Test, and Development Commands

This is a shell/INI configuration project — there is no build step or test suite.

|Command|Purpose|
|---|---|
|`./launcher-qwen.sh`|Start Qwen3.6 MTP server on port 8080|
|`./launcher-qwen3.5-122b-a10b.sh`|Start Qwen3.5-122B-A10B standalone server on port 8081|
|`./launcher-gemma.sh`|Start Gemma-4 MTP server on port 7080|
|`./huggingface-scripts/download-models.sh`|Download all models from `models.json`|
|`./huggingface-scripts/download-models.sh --list`|List available model IDs|
|`./huggingface-scripts/download-models.sh --dry-run`|Preview downloads without executing|
|`./huggingface-scripts/download-models.sh <modelId>`|Download a single model by ID|

### Context-Specific Notes

- Root launcher `launcher-qwen.sh` sources `.env.launcher` from repo root; root launcher `launcher-gemma.sh` delegates to `launchers/gemma-4-mtp/launcher-gemma-4-mtp.sh`, which sources `.env.launcher` from its own directory (`launchers/gemma-4-mtp/`).
- INI configs use **hardcoded absolute paths** (`/home/saumen/.cache/huggingface/hub/...`). These will fail on other machines. Before deploying elsewhere, update all `model` and `spec-draft-model` paths in the INI files.
- Logs are written to `/tmp/YYYY-MM-DD-llama-qwen3.6/qwen3.6-catalog.log` by the Qwen launcher.
- The Gemma launcher (`launcher-gemma.sh`) is a thin wrapper that sources `launchers/gemma-4-mtp/launcher-gemma-4-mtp.sh`.
- `launcher-gemma-4-mtp.sh` references the INI via tilde path (`~/workspace/github/saumen/llama-server-launcher/...`), not `$SCRIPT_DIR`.

## Commit & Pull Request Guidelines

- Use conventional commit prefixes (`feat:`, `fix:`, `docs:`, `refactor:`). Imperative mood, subject line under 72 characters, no trailing period.
- Example: `feat: Add coder tier to Qwen3.6 catalog`
- PRs should include a clear description, link related issues, and note any environment variable or path changes.

## Documentation & Planning

- [Qwen3.6 model routing & decision matrix](launchers/qwen3.6-mtp/docs/qwen3.6-model-routing.md)
- [Qwen3.6 official recommended settings](launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md)
- [Gemma-4 model routing & quantization analysis](launchers/gemma-4-mtp/gemma-4-model-routing.md)
- [llama.cpp preset docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md)
- [llama.cpp speculative decoding docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md)
- [Unsloth Qwen3.6 recommended settings](https://unsloth.ai/docs/models/qwen3.6#recommended-settings)

## Agent-Specific Instructions

### Before modifying code

1. Read the relevant INI catalog (`qwen3.6-catalog.ini` or `gemma-4-mtp.ini`) to understand preset inheritance from the `[ * ]` base defaults.
2. Read the corresponding launcher script to understand CLI flags set outside the INI (e.g., `--gpu-layers all` is set in `launcher-qwen.sh`, not the INI).
3. Cross-reference routing docs for benchmark data and decision rationale before changing model tiers.

### Patterns to follow

- **INI preset inheritance:** All presets inherit from `[ * ]` base defaults. Only override what differs; do not repeat base values in every preset.
- **Thinking mode:** Use `reasoning = on/off` (llama.cpp native flag) for per-preset thinking control. Do NOT use `chat-template-kwargs`.
- **MTP config:** Qwen uses `spec-draft-n-max = 3` (DGX Spark-specific); Gemma uses `spec-draft-n-max = 2` (Unsloth recommended sweet spot).
- **Model paths:** INI configs use absolute paths. The `models.json` download manifest uses portable HuggingFace model IDs. These are not currently linked — path resolution is manual.
- **Launcher scripts:** Root-level launchers (`launcher-qwen.sh`, `launcher-gemma.sh`) are convenience entry points. The real logic lives in `launchers/*/`.

### INI config conventions

Section names follow the pattern `[unsloth/<model-name>-<quant>-MTP-<mode>]` for MTP models.
- `alias` field defines the model name exposed via the API (comma-separated for multiple aliases).
- `model` and `mmproj` paths are absolute; `spec-draft-model` is used for Gemma MTP drafters.

## Domain-Specific Guidelines

### Qwen3.6 Catalog (`qwen3.6-catalog.ini`)

Verified against `launchers/qwen3.6-mtp/qwen3.6-catalog.ini`:

- **Base `[ * ]` defaults:** `ctx-size=175000`, `cache-type-k=q8_0`, `cache-type-v=q8_0`, `temperature=0.6`, `top-p=0.95`, `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`, `spec-draft-type-k=q8_0`, `spec-draft-type-v=q8_0`.
- **Flash preset (`unsloth/Qwen3.6-35B-A3B-UD-Q5_K_XL-NT`):** aliases `Qwen3.6-35B-A3B-IT, flash`; overrides: `reasoning=off`, `temperature=0.7`, `top-p=0.80`, `presence-penalty=1.5`.
- **General preset (`unsloth/Qwen3.6-35B-A3B-UD-Q5_K_XL-General`):** aliases `Qwen3.6-35B-A3B-general, general`; overrides: `reasoning=on`, `presence-penalty=1.5`.
- **Coder preset (`unsloth/Qwen3.6-35B-A3B-UD-Q5_K_XL-Coder`):** aliases `Qwen3.6-35B-A3B-Coder, coder`; overrides: `reasoning=on`, `presence-penalty=0.0`.
- GPU offload is set via CLI flags in `launcher-qwen.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not in the INI.

### Gemma-4 Catalog (`gemma-4-mtp.ini`)

Verified against `launchers/gemma-4-mtp/gemma-4-mtp.ini`:

- **Base `[ * ]` defaults:** `ctx-size=150000`, `n-gpu-layers=55` (structural offset for sparse gating — true layers are 48), `temp=1.0`, `top-p=0.95`, `top-k=64`, `cache-type-k=f16`, `cache-type-v=f16`, `reasoning=off`.
- **MTP:** `spec-type=draft-mtp`, `spec-draft-n-max=2`, `draft-p-min=0.50`.
- **flash-lite (`Q4_K_M`):** aliases `gemma-4-26B-A4B-Q4_K_M, gemma-4-flash-lite`; non-thinking.
- **flash (`Q4_K_XL`):** aliases `gemma-4-26B-A4B-Q4_K_XL, gemma-4-flash`; non-thinking.
- **flash-high (`Q5_K_M`):** aliases `gemma-4-26B-A4B-Q5_K_M, gemma-4-flash-high`; overrides `reasoning=on`.
- **pro (`Q5_K_XL`):** aliases `gemma-4-26B-A4B-Q5_K_XL, gemma-4-pro`; overrides `reasoning=on`.
- All tiers use the same MTP drafter: `gemma-4-26B-A4B-it-MTP-Q8_0.gguf`.
- `mmproj` path in base defaults points to the BF16 vision projector for multimodal support.
