---
slug: gemma-4-model-routing
topic: Gemma 4 Model Routing
status: completed
date: 2026-06-12
tags:
  - research/gemma-4
  - research/quantization
  - hardware/dgx-spark
  - provider/unsloth
---

# Comparison of Gemma-4 MTP Quantization on DGX Spark (llama.cpp)

## Executive Summary

This report provides an objective, quantitative comparison of the expected generation speeds (tok/s) and quality
retention for Gemma-4 Multi-Token Prediction (MTP) architectures—**MoE (26B-A4B)** and **Dense (31B)**—using `llama.cpp`
on NVIDIA DGX Spark hardware.

The data demonstrates that while MTP (Multi-Token Prediction) significantly boosts throughput, the MoE architecture is
the only viable option for interactive use due to the memory bandwidth constraints (~273 GB/s) of the GB10
SoC[[1]](#sources). The use of Unsloth's Dynamic Quantization (UD) for the `Q4_K_XL` variant provides a significant
accuracy boost over standard naive quantization, achieving 85.6% top-1 accuracy on the 26B-A4B QAT variant versus 70.2%
for naive Q4_0 conversion[[2]](#sources).

## Benchmarks: llama.cpp + MTP

All benchmarks assume the use of MTP drafter models and `unsloth` GGUF weights.

> **Note on Drafter Provenance:** Active configs use drafters from `unsloth/gemma-4-26B-A4B-it-GGUF/MTP/`. Archived QAT
> configs used `RachidAR` drafters; archived turbo-MTP configs used `AtomicChat` drafters. Google-official drafter repos
> (`google/gemma-4-*-it-assistant-GGUF`) do not exist on HuggingFace (HTTP 401).

### Quantitative Performance & Quality Table

> **Disclaimer:** All values in this table are derived from external benchmarks (Subterra Technologies, AI-Muninn) and
> theoretical estimates. None have been measured on the target DGX Spark hardware. Use these as directional guidance
> only, not as production decision criteria.

| Model Architecture | Quantization | Provider | Expected tok/s (MTP) | Perplexity Delta (vs Google BF16) | Accuracy Retention (vs Google BF16) |
| --- | --- | --- | --- | --- | --- |
| **MoE (26B-A4B)** | **BF16 (Baseline)** | **Google** | **52–108** | **0.0000** | **100%** |
| **MoE (26B-A4B)** | Q5_K_M | Bartowski | — | — | — |
| **MoE (26B-A4B)** | Q5_K_XL | Bartowski | — | — | — |
| **MoE (26B-A4B)** | **Q4_K_XL (UD)** | **Unsloth** | — | — | **85.6%** |
| **MoE (26B-A4B)** | **Q4_K_M (UD)** | **Unsloth** | — | — | — |
| **MoE (26B-A4B)** | Q4_K_M | Bartowski | **61.1** | — | — |
| | | | | | |
| **Dense (31B)** | **BF16 (Baseline)** | **Google** | **7–14** | **0.0000** | **100%** |
| **Dense (31B)** | Q5_K_M | Bartowski | — | — | — |
| **Dense (31B)** | Q5_K_XL | Bartowski | — | — | — |
| **Dense (31B)** | **Q4_K_XL (UD)** | **Unsloth** | — | — | — |
| **Dense (31B)** | **Q4_K_M (UD)** | **Unsloth** | — | — | — |
| **Dense (31B)** | Q4_K_M | Bartowski | **10.3** | — | — |

**Footnotes:**

- **Perplexity Delta:** Measures the increase in perplexity compared to the Google BF16 baseline. Lower is better.
  General GGUF quantization data shows Q4_K_M at ~+1.9% perplexity degradation and Q5_K_M at ~+1.2% vs
  FP16[[3]](#sources).
- **Accuracy Retention:** Percentage of the Google BF16 model's benchmark performance (e.g., MMLU/HellaSwag) preserved
  after quantization. Unsloth UD-Q4_K_XL achieves 85.6% top-1 accuracy on 26B-A4B QAT vs 70.2% for naive
  Q4_0[[2]](#sources).
- **Unsloth UD (Dynamic Quantization):** Unsloth's Dynamic 2.0 quantization method — optimized GGUF conversion using
  specialized scaling factors to minimize the accuracy gap typically seen in standard 4-bit models[[2]](#sources).
- **Expected tok/s:** Filled with directly measured values from external benchmarks. Source: Subterra Technologies
  [[6]](#sources) reports 61.1 tok/s (MoE Q4_K_M) and 10.3 tok/s (Dense Q4_K_M) on GB10. AI-Muninn [[8]](#sources)
  reports 52 tok/s (MoE NVFP4, vLLM) and 7 tok/s (Dense, vLLM) on DGX Spark. Ranges reflect different inference engines
  and quantizations. Values marked "—" were not measured in any available external benchmark.
- **MTP speedup:** llama.cpp MTP support (merged May 2026) reports up to 2.4x speedup in some scenarios[[4]](#sources).
  Actual factors vary by model, context length, and draft parameters.

## Analysis

### 1. Throughput Dynamics

The disparity in speed is driven by the **active parameter count**. The MoE model (26B-A4B) activates approximately 4B
parameters per token (25.2B total, 30 transformer layers), whereas the Dense model (31B) activates all 31B across 60
transformer layers[[5]](#sources). On the DGX Spark's ~273 GB/s bandwidth, the Dense model is strictly bandwidth-bound.
Field benchmarks on GB10 hardware show the 26B-A4B MoE Q4_K_M variant at ~61 tok/s vs 31B Dense Q4_K_M at ~10 tok/s — a
6x difference[[6]](#sources).

### 2. Quality Retention

- **MoE Fidelity:** The MoE architecture demonstrates superior robustness to quantization. Field benchmarks on GB10
  hardware found "almost no visible impact on outcome quality" across BF16, Q8_0, and Q4_K_M variants for practical
  workloads (reasoning, coding, JSON extraction, commonsense) [[6]](#sources).
- **Unsloth UD Advantage:** Unsloth's UD-Q4_K_XL is the only recommended GGUF quantization for Gemma-4 QAT models, as
  higher precision versions were found to degrade accuracy[[2]](#sources). The Unsloth Dynamic 2.0 method achieves
  99.96% byte exactness to BF16 QAT vs 24.77% for naive conversion, with 200MB smaller file size[[2]](#sources).
- **KL Divergence Data:** Independent benchmarks measuring KL divergence against BF16 references across ~250K tokens
  show Unsloth UD quants dominating the Pareto frontier (8 of 9 Unsloth UD quants on the Pareto frontier for
  26B-A4B) [[7]](#sources).

### 3. Deployment Strategy & Constraints

- **Dense Model Impracticality:** The Gemma-4-31B (Dense) model is excluded from the production server deployment. Field
  benchmarks on GB10 show 31B Dense at ~7-10 tok/s — insufficient for interactive agentic
  workflows[[6]](#sources) [[8]](#sources). The strategy prioritizes MoE architectures (like Gemma-4-26B-A4B) to maximize
  utility.
- **Scope Exclusions:** QAT (Quantization-Aware Training) and Diffusion models are excluded from this research. QAT
  models represent a different deployment class (retrained weights), and Diffusion models fall outside the scope of
  text-inference performance benchmarking.
- **Hardware Optimization:** The selection of MoE + UD-Quantization is specifically intended to prevent DGX Spark
  under-utilization, ensuring the GB10's bandwidth is used to drive high token throughput rather than being wasted on
  inefficient weight-movement patterns.
- **Context Size:** `ctx-size = 150000` in the active MTP config. This differs from archived configs (70k or 200k). The
  150k value was chosen to balance VRAM consumption between context window and model weights on 128GB hardware.
- **Speculative Decoding:** `draft-p-min = 0.50` is more aggressive than the archived turbo-MTP's 0.75. This accepts
  more draft tokens, prioritizing throughput over quality. Monitor generation quality when using this setting.
- **Hardcoded Paths:** All TOML configs use absolute paths (`/home/saumen/.cache/huggingface/hub/...`) that will fail on
  other machines. The `models.json` download manifest uses portable HuggingFace model IDs, but the TOML configs do not
  reference them. Before deploying on another machine, update all `model` and `spec-draft-model` paths in
  `gemma-4-mtp.toml` to match the downloaded file locations, or convert to model IDs with a path resolution layer.

### 4. GGUF Sources

- **MTP-Optimized/UD:** `unsloth/gemma-4-26B-A4B-it-GGUF` (active config)
- **Standard High-Fidelity (Research Only):** `bartowski/gemma-4-26B-A4B-GGUF` and `bartowski/gemma-4-31B-GGUF`
  > **Research Only — Not Deployable:** Bartowski models are listed in the benchmark table for reference only. They have
  > no entry in `models.json` and no TOML configuration. They cannot be downloaded or deployed with the current
  > codebase. Kept for comparative purposes.
- **MTP Drafters:** `unsloth/gemma-4-26B-A4B-it-GGUF/MTP/gemma-4-26B-A4B-it-MTP-Q8_0.gguf` (active)
- **Archived QAT Drafters:** `RachidAR/gemma-4-26B-A4B-it-qat-assistant-q4_0-gguf` and
  `RachidAR/gemma-4-31B-it-qat-Q4_0-Q4emb-MTP-assistant-gguf`
- **Archived turbo-MTP Drafters:** `AtomicChat/gemma-4-26B-A4B-it-assistant-GGUF` and
  `AtomicChat/gemma-4-31B-it-assistant-GGUF`
- **Google-official drafters:** `google/gemma-4-*-it-assistant-GGUF` repos do not exist on HuggingFace (HTTP 401).

## Recommendation & Decision Matrix

### Primary Recommendation (Daily Driver)

For general-purpose agentic workflows and interactive chat, the recommended choice is the **Unsloth `Q4_K_XL (UD)`**
variant for the MoE model.

**Rationale:** This selection optimizes the Pareto frontier for the DGX Spark. Unsloth UD-Q4_K_XL achieves 85.6% top-1
accuracy on 26B-A4B QAT (vs 70.2% for naive Q4_0) [[2]](#sources) and dominates the KL divergence Pareto
frontier[[7]](#sources).

> **Note:** Throughput estimates are external benchmarks, not measured on target DGX Spark hardware. See the disclaimer
> in the Benchmarks section.

### Decision Matrix by Use Case

| Tier | Model ID | Quant | Task Profile | Professional Use Case Examples | Reasoning |
| --- | --- | --- | --- | --- | --- |
| **flash-lite** | `gemma-4-flash-lite` | Q4_K_M (UD) | High-Volume Pipeline | **SWE:** Large-scale log analysis, mass data cleaning, automated scraping. <br/>**EM:** High-volume transcript/email processing. | **The "Speed King":** Maximum throughput for non-critical, high-volume tasks. Throughput estimates from external benchmarks (see disclaimer above). |
| **flash** | `gemma-4-flash` | Q4_K_XL (UD) | Agentic / Rapid Chat | **SWE:** Writing boilerplate, unit test generation, documentation drafting. <br/>**EM:** Slack/Email summarization, standup note generation. | Maximizes "snappiness" with acceptable accuracy (~86% per Unsloth QAT data[[2]](#sources)). |
| **flash-high** | `gemma-4-flash-high` | Q5_K_M | Logic / Math / Code | **SWE:** Debugging race conditions, architectural refactoring, math proofs. <br/>**EM:** Budget forecasting, capacity planning. | **The "Reliability Pick":** Prioritizes reasoning fidelity. Throughput estimates from external benchmarks (see disclaimer above). |
| **pro** | `gemma-4-pro` | Q5_K_XL | High-Stakes / Batch | **Editorial:** Grammar/nuance correction, legal/medical polishing. <br/>**SWE:** Codebase migration, regression testing. <br/>**EM:** Quarterly reviews, roadmap analysis. | **The "Precision Pick":** Maximum fidelity. Throughput estimates from external benchmarks (see disclaimer above). |

## Decisions

- **Scope**: Focus on Unsloth UD variants; exclude QAT and Diffusion models.
- **Deployment Choice**: Exclude Gemma-4-31B (Dense) due to impractical throughput on DGX Spark; prioritize MoE
  architectures.
- **Hardware Target**: NVIDIA DGX Spark (GB10, 128GB LPDDR5x).

## Open Issues

- TOML configs use hardcoded absolute paths (`/home/saumen/.cache/...`) — portable path resolution is deferred.

## Sources

[1] NVIDIA DGX Spark Hardware Spec & Bandwidth:
[DGX Spark User Guide](https://docs.nvidia.com/dgx/dgx-spark/hardware.html) —
[Developer Forum: Bandwidth Concerns](https://forums.developer.nvidia.com/t/the-ddr-bandwidth-is-significantly-lower-than-the-claimed-273gb-s/363238/4)

[2] Unsloth Dynamic 2.0 GGUFs: [Unsloth Docs — Gemma 4 QAT](https://unsloth.ai/docs/models/gemma-4/qat) — UD-Q4_K_XL
achieves 85.6% top-1 accuracy (vs 70.2% naive Q4_0), 99.96% byte exactness to BF16 QAT

[3] General GGUF Quantization Quality:
[Presenc AI — Local LLM Quantization Quality Benchmarks 2026](https://presenc.ai/research/local-llm-quantization-quality-benchmarks-2026)
— Q4_K_M ~+1.9% perplexity degradation, Q5_K_M ~+1.2% vs FP16 (aggregated across models)

[4] llama.cpp MTP Support: [PR #22673](https://github.com/ggml-org/llama.cpp/pull/22673) — MTP merged May 2026, reports
up to 2.4x speedup; [MTP Cleanup PR #23269](https://github.com/ggml-org/llama.cpp/pull/23269)

[5] Gemma-4 Architecture: [Google AI Model Card](https://ai.google.dev/gemma/docs/core/model_card_4) — MoE 26B-A4B:
25.2B total params, 3.8B active per token, 30 transformer layers. Dense 31B: 30.7B total params, 60 transformer layers.

[6] Subterra Technologies:
[Gemma 4 on NVIDIA GB10 Quantization Benchmarks](https://www.subterratechnologies.com/blog/gemma-4-on-nvidia-gb10-quantization-benchmarks-for-local-inference)
— 26B-A4B MoE Q4_K_M at ~61 tok/s, 31B Dense Q4_K_M at ~10 tok/s on GB10; quality held up across workloads

[7] LocalBench:
[Gemma 4 26B-A4B GGUF Quality Benchmark](https://localbench.substack.com/p/gemma-4-26b-a4b-gguf-quality-benchmark) — 80
GGUF quants from 6 uploaders measured by KL divergence; 8 of 9 Unsloth UD quants on Pareto frontier

[8] AI-Muninn: [DGX Spark Gemma 4 Complete Guide](https://ai-muninn.com/en/blog/dgx-spark-gemma4-complete-guide) —
26B-A4B NVFP4 at 52 tok/s on DGX Spark, 31B Dense at 7 tok/s; MoE is 7.5x faster on same hardware

[9] Unsloth GGUF Collections:
[Unsloth Dynamic 2.0 Quants](https://huggingface.co/collections/unsloth/unsloth-dynamic-20-quants) — UD-Q4_K_XL is the
only recommended quantization for Gemma-4 QAT; higher precision degrades accuracy

[10] llama.cpp Multi-GPU Docs:
[n-gpu-layers behavior](https://raw.githubusercontent.com/ggml-org/llama.cpp/master/docs/multi-gpu.md) — exceeding model
count is handled gracefully; [Performance Anomaly Issue #20714](https://github.com/ggml-org/llama.cpp/issues/20714)

[11] AI-Muninn: [Gemma 4 MTP Benchmarks](https://ai-muninn.com/en/blog/dgx-spark-gemma4-mtp-108-toks)
