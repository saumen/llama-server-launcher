# llama-server-launcher — Repository Guidelines

## Documentation & File Purposes

This project uses multiple markdown files, each with a distinct audience and scope. Do not duplicate content across
  them.

|File|Audience|Scope|
| --- | --- | --- |
|[`README.md`](README.md)|End users|Setup, workspace layout, workflow, feature usage|
|`AGENTS.md` (this file)|Developers & AI assistants|Project structure, conventions, development guidance|
|[`launchers/qwen3.6-mtp/README.md`](launchers/qwen3.6-mtp/README.md)|Developers|Qwen3.6 catalog preset memory: config values, inheritance, trial notes|
|[`launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md`](launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md)|Developers|Cached official Qwen3.6 recommended settings from HuggingFace|
|[`launchers/qwen3.8-mtp/README.md`](launchers/qwen3.8-mtp/README.md)|Developers|Qwen3.8 catalog preset memory: config values, per-mode settings|
|[`.markdownlint.json`](.markdownlint.json)|All developers|Markdown lint config: line length 120, compact style, allowed `<br/>`|

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
├── compiler.sh                # Build llama.cpp from source on DGX Spark
│
├── launchers/
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

|Command|Purpose|
| --- | --- |
|`./launcher-qwen3.6.sh`|Start Qwen3.6 MTP server on port 8036|
|`./launcher-qwen3.8.sh`|Start Qwen3.8-27B MTP server on port 8888|
|`bash compiler.sh`|Build llama.cpp from source on DGX Spark (default tag v0.3.0)|
|`LLAMA_CPP_TAG=vX.Y.Z bash compiler.sh`|Build a specific llama.cpp version|

### Context-Specific Notes

- Both root launchers (`launcher-qwen3.6.sh`, `launcher-qwen3.8.sh`) source `.env.launcher` from repo root and point at
  their respective INI catalogs in `launchers/qwen3.6-mtp/` and `launchers/qwen3.8-mtp/`.
- INI configs use **hardcoded absolute paths** (`/home/saumen/.cache/huggingface/hub/...`). These will fail on other
  machines. Before deploying elsewhere, update all `model` and `mmproj` paths in the INI files.
- Logs are written to `/tmp/YYYY-MM-DD-llama-qwen3.N/qwen3.N-catalog.log`. Qwen3.6 uses port 8036; Qwen3.8 uses 8888.
- Both launchers use `--device CUDA0` and `--spec-draft-device CUDA0`. If your GPU is on a different device, update the
  `--device` flags in the launcher scripts.
- Both launchers include `--image-min-tokens 1024` for vision/multimodal support.

## Commit & Pull Request Guidelines

- Use conventional commit prefixes (`feat:`, `fix:`, `docs:`, `refactor:`). Imperative mood, subject line under 72
  characters, no trailing period.
- Example: `feat: Add coder tier to Qwen3.6 catalog`
- PRs should include a clear description, link related issues, and note any environment variable or path changes.

## Documentation & Planning

- [Qwen3.6 official recommended settings](launchers/qwen3.6-mtp/docs/qwen3.6-recommendations.md)
- [Unsloth Qwen3.8 recommended settings](https://unsloth.ai/docs/models/qwen3.8#recommended-settings)
- [llama.cpp preset docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md)
- [llama.cpp speculative decoding docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md)

## Agent-Specific Instructions

### Before modifying code

1. Read the relevant INI catalog (`qwen3.6-catalog.ini` or `qwen3.8-catalog.ini`) to understand preset inheritance
  from the `[ * ]` base defaults.
2. Read the corresponding launcher script to understand CLI flags set outside the INI (e.g., `--gpu-layers all` is set
  in the launcher scripts, not the INI).
3. Cross-reference routing docs for benchmark data and decision rationale before changing model tiers.

### Patterns to follow

- **INI preset inheritance:** All presets inherit from `[ * ]` base defaults. Only override what differs; do not repeat
  base values in every preset.
- **Thinking mode:** Use `reasoning = on/off` (llama.cpp native flag) for per-preset thinking control. Do NOT use
  `chat-template-kwargs`.
- **MTP config:** Both Qwen3.6 and Qwen3.8 use `spec-draft-n-max = 3` (DGX Spark-specific). The MTP head is embedded
  in the main GGUF — `draft-mtp` uses the in-file MTP module, no separate `spec-draft-model`.
- **Model paths:** INI configs use absolute paths. Path resolution is manual — update when models are re-downloaded.
- **Launcher scripts:** Both root launchers are self-contained entry points that run `llama-server` directly;
  `launchers/` holds the INI catalogs and routing docs they reference.

### INI config conventions

Section names follow the pattern `[unsloth/<model-name>]` for MTP models.

- `alias` field defines the model name exposed via the API.
- `model` and `mmproj` paths are absolute; no `spec-draft-model` is used (MTP head is in-file).

## Domain-Specific Guidelines

### Qwen3.6 Catalog (`qwen3.6-catalog.ini`)

Verified against `launchers/qwen3.6-mtp/qwen3.6-catalog.ini`:

- **Base `[ * ]` defaults:** `ctx-size=250000`, `cache-type-k=q8_0`, `cache-type-v=q8_0`, `temperature=0.6`,
  `top-p=0.95`, `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`,
  `draft-p-min=0.50`, `spec-draft-type-k=q8_0`, `spec-draft-type-v=q8_0`.
- **NT preset (`unsloth/Qwen3.6-35B-A3B`):** alias `qwen3.6-flash`; uses `Q6_K` quantization; overrides:
  `reasoning=off`, `temperature=0.7`, `top-p=0.80`, `presence-penalty=1.5`.
- GPU offload is set via CLI flags in `launcher-qwen3.6.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not in the
  INI.

### Qwen3.8 Catalog (`qwen3.8-catalog.ini`)

Verified against `launchers/qwen3.8-mtp/qwen3.8-catalog.ini`:

- **Base `[ * ]` defaults:** `ctx-size=262144`, `cache-type-k=q8_0`, `cache-type-v=q8_0`, `top-k=20`, `min-p=0.0`,
  `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`, `spec-draft-type-k=q8_0`,
  `spec-draft-type-v=q8_0`.
- **Expert preset (`unsloth/Qwen3.8-27B`):** alias `qwen3.8-expert`; uses `Q6_K_XL` quantization; overrides:
  `reasoning=off`, `temperature=0.6`, `top-p=0.90`, `presence-penalty=1.5`.
- Per-mode sampling follows [Unsloth Qwen3.8 recommended settings](https://unsloth.ai/docs/models/qwen3.8#recommended-settings)
  (see linked docs in Documentation & Planning section).
- Qwen3.8-27B is a dense Qwen3.5-family model with an MTP head embedded in the main GGUF — `draft-mtp` uses the in-file
  MTP module, no separate `spec-draft-model`.
- `model` path uses the HF cache snapshot layout
  (`models--unsloth--Qwen3.8-27B-GGUF/snapshots/4ca720788d1e01f1bff70c033e0d0028fd02e502/`); the model is not in
  `models.json`.
- GPU offload is set via CLI flags in `launcher-qwen3.8.sh` (`--gpu-layers all`, `--gpu-layers-draft all`), not the INI.
