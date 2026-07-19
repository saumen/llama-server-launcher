#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "$SCRIPT_DIR/.env.launcher" ]; then
	source "$SCRIPT_DIR/.env.launcher"
fi

DATE=$(date +%Y-%m-%d)

log_dir="/tmp/${DATE}-llama-gemma-4"
mkdir -p "${log_dir}"

"${LLAMA_SERVER_BIN}" \
	--host 0.0.0.0 \
	--port 8080 \
	--models-preset "$SCRIPT_DIR/launchers/gemma-4-mtp/gemma-4-mtp.ini" \
	--no-mmproj \
	--models-max 2 \
	--gpu-layers all \
	--gpu-layers-draft all \
	--flash-attn on \
	--cont-batching \
	--device CUDA0 \
	--spec-draft-device CUDA0 \
	--image-min-tokens 1024 \
	--log-colors on \
	--log-timestamps \
	--log-file "${log_dir}/gemma-4.log"
