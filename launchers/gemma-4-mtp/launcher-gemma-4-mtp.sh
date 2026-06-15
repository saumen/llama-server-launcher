#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "$SCRIPT_DIR/.env.launcher" ]; then
  source "$SCRIPT_DIR/.env.launcher"
fi

${LLAMA_SERVER_BIN} \
    --host 0.0.0.0 \
    --port 7080 \
    --models-preset ~/workspace/github/saumen/llama-server-launcher/launchers/gemma-4-mtp/gemma-4-mtp.toml \
    --models-max 2 \
    --flash-attn on \
    --cont-batching \
    --no-mmproj \
    --log-colors on \
    --log-timestamps
