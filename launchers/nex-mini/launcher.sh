~/workspace/github/ggml-org/2026-06-07/llama.cpp/build/bin/llama-server \
	--models-preset ~/workspace/github/saumen/llama-server-launcher/launchers/nex-mini/nex-mini.ini \
	--host 0.0.0.0 \
	--port 8082 \
	--models-max 1 \
	--flash-attn on \
	--cont-batching \
	--no-mmproj \
	--log-colors on \
	--log-timestamps
