## User

Reference: https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md

Review [@benchmark-unsloth-qwen3.6-27B-Q6_K.md](file:///home/saumen/llama.cpp/benchmark-unsloth-qwen3.6-27B-Q6_K.md) and recommend how to increase tok/s without compromizing quality

## Assistant

<thinking>
The user wants me to review their benchmark comparison and the llama.cpp speculative decoding documentation to recommend how to increase tokens per second without compromising quality. Let me analyze the benchmark results and then check the documentation for best practices.

Let me first analyze the benchmarks:

1. **No speculation (baseline)**: 8.60 tok/s, 3824 tokens, 357.5s total
2. **MTP only (spec-draft-n-max=2)**: 17.56 tok/s, 5062 tokens, 246.6s total, acceptance rate 0.760


3. **MTP + NGRAM (spec-draft-n-max=6)**: 18.27 tok/s, 3751 tokens, 165.4s total, acceptance rate 0.426

The MTP approach alone nearly doubled throughput by accepting 76% of drafts with 2 speculative steps. Adding NGRAM进一步提升s speed slightly to 18.27 tok/s, but the acceptance rate drops to 42.6%, suggesting the longer speculation window is less effective. Since these are single runs with varying token counts, I should check the documentation to understand the tradeoffs better.

</thinking>

Let me first review the speculative decoding documentation to understand the available options, then analyze your benchmarks.



**Tool Call: Fetch `https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md`**
Status: Completed

Skip to content                                                                         

## Navigation Menu

      Toggle navigation                                                                                                                Sign in                                         Appearance settings                                                                                                                       Search or jump to...                                                      

# Search code, repositories, users, issues, pull requests...

                                                           Search                                                                                                                                             Clear                                                                        

                                                                                  Search syntax tips                                                              

#         Provide feedback       

                                                                   

We read every piece of feedback, and take your input very seriously.                              Include my email address so I can be contacted                          Cancel              Submit feedback                          

#         Saved searches       

        

## Use saved searches to filter your results more quickly

                                                                                                          Name                                                                                    Query                                

            To see all available qualifiers, see our documentation.                                                                       Cancel              Create saved search                                                Sign in                                                         Sign up                                               Appearance settings                      Resetting focus                                                 You signed in with another tab or window. Reload to refresh your session.        You signed out in another tab or window. Reload to refresh your session.        You switched accounts on another tab or window. Reload to refresh your session.          Dismiss alert                                                                                                                                          ggml-org        /    **      llama.cpp    **    Public                              
               -                     Notifications    You must be signed in to change notification settings  
  -                   Fork     18.6k  
  -                                   Star          112k  

                                                                            

## FilesExpand file tree

 master/

# speculative.md

Copy pathBlameMore file actionsBlameMore file actions 

## Latest commit

 

## History

HistoryHistory325 lines (246 loc) · 16 KB master/

# speculative.md

Top

## File metadata and controls

- Preview
- Code
- Blame

325 lines (246 loc) · 16 KBRawCopy raw fileDownload raw fileOutlineEdit and raw actions

# Speculative Decoding

llama.cpp supports speculative decoding, a technique that can significantly accelerate token generation by predicting multiple tokens ahead of the main model.

Speculative decoding leverages the fact that computing n tokens in a batch (as in prompt processing) is more efficient than computing n sequentially (as in response generation). By generating draft tokens quickly and then verifying them with the target model in a single batch, this approach can achieve substantial speedups when the draft predictions are frequently correct.

## Implementations

The `llama-server` application supports several implementations of speculative decoding. An implementation with draft model can be mixed with an implementation without draft model.

### Draft Model (`draft`)

A much smaller model (called the _draft model_) generates drafts. A draft model is the most used approach in speculative decoding.

### n-gram Cache (`ngram-cache`)

An n-gram is a sequence of n tokens. The n-gram cache implementation maintains statistics about short n-gram sequences. A draft is computed using probabilities derived from these statistics. External statistics can also be loaded from files for improved accuracy.

See:
- #5479, #6828, #6848

### n-gram Map (`ngram-simple`, `ngram-map-*`)

These implementations search the token history for patterns and use matching sequences as draft candidates. They require no additional model but rely on patterns that have already appeared in the generated text. An example to use this approach can be the rewriting of source code by a LLM.

#### n-gram Map (`ngram-simple`)

This implementation looks for the last n-gram in history that matches the current n-gram and creates a draft using the m tokens following the matched n-gram. It is the simplest self-speculative approach with minimal overhead.

```
llama-server [...] --spec-type ngram-simple --spec-draft-n-max 64

```

#### n-gram Map Key (`ngram-map-k`)

This implementation looks for the current n-gram of size n (called the _key_) in the token history. If the key n-gram is followed by the same m tokens (called the _mgram_) multiple times, it creates a draft using these m tokens. This approach requires a minimum number of occurrences (argument `--spec-ngram-map-k-min-hits`, default is 1) before generating drafts.

The number of accepted tokens is stored for each used n-gram.

**Example:**

```
llama-server [...] --spec-type ngram-map-k --spec-draft-n-max 64

```

#### n-gram Map Key-4-Values (`ngram-map-k4v`)

This experimental implementation looks for the current n-gram of size n (called the _key_) in the token history. For each key, up to four _values_ (n-grams of size m, called _mgrams_) are tracked. An internal statistic counts the occurrences of each mgram after the key n-gram. If one mgram is significantly more frequent than the others, it is used as the draft.

The number of accepted tokens is stored for each used n-gram.

**Example:** Server options to be used if there are a lot of longer repetitions.

```
llama-server [...] --spec-type ngram-map-k4v --spec-ngram-map-k4v-size-n 8 --spec-ngram-map-k4v-size-m 8 --spec-ngram-map-k4v-min-hits 2 --spec-draft-n-max 64

```

### n-gram Mod (`ngram-mod`)

Add basic ngram hasher for speculative decoding:
- For each ngram, compute a hash using LCG
- For each computed hash, store the next token
- During speculation, iteratively compute the rolling hash of the last n tokens and pick the next token from the storage

Some characteristics:
- Lightweight (~16 MB)
- Constant memory and complexity
- Can generate variable draft lengths (i.e. m is not fixed)

Currently, a single hash pool is shared across all server slots, so different requests can benefit from each other.

**Sample usage:**

```
# notes:
# - small `n` are not recommended
# - MoEs require long drafts
# - dense models: can reduce `--spec-ngram-mod-n-min` and `--spec-ngram-mod-n-max`

llama-server ... --spec-type ngram-mod --spec-ngram-mod-n-match 24 --spec-ngram-mod-n-min 48 --spec-ngram-mod-n-max 64

```

Applications:
- Iterating over a block of text/code (e.g. in llama.vim)
- Reasoning models (when they have to repeat their thinking in the final answer)
- Summarization

Example Video:
- See #19164

### Differences between ngram-simple, ngram-map and ngram-mod

- ngram-simple looks for a previous matching n-gram and inserts the following m-gram.
- ngram-map-k looks for a previous matching n-gram and inserts the following m-gram but uses an internal hash-map of n-grams in the current context window.
- ngram-mod uses a hash pool which is shared across all server slots. The hash pool is a map from n-gram hash to the next token (not the next m-gram as in ngram-map).

## Command-Line Options

If a draft model is combined with a draftless decoding the draftless decoding has higher precedence.

### General Speculative Parameters

```
--spec-type [none|draft-simple|draft-mtp|ngram-cache|ngram-simple|ngram-map-k|ngram-map-k4v|ngram-mod]
                                        comma-separated list of types of speculative decoding to use
                                        (default: none)
                                        (env: LLAMA_ARG_SPEC_TYPE)
--spec-default                          use default speculative decoding config
                                        (enables ngram-mod)

```

### Draft Model Parameters

```
--spec-draft-model, -md, --model-draft  FNAME
                                        draft model for speculative decoding (default: unused)
                                        (env: LLAMA_ARG_SPEC_DRAFT_MODEL)
--spec-draft-hf, -hfd, -hfrd, --hf-repo-draft  <user>/<model>[:quant]
                                        HuggingFace repository for the draft model
                                        (env: LLAMA_ARG_SPEC_DRAFT_HF_REPO)
--spec-draft-n-max                      N
                                        number of tokens to draft for speculative decoding (default: 3)
                                        (env: LLAMA_ARG_SPEC_DRAFT_N_MAX)
--spec-draft-n-min                      N
                                        minimum number of draft tokens to use for speculative decoding (default: 0)
                                        (env: LLAMA_ARG_SPEC_DRAFT_N_MIN)
--spec-draft-p-split, --draft-p-split   P
                                        speculative decoding split probability (default: 0.10)
                                        (env: LLAMA_ARG_SPEC_DRAFT_P_SPLIT)
--spec-draft-p-min, --draft-p-min       P
                                        minimum speculative decoding probability (greedy) (default: 0.00)
                                        (env: LLAMA_ARG_SPEC_DRAFT_P_MIN)
--spec-draft-ngl, -ngld, --gpu-layers-draft, --n-gpu-layers-draft  N
                                        max. number of draft model layers to store in VRAM, either an exact number, 'auto', or 'all' (default: auto)
                                        (env: LLAMA_ARG_N_GPU_LAYERS_DRAFT)
--spec-draft-device, -devd, --device-draft  <dev1,dev2,..>
                                        comma-separated list of devices to use for offloading the draft model
                                        (use --list-devices to see available devices)

```

### Draft Model CPU Scheduling Parameters

```
--spec-draft-threads, -td, --threads-draft  N
                                        number of CPU threads to use during generation
--spec-draft-threads-batch, -tbd, --threads-batch-draft  N
                                        number of threads to use during batch and prompt processing (default: same as --threads-draft)
--spec-draft-cpu-mask, -Cd, --cpu-mask-draft  M
                                        Draft model CPU affinity mask. Complements cpu-range-draft
--spec-draft-cpu-range, -Crd, --cpu-range-draft  lo-hi
                                        Ranges of CPUs for affinity. Complements --cpu-mask-draft
--spec-draft-cpu-strict, --cpu-strict-draft  <0|1>
                                        Use strict CPU placement for draft model (default: same as --cpu-strict)
--spec-draft-prio, --prio-draft  N
                                        set draft process/thread priority : 0-normal, 1-medium, 2-high, 3-realtime
--spec-draft-poll, --poll-draft  <0|1>
                                        Use polling to wait for draft model work (default: same as --poll)
--spec-draft-cpu-mask-batch, -Cbd, --cpu-mask-batch-draft  M
                                        Draft model CPU affinity mask for batch. Complements cpu-range-batch-draft
--spec-draft-cpu-range-batch, -Crbd, --cpu-range-batch-draft  lo-hi
                                        Ranges of CPUs for affinity for batch. Complements --cpu-mask-batch-draft
--spec-draft-cpu-strict-batch, --cpu-strict-batch-draft  <0|1>
                                        Use strict CPU placement for draft model batch (default: --cpu-strict-draft)
--spec-draft-prio-batch, --prio-batch-draft  N
                                        set draft process/thread priority for batch : 0-normal, 1-medium, 2-high, 3-realtime
--spec-draft-poll-batch, --poll-batch-draft  <0|1>
                                        Use polling to wait for draft model work for batch (default: --poll-draft)

```

### Draft Model KV Cache and Tensor Override Parameters

```
--spec-draft-type-k, -ctkd, --cache-type-k-draft  TYPE
                                        KV cache data type for K for the draft model
                                        allowed values: f32, f16, bf16, q8_0, q4_0, q4_1, iq4_nl, q5_0, q5_1
                                        (env: LLAMA_ARG_SPEC_DRAFT_CACHE_TYPE_K)
--spec-draft-type-v, -ctvd, --cache-type-v-draft  TYPE
                                        KV cache data type for V for the draft model
                                        allowed values: f32, f16, bf16, q8_0, q4_0, q4_1, iq4_nl, q5_0, q5_1
                                        (env: LLAMA_ARG_SPEC_DRAFT_CACHE_TYPE_V)
--spec-draft-override-tensor, -otd, --override-tensor-draft  <tensor name pattern>=<buffer type>,...
                                        override tensor buffer type for draft model
--spec-draft-cpu-moe, -cmoed, --cpu-moe-draft
                                        keep all Mixture of Experts (MoE) weights in the CPU for the draft model
                                        (env: LLAMA_ARG_SPEC_DRAFT_CPU_MOE)
--spec-draft-n-cpu-moe, --spec-draft-ncmoe, -ncmoed, --n-cpu-moe-draft  N
                                        keep the MoE weights of the first N layers in the CPU for the draft model
                                        (env: LLAMA_ARG_SPEC_DRAFT_N_CPU_MOE)

```

### n-gram Mod Parameters

```
--spec-ngram-mod-n-match                N
                                        ngram-mod lookup length (default: 24)
--spec-ngram-mod-n-min                  N
                                        minimum number of ngram tokens to use for ngram-based speculative decoding (default: 48)
--spec-ngram-mod-n-max                  N
                                        maximum number of ngram tokens to use for ngram-based speculative decoding (default: 64)

```

### n-gram Simple Parameters

```
--spec-ngram-simple-size-n              N
                                        ngram size N for ngram-simple speculative decoding, length of lookup n-gram (default: 12)
--spec-ngram-simple-size-m              N
                                        ngram size M for ngram-simple speculative decoding, length of draft m-gram (default: 48)
--spec-ngram-simple-min-hits            N
                                        minimum hits for ngram-simple speculative decoding (default: 1)

```

### n-gram Map Key Parameters

```
--spec-ngram-map-k-size-n               N
                                        ngram size N for ngram-map-k speculative decoding, length of lookup n-gram (default: 12)
--spec-ngram-map-k-size-m               N
                                        ngram size M for ngram-map-k speculative decoding, length of draft m-gram (default: 48)
--spec-ngram-map-k-min-hits             N
                                        minimum hits for ngram-map-k speculative decoding (default: 1)

```

### n-gram Map Key-4-Values Parameters

```
--spec-ngram-map-k4v-size-n             N
                                        ngram size N for ngram-map-k4v speculative decoding, length of lookup n-gram (default: 12)
--spec-ngram-map-k4v-size-m             N
                                        ngram size M for ngram-map-k4v speculative decoding, length of draft m-gram (default: 48)
--spec-ngram-map-k4v-min-hits           N
                                        minimum hits for ngram-map-k4v speculative decoding (default: 1)

```

### `--spec-type TYPE`

Specifies a comma-separated list of speculative decoding types to use.

| Type | Description |
| --- | --- |
| `none` | No speculative decoding (default) |
| `draft-simple` | Use a simple draft model for speculation |
| `draft-mtp` | Use Multi Token Prediction (MTP) heads from the main model |
| `ngram-cache` | Use n-gram cache lookup |
| `ngram-simple` | Use simple n-gram pattern matching |
| `ngram-map-k` | Use n-gram pattern matching with n-gram-keys |
| `ngram-map-k4v` | Use n-gram pattern matching with n-gram-keys and up to four m-gram values (experimental) |
| `ngram-mod` | Use basic ngram hasher for speculative decoding with shared pool |

**Example:** Server-instance used to refactor source code.

```
./llama-server [...] --spec-type ngram-simple
```

**Example:** Multiple speculative implementations.

```
./llama-server [...] --spec-type ngram-mod,ngram-map-k4v
```

### `--spec-ngram-*-size-n N`

Sets the size N of the lookup n-gram for n-gram map based speculative decoding. The n-gram size N determines how many tokens in a row to look back when searching for matching patterns.

Each n-gram implementation has its own parameter:
- `--spec-ngram-simple-size-n` for `ngram-simple`
- `--spec-ngram-map-k-size-n` for `ngram-map-k`
- `--spec-ngram-map-k4v-size-n` for `ngram-map-k4v`
- `--spec-ngram-mod-n-match` for `ngram-mod`

### `--spec-ngram-*-size-m M`

Sets the size M of the draft m-gram for n-gram map based speculative decoding. The m-gram size determines how many tokens to draft when a match is found. Larger values can provide more speedup but may reduce acceptance rate.

Each n-gram implementation has its own parameter:
- `--spec-ngram-simple-size-m` for `ngram-simple`
- `--spec-ngram-map-k-size-m` for `ngram-map-k`
- `--spec-ngram-map-k4v-size-m` for `ngram-map-k4v`

### `--spec-ngram-*-min-hits H`

This option defines how often a key has to appear in the token history to be used as a draft (default is 1).

Each n-gram implementation has its own parameter:
- `--spec-ngram-simple-min-hits` for `ngram-simple`
- `--spec-ngram-map-k-min-hits` for `ngram-map-k`
- `--spec-ngram-map-k4v-min-hits` for `ngram-map-k4v`

## Statistics

Each speculative decoding implementation prints statistics.

```
draft acceptance rate = 0.57576 (  171 accepted /   297 generated)
statistics ngram_simple: #calls = 15, #gen drafts = 5, #acc drafts = 5, #gen tokens = 187, #acc tokens = 73
statistics draft: #calls = 10, #gen drafts = 10, #acc drafts = 10, #gen tokens = 110, #acc tokens = 98

```

```
draft acceptance rate = 0.70312 (   90 accepted /   128 generated)
statistics ngram_mod: #calls = 810, #gen drafts = 15, #acc drafts = 15, #gen tokens = 960, #acc tokens = 730, dur(b,g,a) = 0.149, 0.347, 0.005 ms

```

```
statistics ngram_map_k: #calls(b,g,a) = 6 1690 26, #gen drafts = 26, #acc drafts = 26, #gen tokens = 1248, #acc tokens = 968, dur(b,g,a) = 2.234, 1.427, 0.016 ms

```

- `#calls(b,g,a)`: number of calls of begin (new prompt), generation and accumulation of this implementations
- `#gen drafts`: number of drafts generated by this implementation
- `#acc drafts`: number of drafts accepted (partially) by the main model
- `#gen tokens`: number of tokens generated by this implementation (including rejected tokens)
- `#acc tokens`: number of tokens accepted by the main model
- `dur(b,g,a): durations of begin (new prompt), generation and accumulation (process acceptance).

                            

## Footer

                                           © 2026 GitHub, Inc.                                                     You can’t perform that action at this time.

## Assistant

<thinking>
Now I have the documentation. Let me analyze the user's benchmarks:

**Key observations from the benchmarks:**

1. **No speculation**: 8.60 tok/s, 3824 tokens
2. **MTP only (spec-draft-n-max=2)**: 17.56 tok/s, 5062 tokens, acceptance rate 0.760, 2595/3414 accepted/generated
3. **MTP + NGRAM (spec-draft-n-max=6)**: 18.27 tok/s, 3751 tokens, acceptance rate 0.426, 2151/5046 accepted/generated


4. **MTP + NGRAM (spec-draft-n-max=6)**: 18.27 tok/s, 3751 tokens, acceptance rate 0.426, 2151/5046 accepted/generated

The MTP approach alone nearly doubled throughput with a strong 76% acceptance rate. Adding ngram-mod with a higher draft-n-max only marginally improved speed to 18.27 tok/s while the acceptance rate dropped significantly to 42.6%. The ngram-mod statistics show it generated zero drafts and accepted zero drafts, suggesting it's not contributing effectively to the speculation process.

I'm noticing a critical issue: switching from q8_0 to f16 for the KV cache caused a substantial performance regression, increasing per-token latency from 116.23ms down to 116ms and dropping throughput from 603 to 445 tok/s during prompt processing. Additionally, the MTP + NGRAM configuration produced fewer output tokens (3751 vs 5062), which points to either different prompt lengths or potential issues with how the generation terminated. To get accurate comparisons, I need to control for these variables and isolate which speculative decoding approach actually delivers the best performance.

Looking at the ngram-mod configuration, the problem is clear: it requires an n-match length of 24 before it can even attempt speculation, which is rarely achieved in typical output. With n-min of 48, nothing gets generated until 48 tokens in, and n-max of 64 caps the lookback window. Since the model only produced 3751 tokens total, the ngram-mod strategy likely never activated or had minimal impact. The real bottleneck appears to be the KV cache format shift from q8_0 to f16, which fundamentally changes memory bandwidth characteristics.

I should focus on what would actually help: bumping up MTP's draft-n-max since the 76% acceptance rate suggests there's room for more speculation; keeping the KV cache in q8_0 for better bandwidth efficiency; and considering draft model speculation as an alternative approach if a smaller model is available.

The ngram-mod approach needs either a shorter n-match window or simply being disabled since it's not contributing meaningfully. I should also verify whether parallel=4 is actually providing benefits or if the GPU is already saturated. I'm reconsidering the token count discrepancy—the "graphs reused" metric tells a different story than I initially thought, suggesting the actual output lengths are comparable across configurations rather than the generation being truncated.

Looking at the acceptance rate more carefully, with 2595 accepted tokens out of 3414 generated, the average acceptance is about 0.76, which aligns well with the theoretical maximum for spec-draft-n-max=2 at roughly 0.89. This means there's still headroom to push n-max higher, likely around 4-5, since the acceptance rate isn't yet constrained. The ngram-mod approach didn't help at all—it generated zero drafts, which suggests the 24-token n-match threshold is too strict for the typical token sequences in this workload.

For KV cache, I should stick with q8_0 rather than downgrading to f16, since the bandwidth advantage is significant and the quality loss from quantization is minimal. To really push throughput higher, I could try MTP alone with n-max set to 4 or 5, which should yield better acceptance rates than combining MTP with ngram-mod. If that's not enough, I could explore MTP plus a smaller n-gram approach like ngram-simple with a much lower n-match value, though the tradeoff would be higher overhead for potentially diminishing returns.

</thinking>

## Analysis & Recommendations

Here's a breakdown of your benchmark results and how to push tok/s higher:

### Benchmark Summary

| Config | tok/s | Acceptance Rate | KV Cache | spec-draft-n-max |
|---|---|---|---|---|
| No speculation | **8.60** | — | q8_0 | — |
| MTP only | **17.56** | 0.760 | q8_0 | 2 |
| MTP + NGRAM | **18.27** | 0.426 | **f16** | 6 |

### Key Finding: ngram-mod is doing nothing

Look at the ngram-mod statistics:

```
ngram-mod: #calls=841, #gen drafts=0, #acc drafts=0, #gen tokens=0, #acc tokens=0
```

**Zero drafts generated, zero accepted.** The ngram-mod approach contributed nothing to speedup. Its n-match=24 means it needs 24 consecutive matching tokens before it can even start — far too restrictive for general-purpose generation. You paid the price of the KV cache downgrade (q8_0→f16) for no gain.

---

### Recommendations (ranked by impact)

#### 1. Increase MTP `spec-draft-n-max` (highest impact)

Your MTP-only run has a **76% acceptance rate with n-max=2**. The theoretical sweet spot for acceptance rate is ~0.7–0.85. At 0.76, you have headroom to go higher. Each additional accepted draft token gives you a near-free speedup.

Try **`spec-draft-n-max = 4`** first, then experiment with **5–6** if acceptance stays above ~0.60:

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-n4]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-n4
ctx-size = 50000

spec-type = draft-mtp
spec-draft-n-max = 4

flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

**Expected:** If acceptance holds above ~0.60 with n-max=4, you should see **~22–25 tok/s** based on the acceptance/speed relationship.

#### 2. Drop ngram-mod, keep MTP + ngram-simple instead

If you want to try combining a pattern-based drafter with MTP, **ngram-mod is the wrong choice** for your use case (general text generation). The `ngram-simple` variant is lighter and uses smaller n-grams:

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP+NGRAM]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP+NGRAM
ctx-size = 50000

spec-type = draft-mtp,ngram-simple
spec-draft-n-max = 4
spec-ngram-simple-size-n = 8    ; much smaller lookup
spec-ngram-simple-size-m = 16   ; shorter drafts from ngram

flash-attn = true
kv-unified = true
cache-type-k = q8_0             ; keep q8_0, don't downgrade to f16
cache-type-v = q8_0
```

**Why ngram-simple?** Its default n=12 (set to 8 above) means it can start contributing after just 8 tokens, vs. ngram-mod's 24-token threshold. It complements MTP by catching patterns the MTP heads miss.

#### 3. Consider a small external draft model (biggest potential gain)

If MTP alone maxes out, the [docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md) describe using a separate smaller model as the drafter. For a Qwen 27B model, a **Qwen 0.5B–1.5B** draft model can deliver dramatic speedups because it runs much faster than the main model while providing good draft quality.

```ini
[unsloth/qwen3.6-27B-Q6_K+Draft]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K+Draft
ctx-size = 50000

spec-type = draft-mtp,draft-simple
spec-draft-model = <path-to-qwen-1.5B-GGUF>
spec-draft-n-max = 8

flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0
```

The MTP heads still provide intra-model drafts, and the external model provides extra drafts. With n-max=8 and a good acceptance rate, **30–40+ tok/s** is achievable.

#### 4. KV Cache: stick with `q8_0`, not `f16`

Your MTP+NGRAM run switched KV cache to `f16` (likely due to ngram-mod's memory requirements). **q8_0 is the right choice** — it gives you ~2x the KV cache bandwidth at negligible quality loss for generation. The MTP drafter uses the model's own heads, so it doesn't need a separate KV cache.

---

### Quick experiment plan

Run these in order (same seed, same prompt for fair comparison):

| # | Config | `spec-draft-n-max` | `spec-type` | Expected improvement |
|---|---|---|---|---|
| 1 | Baseline (current) | 2 | `draft-mtp` | 17.56 tok/s |
| 2 | **Higher n-max** | **4** | `draft-mtp` | **+20–40%** if acc > 0.60 |
| 3 | MTP + ngram-simple | 4 | `draft-mtp,ngram-simple` | Small bump if acc holds |
| 4 | External draft model | 6–8 | `draft-mtp,draft-simple` | **2–3×** if you have a small model |

The single highest-leverage change is **#2: increasing `spec-draft-n-max` to 4** while keeping everything else identical. Your 76% acceptance rate tells you the MTP heads are confident and you're leaving speed on the table by capping at 2.
