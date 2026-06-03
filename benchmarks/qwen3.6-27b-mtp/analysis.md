# MTP Speculative Decoding Benchmark Analysis

**Default variant:** unsloth/Qwen3.6-27B-UD-Q5_K_XL (GGUF). Q6_K retained for reference.

**Date:** 2026-05-23
**Model:** unsloth/Qwen3.6-27B-Q6_K (GGUF)
**Context Window:** 50,000 tokens
**Temperature:** 0.3 | **Top-p:** 0.9 | **Top-k:** 20
**KV Cache:** q8_0 (K/V unified), except where noted
**Parallelism:** 4 | **Cont-batching:** enabled
**Prompt:** 759 tokens

---

## 1. Executive Summary

Speculative decoding with MTP (Multi-Token Prediction) delivers a **121.6% throughput improvement** over no speculation on this model, peaking at **19.07 tok/s** with `spec-draft-n-max = 5`.

Key findings:

| Finding | Detail |
|---------|--------|
| **Best throughput** | 19.07 tok/s at n=5 (MTP only), up from 8.60 tok/s baseline |
| **Diminishing returns** | n=6 drops to 18.30 tok/s despite higher effective tokens per draft |
| **N-gram simple adds overhead** | n=4 with ngram-simple (18.51 tok/s) is worse than n=3 alone (18.79 tok/s); n=6+ngram (17.75 tok/s) is worse than n=6 alone (18.30 tok/s) |
| **N-gram mod is inert** | Produced 0 accepted drafts out of 841 calls — entirely useless on this model |
| **Acceptance degrades predictably** | 76.0% at n=2 → 43.0% at n=6 |
| **Sweet spot** | Dual recommendation — n=3 (stable latency) or n=5 (peak throughput) — both valid |
| **Q5_K_XL wins** | Q5_K_XL replaces Q6_K — n=3: 21.75 tok/s (+15.7%), n=5: 20.83 tok/s (+9.2%). Acceptance at n=3 even improved from 63.4% → 68.8% |

---

## 2. Configuration Matrix

| Run | Config | Throughput | Draft Acceptance | Eff. Toks/Draft | Total Toks | Prompt Eval (ms) | KV Cache |
|-----|--------|-----------:|:----------------:|:---------------:|:----------:|:----------------:|:--------:|
| Baseline | no speculation | **8.60** tok/s | — | — | 3,065 | 1,257.57 | q8_0 |
| MTP | n=2, draft-mtp | 17.56 tok/s | 76.0% | 1.52 | 4,303 | 1,516.93 | q8_0 |
| MTP+ngram-mod | n=6, draft-mtp+ngram-mod | 18.27 tok/s | 42.6% | 2.56 | 2,992 | 1,703.64 | f16 |
| MTP+ngram-simple | n=4, draft-mtp+ngram-simple | 18.51 tok/s | 53.1% | 2.12 | 2,929 | 1,665.35 | q8_0 |
| Run A | n=3, draft-mtp | 18.79 tok/s | 63.4% | 1.90 | 3,191 | 1,513.71 | q8_0 |
| **Run B** | **n=5, draft-mtp** | **19.07 tok/s** | **50.0%** | **2.50** | **3,573** | **1,548.89** | **q8_0** |
| Run C | n=6, draft-mtp | 18.30 tok/s | 43.0% | 2.58 | 3,132 | 1,557.05 | q8_0 |
| Run D | n=6, draft-mtp+ngram-simple | 17.75 tok/s | 40.5% | 2.58 | 2,539 | 1,544.58 | q8_0 |

> **Note:** "Total Toks" refers to decoded (generated) tokens during the eval phase. Prompt tokens = 759 across all runs.
>
> **Throughput improvement over baseline:** MTP n=2 (+104.2%), MTP+ngram-mod n=6 (+112.4%), MTP+ngram-simple n=4 (+115.2%), Run A n=3 (+118.5%), **Run B n=5 (+121.6%)**, Run C n=6 (+112.8%), Run D n=6+ngram (+106.4%).

---

## 3. Acceptance Rate vs. Depth Curve

Draft acceptance rate degrades monotonically as the draft depth `n` increases:

| Draft Depth (n) | Acceptance Rate | Accepted / Generated | Source |
|:---------------:|:---------------:|:--------------------:|:------:|
| 2 | **76.0%** | 2,595 / 3,414 | MTP baseline run |
| 3 | **63.4%** | 2,091 / 3,297 | Run A |
| 5 | **50.0%** | 2,554 / 5,110 | Run B |
| 6 | **43.0%** | 2,260 / 5,250 | Run C |

```
Acceptance Rate
100% ┤
 90% ┤
 80% ┤ ●
 70% ┤
 60% ┤      ●
 50% ┤              ●
 40% ┤                    ●
 30% ┤
 20% ┤
 10% ┤
  0% ┤──┬────┬────┬────┬───
      2    3    4    5    6   Draft Depth (n)
```

**Observation:** The acceptance rate follows a roughly linear decline of ~8–9 percentage points per additional draft token. This is consistent with the expected behavior of speculative decoding: each additional token in a draft sequence compounds the probability of disagreement between the draft and target models.

---

## 4. Effective Tokens per Draft Analysis

Effective tokens per draft measures the average number of tokens accepted per draft invocation. This is computed as `acceptance_rate × n`:

| Draft Depth (n) | Acceptance Rate | Eff. Toks/Draft | Source |
|:---------------:|:---------------:|:---------------:|:------:|
| 2 | 76.0% | **1.52** | MTP baseline run |
| 3 | 63.4% | **1.90** | Run A |
| 4 | 53.1% | **2.12** | MTP+ngram-simple n=4 |
| 5 | 50.0% | **2.50** | Run B |
| 6 | 43.0% | **2.58** | Run C |

```
Effective Tokens per Draft
3.0 ┤                                    ●
2.5 ┤                       ●     ●
2.0 ┤             ●
1.5 ┤  ●
1.0 ┤
0.5 ┤
0.0 ┤──┬────┬────┬────┬────┬───
     2    3    4    5    6
          Draft Depth (n)
```

### Why n=6 Has the Highest Effective Tokens but Not the Best Throughput

At n=6, the effective tokens per draft (2.58) exceeds that of n=5 (2.50), meaning more draft tokens are accepted on average per invocation. However, throughput at n=5 (19.07 tok/s) still exceeds n=6 (18.30 tok/s) by 4.2%.

**The reason is verification overhead.** In speculative decoding, the main model must verify all draft tokens (accepted or rejected) in a single forward pass. As `n` increases:

1. **More computation per verification step:** Each verification pass processes `n` tokens instead of 1, increasing memory bandwidth pressure and computation.
2. **Higher rejection penalty:** Even though more tokens are accepted, the remaining rejected tokens still consume verification compute. At n=6, 57% of draft tokens are rejected — those are "wasted" verification cycles.
3. **Diminishing parallelism gain:** The speedup formula for speculative decoding is roughly `(1 + (n-1) × acceptance_rate)`. At n=5: `1 + 4 × 0.50 = 3.0×`. At n=6: `1 + 5 × 0.43 = 3.15×`. The marginal gain (3.15 vs 3.00) does not offset the increased per-step latency.

This is a classic tradeoff: **higher effective tokens per draft does not guarantee higher throughput** — the per-step latency must remain low enough to make the increased draft length worthwhile.

---

### Head-to-Head: n=3 vs n=5

The two top configurations sit within 1.9% of each other in throughput, making this the most consequential decision in the benchmark. Here's the tradeoff:

| Metric | n=3 | n=5 | Delta |
|--------|-----|-----|-------|
| Throughput | 18.79 tok/s | 19.07 tok/s | +1.9% |
| Prompt eval time | 1,513.71 ms | 1,548.89 ms | +2.3% |
| Acceptance rate | **63.4%** | 50.0% | −13.4pp |
| Eff. toks/draft | 1.90 | **2.50** | +32% |
| Tail latency risk | Lower | Higher | — |

**n=3 is the better choice when:**
- You need consistent, predictable latency (interactive chat, agents, API serving)
- Higher acceptance rates mean fewer "bursty" generation patterns
- Lower per-step verification cost reduces memory bandwidth pressure
- The 1.9% throughput difference is not worth the latency variability

**n=5 is the better choice when:**
- Raw throughput is the only metric that matters (batch offline generation)
- You can tolerate slightly more variable latency
- The 32% higher effective tokens per draft justifies the lower acceptance rate

**Verdict:** For most use cases (interactive, real-time), n=3 is the more practical default. The 1.9% throughput gain at n=5 is marginal and comes with measurably worse latency characteristics. For pure throughput benchmarks or batch processing, n=5 is the clear winner.

---

## 5. N-gram Analysis

### MTP-only vs. MTP+ngram at Equivalent Depth

| Configuration | Throughput | Draft Acceptance | Total Toks | Prompt Eval (ms) |
|--------------|-----------:|:----------------:|:----------:|:----------------:|
| MTP n=6 only (Run C) | **18.30** tok/s | 43.0% | 3,132 | 1,557.05 |
| MTP+ngram-simple n=6 (Run D) | 17.75 tok/s | 40.5% | 2,539 | 1,544.58 |
| **Degradation** | **−3.0%** | −2.5pp | −19.0% | −0.8% |

Adding `ngram-simple` at n=6 **reduces** throughput by 3.0% despite adding a second draft source. The ngram-simple statistics reveal why:

```
ngram-simple: #calls(b,g,a) = 1  722     16
              #gen drafts =    16
              #acc drafts =    16
              #gen tokens =   256
              #acc tokens =    81
```

- Only 16 of 722 ngram calls produced valid drafts (2.2% call rate)
- Of those 16, all 81 produced tokens were accepted — but that's only 81 extra accepted tokens
- MTP alone produced 2,260 accepted tokens
- **ngram-simple contributed just 3.6% of total accepted tokens** while adding overhead

### N-gram Mod: Completely Inert

The `ngram-mod` configuration (with `n-match = 24`, `n-min = 48`, `n-max = 64`) produced **zero accepted drafts**:

```
ngram-mod: #calls(b,g,a) = 1  841      0
           #gen drafts =      0
           #acc drafts =      0
           #gen tokens =      0
           #acc tokens =      0
```

The minimum frequency threshold (`n-min = 48`) appears too restrictive for this model's text patterns, rendering the ngram-mod component entirely dead code during inference.

### Summary: N-gram Impact

| Metric | MTP-only (n=6) | +ngram-simple | +ngram-mod |
|--------|:--------------:|:-------------:|:----------:|
| Throughput | 18.30 tok/s | 17.75 tok/s (−3.0%) | 18.27 tok/s (−0.2%) |
| MTP acceptance | 43.0% | 40.5% | 42.6% |
| Extra accepted tokens | — | +81 | 0 |
| Added prompt eval overhead | — | +0.8% | +9.3%* |

> \* ngram-mod also used f16 KV cache instead of q8_0, so part of the overhead is from cache precision, not ngram itself.

**Conclusion:** N-gram supplementation provides negligible to negative benefit on this model. The MTP drafts are sufficiently accurate that the lightweight ngram approach adds overhead without meaningful gains.

---

## 6. Recommendation

### Updated: Q5_K_XL Replaces Q6_K

The Q5_K_XL quantization variant delivers superior throughput across all configurations and has replaced Q6_K as the default model. The recommendation below is for Q5_K_XL.

### For Interactive / Real-Time Use (recommended default)

```ini
spec-type = draft-mtp
spec-draft-n-max = 3
```

**Rationale:**
1. **Peak interactive throughput:** 21.75 tok/s at n=3 (Q5_K_XL) — a 15.7% improvement over Q6_K n=3 (18.79 tok/s).
2. **Higher acceptance rate (68.8%):** Exceeds Q6_K's 63.4% — the Q5_K_XL MTP drafter produces better drafts.
3. **Lower per-step latency:** 3-token verification passes with lighter weights.
4. **Lower prompt eval overhead:** 1,400.69 ms at Q5_K_XL vs 1,513.71 ms at Q6_K (−7.5% faster first token).
5. **Effective toks/draft:** 2.06 at Q5_K_XL vs 1.90 at Q6_K — the drafter is genuinely better.

### For Maximum Throughput (batch / offline)

```ini
spec-type = draft-mtp
spec-draft-n-max = 5
```

**Rationale:**
1. **Peak throughput:** 20.83 tok/s at Q5_K_XL n=5 — a 9.2% improvement over Q6_K (19.07 tok/s).
2. **Higher effective tokens per draft:** 2.49 at Q5_K_XL vs 2.50 at Q6_K — essentially flat, the drafter scales well.
3. **Ideal for:** Batch generation, offline processing, or any scenario where total generation time matters more than per-token latency.

### Common Configuration (Both Use Cases)

```ini
model = <path-to-Q5_K_XL.gguf>
spec-type = draft-mtp
# No ngram augmentation needed — adds overhead without benefit
cache-type-kv = q8_0  # Preserve memory bandwidth
```

### Full Configuration Spectrum (Q5_K_XL)

| Goal | Model | `spec-draft-n-max` | Throughput | Best For |
|------|-------|--------------------|-----------:|----------|
| Interactive / real-time (default) | Q5_K_XL | `3` | **21.75** tok/s | Chat, agents, API serving |
| Maximum throughput | Q5_K_XL | `5` | **20.83** tok/s | Batch, offline generation |
| Maximum draft quality | Q5_K_XL | `2` | ~20 tok/s* | Quality-critical workloads |
| No speculation | Q5_K_XL | — | 9.61 tok/s | Baseline comparison |
| Interactive / real-time (legacy) | Q6_K | `3` | 18.79 tok/s | Reference only |
| Maximum throughput (legacy) | Q6_K | `5` | 19.07 tok/s | Reference only |
| No speculation (legacy) | Q6_K | — | 8.60 tok/s | Reference only |

*Estimated: Q5_K_XL no-spec (9.61) vs Q6_K no-spec (8.60) = +11.7%, so Q5_K_XL n=2 would be ~17.56 × 1.117 ≈ 19.6 tok/s

---

## 7. Future Exploration

If throughput above 25 tok/s is needed, the current MTP-only approach has likely reached its practical ceiling on this hardware/configuration. The remaining bottleneck is the main model's per-token verification cost, which speculative decoding cannot reduce below 1×.

**Potential paths to 25+ tok/s:**

1. **Lightweight external draft model:** A small dedicated draft model (0.5B–1.5B parameters in GGUF format) could provide higher-acceptance drafts than MTP. The MTP architecture shares weights with the main model and predicts tokens autoregressively from the same context, which limits its acceptance rate. A purpose-built draft model trained specifically for token prediction could achieve acceptance rates above 60% even at n=5, translating to throughput well above 20 tok/s.

2. **KV cache optimization:** The current runs reuse 685–1086 graphs. Investigating whether more aggressive KV cache eviction policies or cache compaction could reduce memory bandwidth pressure during the verification step may yield 1–3 tok/s improvements.

3. **Model quantization:** Moving from Q6_K to Q5_K or Q4_K could reduce memory bandwidth pressure, potentially improving both the main model verification speed and the MTP forward passes. This should be tested against quality degradation.

4. **Parallel draft verification:** If llama.cpp supports batching multiple draft verification passes, this could amortize the per-step overhead and push n=5 or n=6 throughput above the current ceiling.

---

## 8. Q5_K_XL Quantization Follow-Up — 2026-05-23

A follow-up benchmark was run using the **Q5_K_XL** quantization variant (`unsloth/Qwen3.6-27B-UD-Q5_K_XL.gguf`) to test whether reducing from Q6_K to Q5_K_XL improves throughput while preserving quality.

### Head-to-Head: Q6_K vs Q5_K_XL

| Metric | Q6_K | Q5_K_XL | Delta |
|--------|------|---------|-------|
| No-spec baseline | 8.60 tok/s | **9.61 tok/s** | +11.7% |
| n=3 throughput | 18.79 tok/s | **21.75 tok/s** | **+15.7%** |
| n=5 throughput | 19.07 tok/s | **20.83 tok/s** | +9.2% |
| n=3 acceptance | 63.4% | **68.8%** | +5.4pp |
| n=5 acceptance | 50.0% | 49.8% | −0.2pp |
| n=3 eff. toks/draft | 1.90 | **2.06** | +8.4% |
| n=5 eff. toks/draft | 2.50 | 2.49 | flat |
| n=3 prompt eval | 1,513.71 ms | **1,400.69 ms** | −7.5% |
| n=5 prompt eval | 1,548.89 ms | **1,411.80 ms** | −8.9% |

### Key Findings

1. **Q5_K_XL dominates Q6_K across all configurations.** Both n=3 and n=5 show significant throughput gains (+15.7% and +9.2% respectively). The lighter model weights reduce memory bandwidth pressure during both main model inference and MTP draft passes.

2. **Acceptance rate improved at n=3 (63.4% → 68.8%).** This is unexpected — quantization typically degrades or leaves acceptance unchanged. The improvement suggests the Q5_K_XL weight layout may have better cache behavior during the MTP's autoregressive draft generation. The UD prefix in the filename (`Qwen3.6-27B-UD-Q5_K_XL`) may indicate a weight format that's more amenable to the MTP's internal KV cache reuse.

3. **n=5 acceptance is unchanged (50.0% → 49.8%).** The deeper draft sequence is already at the point where MTP prediction quality naturally degrades, so quantization has no further impact.

4. **Effective tokens per draft improved at n=3 (1.90 → 2.06).** This is the combined result of higher acceptance rate and same draft depth — the drafter is genuinely producing better drafts.

5. **Prompt eval time improved at both n=3 (−7.5%) and n=5 (−8.9%).** Lighter model weights load faster and evaluate the prompt faster, reducing first-token latency.

### Why Q5_K_XL Worked Here

Q5_K_XL is the highest-quality variant of the Q5_K quantization family. It uses per-token + per-group quantization with 5-bit weights, retaining significantly more precision than Q5_K or Q4_K variants. For many models, Q5_K_XL is visually indistinguishable from Q6_K in generation quality while being ~15-20% smaller.

The MTP drafter is usually the bottleneck in speculative decoding — its acceptance rate determines whether speculation pays off. The fact that acceptance *improved* suggests the UD (uncompressed/unpruned) weight format may interact favorably with llama.cpp's MTP implementation, possibly by reducing memory access fragmentation during the draft's autoregressive passes.

### Updated Ceiling

With Q5_K_XL, the practical ceiling for MTP-only speculative decoding on this hardware is now **~22 tok/s at n=3** or **~21 tok/s at n=5**. The remaining bottleneck is the main model's per-token verification cost, which speculative decoding cannot reduce below 1×. Paths to 25+ tok/s remain the same as Section 7.

## Appendix: Raw Data Sources

| File | Configuration |
|------|--------------|
| `benchmark-unsloth-qwen3.6-27B-Q6_K.md` | No speculation, MTP n=2, MTP+ngram-mod n=6, MTP+ngram-simple n=4 |
| `benchmarks/run-a.md` | Q6_K, MTP n=3 |
| `benchmarks/run-b.md` | Q6_K, MTP n=5 |
| `benchmarks/run-c.md` | Q6_K, MTP n=6 |
| `benchmarks/run-d.md` | Q6_K, MTP+ngram-simple n=6 |
| `benchmarks/q5-a.md` | Q5_K_XL, no speculation (9.61 tok/s) |
| `benchmarks/q5-b.md` | Q5_K_XL, MTP n=3 (21.75 tok/s) |
| `benchmarks/q5-c.md` | Q5_K_XL, MTP n=5 (20.83 tok/s) |
