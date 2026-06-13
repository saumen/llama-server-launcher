# - Do not set global `--gpu-layers`. GPU offload setting is defined in models preset.
# -------------------------------------------------------------------------
# cache-ram default is 8GB. Increased to leverage massive VRAM in DGX Spark.
# -------------------------------------------------------------------------
# STABILITY OVERRIDES FOR FRAGMENTATION BUG (#23720)
# OMIT --kv-unified here. Using dedicated slot partitions isolates
# memory and completely bypasses the cell-stitching 'checkpoint mismatch' crash.
# Force symmetric batching bounds to keep memory alignment clean.
# The penalty is server need to re-process prompt for every request.
# The tradeoff is speed vs stability.
# If speed becomes an issue, add --kv-unified with
#   `--parallel 2`,
#   `--ctx-size [per model ctx-size x 2]`
#   `-b 2048`
#   `-ub 2048`
#   `--cache-resue 256`
# -------------------------------------------------------------------------
# --cache-reuse requires --kv-unified.
# -------------------------------------------------------------------------
# --ctx-size = per model ctx-size x parallel N. Example:
#   per model ctx-size = 200,000
#   parallel = 4
#   therefore, global --ctx-size = 200,000 x 4 = 800,000
# -------------------------------------------------------------------------
# https://github.com/AtomicBot-ai/atomic-llama-cpp-turboquant
# https://github.com/AtomicBot-ai/atomic-llama-cpp-turboquant/blob/feature/turboquant-kv-cache/docs/speculative.md
# https://github.com/AtomicBot-ai/atomic-llama-cpp-turboquant/blob/feature/turboquant-kv-cache/MTP.md
# https://github.com/AtomicBot-ai/atomic-llama-cpp-turboquant/blob/feature/turboquant-kv-cache/scripts/run-gemma4-31b-mtp-server.sh
# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md
# Model downloader: ~/workspace/huggingface-scripts/download-models.sh
# Model config:     ~/workspace/huggingface-scripts/models.json

# ~/workspace/github/AtomicBot-ai/atomic-llama-cpp-turboquant/build/bin/llama-server \
#   --host 0.0.0.0 \
#   --port 8080 \
#   --model /home/saumen/.cache/huggingface/hub/unsloth/gemma-4-31B-it-GGUF/gemma-4-31B-it-UD-Q4_K_XL.gguf \
#   --mtp-head /home/saumen/.cache/huggingface/hub/AtomicChat/gemma-4-31B-it-assistant-GGUF/gemma-4-31B-it-assistant.Q4_K_M.gguf \
#   --alias gemma-4-31B \
#   --spec-type mtp \
#   --draft-block-size 4 \
#   --n-gpu-layers 99 \
#   --n-gpu-layers-draft 99 \
#   --models-max 2 \
#   --parallel 1 \
#   --ctx-size 70000 \
#   --cache-ram 32768 \
#   --flash-attn on \
#   -ctk turbo4 \
#   -ctv turbo4 \
#   --cont-batching \
#   --no-mmproj

~/workspace/github/AtomicBot-ai/atomic-llama-cpp-turboquant/build/bin/llama-server \
  --host 0.0.0.0 \
  --port 8080 \
  --models-preset ~/workspace/github/saumen/llama-server-launcher/launchers/gemma-4-turbo-mtp/gemma-4-turbo-mtp.toml \
  --models-max 2 \
  --flash-attn on \
  --cont-batching \
  --no-mmproj \
  --log-colors on \
  --log-timestamps
