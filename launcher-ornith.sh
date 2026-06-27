#!/bin/bash

# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "${SCRIPT_DIR}/.env.launcher" ]; then
	source "${SCRIPT_DIR}/.env.launcher"
fi

DATE=$(date +%Y-%m-%d)

log_dir="/tmp/${DATE}-llama-ornith"
mkdir -p "${log_dir}"
preset='ornith-catalog'

"${LLAMA_SERVER_BIN}" \
	--models-preset "$SCRIPT_DIR/launchers/ornith-gguf/${preset}.ini" \
	--host 0.0.0.0 \
	--port 9080 \
	--models-max 2 \
	--flash-attn on \
	--cont-batching \
	--jinja \
	--gpu-layers all \
	--device CUDA0 \
	--log-colors on \
	--log-timestamps \
	--log-file "${log_dir}/${preset}.log"
