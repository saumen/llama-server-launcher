# -------------------------------------------------------------------------
# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md
# Model downloader: ~/workspace/huggingface-scripts/download-models.sh
# Model config:     ~/workspace/huggingface-scripts/models.json

~/workspace/github/ggml-org/2026-06-07/llama.cpp/build/bin/llama-server \
	--host 0.0.0.0 \
	--port 8081 \
	--models-preset ~/workspace/github/saumen/llama-server-launcher/launchers/gemma-4-qat-mtp/gemma-4-qat-mtp.ini \
	--models-max 2 \
	--flash-attn on \
	--cont-batching \
	--no-mmproj \
	--log-colors on \
	--log-timestamps
