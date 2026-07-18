#!/bin/bash

# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "${SCRIPT_DIR}/.env.launcher" ]; then
	source "${SCRIPT_DIR}/.env.launcher"
fi

DATE=$(date +%Y-%m-%d)

log_dir="/tmp/${DATE}-llama-qwen3.6"
mkdir -p "${log_dir}"
preset='qwen3.6-catalog'

"${LLAMA_SERVER_BIN}" \
	--models-preset "$SCRIPT_DIR/launchers/qwen3.6-mtp/${preset}.ini" \
	--host 0.0.0.0 \
	--port 8080 \
	--models-max 3 \
	--flash-attn on \
	--cont-batching \
	--jinja \
	--gpu-layers all \
	--gpu-layers-draft all \
	--device CUDA0 \
	--spec-draft-device CUDA0 \
	--image-min-tokens 1024 \
	--log-colors on \
	--log-timestamps \
	--log-file "${log_dir}/${preset}.log"
