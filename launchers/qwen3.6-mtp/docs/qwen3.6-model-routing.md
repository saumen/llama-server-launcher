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
bandwidth. The use of Unsloth's Dynamic Quantization (UD) for the `Q5_K_XL` variant provides a significant accuracy boost over
standard naive quantization.

The 27B Dense model achieves superior benchmark scores across coding, reasoning, and knowledge tasks compared to the
35B-A3B MoE variant, but its throughput on DGX Spark is significantly lower due to full-parameter activation.

## Benchmarks: llama.cpp + MTP

All benchmarks assume the use of Unsloth Dynamic v2.0 GGUF weights from `unsloth/Qwen3.6-*-MTP-GGUF` repos.

### Quantitative Performance & Quality Table

| Model Architecture | Quantization | Provider | Est. tok/s (MTP, DGX Spark) | Mean KLD (vs BF16)     | Quality Band           |
| ------------------ | ------------ | -------- | --------------------------- | ---------------------- | ---------------------- |
| **35B-A3B (MoE)**  | **BF16**     | Qwen     | **[Baseline]**              | **0.0000 (reference)** | **Reference**          |
| **35B-A3B (MoE)**  | Q5_K_XL (UD) | Unsloth  | ~80 - 110 (projected)       | **~0.0069**            | Very close (< 0.01)    |
|                    |              |          |                             |                        |                        |
| **27B (Dense)**    | **BF16**     | Qwen     | **[Baseline]**              | **0.0000 (reference)** | **Reference**          |
| **27B (Dense)**    | Q5_K_XL (UD) | Unsloth  | ~14 - 18 (projected)        | **0.0455**             | Close (0.02–0.05 band) |

**Footnotes:**

- **Mean KLD (KL Divergence):** Measures how much the quantized model's token predictions diverge from BF16. Lower =
  closer to original. 35B-A3B values measured by localbench (~250K tokens). 27B values measured by independent
  researcher using `llama-perplexity` (8192 tokens, KV cache q8_0): UD-Q5_K_XL = 0.0455. Unsloth UD
  GGUFs rank on the SOTA Pareto frontier for 21 of 22 sizes tested on 35B-A3B.
- **Why Dense drifts more than MoE:** The MoE activates only ~3B of 35B parameters per token. The remaining ~97%
  of expert weights are inactive and their quantization noise never reaches the output. The Dense model activates all
  27B on every token — quantization error compounds across the full parameter set. This structural sparsity gives MoE a
  natural advantage under quantization.
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

| Benchmark              | Qwen3.6-27B (Dense) | Qwen3.6-35B-A3B (MoE) | Delta |
| ---------------------- | ------------------- | --------------------- | ----- |
| **SWE-bench Verified** | 77.2                | 73.4                  | +3.8  |
| **SWE-bench Pro**      | 53.5                | 49.5                  | +4.0  |
| **Terminal-Bench 2.0** | 59.3                | 51.5                  | +7.8  |
| **SkillsBench Avg5**   | 48.2                | 28.7                  | +19.5 |
| **NL2Repo**            | 36.2                | 29.4                  | +6.8  |
| **LiveCodeBench v6**   | 83.9                | 80.4                  | +3.5  |

#### Knowledge & Reasoning

| Benchmark        | Qwen3.6-27B (Dense) | Qwen3.6-35B-A3B (MoE) | Delta |
| ---------------- | ------------------- | --------------------- | ----- |
| **MMLU-Pro**     | 86.2                | 85.2                  | +1.0  |
| **GPQA Diamond** | 87.8                | 86.0                  | +1.8  |
| **AIME26**       | 94.1                | 92.7                  | +1.4  |

#### General Agent (35B-A3B only — not directly comparable)

The 35B-A3B card additionally reports agent-specific benchmarks:

| Benchmark      | Qwen3.6-35B-A3B |
| -------------- | --------------- |
| **TAU3-Bench** | 67.2            |
| **MCPMark**    | 37.0            |
| **MCP-Atlas**  | 62.8            |
| **WideSearch** | 60.1            |

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

- **MoE Fidelity:** The MoE architecture demonstrates robust quantization behavior. At `Q5_K_XL`, it preserves
  near-BF16 quality (KLD ~0.007) with Unsloth's Dynamic v2.0 selectively upcasting critical layers.
- **Unsloth UD Advantage:** Dynamic v2.0 intelligently adjusts quantization types per layer and per model, using a
  > 1.5M token calibration dataset. KL Divergence benchmarks show Unsloth GGUFs on the SOTA Pareto frontier for 21 of 22
  > sizes tested on Qwen3.6-35B-A3B.

### 3. Deployment Strategy & Constraints

- **Dense Model Limitation:** The Qwen3.6-27B (Dense) model, while achieving superior benchmark scores, delivers only
  ~18-25 tok/s on DGX Spark with MTP. This is sufficient for batch processing and non-interactive workflows but not
  ideal for rapid agentic iteration.
- **MoE Priority:** The Qwen3.6-35B-A3B MoE is the primary interactive workhorse, delivering ~80-110 tok/s with MTP at
  `Q5_K_XL (UD)`, making it suitable for real-time agentic coding workflows.
- **Hardware Optimization:** The selection of MoE + UD-Quantization prevents DGX Spark under-utilization, ensuring the
  GB10's bandwidth drives high token throughput rather than being wasted on inefficient weight-movement patterns.

### 4. GGUF Sources & MTP Configuration

- **MTP-Optimized/UD:** `unsloth/Qwen3.6-27B-MTP-GGUF` and `unsloth/Qwen3.6-35B-A3B-MTP-GGUF`
- **MTP settings in catalog:** `spec-type = draft-mtp`, `spec-draft-n-max = 3`, `draft-p-min = 0.50` — Unsloth recommends
  trying values 1-6; `2` is the documented sweet spot at ~83% acceptance rate.
- **Context window:** NT (flash) = 80,000 tokens — optimized for quick edit and rapid agentic chat where large context is unnecessary overhead; General = 120,000 tokens; Expert = 150,000 tokens; Coder (reason-fast/pro) = 120,000 tokens; Coder-Expert (reason-expert) = 150,000 tokens — balances depth with faster prompt processing. Native support up to 262K, extensible to 1M via YaRN

### 5. Preset Modes: NT, General, Expert, Coder, and Coder-Expert

The catalog defines five operational presets, all inheriting from the base `[ * ]` defaults (`ctx-size=120000`, `cache-type-k/v=f16`, `enable_thinking=true`, `temperature=0.6`, `top-p=0.95`, `top-k=20`, `min-p=0.0`, `repeat-penalty=1.0`, `spec-type=draft-mtp`, `spec-draft-n-max=3`, `draft-p-min=0.50`):

- **NT (flash):** `ctx-size=80000`, `enable_thinking=false`, `temperature=0.7`, `top-p=0.80`, `presence-penalty=1.5` — rapid general-purpose tasks, no thinking traces.
- **General:** `ctx-size=120000`, `presence-penalty=1.5` — inherits base thinking mode + MTP settings; for general reasoning tasks.
- **Expert:** `ctx-size=150000`, `presence-penalty=1.5` — 27B Dense model with extended context for deep reasoning.
- **Coder:** `ctx-size=120000`, `presence-penalty=0.0` — inherits base thinking mode + MTP; for coding tasks (zero presence penalty avoids penalizing code patterns).
- **Coder-Expert:** `ctx-size=150000`, `presence-penalty=0.0` — 27B Dense model with extended context for complex coding.

Qwen3.6 operates in thinking mode by default, generating `<think>...</think>` blocks before final responses. The
Reasoning preset leverages this for precise code generation, research, and decision-making, while NT disables it for
speed-critical pipelines.

**Sampling parameter nuances across model cards:**

| Parameter        | 27B Thinking (General) | 27B Thinking (Precise) | 35B-A3B Thinking (General) | 35B-A3B Thinking (Precise) |
| ---------------- | ---------------------- | ---------------------- | -------------------------- | -------------------------- |
| temperature      | 1.0                    | 0.6                    | 1.0                        | 0.6                        |
| top_p            | 0.95                   | 0.95                   | 0.95                       | 0.95                       |
| presence_penalty | 0.0                    | 0.0                    | 1.5                        | 0.0                        |

The Reasoning preset (`presence_penalty=0.0`) matches both models' precise-task recommendations. The NT preset
(`presence_penalty=1.5`) matches the 35B-A3B instruct mode. Note that the 27B card recommends `presence_penalty=0.0` for
_all_ thinking modes, while 35B-A3B uses `1.5` for general thinking — this suggests the Dense model may be more
sensitive to presence penalty during reasoning.

## Recommendation & Decision Matrix

### Primary Recommendation (Daily Driver)

For general-purpose agentic workflows and interactive chat, the recommended choice is the **35B-A3B MoE at `Q5_K_XL`
(UD)** in NT mode (`flash`). It delivers ~80-110 tok/s with mean KLD of ~0.007 (very close to BF16), making it
indistinguishable from higher-bit quants for most tasks.

For serious work requiring careful analysis, the recommended choice is **`coder`** — 35B-A3B MoE at `Q5_K_XL` in
Coder mode. This gives you thinking mode + near-BF16 quality (KLD ~0.007) at ~80-110 tok/s, striking the best
balance between speed and accuracy for research, analysis, decision-making, and precise coding.

**Rationale:** The MoE's 3B active parameters + UD v2.0 quantization hit the sweet spot: near-BF16 quality at maximum
throughput. Dense 27B is reserved only for tasks where its +4% coding benchmark edge justifies a 5-7x throughput
penalty.

### Decision Matrix by Use Case

| Tier               | Model ID                                          | Quant        | Mode    | Task Profile         | Est. tok/s | KLD    | Rationale                                                             |
| ------------------ | ------------------------------------------------- | ------------ | ------- | -------------------- | ---------- | ------ | --------------------------------------------------------------------- |
| **flash**          | `Qwen3.6-35B-A3B-Q5-IT` (alias: `flash`)          | Q5_K_XL (UD) | NT      | Agentic / Rapid Chat | ~80-110    | ~0.007 | Near-BF16 quality for interactive workflows. Best all-around NT tier. |
| **general**        | `Qwen3.6-35B-A3B-Q5-general` (alias: `general`)   | Q5_K_XL (UD) | General | General Reasoning    | ~80-110    | ~0.007 | Thinking mode + MTP for general reasoning tasks.                      |
| **general-expert** | `Qwen3.6-27B-Q5-Expert` (alias: `general-expert`) | Q5_K_XL (UD) | General | Deep Reasoning       | ~14-18     | 0.0455 | 27B Dense with 150K context for deep reasoning.                       |
| **coder**          | `Qwen3.6-35B-A3B-Q5-Coder` (alias: `coder`)       | Q5_K_XL (UD) | Coder   | Coding / Analysis    | ~80-110    | ~0.007 | MoE speed + thinking mode for coding and analysis.                    |
| **coder-expert**   | `Qwen3.6-27B-Q5-Coder` (alias: `coder-expert`)    | Q5_K_XL (UD) | Coder   | Complex Coding       | ~14-18     | 0.0455 | 27B Dense with 150K context for complex coding tasks.                 |

**How to choose (pick one):**

1. **Quick agentic chat** → `flash` — MoE Q5 NT at ~80-110 tok/s, KLD ~0.007 (near-BF16 quality)
2. **General reasoning with thinking** → `general` — MoE Q5 General mode; thinking traces for everyday reasoning
3. **Deep reasoning with extended context** → `general-expert` — 27B Dense at 150K context, ~14-18 tok/s
4. **Everyday coding/analysis** → `coder` — MoE Q5 Coder mode; thinking + MTP for coding tasks
5. **Complex coding with extended context** → `coder-expert` — 27B Dense at 150K context for complex code tasks

**Key design decisions:**

- **MoE dominates for interactive work.** MoE's 3B active parameters deliver 5-7x throughput over Dense 27B.
- **All catalog presets use Q5_K_XL (UD).** Q4 variants are not included in the current catalog — Q5 provides near-BF16 quality (KLD ~0.007) with acceptable throughput.
- **`coder` is the coding workhorse.** MoE Q5 Coder mode gives thinking + MTP at ~80-110 tok/s for everyday coding.
- **`flash` is the NT workhorse.** MoE Q5 NT at ~80-110 tok/s without thinking overhead.
- **`general` and `coder-expert` extend context.** General (120K) and Expert variants (150K) support longer-context tasks.
- **Dense 27B for precision.** Used only in Expert presets where benchmark edge justifies the throughput cost.
- **BF16 excluded** — too slow for practical use on DGX Spark; not included as a routing target.

## Decision Log

- **Scope**: Focus on Unsloth UD variants (Q5_K_XL); exclude QAT and Diffusion models.
- **Deployment Choice**: Prioritize Qwen3.6-35B-A3B MoE for all interactive use. Reserve Qwen3.6-27B Dense only for
  tasks where its +4% coding benchmark edge justifies a 6-8x throughput penalty.

- **Hardware Target**: NVIDIA DGX Spark — GB10 Grace Blackwell (SM121, compute cap 12.1), 6,144 CUDA cores, 128 GB
  unified LPDDR5x (~273 GB/s bandwidth).
- **MTP Configuration**: `--spec-type draft-mtp --spec-draft-n-max 3` in catalog (Unsloth recommends trying values 1-6;
  `2` is the documented sweet spot at ~83% acceptance rate). Local catalog uses `3` — may be DGX Spark-specific optimization.
- **Throughput estimates**: All tok/s figures are unmeasured projections derived from bandwidth-limited calculations and
  MTP speedup factors. Unsloth's measured benchmarks (160 tok/s for 27B, 240 tok/s for 35B-A3B on RTX 6000) serve as
  reference points but are not directly comparable due to different memory architectures.
- **KLD values**: All measured. 35B-A3B by localbench (~250K tokens). 27B by independent researcher using
  `llama-perplexity` (8192 tokens, KV cache q8_0): UD-Q5_K_XL = 0.0455. Quality bands per
  smcleod.net scale: <0.005 identical, 0.005–0.02 very close, 0.02–0.05 close, 0.05–0.10 measurable drift, >0.10
  substantial divergence.
- **Verification**: Benchmark scores verified against official HuggingFace model cards (Qwen/Qwen3.6-27B,
  Qwen/Qwen3.6-35B-A3B). Catalog presets cross-checked against current `qwen3.6-catalog.ini`. Sampling parameters
  cross-checked against both model cards and Unsloth documentation.

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
- **localbench 35B-A3B KLD benchmark** (MoE Q5=0.0069):
  <https://localbench.substack.com/p/qwen-36-35b-a3b-gguf-quality-benchmark>
- **27B quantization KLD benchmark** (Dense Q5=0.0455, via `llama-perplexity`):
  <https://bittide.aicompass.dev/article/9224f7cd-89fa-43a2-9c04-6a64a267fd20>
- **KLD methodology & quality band scale**:
  <https://smcleod.net/2026/04/measuring-model-quantisation-quality-with-kl-divergence>

### llama.cpp Features

- Comma-separated alias support (PR #19926): <https://github.com/ggml-org/llama.cpp/pull/19926>
- Alias overwrite bug, now closed (issue #22056): <https://github.com/ggml-org/llama.cpp/issues/22056>

### Hardware

- DGX Spark (local): GB10 Grace Blackwell, 6,144 CUDA cores, 128 GB LPDDR5x @ ~273 GB/s
