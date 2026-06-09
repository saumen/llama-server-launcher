#!/usr/bin/env bash
# Download HF models based on models.json config.
#
# Usage:
#   ./download-models.sh              # Download all models in config
#   ./download-models.sh --dry-run    # Print commands without executing
#   ./download-models.sh --list       # List model IDs from config
#   ./download-models.sh <modelId>    # Download a single model by ID
#
# Prerequisites: jq, huggingface_hub (hf CLI)
# ---------------------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${SCRIPT_DIR}/models.json"

if [[ ! -f "$CONFIG" ]]; then
    echo "ERROR: config not found: $CONFIG" >&2
    exit 1
fi

CACHE_DIR="$(jq -r '.cacheDir' "$CONFIG")"
CACHE_DIR="${CACHE_DIR/#\~/$HOME}"

# ---- subcommands -----------------------------------------------------------

list_models() {
    jq -r '.models[].modelId' "$CONFIG"
}

download_model() {
    local model_id="$1" local_dir="$2"
    shift 2
    local include_patterns=("$@")

    # Build the --include flags
    local flags=""
    for p in "${include_patterns[@]}"; do
        flags+=" --include '${p}'"
    done

    local cmd="hf download ${model_id} --local-dir ${local_dir}${flags}"

    if [[ "${DRY_RUN:-}" == "true" ]]; then
        echo "[dry-run] ${cmd}"
        return
    fi

    echo ">>> Downloading ${model_id} -> ${local_dir}"
    eval "cd ${CACHE_DIR} && ${cmd}"
    echo ">>> Done: ${model_id}"
    echo
}

# ---- main ------------------------------------------------------------------

DRY_RUN="false"
TARGET=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)  DRY_RUN="true"; shift ;;
        --list)     list_models; exit 0 ;;
        -h|--help)
            sed -n '/^# Usage:/,/^#$/p' "${BASH_SOURCE[0]}" | sed 's/^# //'
            exit 0
            ;;
        *)          TARGET="$1"; shift ;;
    esac
done

# Resolve target model(s)
if [[ -n "$TARGET" ]]; then
    # Single model by ID — find it in config
    entry=$(jq -r --arg id "$TARGET" '.models[] | select(.modelId == $id)' "$CONFIG")
    if [[ -z "$entry" ]]; then
        echo "ERROR: model '${TARGET}' not found in config." >&2
        echo "Available models:" >&2
        list_models >&2
        exit 1
    fi
    model_id=$(echo "$entry" | jq -r '.modelId')
    local_dir=$(echo "$entry" | jq -r '.localDir')
    mapfile -t includes < <(echo "$entry" | jq -r '.include[]')
    download_model "$model_id" "$local_dir" "${includes[@]}"
else
    # All models
    if [[ "$DRY_RUN" != "true" ]]; then
        cd "$CACHE_DIR"
    fi

    jq -c '.models[]' "$CONFIG" | while IFS= read -r entry; do
        model_id=$(echo "$entry" | jq -r '.modelId')
        local_dir=$(echo "$entry" | jq -r '.localDir')
        mapfile -t includes < <(echo "$entry" | jq -r '.include[]')
        download_model "$model_id" "$local_dir" "${includes[@]}"
    done

    # Show tree of downloaded models (only when not dry-run)
    if [[ "$DRY_RUN" != "true" ]]; then
        echo "=== Downloaded model tree ==="
        find /home/saumen/.cache/huggingface/hub -name "*.gguf" | sed 's/.*hub\///g' | sort
    fi
fi
