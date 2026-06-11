# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

# - Do not set global `--gpu-layers`. GPU offload setting is defined in models preset.
# -------------------------------------------------------------------------
# --cache-ram default is 8GB. Increased to 32768 leverage massive VRAM in DGX Spark.
# Removed with the removal of --kv-unified.
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
#   per model ctx-size = 200000
#   parallel = 4
#   therefore, global --ctx-size 200000 x 4 = 800000
# Removed with the removal of --kv-unified.
# -------------------------------------------------------------------------
# Related: Model downloader: ~/workspace/huggingface-scripts/download-models.sh
#          Model config:     ~/workspace/huggingface-scripts/models.json
# Usage: ./download-models.sh --dry-run   (preview commands)
#        ./download-models.sh             (download all)
#        ./download-models.sh <modelId>   (download single model)

~/workspace/github/ggml-org/2026-06-07/llama.cpp/build/bin/llama-server \
  --models-preset ~/workspace/llama-server/launchers/qwen3.6-mtp/qwen3.6-catalog.toml \
  --host 0.0.0.0 \
  --port 8080 \
  --models-max 3 \
  --flash-attn on \
  --cont-batching \
  --no-mmproj \
  --log-colors on \
  --log-timestamps
