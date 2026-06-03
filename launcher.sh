# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

~/workspace/github/ggml-org/llama.cpp/build/bin/llama-server \
  --models-preset ~/workspace/llama-server/presets/gemma-4-catalog.ini \
  --host 0.0.0.0 \
  --port 8080 \
  --gpu-layers all \
  --log-colors on \
  --models-max 2

# Related: Model downloader: ~/workspace/huggingface-scripts/download-models.sh
