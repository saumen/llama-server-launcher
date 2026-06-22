#!/bin/bash

# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "${SCRIPT_DIR}/.env.launcher" ]; then
	source "${SCRIPT_DIR}/.env.launcher"
fi

DATE=$(date +%Y-%m-%d)

launch_server() {
	local preset="${1}"
	local port="${2}"
	local log_dir="${3}"

	"${LLAMA_SERVER_BIN}" \
		--models-preset "$SCRIPT_DIR/launchers/qwen3.6-mtp/${preset}.toml" \
		--host 0.0.0.0 \
		--port "${port}" \
		--models-max 2 \
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
}

log_dir="/tmp/${DATE}-llama-qwen3.6"
mkdir -p "${log_dir}"

launch_server qwen3.6-catalog-nt 8080 "${log_dir}" &
launch_server qwen3.6-catalog-coder 8081 "${log_dir}" &

tail -f "${log_dir}/qwen3.6-catalog-coder.log" "${log_dir}/qwen3.6-catalog-nt.log"
