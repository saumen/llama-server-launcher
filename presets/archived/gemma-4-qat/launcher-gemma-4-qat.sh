# -------------------------------------------------------------------------
# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md
# Model downloader: ~/workspace/huggingface-scripts/download-models.sh
# Model config:     ~/workspace/huggingface-scripts/models.json

~/workspace/github/ggml-org/2026-06-06_llama.cpp/llama.cpp/build/bin/llama-server \
	--host 0.0.0.0 \
	--port 8080 \
	--models-preset ~/workspace/github/saumen/llama-server-launcher/launchers/gemma-4-qat/gemma-4-qat.ini \
	--models-max 2 \
	--flash-attn on \
	--cont-batching \
	--no-mmproj \
	--log-colors on \
	--log-timestamps
