# My Quest for the Optimal Local LLM Setup

*A personal journey through speculative decoding, MTP, and finding the right engine + quant combo.*

---

## The Starting Point

I've been running Qwen3.6-27B locally via **LMStudio** with `Q4_K_M` and `Q6_K`. It worked but was slow — conversational speed felt just out of reach. That sent me down a speculative decoding and llama.cpp rabbit hole. Here's what I found.

---

## The Numbers (My Benchmarks)

| Setup | Speed | |
|---|---|---|
| **No speculation** (baseline) | ~8.6 tok/s | sluggish |
| **MTP n=3** | 21.75 tok/s | **2.5× baseline** |
| MTP n=5 (peak throughput) | 20.83 tok/s | marginal gain vs n=3 |
| MTP n=6 | ~18.3–19.1 tok/s | diminishing returns |

The headline: speculative decoding **doubled my throughput** — and with the right settings, I'm well past conversational smoothness.

---

## How It Worked

The Qwen3.6-27B MTP variant has **built-in Multi-Token Prediction heads** — extra outputs that predict several tokens ahead. They generate a short draft, the main model verifies all of them in one forward pass, and accepted drafts are free tokens.

With `n-max=3` and a **68.8% acceptance rate** (Q5_K_XL), I hit 21.75 tok/s — 15.7% better than the same config on Q6_K. The MTP drafter actually produces *better* drafts at Q5_K_XL, which was the last thing I expected.

---

## Why n=3 Over n=2 or n=5

I tested n=2, n=3, n=5, and n=6. Here's the decision:

| Metric | n=2 | **n=3** (chosen) | n=5 | n=6 |
|--------|-----|:-----------------:|-----|-----|
| Acceptance rate | Highest | **68.8%** | 50.0% | 43.0% |
| Eff. toks/draft | 1.52 | **2.06** | 2.49 | 2.58 |
| Tail latency | Lowest | **Low** | Higher | Highest |
| Verdict | Too conservative | **Sweet spot** | Marginal gain, worse latency | Diminishing returns |

**n=2** was my first test — high acceptance but only 1.52 effective tokens per draft. That's leaving speed on the table.

**n=3** hit the sweet spot: 35% more effective tokens/draft than n=2, with still-high acceptance (68.8%) and low tail latency. For interactive use, this is the practical default.

**n=5** squeezed 1.9% more raw throughput over n=3, but with measurably worse latency characteristics. For batch/offline generation it wins. For chat, the extra variance isn't worth it.

**n=6** had the highest effective tokens/draft (2.58) but the worst throughput — verification overhead and 57% rejection rate cancelled out the longer drafts.

---

## What Worked vs. What Didn't

| ✅ What Worked | ❌ What Didn't |
|---|---|
| **MTP speculation** — 8.6→21.75 tok/s | **n-gram-mod** — 0 accepted drafts out of 841 calls. Pure overhead. |
| **Q5_K_XL over Q6_K** — better throughput *and* acceptance | **50k context** — ~80ms/token verify wall. 16k would cut ~60%. |
| **KV cache `q8_0`** — ~2× bandwidth over `f16` | **n-gram-simple** — added overhead at every depth tested |

**Key insight:** The model's own MTP heads are all you need. Adding n-gram drafters only added overhead.

---

## The Move: LMStudio → llama.cpp + Q5_K_XL

I'm switching from LMStudio to raw **llama.cpp** for three reasons:

1. **LMStudio runs on llama.cpp anyway** — it's a thin GUI layer over the same backend. The small overhead isn't worth the convenience once you're past the basics.

2. **New features ship to llama.cpp first** — MTP speculative decoding, draft heads, the latest quant formats — all land in llama.cpp before LMStudio, Ollama, or other providers add support.

3. **Granular configuration** — llama.cpp exposes every parameter: cache types, batching strategies, draft lengths, probability floors. That level of control matters when you're benchmarking.

I'm going with `Q5_K_XL` because it outperformed Q6_K in *every* metric — higher throughput, higher acceptance, faster prompt eval. Fine-grained control over context, cache, and batching is the point.

My config: `spec-draft-n-max=3`, `flash-attn`, `cont-batching`, `parallel=4`, `cache-type-kv=q8_0`.

---

## Hardware Notes

| Spec | DGX Spark |
|---|---|
| CPU | GB10 Grace Blackwell (20-core Arm) |
| GPU | Blackwell (5th Gen Tensor Cores) |
| Unified Memory | 128 GB LPDDR5x |
| Memory Bandwidth | 273 GB/s |

---

## TL;DR

| | |
|---|---|
| **Started at** | LMStudio, Q4/Q6, ~8.6 tok/s |
| **Discovered** | MTP speculation → 2.5× speedup |
| **Went with** | n-max=3, Q5_K_XL, llama.cpp — 21.75 tok/s |
| **Hardware** | DGX Spark |
| **Learned** | MTP alone is enough; n-gram was dead weight |
| **One-liner** | MTP model variants + speculative decoding are the real deal |

---

*Configs and benchmark scripts available. DM me.*
