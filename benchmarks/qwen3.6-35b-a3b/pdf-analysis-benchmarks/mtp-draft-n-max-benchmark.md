# MTP `spec-draft-n-max` Benchmark

**Model:** Qwen3.6-35B-A3B (Q5_K_XL, MTP heads enabled)
**Config:** `flash-attn=true`, `kv-unified=true`, `cache-type-k/v=q8_0`, `parallel=32`, `cont-batching=true`
**Workload:** Fidelity Monthly statement (PDF) analysis (repeated prompts with long context ~10K tokens).

## Other flags (constant across all test cases)

```ini
model = unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf

mmproj =
flash-attn = true
kv-unified = true

cache-type-k = q8_0
cache-type-v = q8_0

cont-batching = true
parallel = 32
ctx-size = 100000

spec-type = draft-mtp

temp = 0.6
top-p = 0.95
p-min = 0.0 # default in the used GGUF.
```

## Results

| `spec-draft-n-max` | tok/s | Acceptance Rate | Tokens/Forward-Pass |
|---:|---:|---:|---:|
| **2** | **69.8** | **70.7%** | **2.22** |
| **3** | 69.6 | 63.1% | 2.35 |
| 5 | 62.8 | 51.1% | 2.03 |
| 4 | 56.8 | 42.5% | 2.04 |

## Analysis

**n-max=2 is the optimal setting.** Throughput peaks here with the highest acceptance rate.

As draft length increases, the acceptance rate drops sharply:

- **n-max=2 → 3**: Acceptance drops 70.7% → 63.1%, but tokens/forward-pass increases 2.22 → 2.35. Net throughput is flat (~69.8 vs ~69.6 tok/s). The marginal gain from extra drafts is offset by the lower acceptance.
- **n-max=3 → 5**: Acceptance crashes to 51.1%, and tokens/forward-pass *decreases* to 2.03. More drafts are being generated, but more are being rejected, so the main model still has to regenerate most tokens. Throughput drops to 62.8 tok/s.
- **n-max=4 → 5**: Acceptance drops to 42.5%, throughput bottoms out at 56.8 tok/s. The overhead of generating 4 drafts per step — most of which get discarded — is pure wasted compute.

## Why shorter drafts win here

The Qwen3.6-35B-A3B MTP heads are good at predicting the *next* token (70% acceptance), but their confidence degrades quickly for tokens 3+ steps ahead. Each rejected draft token costs a full main-model forward pass, so the effective speedup is:

```
effective_tokens_per_pass = accepted_drafts + 1 (main token)
speedup = effective_tokens_per_pass / (1 + rejected_drafts * overhead)
```

When acceptance drops below ~50%, the rejected draft overhead outweighs any parallelism benefit.

## Conclusion

**Recommended config:**

```ini
[unsloth/qwen3.6-35B-A3B]
spec-type = draft-mtp
spec-draft-n-max = 2
```

This gives **~70 tok/s** — a ~2x improvement over raw generation (~50-60 tok/s without MTP). Pushing `spec-draft-n-max` higher hurts performance.

## Raw Data

- `draft-n-max-2.md` — n-max=2 run
- `draft-n-max-3.md` — n-max=3 run
- `draft-n-max-4.md` — n-max=4 run
- `draft-n-max-5.md` — n-max=5 run
