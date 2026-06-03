Seeing your full global config block at the top explains exactly what is happening under the hood. There is a massive hidden constraint running in this current file:

```ini
parallel = 32
cache-type-k = q8_0
cache-type-v = q8_0
```

Setting `parallel = 32` globally is the default behavior of some enterprise routing platforms, but when combined with a `ctx-size = 100000`, it causes a massive silent performance tax. Even with `kv-unified = true` and `q8_0` KV compression, `llama.cpp` has to allocate structural slot tracking and bookkeep tracking structures for up to 32 concurrent requests.

For a single developer utilizing Claude Code or Zed, you will never cross more than 2 or 3 overlapping requests at any given millisecond. The remaining 29 slots are just adding massive overhead.

Here is your updated, complete, and drop-in ready `presets.ini` for the Qwen setup. I have moved your global keys into the system-wide block at the top, introduced the tailored `batch-size` and `ubatch-size` configurations, and optimized your slot layout specifically for your terminal/editor tooling.

```ini
# ==============================================================================
# GLOBAL HARDWARE & ENGINE DEFAULTS (Applies to all models)
# ==============================================================================
mmproj =
flash-attn = true
kv-unified = true
cont-batching = true

# Context Optimization
cache-type-k = q8_0
cache-type-v = q8_0
cache-reuse = 256         # CRUCIAL: Keeps your system prompts hot across Claude Code iterations

# Single-user developer parallel slot limit (Replaces the massive 32-slot overhead)
parallel = 3

########################################

[unsloth/Qwen3.6-27B-UD-Q5_K_XL-MTP]
model = /home/saumen/.cache/huggingface/hub/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-UD-Q5_K_XL.gguf
alias = Qwen3.6-27B
ctx-size = 100000

# --- Physical Execution Sizing (Dense Model) ---
batch-size = 1024
ubatch-size = 1024       # Matched to execute dense spec-draft evaluation in one clean burst

# --- Speculative Drafting Layout ---
spec-type = draft-mtp
spec-draft-n-max = 2
draft-p-min = 0.50

# --- Sampling Parameters ---
temp = 0.3
top-p = 0.9
top-k = 20

########################################

[unsloth/qwen3.6-35B-A3B]
model = /home/saumen/.cache/huggingface/hub/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf
alias = Qwen3.6-35B-A3B
ctx-size = 100000

# --- Physical Execution Sizing (MoE Model) ---
batch-size = 2048
ubatch-size = 512        # Decoupled to optimize NVLink routing and prevent MTP thrashing

# --- Speculative Drafting Layout ---
# benchmarks/qwen3.6-35b-a3b/pdf-analysis-benchmarks-02/analysis-report.md
spec-type = draft-mtp
spec-draft-n-max = 2
draft-p-min = 0.50

# --- Sampling Parameters ---
temp = 0.6
top-p = 0.95

########################################

```

### Key Changes Implemented Here:

1. **`parallel = 3` (Down from 32):** This change eliminates massive slot-allocation tracking memory overhead. Setting it to 3 ensures Claude Code can have one active streaming prompt, one concurrent tool verification loop running in the background, and leaves one open slot for Zed's inline helper to query the API at the exact same moment without dropping requests.
2. **`cache-reuse = 256`:** Added to the global parameters. Because your coding tools continuously resubmit large structural text files with tiny code iterations at the end, this forces `llama-server` to lock down the shared KV cache prefixes. Your prompt evaluations will be near-instantaneous instead of triggering a long compute stall every time your tools run a sub-command.
3. **Targeted Micro-Batches:** The dense model gets a matched `1024/1024` matrix to power through raw layers, while the MoE version uses a decoupled `2048/512` split to keep token assignments to the internal expert routing lanes efficient across your NVLink channels.
