---
slug: qwen3.6-model-routing
topic: Qwen3.6 Model Routing
status: completed
date: 2026-06-15
tags:
  - research/qwen3.6
  - research/quantization
  - hardware/dgx-spark
  - provider/unsloth
---

# Comparison of Qwen3.6 MTP Quantization on DGX Spark (llama.cpp)

## Executive Summary

This report provides an objective, quantitative comparison of the expected generation speeds (tok/s) and quality
retention for Qwen3.6 Multi-Token Prediction (MTP) architectures—**Dense (27B)** and **MoE (35B-A3B)**—using `llama.cpp`
on NVIDIA DGX Spark hardware.

The data demonstrates that while MTP (Multi-Token Prediction) boosts throughput for both architectures, the speedup is
more pronounced for the Dense model (~1.4-2.2x) than for MoE (~1.15-1.25x). However, the MoE architecture activates only
~3B parameters per token versus 27B for Dense, making it the throughput champion on the DGX Spark's ~273 GB/s memory
bandwidth. The use of Unsloth's Dynamic Quantization (UD) for the `Q4_K_XL` and `Q5_K_XL` variants provides a
significant accuracy boost over standard naive quantization.

The 27B Dense model achieves superior benchmark scores across coding, reasoning, and knowledge tasks compared to the
35B-A3B MoE variant, but its throughput on DGX Spark is significantly lower due to full-parameter activation.

## Benchmarks: llama.cpp + MTP

All benchmarks assume the use of Unsloth Dynamic v2.0 GGUF weights from `unsloth/Qwen3.6-*-MTP-GGUF` repos.

### Quantitative Performance & Quality Table

| Model Architecture | Quantization | Provider | Est. tok/s (MTP, DGX Spark) | Mean KLD (vs BF16) | Quality Band |
| --- | --- | --- | --- | --- | --- |
| **35B-A3B (MoE)** | **BF16** | Qwen | **[Baseline]** | **0.0000 (reference)** | **Reference** |
| **35B-A3B (MoE)** | Q5_K_XL (UD) | Unsloth | ~80 - 110 (projected) | **~0.0069** | Very close (< 0.01) |
| **35B-A3B (MoE)** | **Q4_K_XL (UD)** | Unsloth | **~100 - 130 (projected)** | **~0.0137** | Very close (< 0.02) |
| | | | | | |
| **27B (Dense)** | **BF16** | Qwen | **[Baseline]** | **0.0000 (reference)** | **Reference** |
| **27B (Dense)** | Q5_K_XL (UD) | Unsloth | ~14 - 18 (projected) | **0.0455** | Close (0.02–0.05 band) |
| **27B (Dense)** | **Q4_K_XL (UD)** | Unsloth | **~18 - 25 (projected)** | **0.0666** | Measurable drift (0.05+) |

**Footnotes:**

- **Mean KLD (KL Divergence):** Measures how much the quantized model's token predictions diverge from BF16. Lower =
  closer to original. 35B-A3B values measured by localbench (~250K tokens). 27B values measured by independent
  researcher using `llama-perplexity` (8192 tokens, KV cache q8_0): UD-Q5_K_XL = 0.0455, UD-Q4_K_XL = 0.0666. Unsloth UD
  GGUFs rank on the SOTA Pareto frontier for 21 of 22 sizes tested on 35B-A3B.
- **Why Dense Q4 drifts more than MoE Q4:** The MoE activates only ~3B of 35B parameters per token. The remaining ~97%
  of expert weights are inactive and their quantization noise never reaches the output. The Dense model activates all
  27B on every token — quantization error compounds across the full parameter set. This structural sparsity gives MoE a
  natural advantage under quantization, making MoE Q4 (~0.014) actually closer to BF16 than Dense Q4 (0.067).
- **Quality bands** (per smcleod.net scale): `<0.005` = essentially identical, `0.005–0.02` = very close, `0.02–0.05` =
  close with minor drift, `0.05–0.10` = measurable but often imperceptible under sampling, `>0.10` = substantial
  divergence where outputs may differ noticeably.
- **UD v2.0:** Uses model-specific per-tensor bit allocation with >1.5M token calibration dataset. Selective upcasting
  of critical layers (embeddings, lm_head, periodic attention layers) preserves reasoning fidelity.
- **Unsloth UD (Dynamic Quantization):** Optimized post-training quantization using specialized scaling factors to
  minimize the accuracy gap typically seen in standard 4-bit models. Works on both MoE and dense architectures.
- **Est. tok/s:** Projected ranges based on DGX Spark bandwidth constraints (~273 GB/s), active parameter counts, and
  MTP speedup factors (Dense: 1.4-2.2x, MoE: 1.15-1.25x at draft-n-max=2). **These are unmeasured projections, not
  benchmarked results.** For reference, Unsloth reports 160 tok/s (27B) and 240 tok/s (35B-A3B) on RTX 6000 GPU with MTP
  enabled.

### Official Benchmark Scores (BF16)

Key benchmarks from official Qwen model cards. The 27B Dense outperforms 35B-A3B MoE across all listed benchmarks,
reflecting the advantage of full parameter activation for reasoning-intensive tasks.

#### Coding & Agentic

| Benchmark | Qwen3.6-27B (Dense) | Qwen3.6-35B-A3B (MoE) | Delta |
| --- | --- | --- | --- |
| **SWE-bench Verified** | 77.2 | 73.4 | +3.8 |
| **SWE-bench Pro** | 53.5 | 49.5 | +4.0 |
| **Terminal-Bench 2.0** | 59.3 | 51.5 | +7.8 |
| **SkillsBench Avg5** | 48.2 | 28.7 | +19.5 |
| **NL2Repo** | 36.2 | 29.4 | +6.8 |
| **LiveCodeBench v6** | 83.9 | 80.4 | +3.5 |

#### Knowledge & Reasoning

| Benchmark | Qwen3.6-27B (Dense) | Qwen3.6-35B-A3B (MoE) | Delta |
| --- | --- | --- | --- |
| **MMLU-Pro** | 86.2 | 85.2 | +1.0 |
| **GPQA Diamond** | 87.8 | 86.0 | +1.8 |
| **AIME26** | 94.1 | 92.7 | +1.4 |

#### General Agent (35B-A3B only — not directly comparable)

The 35B-A3B card additionally reports agent-specific benchmarks:

| Benchmark | Qwen3.6-35B-A3B |
| --- | --- |
| **TAU3-Bench** | 67.2 |
| **MCPMark** | 37.0 |
| **MCP-Atlas** | 62.8 |
| **WideSearch** | 60.1 |

These agent benchmarks are evaluated with different tooling/harnesses than the coding benchmarks and should not be
directly compared across model families.

## Analysis

### 1. Throughput Dynamics

The throughput disparity is driven by **active parameter count**. The 35B-A3B MoE activates only ~3B parameters per
token (8 routed + 1 shared expert out of 256 total), whereas the 27B Dense model activates all 27B. On the DGX Spark's
~273 GB/s bandwidth, the Dense model is strictly bandwidth-bound, limiting its output to ~20 tok/s even with MTP
enabled.

MTP speedup factors differ significantly between architectures:

- **Dense (27B):** 1.4x - 2.2x speedup at draft-n-max=2 (acceptance rate ~83%)
- **MoE (35B-A3B):** 1.15x - 1.25x speedup at draft-n-max=2

The Dense model benefits more from MTP because its higher per-token compute cost makes speculative decoding relatively
more valuable. However, the absolute throughput still favors MoE by a large margin.

### 2. Quality Retention

- **MoE Fidelity:** The MoE architecture demonstrates robust quantization behavior. At `Q4_K_XL`, it preserves
  significant weight precision with Unsloth's Dynamic v2.0 selectively upcasting critical layers.
- **Unsloth UD Advantage:** Dynamic v2.0 intelligently adjusts quantization types per layer and per model, using a
  > 1.5M token calibration dataset. KL Divergence benchmarks show Unsloth GGUFs on the SOTA Pareto frontier for 21 of 22
  > sizes tested on Qwen3.6-35B-A3B.

### 3. Deployment Strategy & Constraints

- **Dense Model Limitation:** The Qwen3.6-27B (Dense) model, while achieving superior benchmark scores, delivers only
  ~18-25 tok/s on DGX Spark with MTP. This is sufficient for batch processing and non-interactive workflows but not
  ideal for rapid agentic iteration.
- **MoE Priority:** The Qwen3.6-35B-A3B MoE is the primary interactive workhorse, delivering ~100-130 tok/s with MTP at
  `Q4_K_XL (UD)`, making it suitable for real-time agentic coding workflows.
- **Hardware Optimization:** The selection of MoE + UD-Quantization prevents DGX Spark under-utilization, ensuring the
  GB10's bandwidth drives high token throughput rather than being wasted on inefficient weight-movement patterns.

### 4. GGUF Sources & MTP Configuration

- **MTP-Optimized/UD:** `unsloth/Qwen3.6-27B-MTP-GGUF` and `unsloth/Qwen3.6-35B-A3B-MTP-GGUF`
- **Recommended MTP settings:** `--spec-type draft-mtp --spec-draft-n-max 2` per Unsloth docs (optimal acceptance rate
  ~83%). **Note:** Local catalog files use `spec-draft-n-max = 3`, which may be DGX Spark-specific. Unsloth recommends
  trying values 1-6 and selecting the fastest for your hardware.
- **Context window:** 150,000 tokens configured in launcher presets (native support up to 262K, extensible to 1M via
  YaRN)

### 5. Preset Modes: Non-Thinking vs Coder

The catalog files define two operational modes with different sampling parameters:

- **Non-Thinking (NT):** `enable_thinking=false`, temperature=0.7, top-p=0.8, top-k=20, min-p=0.0, presence-penalty=1.5,
  repeat-penalty=1.0 — optimized for rapid general-purpose tasks where direct responses are preferred.
- **Reasoning:** `enable_thinking=true`, temperature=0.6, top-p=0.95, top-k=20, min-p=0.0, presence-penalty=0.0,
  repeat-penalty=1.0 — enables extended reasoning traces before output, critical for complex tasks requiring
  step-by-step analysis.

Qwen3.6 operates in thinking mode by default, generating `<think>...</think>` blocks before final responses. The
Reasoning preset leverages this for precise code generation, research, and decision-making, while NT disables it for
speed-critical pipelines.

**Sampling parameter nuances across model cards:**

| Parameter | 27B Thinking (General) | 27B Thinking (Precise) | 35B-A3B Thinking (General) | 35B-A3B Thinking (Precise) |
| --- | --- | --- | --- | --- |
| temperature | 1.0 | 0.6 | 1.0 | 0.6 |
| top_p | 0.95 | 0.95 | 0.95 | 0.95 |
| presence_penalty | 0.0 | 0.0 | 1.5 | 0.0 |

The Reasoning preset (`presence_penalty=0.0`) matches both models' precise-task recommendations. The NT preset
(`presence_penalty=1.5`) matches the 35B-A3B instruct mode. Note that the 27B card recommends `presence_penalty=0.0` for
_all_ thinking modes, while 35B-A3B uses `1.5` for general thinking — this suggests the Dense model may be more
sensitive to presence penalty during reasoning.

## Recommendation & Decision Matrix

### Primary Recommendation (Daily Driver)

For general-purpose agentic workflows and interactive chat, the recommended choice is the **35B-A3B MoE at `Q4_K_XL`
(UD)** in NT mode. It delivers ~100-130 tok/s with mean KLD of only ~0.014 (very close to BF16), making it
indistinguishable from higher-bit quants for most tasks.

For serious work requiring careful analysis, the recommended choice is **`reason-pro`** — 35B-A3B MoE at `Q5_K_XL` in
Reasoning mode. This gives you thinking mode + near-BF16 quality (KLD ~0.007) at ~80-110 tok/s, striking the best
balance between speed and accuracy for research, analysis, decision-making, and precise coding.

**Rationale:** The MoE's 3B active parameters + UD v2.0 quantization hit the sweet spot: near-BF16 quality at maximum
throughput. Dense 27B is reserved only for tasks where its +4% coding benchmark edge justifies a 5-7x throughput
penalty.

### Decision Matrix by Use Case

| Tier | Model ID | Quant | Mode | Task Profile | Est. tok/s | KLD | Rationale |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **flash-lite** | `Qwen3.6-35B-A3B-Q4-IT` | Q4_K_XL (UD) | NT | High-Volume Pipeline | ~100-130 | ~0.014 | Maximum throughput for non-critical, high-volume batch tasks. KLD ~0.014 is effectively indistinguishable from BF16. |
| **flash** | `Qwen3.6-35B-A3B-Q5-IT` | Q5_K_XL (UD) | NT | Agentic / Rapid Chat | ~80-110 | ~0.007 | Near-BF16 quality for interactive workflows. Best all-around NT tier. |
| **reason-fast** | `Qwen3.6-35B-A3B-Q4-Coder` | Q4_K_XL (UD) | Reasoning | Rapid Analysis | ~100-130 | ~0.014 | MoE speed + thinking mode for everyday research, coding, and analysis where turnaround time matters. |
| **reason-pro** | `Qwen3.6-35B-A3B-Q5-Coder` | Q5_K_XL (UD) | Reasoning | Precision Analysis | ~80-110 | ~0.007 | **Default for serious work.** Thinking mode + near-BF16 quality at MoE throughput. Best speed/accuracy balance. |
| **expert** | `Qwen3.6-27B-Q5-Coder` | Q5_K_XL (UD) | Reasoning | High-Stakes Analysis | ~14-18 | 0.0455 | Dense's +4% benchmark edge where it matters. KLD 0.0455 is in the "close" band. Use sparingly. |

**How to choose (pick one):**

1. **Speed first, anything non-critical** → `flash-lite` — MoE Q4 NT at ~100-130 tok/s, KLD ~0.014 is effectively
   indistinguishable from BF16
2. **Everyday agentic chat** → `flash` — MoE Q5 NT at ~80-110 tok/s, KLD ~0.007 (near-BF16 quality)
3. **Everyday research/analysis with thinking** → `reason-fast` — MoE Q4 Reasoning; same quality as flash-lite but with
   reasoning traces
4. **Precision work where errors are costly** → `reason-pro` — MoE Q5 Reasoning at ~80-110 tok/s, KLD ~0.007
   (essentially BF16-quality). **Best balance of speed + accuracy for most serious work.**
5. **Dense's benchmark edge matters** → `expert` — Dense 27B Q5 Reasoning at ~14-18 tok/s. Use only when the +3.8%
   SWE-bench / +4% SWE-bench Pro over MoE justifies paying a 6-8x throughput tax

**Key design decisions:**

- **MoE dominates for interactive work.** At Q4, MoE's KLD (~0.014) is only marginally higher than Dense Q5
  (~0.03–0.05), while being 5-7x faster.
- **Dense Q4 is excluded from the matrix.** Its KLD of ~0.06–0.09 (measurable drift band) means it offers worse quality
  than MoE Q4 _and_ worse throughput. It occupies a dead zone — use MoE Q4 for speed or Dense Q5 for accuracy.
- **`reason-pro` is the new workhorse tier.** MoE Q5 Reasoning gives you thinking mode + near-BF16 quality (~0.007 KLD)
  at ~80-110 tok/s. This should be the default for any task beyond boilerplate — coding, research, analysis,
  decision-making.
- **`flash` is the NT workhorse.** MoE Q5 NT gives you near-BF16 quality (~0.007 KLD) at ~80-110 tok/s without thinking
  overhead.
- **`flash-lite` is the speed tier.** MoE Q4 NT at ~100-130 tok/s for high-volume, non-critical workloads.
- **`expert` is the accuracy tier.** Dense 27B Q5 Reasoning for tasks where the +3.8% SWE-bench edge justifies a 6-8x
  throughput tax.
- **BF16 excluded** — too slow for practical use on DGX Spark; not included as a routing target.

## Decision Log

- **Scope**: Focus on Unsloth UD variants (Q4_K_XL, Q5_K_XL); exclude QAT and Diffusion models.
- **Deployment Choice**: Prioritize Qwen3.6-35B-A3B MoE for all interactive use. Reserve Qwen3.6-27B Dense only for
  tasks where its +4% coding benchmark edge justifies a 6-8x throughput penalty.

- **Hardware Target**: NVIDIA DGX Spark — GB10 Grace Blackwell (SM121, compute cap 12.1), 6,144 CUDA cores, 128 GB
  unified LPDDR5x (~273 GB/s bandwidth).
- **MTP Configuration**: `--spec-draft-n-max 2` recommended per Unsloth docs (83% acceptance rate vs 50% at
  draft-n-max=4). Local catalogs use `3` — may be DGX Spark-specific optimization.
- **Throughput estimates**: All tok/s figures are unmeasured projections derived from bandwidth-limited calculations and
  MTP speedup factors. Unsloth's measured benchmarks (160 tok/s for 27B, 240 tok/s for 35B-A3B on RTX 6000) serve as
  reference points but are not directly comparable due to different memory architectures.
- **KLD values**: All measured. 35B-A3B by localbench (~250K tokens). 27B by independent researcher using
  `llama-perplexity` (8192 tokens, KV cache q8_0): UD-Q5_K_XL = 0.0455, UD-Q4_K_XL = 0.0666. Quality bands per
  smcleod.net scale: <0.005 identical, 0.005–0.02 very close, 0.02–0.05 close, 0.05–0.10 measurable drift, >0.10
  substantial divergence.
- **Verification**: Benchmark scores verified against official HuggingFace model cards (Qwen/Qwen3.6-27B,
  Qwen/Qwen3.6-35B-A3B). Sampling parameters cross-checked against both model cards and Unsloth documentation.

## Sources

### Model & Architecture

- Qwen3.6-27B Model Card: <https://huggingface.co/Qwen/Qwen3.6-27B>
- Qwen3.6-35B-A3B Model Card: <https://huggingface.co/Qwen/Qwen3.6-35B-A3B>
- Qwen3.6-27B Blog Post: <https://qwen.ai/blog?id=qwen3.6-27b>
- Qwen3.6-35B-A3B Blog Post: <https://qwen.ai/blog?id=qwen3.6-35b-a3b>

### Quantization & KLD Benchmarks

- Unsloth Qwen3.6-27B MTP GGUF: <https://huggingface.co/unsloth/Qwen3.6-27B-MTP-GGUF>
- Unsloth Qwen3.6-35B-A3B MTP GGUF: <https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF>
- Unsloth Dynamic v2.0 GGUFs: <https://unsloth.ai/docs/basics/unsloth-dynamic-v2.0-gguf>
- Unsloth Qwen3.6 Guide: <https://unsloth.ai/docs/models/qwen3.6>
- **localbench 35B-A3B KLD benchmark** (MoE Q4=0.0137, Q5=0.0069):
  <https://localbench.substack.com/p/qwen-36-35b-a3b-gguf-quality-benchmark>
- **27B quantization KLD benchmark** (Dense Q4=0.0666, Q5=0.0455, via `llama-perplexity`):
  <https://bittide.aicompass.dev/article/9224f7cd-89fa-43a2-9c04-6a64a267fd20>
- **KLD methodology & quality band scale**:
  <https://smcleod.net/2026/04/measuring-model-quantisation-quality-with-kl-divergence>

### llama.cpp Features

- Comma-separated alias support (PR #19926): <https://github.com/ggml-org/llama.cpp/pull/19926>
- Alias overwrite bug, now closed (issue #22056): <https://github.com/ggml-org/llama.cpp/issues/22056>

### Hardware

- DGX Spark (local): GB10 Grace Blackwell, 6,144 CUDA cores, 128 GB LPDDR5x @ ~273 GB/s
