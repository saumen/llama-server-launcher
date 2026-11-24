#!/bin/bash

# Inkling 2 Mini on DGX Spark.
# https://unsloth.ai/docs/models/inkling-2-mini
# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md
# This script does not stop other servers.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# shellcheck disable=SC1090,SC1091
if [ -f "${SCRIPT_DIR}/.env.launcher" ]; then
	source "${SCRIPT_DIR}/.env.launcher"
fi

# 23 Nov update: https://unsloth.ai/docs/models/inkling-2-mini#id-23rd-november-update
# Mainline can load the updated quants. This script still pins the faster Unsloth build.
# Sibling of the mainline build. Same naming pattern as compiler.sh.
LLAMA_SERVER_BIN="/home/saumen/workspace/github/ggml-org/2026-11-23-b12649-mix-c7059d6/llama.cpp/llama-server"

if [ ! -x "${LLAMA_SERVER_BIN}" ]; then
	echo "Error: Unsloth llama-server is not executable: ${LLAMA_SERVER_BIN}" >&2
	echo "Install b12649-mix-c7059d6 from the 23 Nov Unsloth release before you start this script." >&2
	exit 1
fi

DATE=$(date +%Y-%m-%d)
PORT=8888

log_dir="/tmp/${DATE}-llama-inkling-2-mini"
mkdir -p "${log_dir}"
preset='inkling-2-mini-catalog'

echo "LLAMA_SERVER_BIN = ${LLAMA_SERVER_BIN}"

"${LLAMA_SERVER_BIN}" \
	--models-preset "$SCRIPT_DIR/launchers/inkling-2-mini/${preset}.ini" \
	--host 0.0.0.0 \
	--port "${PORT}" \
	--models-max 1 \
	--flash-attn on \
	--cont-batching \
	--jinja \
	--gpu-layers all \
	--gpu-layers-draft all \
	--device CUDA0 \
	--metrics \
	--log-colors on \
	--log-timestamps \
	--log-file "${log_dir}/${preset}.log"
