#!/bin/bash

# Standalone launcher for Qwen3.5-122B-A10B (122B MoE, 10B active)
# All settings hardcoded as CLI flags - no INI preset file
# Mode: Instruct (non-thinking) for general tasks
# https://unsloth.ai/docs/models/qwen3.5
# https://unsloth.ai/docs/models/qwen3.5/gguf-benchmarks
# https://huggingface.co/unsloth/Qwen3.5-122B-A10B-MTP-GGUF

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "${SCRIPT_DIR}/.env.launcher" ]; then
	source "${SCRIPT_DIR}/.env.launcher"
fi

DATE=$(date +%Y-%m-%d)

log_dir="/tmp/${DATE}-llama-qwen3.5-122b"
mkdir -p "${log_dir}"

"${LLAMA_SERVER_BIN}" \
	--model "${HF_UNSLOTH_DIR}/Qwen3.5-122B-A10B-MTP-GGUF/UD-Q4_K_XL/Qwen3.5-122B-A10B-UD-Q4_K_XL-00001-of-00003.gguf" \
	--alias Qwen3.5-122B-A10B-NT,qwen-122b-a10b-it \
	--host 0.0.0.0 \
	--port 8081 \
	--gpu-layers all \
	--device CUDA0 \
	--ctx-size 200000 \
	--cache-type-k q8_0 \
	--cache-type-v q8_0 \
	--spec-type draft-mtp \
	--spec-draft-n-max 2 \
	--spec-draft-p-min 0.50 \
	--temp 0.7 \
	--top-p 0.80 \
	--top-k 20 \
	--min-p 0.0 \
	--presence-penalty 1.5 \
	--repeat-penalty 1.0 \
	--jinja \
	--reasoning off \
	--flash-attn on \
	--cont-batching \
	--log-verbosity 4 \
	--log-colors on \
	--log-timestamps \
	--log-file "${log_dir}/qwen3.5-122b.log"
