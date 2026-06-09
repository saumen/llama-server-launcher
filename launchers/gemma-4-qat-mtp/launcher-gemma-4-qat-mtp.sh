# -------------------------------------------------------------------------
# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md
# Model downloader: ~/workspace/huggingface-scripts/download-models.sh
# Model config:     ~/workspace/huggingface-scripts/models.json

~/workspace/github/ggml-org/2026-06-07/llama.cpp/build/bin/llama-server \
    --host 0.0.0.0 \
    --port 8081 \
    --models-preset ~/workspace/llama-server/launchers/gemma-4-qat-mtp/gemma-4-qat-mtp.toml \
    --models-max 2 \
    --flash-attn on \
    --cont-batching \
    --no-mmproj \
    --log-colors on \
    --log-timestamps
