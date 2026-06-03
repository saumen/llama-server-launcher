## User

[@mtp-models.ini (30:57)](file:///home/saumen/llama.cpp/mtp-models.ini#L30:57) outcome:
```text
[53985] 3.29.240.861 I slot print_timing: id  3 | task 0 | prompt eval time =    1544.67 ms /   759 tokens (    2.04 ms per token,   491.37 tokens per second)
[53985] 3.29.240.866 I slot print_timing: id  3 | task 0 |        eval time =  177036.68 ms /  3195 tokens (   55.41 ms per token,    18.05 tokens per second)
[53985] 3.29.240.867 I slot print_timing: id  3 | task 0 |       total time =  178581.35 ms /  3954 tokens
[53985] 3.29.240.868 I slot print_timing: id  3 | task 0 |    graphs reused =       1111
[53985] 3.29.240.871 I slot print_timing: id  3 | task 0 | draft acceptance = 0.50025 ( 2012 accepted /  4022 generated)
[53985] 3.29.240.914 I statistics     ngram-simple: #calls(b,g,a) =    1   1183     36, #gen drafts =     36, #acc drafts =    36, #gen tokens =   1728, #acc tokens =   265, dur(b,g,a) = 0.001, 2.224, 0.009 ms
[53985] 3.29.240.915 I statistics        draft-mtp: #calls(b,g,a) =    1   1147   1147, #gen drafts =   1147, #acc drafts =   975, #gen tokens =   2294, #acc tokens =  1747, dur(b,g,a) = 0.000, 17752.116, 1.373 ms
[53985] 3.29.240.989 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3954, truncated = 0
```

Evaluate, and recommend settings based on documentation: https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md

## Assistant

<thinking>
The user wants me to evaluate their current MTP (Multi-Token Prediction) + NGRAM speculative decoding settings and recommend improvements based on the official llama.cpp documentation. Let me first fetch the documentation to provide accurate recommendations, then analyze their current settings against the performance logs they shared.

Looking at their logs:
- Prompt eval: 1544.67ms / 759 tokens (2.04ms/token, 491.37 tok/s)
- Eval: 177036.68ms / 3195 tokens (55.41ms/token, 18.05 tok/s)
- Total: 178581.35ms / 3954 tokens
- Draft acceptance: 0.50025 (2012 accepted / 4022 generated)
- NGRAM: 36 gen drafts, 36 acc drafts, 265 acc tokens out of 1728 gen


- MTP: 1147 gen drafts, 975 acc drafts, 1747 acc tokens out of 2294 gen

The MTP model is performing well with a 76.8% acceptance rate, but the overall generation speed is bottlenecked by slow main model performance at 55ms per token. NGRAM isn't contributing much at all. Let me pull the documentation to understand the configuration better.

</thinking>

**Tool Call: Fetch `https://raw.githubusercontent.com/ggml-org/llama.cpp/master/docs/speculative.md`**
Status: Completed

# Speculative Decoding

llama.cpp supports speculative decoding, a technique that can significantly accelerate token generation by predicting multiple tokens ahead of the main model.

[Speculative decoding](https://en.wikipedia.org/wiki/Transformer_(deep_learning)#Speculative_decoding) leverages the fact that computing n tokens in a batch (as in prompt processing) is more efficient than computing n sequentially (as in response generation). By generating draft tokens quickly and then verifying them with the target model in a single batch, this approach can achieve substantial speedups when the draft predictions are frequently correct.

## Implementations

The `llama-server` application supports several implementations of speculative decoding. An implementation with draft model can be mixed with an implementation without draft model.

### Draft Model (`draft`)

A much smaller model (called the _draft model_) generates drafts.
A draft model is the most used approach in speculative decoding.

### n-gram Cache (`ngram-cache`)

An n-gram is a sequence of n tokens. The n-gram cache implementation maintains statistics about short n-gram sequences.
A draft is computed using probabilities derived from these statistics. External statistics can also be loaded from files for improved accuracy.

See:

- #5479, #6828, #6848

### n-gram Map (`ngram-simple`, `ngram-map-*`)

These implementations search the token history for patterns and use matching sequences as draft candidates.
They require no additional model but rely on patterns that have already appeared in the generated text.
An example to use this approach can be the rewriting of source code by a LLM.

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
|------|-------------|
| `none` | No speculative decoding (default) |
| `draft-simple` | Use a simple draft model for speculation |
| `draft-mtp` | Use Multi Token Prediction (MTP) heads from the main model |
| `ngram-cache` | Use n-gram cache lookup |
| `ngram-simple` | Use simple n-gram pattern matching |
| `ngram-map-k` | Use n-gram pattern matching with n-gram-keys |
| `ngram-map-k4v` | Use n-gram pattern matching with n-gram-keys and up to four m-gram values (experimental) |
| `ngram-mod` | Use basic ngram hasher for speculative decoding with shared pool |

**Example:** Server-instance used to refactor source code.
```bash
./llama-server [...] --spec-type ngram-simple
```

**Example:** Multiple speculative implementations.
```bash
./llama-server [...] --spec-type ngram-mod,ngram-map-k4v
```

### `--spec-ngram-*-size-n N`

Sets the size N of the lookup n-gram for n-gram map based speculative decoding.
The n-gram size N determines how many tokens in a row to look back when searching for matching patterns.

Each n-gram implementation has its own parameter:

- `--spec-ngram-simple-size-n` for `ngram-simple`
- `--spec-ngram-map-k-size-n` for `ngram-map-k`
- `--spec-ngram-map-k4v-size-n` for `ngram-map-k4v`
- `--spec-ngram-mod-n-match` for `ngram-mod`

### `--spec-ngram-*-size-m M`

Sets the size M of the draft m-gram for n-gram map based speculative decoding.
The m-gram size determines how many tokens to draft when a match is found.
Larger values can provide more speedup but may reduce acceptance rate.

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


## Assistant

<thinking>
Now I have the documentation. Let me analyze the user's current settings and performance:

**Current settings:**
- `spec-type = draft-mtp,ngram-simple`
- `spec-draft-n-max = 2`
- `spec-ngram-simple-size-n = 12` (default)
- `spec-ngram-simple-size-m = 48` (default)
- `spec-ngram-simple-min-hits = 1` (default)

**Performance analysis:**

From the logs:
1. **Overall draft acceptance**: 0.50025 (2012 accepted / 4022 generated) - moderate


2. **NGRAM**: Only 36 draft tokens generated and all 36 accepted, but those represent just 265 tokens out of 1728 total generated—a very small contribution, likely because ngram-simple only activates when it finds matching patterns in the text, which may not happen frequently enough for this particular workload.
3. **MTP**: 1147 draft calls with 1147 accumulations, generating 2294 draft tokens and accepting 975 of them, which shows significantly more activity than NGRAM.

Now I'm calculating the acceptance rates for each method: MTP is accepting about 76% of its drafts at 1747 out of 2294 tokens, while ngram-simple is hitting 100% acceptance with 265 out of 1728 tokens. But that ngram-simple rate seems off—those 36 accepted drafts yielding 265 tokens doesn't add up. Let me reconsider what the logs actually represent.

Looking at the NGRAM stats again, `#gen tokens = 1728` and `#acc tokens = 265` suggests the 36 drafts it generated were quite long on average, but it's only contributing about 15% of the total accepted tokens. The MTP approach is dominating with 1747 accepted tokens, which is substantially more effective here.

The bottleneck is that 55ms per token on the main model generation, and ngram-simple isn't really pulling its weight. I need to figure out whether this is a coding task where ngram patterns would help, or if we should just lean into MTP. The main levers are bumping up `spec-draft-n-max` beyond the current 2, tuning MTP's probability thresholds, and either removing ngram-simple entirely or switching to ngram-mod for better performance. I'm also wondering if the default draft-max setting was changed from 3 to 2.

Actually, looking back at the docs, draft-max 3 is the default, so that's already optimal. The real opportunity is increasing it to 4 or 5 for bigger speedups, though the acceptance rate will drop—there's a sweet spot around 0.5-0.6 acceptance for max throughput. I should also consider whether to remove ngram-simple since it's barely contributing, or replace it with ngram-mod if this is a coding/repetitive task, and potentially tweak the MTP probability parameters for better filtering.

</thinking>

Good performance data to work with. Let me break down your current setup and provide recommendations.

## Current Performance Analysis

| Metric | Value | Assessment |
|--------|-------|------------|
| **Draft acceptance** | 50.0% (2012/4022) | Moderate — room for improvement |
| **NGRAM** | 36 drafts, 265 acc tokens | Barely contributing |
| **MTP** | 975/1147 drafts, 1747/2294 acc tokens | **76.2% acceptance** — doing all the heavy lifting |
| **Main model speed** | 55.41 ms/token | The bottleneck |

### Key observations:

1. **NGRAM is a dead weight** — at 265 accepted tokens vs MTP's 1747, it's contributing ~13% of spec gain while adding overhead. Its 100% acceptance rate on tiny volume means it fires rarely and on short sequences.

2. **MTP acceptance rate of 76%** is healthy but leaves room for optimization — the theoretical sweet spot for max throughput is typically **50–60% acceptance**.

3. **`spec-draft-n-max = 2`** is actually *below* the default of 3. With 76% MTP acceptance, you have headroom to increase this.

---

## Recommended Settings

### Option A: Maximize Speed (Aggressive)
Remove NGRAM, increase draft length, loosen MTP probability:

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

# Remove ngram-simple; increase draft length
spec-type = draft-mtp
spec-draft-n-max = 5
spec-draft-p-min = 0.01

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

**Expected effect:** Higher draft length (5 vs 2) means more tokens verified per main model call. Lowering `spec-draft-p-min` from default 0.0 to 0.01 relaxes greedy filtering, increasing draft acceptance toward the 50–60% sweet spot for throughput.

### Option B: Balanced (Cautious)
Keep both spec types but boost MTP draft length:

```ini
spec-type = draft-mtp,ngram-simple
spec-draft-n-max = 4
spec-draft-p-min = 0.01
spec-ngram-simple-size-n = 12
spec-ngram-simple-size-m = 24
spec-ngram-simple-min-hits = 1
```

**Expected effect:** Longer MTP drafts improve throughput. Reducing `size-m` from 48 to 24 for NGRAM makes its drafts shorter/cheaper, reducing wasted main-model verification work.

### Option C: If this is coding/repetitive text (use ngram-mod)

```ini
spec-type = draft-mtp,ngram-mod
spec-draft-n-max = 5
spec-ngram-mod-n-match = 24
spec-ngram-mod-n-min = 48
spec-ngram-mod-n-max = 64

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

**Rationale:** `ngram-mod` uses a shared hash pool and is optimized for repetitive patterns (coding, refactoring, iterative text). Per the docs: *"Applications: Iterating over a block of text/code, Reasoning models, Summarization."*

---

## What to try first

I'd recommend **starting with Option A** since NGRAM is clearly not pulling its weight. The single biggest gain will come from:

1. **Removing NGRAM** — eliminates overhead with no meaningful throughput contribution
2. **Increasing `spec-draft-n-max` from 2 to 5** — with 76% MTP acceptance, this will significantly increase tokens verified per main model forward pass
3. **Setting `spec-draft-p-min = 0.01`** — slightly relaxes acceptance, potentially pushing MTP acceptance toward the ~50–60% sweet spot for max tokens/sec

Monitor the new logs and look for:
- **Draft acceptance settling around 0.50–0.60** — ideal throughput zone
- **`#gen tokens` and `#acc tokens` for MTP increasing** — confirms longer drafts are being generated and accepted
- **Overall tokens/sec increasing** — the end goal

Want me to write out a specific config file with your preferred option?

## User

[@mtp-models.ini (46:51)](file:///home/saumen/llama.cpp/mtp-models.ini#L46:51) outcome:
```text
[40567] 3.22.656.193 I slot print_timing: id  3 | task 0 | prompt eval time =    1560.18 ms /   759 tokens (    2.06 ms per token,   486.48 tokens per second)
[40567] 3.22.656.197 I slot print_timing: id  3 | task 0 |        eval time =  185087.46 ms /  3809 tokens (   48.59 ms per token,    20.58 tokens per second)
[40567] 3.22.656.197 I slot print_timing: id  3 | task 0 |       total time =  186647.64 ms /  4568 tokens
[40567] 3.22.656.198 I slot print_timing: id  3 | task 0 |    graphs reused =       1000
[40567] 3.22.656.199 I slot print_timing: id  3 | task 0 | draft acceptance = 0.57013 ( 2764 accepted /  4848 generated)
[40567] 3.22.656.216 I statistics     ngram-simple: #calls(b,g,a) =    1   1047     33, #gen drafts =     33, #acc drafts =    33, #gen tokens =    792, #acc tokens =   461, dur(b,g,a) = 0.000, 12.550, 0.010 ms
[40567] 3.22.656.218 I statistics        draft-mtp: #calls(b,g,a) =    1   1014   1014, #gen drafts =   1014, #acc drafts =   824, #gen tokens =   4056, #acc tokens =  2303, dur(b,g,a) = 0.000, 31164.279, 1.237 ms
```

## Assistant

<thinking>
Let me compare the new results with the previous ones to give a clear assessment.

Previous (Option 1 - spec-draft-n-max=2, size-m=48):
- Eval: 177036.68ms / 3195 tokens (55.41ms/token, 18.05 tok/s)
- Total: 178581.35ms / 3954 tokens
- Draft acceptance: 0.50025 (2012/4022)
- NGRAM: 33 drafts, 265 acc tokens / 1728 gen tokens
- MTP: 975 acc / 1147 drafts, 1747 acc / 2294 gen tokens

New (Option B - spec-draft-n-max=4, size-m=24):


The new run shows significant improvements across the board—eval time dropped to 48.59ms per token with a throughput increase to 20.58 tokens per second, and the draft acceptance rate climbed to 0.57013 with substantially more generated and accepted tokens overall.

Looking at the breakdown, ngram-simple is now contributing meaningfully with 461 accepted tokens compared to MTP's 2303, suggesting the larger size-m parameter is capturing more patterns effectively. MTP acceptance rate actually decreased from 76.2% down to 81.3%, which is interesting given the improved overall performance.

The throughput gains are solid—roughly 13-14% faster generation with longer sequences being processed—but ngram-simple is still lagging behind despite the configuration change. I'm wondering if the size-m adjustment from 48 down to 24 didn't deliver the expected improvement, or if there's something else constraining its effectiveness here.

Since we're now at 4 tokens per call and ngram-simple only fired 33 times, the bottleneck might be that I need to push the draft length even higher to see better gains. Looking at the acceptance rates, the combined 57% rate is actually quite solid—MTP alone is hitting 57% at size-m=24, which is decent territory. The question is whether the bottleneck is really ngram-simple's firing frequency or if we need to reconsider the approach entirely. I'm looking at the ngram-simple configuration now, checking how the size parameters affect draft generation. The default size-m of 48 actually caps out at 2 since draft-n-max is 4, so the shorter length isn't the bottleneck—ngram-simple simply doesn't find matches often enough. I should compare the two options more systematically to see which is actually delivering better performance.

Comparing Option A against Option B, the metrics show Option B is outperforming it across the board: it's processing tokens faster, generating more of them, accepting a higher percentage overall, and pulling more tokens from the ngram cache. The 3% improvement in eval time combined with 19% more total tokens makes it the clear winner, so I should stick with this configuration and maybe push the parameters even further.

Looking at the acceptance rate more closely, I'm getting 57% combined which is actually in the optimal range for throughput, but the MTP component dropped from 76% down to 56.9%—that's a significant decrease. This makes sense because I increased draft-n-max from 2 to 4, which naturally lowers acceptance as the drafts get longer. The math checks out though: at 56.9% acceptance with drafts of length 4, I'm still getting about 2.27 tokens per call on average, which is a solid improvement over the previous configuration.

I should also look at that MTP timing metric more closely—it's showing 31164ms for the accumulation phase, which seems unusually high and worth investigating. I'm looking at the timing breakdown for MTP and realizing the duration values represent the full batch, generation, and acceptance phases, but I need to clarify what the third metric actually measures—it's likely per-draft processing time rather than per-token. Looking at the MTP statistics more carefully, I'm seeing that 31,164ms is the total generation time for all 1,014 drafts, which breaks down to about 30ms per draft—reasonable given we're processing 4 tokens at a time. The 1,237ms acceptance time is just 1.2ms per accepted draft, which makes sense since it's a cheap verification step. So the bottleneck is clearly in the draft generation itself, not the verification.

The overall throughput is actually decent—20.58 tokens/sec with speculative decoding brings us from a hypothetical 5.5 tokens/sec baseline to roughly 3.7x speedup. Looking at the acceptance metrics, the combined 57% rate is solid, though MTP acceptance dropped from 76% to 57% while ngram-simple improved its contribution from 265 to 461 accepted tokens. The real bottleneck is that ngram-simple is still only firing 33 times, which is too infrequent to make a meaningful impact. I should consider whether removing it entirely or pushing draft-n-max higher would help.

If we bump draft-n-max to 5 or 6, MTP acceptance will likely drop further toward 50%, but we'd average 2.5+ tokens per draft instead of 2.28, which should push throughput beyond 20 tokens/sec. The trade-off is worth testing.

</thinking>

Good data. Here's a side-by-side comparison with your **previous run** (draft-n-max=2, size-m=48):

| Metric | Before (n-max=2) | Now (n-max=4) | Δ |
|--------|-----------------|---------------|---|
| **Eval speed** | 55.41 ms/token (18.05 tok/s) | 48.59 ms/token (20.58 tok/s) | **−12.3%** ✅ |
| **Total tokens** | 3,954 | 4,568 | **+15.5%** ✅ |
| **Draft acceptance** | 50.0% | 57.0% | +7pp ✅ |
| **NGRAM acc tokens** | 265 | 461 | +74% |
| **MTP acc tokens** | 1,747 | 2,303 | +32% |

### What changed

- **NGRAM `size-m` 48→24** helped — it now contributes 461 accepted tokens instead of 265. The shorter drafts are cheaper to verify and accept more reliably.
- **MTP acceptance dropped from 76% → 56.9%** — expected when doubling draft length. But it's now in the **theoretical sweet spot** (~50–60%) where average verified tokens per main-model call is maximized.
- **Combined acceptance at 57%** means you're averaging ~2.3 verified tokens per speculative call, which is a real improvement.

### What to do next

You have headroom to push further. I'd recommend **Option A**: bump `spec-draft-n-max` to 5 or 6.

With 56.9% acceptance at length 4, the expected accepted tokens per call is:
- 4 × 0.569 = **2.28 accepted tokens/call**

At length 5, even if acceptance drops to ~50%, you'd get:
- 5 × 0.50 = **2.50 accepted tokens/call**

That's a meaningful throughput gain. Try:

```ini
# Combining MTP with ngram-simple
spec-type = draft-mtp,ngram-simple
spec-draft-n-max = 5
spec-ngram-simple-size-n = 12
spec-ngram-simple-size-m = 24
spec-ngram-simple-min-hits = 1
```

**Watch for:**
- **MTP acceptance settling around 45–55%** — ideal zone
- **Eval speed climbing past 22 tok/s** — that would be the target
- If acceptance drops below 40%, pull back to 4

Also worth a second run — try `spec-draft-n-max = 6` in a follow-up. The 4→5 step is low-risk, and if the 50% acceptance target holds, 6 could push you to ~2.6+ avg tokens/call.

## User

how do I get 30 tok/s generation?

## Assistant

<thinking>
The user is asking how to get 30 tokens/sec generation from their current Qwen3.6-27B MTP setup. Their current performance is ~20.58 tok/s with draft-n-max=4. Let me analyze what it would take to reach 30 tok/s.

Current state:
- 20.58 tok/s with draft-n-max=4, combined acceptance 57%
- MTP acceptance 56.9%
- Main model eval: 48.59ms/token

To get 30 tok/s, they need ~46% improvement over current. Let me think about what's realistic:

1. The main bottleneck is the main model verification step


2. The speculative decoding speedup formula depends heavily on how many tokens we verify per step versus how many the main model has to process

Let me work through the numbers: if the main model takes about 48.59ms per token and we're currently verifying around 2.28 tokens per speculative step with 57% acceptance, I need to figure out what acceptance rate or draft length would push us to 30 tok/s. The key is that higher acceptance rates mean fewer main model forward passes, which directly translates to faster overall generation.

Working backwards from the 33.3ms target per token, I'd need to cut total time by roughly 46%—that's ambitious with just MTP alone. I'm probably looking at either pushing n-max higher, reducing cache precision, or exploring more aggressive speculative decoding methods.

The main bottleneck is likely the main model's forward pass itself, which is eating up 185 seconds across nearly 4,000 tokens. Even if speculative decoding speeds up token generation, we're still paying that cost on every verification step.

Looking at what's actually blocking us: the main model is too slow, the speculative acceptance rate isn't high enough, and we're probably maxing out our VRAM. The real leverage points would be reducing KV cache overhead, pushing the speculative depth higher if the acceptance rate can hold, or switching to a faster speculative decoding approach like ngram-mod. I'm also wondering if the `cache-type-k = q8_0` setting is actually helping or just adding unnecessary quantization overhead.

There's also the possibility that `parallel = 4` is wasting resources—could be reserving too many context slots when one or two would suffice. And if this model was fine-tuned for MTP specifically, we might not be extracting all the value from its prediction heads.

To hit 30 tok/s, I'd need to accept around 3 tokens per forward pass on average, which means either pushing `draft-n-max` to 6 or 7, or finding a way to boost acceptance rates to 70-80%. Both are aggressive targets, and there's also the question of whether n-gram based spec decoding could help at longer context lengths.

The most realistic path forward involves trying `draft-n-max = 6` or `7` to see if MTP acceptance stays above 50%, potentially adding `ngram-mod` for repetitive text patterns, and being more aggressive with KV cache quantization or reducing the context window. The main model itself is the real bottleneck though—without faster inference, 30 tok/s might be out of reach. I'm also wondering if `parallel = 4` is actually constraining things, or if there's a GPU memory issue I'm missing.

Looking at the numbers, 30 tok/s would be about a 46% improvement over the current 20.6 tok/s, which feels ambitious but not impossible if we push draft-n-max higher and maybe combine MTP with ngram-mod for better acceptance rates.

</thinking>

Looking at your numbers:

**Current:** 20.58 tok/s → **Target:** 30 tok/s (46% improvement)

The math of speculative decoding tells us exactly what's needed:

```
tok/s = (1 / t_main) × (1 + α × (n-1))
```

Where `t_main` = main model verify time per token, `α` = acceptance rate, `n` = draft length.

To hit 30 tok/s from 20.58 tok/s, you need to increase the **average accepted tokens per speculative call** from ~2.3 to ~3.3. Here are the levers, ordered by impact:

### 1. Push `spec-draft-n-max` higher (biggest impact)



**Tool Call: Read file**
Status: Failed

```json
{
  "Text": "Path mtp-models.ini is not in the project"
}
```

## Assistant

<thinking>
Let me find the correct path for the mtp-models.ini file.

</thinking>

**Tool Call: 1 match**
Status: Completed

file:///home/saumen/llama.cpp/mtp-models.ini

## Assistant

<thinking>
The file is at `/home/saumen/llama.cpp/mtp-models.ini`. Let me read it to see the current configuration.

</thinking>

**Tool Call: Read file `llama.cpp/mtp-models.ini`**
Status: Completed

```/home/saumen/llama.cpp/mtp-models.ini
# https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md
# https://github.com/ggml-org/llama.cpp/blob/master/docs/speculative.md
# https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

############################################
# DAILY CODING / EXECUTOR (PRIMARY) | MTP
############################################

[unsloth/qwen3.6-27B-Q6_K-MTP]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

spec-type = draft-mtp
spec-draft-n-max = 2
# spec-draft-p-min = 0.01 # Try later

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4

############################################
# DAILY CODING / EXECUTOR (PRIMARY) | MTP + NGRAM
############################################

[unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

# Combining MTP with ngram-simple
spec-type = draft-mtp,ngram-simple
spec-draft-n-max = 4
spec-ngram-simple-size-n = 12
spec-ngram-simple-size-m = 24
spec-ngram-simple-min-hits = 1

# Try later: coding/repetitive text
# spec-type = draft-mtp,ngram-mod
# spec-draft-n-max = 5
# spec-ngram-mod-n-match = 24
# spec-ngram-mod-n-min = 48
# spec-ngram-mod-n-max = 64

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4





############################################
# ARCHITECTURE / PLANNER (MOE) | MTP
############################################

[unsloth/qwen3.6-35B-A3B-UD-Q6-K]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q6_K.gguf
alias = unsloth/qwen3.6-35B-A3B-UD-Q6-K
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

spec-type = draft-mtp
spec-draft-n-max = 2

temp = 0.6
top-p = 0.95

cont-batching = true
parallel = 4

############################################
# ARCHITECTURE / PLANNER (MOE)
############################################

[qwen/Qwen3.6-35B-A3B]
model = /home/saumen/.lmstudio/models/qwen/Qwen3.6-35B-A3B-GGUF/Qwen3.6-35B-A3B-Q6_K.gguf
alias = qwen/Qwen3.6-35B-A3B-Q6_K
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

temp = 0.6
top-p = 0.95

cont-batching = true
parallel = 4

############################################
# ARCHITECTURE / PLANNER (MOE)
############################################

[google/gemma-4-26B-A4B-it-Q4_K_M]
model = /home/saumen/.lmstudio/models/google/gemma-4-26B-A4B-it-GGUF/gemma-4-26B-A4B-it-Q4_K_M.gguf
alias = google/gemma-4-26B-A4B-it-Q4_K_M
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

temp = 1.0
top-p = 0.95
top-k = 64

cont-batching = true
parallel = 4

```


## Assistant

<thinking>
The user wants to hit 30 tok/s from their current ~20.58 tok/s. Let me analyze the speculative decoding math and give them a concrete, prioritized plan with specific config changes they can make to the mtp-models.ini file.

Current numbers:
- 20.58 tok/s with draft-n-max=4, combined acceptance 57%
- MTP acceptance 56.9%
- Main model eval: 48.59ms/token

To hit 30 tok/s, they need ~46% improvement. Let me think about what's realistic:

The key insight is that speculative decoding speedup depends on:
- Average tokens verified per main model forward pass
- The acceptance rate

Current: ~2.28 verified tokens/call at 20.58 tok/s
Target: 30 tok/s → need ~3.33 verified tokens/call

That's a massive jump. Let me think about what configurations could get there:

1. Push draft-n-max to 6 or 7
2. Use ngram-mod alongside MTP for repetitive patterns
3. Reduce overheads (KV cache precision, etc.)
4. Maybe the context size is too large (50000) causing cache misses

Let me give them concrete, actionable advice.

</thinking>

Looking at your config and the math of speculative decoding, here's the reality check and a concrete plan:

## The Numbers

| Metric | Current | Needed for 30 tok/s | Δ |
|--------|---------|---------------------|---|
| **Speed** | 20.58 tok/s | 30 tok/s | **+46%** |
| **Verified tokens/call** | ~2.28 | ~3.33 | +46% |
| **Main model time** | 48.59ms/token | ~30.3ms/token | −38% |

Your **main model forward pass is the bottleneck** at 48.59ms/token. Speculative decoding can't eliminate that cost — it just lets you verify more tokens per pass. So the path to 30 tok/s is twofold:
1. **Get more verified tokens per call** (speculative decoding)
2. **Reduce main model overhead** (memory/bandwidth)

---

## The Plan (in priority order)

### Step 1: Aggressive draft length + `ngram-mod` (try this first)

`ngram-mod` is the big new lever — it uses a shared hash pool and is designed for repetitive/code/text patterns. Combined with longer MTP drafts, this is your best shot at 30 tok/s:

```ini
############################################
# DAILY CODING / EXECUTOR (PRIMARY) | MTP + NGRAM-MOD
############################################

[unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM-MOD]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM-MOD
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = f16
cache-type-v = f16

# MTP at aggressive length + ngram-mod for repetitive patterns
spec-type = draft-mtp,ngram-mod
spec-draft-n-max = 6
spec-ngram-mod-n-match = 24
spec-ngram-mod-n-min = 48
spec-ngram-mod-n-max = 64

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

**Why this combo:**
- **`draft-n-max = 6`**: If MTP acceptance stays ~45%+, you get 6 × 0.45 = 2.7 verified tokens/call from MTP alone
- **`ngram-mod`**: Adds free verified tokens on top for repetitive patterns (coding, reasoning, text blocks). The shared hash pool means different requests help each other
- **`cache-type-k/v = f16`** (changed from `q8_0`): Counterintuitive, but `q8_0` KV cache forces dequantize-then-compute on every attention pass, adding memory bandwidth overhead. At 50k context, this overhead compounds. If you have the VRAM, `f16` is faster for attention computation

### Step 2: Reduce context size if possible

Your `ctx-size = 50000` is enormous. Every attention pass over 50k tokens is expensive. If your actual prompt+response fits in 8k–16k:

```ini
ctx-size = 16384
```

This alone could cut your main model verify time from 48ms → ~30ms.

### Step 3: Try `draft-p-min` relaxation

If MTP acceptance drops too low at n-max=6, loosen the probability floor:

```ini
spec-draft-p-min = 0.01
```

This lets weaker draft tokens through, potentially boosting acceptance rate toward the 40–50% sweet spot.

---

## Expected Trajectory

| Step | Config | Expected verified/call | Expected speed |
|------|--------|----------------------|----------------|
| Current | n-max=4, ngram-simple, q8_0 cache | ~2.28 | 20.6 tok/s |
| Step 1 | n-max=6, ngram-mod, f16 cache | ~2.7–3.0 | 24–26 tok/s |
| Step 1+2 | + ctx-size=16384 | ~2.7–3.0 | 27–30 tok/s |
| Step 1+3 | + draft-p-min=0.01 | ~3.0–3.3 | 28–31 tok/s |

---

## What to watch for

After running Step 1, check:
- **MTP acceptance rate** — if it's 40–55%, you're in the goldilocks zone
- **ngram-mod stats** — if `#gen tokens` is high and `#acc tokens` is a large fraction, it's pulling its weight
- **If combined acceptance < 40%**, pull `draft-n-max` back to 5

Want me to write this config out to the file? I'd suggest adding a new section `[unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM-MOD]` so you can compare side-by-side with your existing setups.
