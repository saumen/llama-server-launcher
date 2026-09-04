#!/usr/bin/env bash
# should be executed in DGX Spark
set -euo pipefail

# Configuration ---------------------------------------------------------- #
LLAMA_CPP_TAG="${LLAMA_CPP_TAG:-v0.3.0}"
BASE_DIR="${HOME}/workspace/github/ggml-org"

# Ensure CUDA is on PATH (not set in SSH login by default)
export PATH="/usr/local/cuda/bin:${PATH}"
if [ -n "${LD_LIBRARY_PATH:-}" ]; then
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
else
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64"
fi

# Build directory -------------------------------------------------------- #
today="$(date +%Y-%m-%d)"
tag="${LLAMA_CPP_TAG#v}"          # strip leading 'v' for dir name
build_dir="${BASE_DIR}/${today}-${tag}"
mkdir -p "${build_dir}" || {
    echo "Error: could not create '${build_dir}'"; exit 1; }
cd "${build_dir}" || {
    echo "Error: could not enter '${build_dir}'"; exit 1; }

# Clone / checkout llama.cpp --------------------------------------------- #
if [ -d "llama.cpp/.git" ]; then
    cd llama.cpp
    git fetch --tags
    git checkout "${LLAMA_CPP_TAG}" || {
        echo "Error: git checkout ${LLAMA_CPP_TAG} failed"; exit 1; }
    cd ..
else
    git clone https://github.com/ggml-org/llama.cpp || {
        echo "Error: git clone failed"; exit 1; }
    cd llama.cpp
    git checkout "${LLAMA_CPP_TAG}" || {
        echo "Error: git checkout ${LLAMA_CPP_TAG} failed"; exit 1; }
    cd ..
fi

# Build ------------------------------------------------------------------ #
cmake -S llama.cpp -B llama.cpp/build \
    -DBUILD_SHARED_LIBS=OFF \
    -DGGML_CUDA=ON || { echo "Error: cmake configure failed"; exit 1; }

cmake --build llama.cpp/build \
    --config Release \
    -j \
    --clean-first \
    --target llama-cli llama-server llama-gguf-split || {
        echo "Error: build failed"; exit 1; }

# Copy binaries ---------------------------------------------------------- #
cp llama.cpp/build/bin/llama-* llama.cpp || {
    echo "Error: cp build artifacts failed"; exit 1; }

cd - || { echo "Error: could not return to previous directory"; exit 1; }

realpath "${build_dir}/llama.cpp"
