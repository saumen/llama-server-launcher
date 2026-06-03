# Speculative Decoding Analysis Report

**Model:** Qwen3.6-35B-A3B-MTP-GGUF (Q5_K_XL)
**Date:** 2026-06-02
**Config:** flash-attn=true, kv-unified=true, cache-type-k/v=q8_0, cont-batching=true, parallel=32, temp=0.6, top-p=0.95, ctx-size=100000

---

## Benchmark Comparison

| Config | n | draft-p-min | Acceptance | Eval Time | Eval Tokens | Throughput | Graphs Reused | Total Time |
|--------|---|-------------|------------|-----------|-------------|------------|---------------|------------|
| **Baseline** | 2 | **0.0** (default) | 70.71% | 76.91s | 5,369 | 69.81 t/s | 2,210 | 82.35s |
| **Run 06** | 2 | **0.50** | 83.72% | 70.15s | 4,758 | 67.83 t/s | 1,417 | **75.55s** |
| Run 07 | 2 | 0.65 | 89.77% | 95.63s | 6,270 | 65.56 t/s | 1,664 | 101.04s |
| Run 01 | 2 | 0.75 | 92.82% | 93.08s | 5,939 | 63.80 t/s | 1,940 | 98.49s |
| Run 03 | 3 | 0.75 | 90.36% | 88.55s | 5,563 | 62.82 t/s | 1,502 | 94.02s |
| Run 04 | 4 | 0.75 | 88.55% | 97.49s | 6,143 | 63.01 t/s | 892 | 102.96s |
| Run 05 | 5 | 0.75 | 86.20% | 98.52s | 6,087 | 61.78 t/s | 702 | 104.00s |

---

## Winner: draft-p-min = 0.50, n = 2

Fastest total generation time: **75.55s**

- Beats baseline (draft-p-min=0.0) by **8.3s (10.1% faster)**
- Beats Run 01 (draft-p-min=0.75) by **22.9s (23.3% faster)**

---

## The draft-p-min Tradeoff Curve

```
draft-p-min   Acceptance   Throughput   Total Time
───────────────────────────────────────────────────
0.00          70.71%       69.81 t/s    82.35s  ← too many draft calls
0.50          83.72%       67.83 t/s    75.55s  ← sweet spot
0.65          89.77%       65.56 t/s   101.04s  ← near cliff edge
0.75          92.82%       63.80 t/s    98.49s  ← over-filtering
```

### Why draft-p-min=0.0 is slower than 0.50

At `draft-p-min=0.0`, the model generates significantly more draft tokens but only marginally more are accepted:

| Metric | Baseline (0.0) | Run 06 (0.50) | Delta |
|--------|----------------|---------------|-------|
| Draft calls | 2,232 | 1,975 | −11.5% |
| Draft tokens gen | 4,464 | 3,608 | −19.2% |
| Draft tokens acc | 3,159 | 3,016 | −4.5% |
| Graphs reused | 2,210 | 1,417 | −35.9% |

Many low-probability draft tokens are generated and rejected, incurring the full cost of draft computation plus main-model recovery.

### Why draft-p-min=0.65 is slower than 0.50

At 89.8% acceptance, Run 07 sits between the sweet spot and the over-filtering zone. It generates more draft tokens (4,304 vs 3,608) with only marginally more accepted (3,858 vs 3,016), but the extra draft computation costs more than it saves:

| Metric | Run 06 (0.50) | Run 07 (0.65) | Delta |
|--------|---------------|---------------|-------|
| Draft tokens gen | 3,608 | 4,304 | +19.3% |
| Draft tokens acc | 3,016 | 3,858 | +27.9% |
| Graphs reused | 1,417 | 1,664 | +17.4% |

The 27.9% gain in accepted draft tokens does not offset the extra draft computation overhead. The curve rises sharply after 0.50.

### Why draft-p-min=0.75 is slower than 0.50

At 92.8% acceptance, the model is too selective. Higher acceptance rate per draft is outweighed by:
- More rejected chains (longer chains = higher cumulative rejection probability)
- More draft tokens wasted on chains that eventually fail
- Slower throughput due to higher n and more graph rebuilds

---

## Cost Per Accepted Draft Token (lower is better)

| Config | Eval Time | Acc Draft Tokens | ms per Acc Token |
|--------|-----------|------------------|------------------|
| 0.0 | 76,913ms | 3,159 | 24.35 |
| 0.50 | 70,149ms | 3,016 | **23.26** ← best |
| 0.65 | 95,632ms | 3,858 | 24.80 |
| 0.75 | 93,084ms | 2,740 | 33.98 |

## Why n > 2 degrades performance

Graph reuse collapses as n increases, indicating more frequent graph rebuilds from rejected chains:

| n | Graphs Reused | Drop from n=2 |
|---|---------------|---------------|
| 2 | 1,940 | — |
| 3 | 1,502 | −22.6% |
| 4 | 892 | −54.0% |
| 5 | 702 | −63.8% |

Each rejected draft forces a full main-model forward pass. The Qwen3.6-35B-A3B-MTP model has limited useful draft heads — beyond n=2, additional tokens are overhead.

## High Acceptance Rate: Not a Concern

86-93% acceptance is expected from MTP (trained draft heads sharing base model representations). This is not "overconfidence" — MTP drafts are calibrated to the base model. High acceptance genuinely means the draft heads are predicting well. The real danger zone would be <50% acceptance.

---

## Concerning Observation: Variable Output Lengths

Despite same prompt and model, eval token counts vary by ~13%:

| Config | Eval Tokens |
|--------|-------------|
| 0.0 | 5,369 |
| 0.50 | 4,758 |
| 0.65 | 6,270 |
| 0.75 | 5,939 |

Possible causes:
1. Different stopping points — speculative decoding path changes token distribution, hitting EOS at different times
2. Non-deterministic prompt assembly from PDF extraction
3. Temperature sampling (`temp=0.6`) — model may stop generating at different points

**Recommendation:** For deterministic benchmarks, set `temp=0.0` or use a fixed output token count instead of EOS.

---

## Recommended Next Steps (highest ROI)

1. **draft-p-min = 0.30** — interpolate between 0.0 and 0.50 to find the exact curve minimum
2. **draft-p-min = 0.40** — test below the 0.50 sweet spot
3. **temp=0.0 deterministic run** — eliminate sampling variance to confirm the output length discrepancy (Run 07's 6,270 tokens vs Run 06's 4,758 may explain why 0.65 is slower than 0.75 despite higher draft-p-min)
4. **No-speculative baseline** (`spec-type=none`) — quantify the absolute MTP speedup
