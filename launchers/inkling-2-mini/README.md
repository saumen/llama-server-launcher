# MEMORY

## Catalog presets (inkling-2-mini-catalog.ini)

Two presets inherit from base `[ * ]` defaults (`ctx-size=262144`, `cache-type-k=q8_0`, `cache-type-v=q8_0`,
`temperature=1.0`, `top-p=1.0`, `top-k=0`, `min-p=0.0`, `spec-type=draft-dspark`, `spec-draft-n-max=3`).

| Preset | Alias | Quant | File |
| --- | --- | --- | --- |
| UD-Q8_K_XL | `inkling-2-mini-ud-q8-k-xl` | UD-Q8_K_XL | `Inkling-2-Mini-UD-Q8_K_XL.gguf` |
| UD-Q4_K_XL | `inkling-2-mini-ud-q4-k-xl` | UD-Q4_K_XL | `Inkling-2-Mini-UD-Q4_K_XL.gguf` |

The shared files are `mmproj-F16.gguf` and `dspark-Inkling-2-Mini-Q8_0.gguf`. Both presets inherit those paths.

## Binary

Mainline llama.cpp cannot read these GGUFs yet. The launcher does not use `LLAMA_SERVER_BIN`. It uses the Unsloth
sibling binary. The directory name follows the `compiler.sh` pattern `YYYY-MM-DD-tag/llama.cpp/llama-server`.

Installed path:

`/home/saumen/workspace/github/ggml-org/2026-11-22-b12588-mix-c0c3de8/llama.cpp/llama-server`

The build is Unsloth `b12588-mix-c0c3de8`, version `1.0.0-dev` build `12588`, commit `883286076`. Source:
[Unsloth DGX Spark build](https://unsloth.ai/docs/models/inkling-2-mini#dgx-spark).

Run this on DGX Spark. The extract keeps `llama-server` and its libraries together. The script does not start the
server. The script does not stop other servers.

```bash
BASE=/home/saumen/workspace/github/ggml-org/2026-11-22-b12588-mix-c0c3de8
mkdir -p "${BASE}/llama.cpp"
curl -fL -o "${BASE}/llama.tar.gz" \
    https://github.com/unslothai/llama.cpp/releases/download/b12588-mix-c0c3de8/app-b12588-mix-c0c3de8-linux-arm64-cuda13-portable.tar.gz
tar -xzf "${BASE}/llama.tar.gz" -C "${BASE}/llama.cpp"
"${BASE}/llama.cpp/llama-server" --version
rm -f "${BASE}/llama.tar.gz"
```

## Speculation

The catalog uses `spec-type = draft-dspark` and `spec-draft-n-max = 3`. The drafter is the root file
`dspark-Inkling-2-Mini-Q8_0.gguf`. The INI key is `model-draft`. Do not set `spec-type` to `draft-mtp`.

The launcher offloads the draft with `--gpu-layers-draft all`. It does not set `--spec-draft-device`. The drafter
borrows the target embeddings, so it must use the same device as the target.

## Server flags

`launcher-inkling-2-mini.sh` sets the port, GPU offload, and log path. The port is 8888. The script does not stop other
processes. `--models-max 1` lists both aliases and loads one model per request.

## Download

Run this on DGX Spark before you start the launcher. The preset paths are absolute. A download to another directory
does not load. A download without `dspark-Inkling-2-Mini-Q8_0.gguf` fails at start.

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

## Paths

INI paths are absolute. They use the flat Unsloth cache layout:

`/home/saumen/.cache/huggingface/hub/unsloth/Inkling-2-Mini-GGUF/`

The files are `Inkling-2-Mini-UD-Q8_K_XL.gguf`, `Inkling-2-Mini-UD-Q4_K_XL.gguf`, `mmproj-F16.gguf`, and
`dspark-Inkling-2-Mini-Q8_0.gguf`.

Do not point `model` at `Mainline_Support` files. Those files need a rename to `.gguf` and a different llama.cpp build.

## Sampling

Unsloth sampling is `temperature=1.0`, `top-p=1.0`, `top-k=0`, `min-p=0.0`. The catalog does not set `reasoning`. A
minimum reasoning effort does not disable reasoning on this model.

## Context

The base context is 262144. The model supports 1M tokens.

## Read as needed

- [Unsloth Inkling 2 Mini guide](https://unsloth.ai/docs/models/inkling-2-mini)
- [unsloth/Inkling-2-Mini-GGUF](https://huggingface.co/unsloth/Inkling-2-Mini-GGUF)
- [DSpark drafter notes](https://huggingface.co/unsloth/Inkling-2-Mini-GGUF/blob/main/dspark/README.md)
