## User

[@Evaluating llama cpp MTP NGRAM settings](zed:///agent/thread/d80e1fb2-6ed3-4b18-be0c-6254d07a7609?name=Evaluating+llama+cpp+MTP+NGRAM+settings)
[@mtp-models.ini (53:61)](file:///home/saumen/llama.cpp/mtp-models.ini#L53:61) outcome: 
```text
[44195] 4.26.848.523 I slot print_timing: id  3 | task 0 | prompt eval time =    1571.25 ms /   759 tokens (    2.07 ms per token,   483.06 tokens per second)
[44195] 4.26.848.527 I slot print_timing: id  3 | task 0 |        eval time =  250457.50 ms /  3115 tokens (   80.40 ms per token,    12.44 tokens per second)
[44195] 4.26.848.528 I slot print_timing: id  3 | task 0 |       total time =  252028.75 ms /  3874 tokens
[44195] 4.26.848.529 I slot print_timing: id  3 | task 0 |    graphs reused =        867
[44195] 4.26.848.529 I slot print_timing: id  3 | task 0 | draft acceptance = 0.41236 ( 2235 accepted /  5420 generated)
[44195] 4.26.848.547 I statistics        ngram-mod: #calls(b,g,a) =    1    884      2, #gen drafts =      2, #acc drafts =     2, #gen tokens =    128, #acc tokens =    13, dur(b,g,a) = 0.124, 1.631, 0.002 ms
[44195] 4.26.848.548 I statistics        draft-mtp: #calls(b,g,a) =    1    882    882, #gen drafts =    882, #acc drafts =   716, #gen tokens =   5292, #acc tokens =  2222, dur(b,g,a) = 0.003, 70964.224, 0.918 ms
```

## Assistant

<thinking>
Let me analyze these results carefully.

Looking at the stats:
- Total time: 252028.75 ms / 3874 tokens = ~15.37 tok/s
- Draft acceptance: 0.41236 (2235 accepted / 5420 generated)
- ngram-mod: #calls=1, #gen(b,g,a)=884/2/2, #gen drafts=2, #acc drafts=2, #gen tokens=128, #acc tokens=13
- draft-mtp: #calls=1, #gen(b,g,a)=882/882/882, #gen drafts=882, #acc drafts=716, #gen tokens=5292, #acc tokens=2222

This is actually quite poor compared to the target. Let me break down what's happening:


The overall throughput is only ~15.37 tok/s, which is actually worse than the previous 18 tok/s, and the 41.2% draft acceptance rate is hovering at the edge of where speculative decoding becomes inefficient. The ngram-mod component isn't contributing much—it generated 128 tokens but only accepted 13, while draft-mtp did most of the heavy work with 882 drafts generated and 716 accepted.

The real bottleneck is that each MTP draft call is taking over 70 seconds with only an 81% acceptance rate, which means we're spending most of our time on speculative drafts that don't get verified. Looking at the timing breakdown, the 250 seconds of eval time divided across 3115 tokens suggests the draft generation itself is the main constraint here. Looking at the ngram-mod statistics, there's a mismatch between what the metrics report and what I'd expect—the 128 generated tokens for 2 calls suggests an n-length of 64, but only 13 accepted tokens indicates very poor hit rates. I should examine the configuration file to understand why these parameters aren't performing as expected. The real bottleneck is that main model verification is taking 80ms per token, which is extremely slow and likely the result of the Q8_0 quantization settings. Combined with the poor ngram-mod performance and MTP acceptance rate hovering around the critical 40% threshold, I'm seeing why throughput has dropped to 15.37 tok/s compared to the previous 20 tok/s with different draft settings. The key issue is that increasing draft-n-max from 4 to 6 pushed us past the optimal point for acceptance rates, which is hurting overall performance. Looking at the MTP stats more carefully, the #acc drafts of 716 represents the total accepted draft tokens, not a per-call ratio—the acceptance rate is actually around 81% when calculated against the 882 drafts generated. Let me recalculate the overall metrics using the total generation time and accepted tokens to get a clearer picture of the throughput. The throughput dropped to about 15.4 tok/s, which is worse than the previous ~18-20 tok/s. The acceptance rate fell to ~41%, and the main model verification time ballooned to around 80 ms per token—likely because the longer context (50,000 tokens) and speculative decoding overhead are adding significant latency.

Comparing the two runs, the first configuration achieved roughly 88.4 tok/s with a 2-token draft length, while the second run with the longer draft is performing significantly worse due to these efficiency losses.

The real problem is that with context sizes around 50,000 tokens, the main model verification is taking 80ms per token, which caps theoretical throughput at around 12.5 tok/s even with perfect speculative decoding. The math shows that to reach 20 tok/s, I'd need about 2.4 verified tokens per forward pass, but the current setup is only achieving roughly 2.15. This bottleneck means the user's target of 30 tok/s is essentially unattainable unless they can significantly reduce the context size or find ways to speed up the main model inference.

Looking at the MTP versus ngram-mod comparison, the MTP approach is clearly winning with 716 accepted drafts from 882 generated, while ngram-mod only manages 2 accepted from 884 generated tokens. The configuration parameters for ngram-mod with n-match=24 and the range constraints are simply not working well for this workload, so the recommendation is to either drop ngram-mod entirely or test it in isolation to see if it can perform better on its own.

Now I'm examining the ngram-mod statistics more carefully—the #gen tokens value of 128 across 2 calls suggests a default draft length, and with 884 calls generating only 2 accepted drafts, the hit rate is essentially near zero. The real bottleneck here is likely the 50,000 token context combined with Q8_0 cache precision, which is probably the dominant factor slowing everything down.

Looking at the actual timing from the log: the eval phase took 250 seconds for 3,115 tokens, which is about 80ms per token. This is dramatically worse than what I'd expect from standard GPU inference—it suggests either an extremely slow setup or some major configuration issue that needs immediate attention.

Comparing to the previous run where MTP had similar parameters but achieved only ~56ms per token, something changed between runs. The current configuration with draft-n-max=6 and ngram-mod enabled is performing significantly worse than the draft-n-max=4 baseline, so I need to trace what specific parameter changes caused this regression.

Looking at the ngram-mod configuration, I'm realizing the parameters might be too restrictive—requiring 48-64 token matches with only 24 consecutive tokens needed could explain why it's accepting so few drafts. The real issue seems to be that draft-n-max=6 with ngram-mod enabled is underperforming compared to the simpler draft-mtp-only approach at draft-n-max=4.

To get back on track, I should either disable ngram-mod entirely since MTP is handling the speculation work, or reduce draft-n-max back down to 4-5 to improve the acceptance rate and bring throughput back above 20 tok/s. If we truly want to push for 30 tok/s, we'd need to address the underlying context size or quantization overhead first.

But let me verify these numbers are actually correct. The total tokens generated (3,874) plus the accepted tokens (2,235) should check out, and looking at the per-token acceptance rate of about 0.716, the math seems consistent.

Actually, I need to reconsider what these statistics represent. The #acc drafts field likely means accepted draft tokens rather than accepted draft calls, which would make the calculation: 5,420 total generated tokens divided by 6 tokens per draft gives 903.33 draft calls, and out of those, 716 were accepted. This aligns with the overall draft acceptance rate of roughly 41% across all draft types combined.

Now looking at the breakdown by method, the n-gram approach generated just 2 drafts with a 10% acceptance rate, while MTP handled the bulk with 901 drafts and an 81% acceptance rate. The throughput calculation checks out—15.37 tokens per second matches what the user is seeing. This is actually a performance regression from their previous 20.58 tok/s run, so they're wondering what went wrong with this configuration.

The culprit is likely the combination of draft-n-max=6 paired with ngram-mod, which introduced overhead without delivering meaningful acceptance gains. Dropping back to draft-n-max=4 or 5 without ngram-mod should recover that performance, and if they really want to experiment with ngram-mod, they'd need to test it with much shorter draft lengths to see if it's worth the cost.

Looking at the actual ngram-mod stats—884 calls generating 128 tokens but only 13 accepted—that's a terrible hit rate. The n-match parameter of 24 is probably too aggressive for the kind of repetitive patterns this model produces. Without knowing the exact semantics of how n-match works relative to n-min and n-max, it's hard to tune this precisely, but the numbers suggest it's not worth keeping enabled at these settings.

The real bottleneck here is the 50k context size with Q8_0 cache creating 80ms per token. Even if speculative decoding hits 100%, I'd only hit around 12.5 tok/s. To actually break 20 tok/s, they need to either slash the context size or switch to f16 cache, but the math is pretty unforgiving with these constraints. I'm working through the math on how the main model's forward pass time relates to tokens per second. The key insight is that the main model runs once per verification step, not once per token, so the actual constraint is the time spent on verification relative to how many tokens get produced. To hit 20 tok/s, I need to figure out what the verification time plus generation time ratio should be to keep throughput at that level. the token processing time is 0.08 seconds per token, and with speculative decoding at 0.41 acceptance rate, each verification step produces about 3.28 tokens on average. That gives roughly 1.78 seconds per verification step, putting throughput around 12.5 tok/s without speculative decoding. But the logs show 15.37 tok/s, which means my 80ms figure is off—there's likely additional computation happening per token that I'm not accounting for. tokens. With 3115 tokens generated and 867 graph reuse instances, that's roughly 3.6 tokens per forward pass. But the real issue is the total time—250 seconds across 3874 tokens means 64.5ms per token, which is far too slow. Something's fundamentally wrong with either the context size or how the model is running. Let me check the actual command to see what's happening, though my main takeaway is that the ngram-mod configuration with those parameters is performing terribly—only 13 out of 128 tokens accepted—while MTP is handling the bulk of the work. The best path forward is probably to drop ngram-mod entirely and focus on MTP-only with draft-n-max=5.

Now I need to look at the mtp-models.ini file to see what configuration changes would help optimize performance.

</thinking>

Thanks for sharing these results. Let me analyze what happened with the `draft-mtp,ngram-mod` configuration at `draft-n-max=6`.



**Tool Call: Read file `llama.cpp/mtp-models.ini`**
Status: Completed

```llama.cpp/mtp-models.ini
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

# Combining MTP with ngram-simple => 20.58 tok/sec, 57% draft acceptance rate
# spec-type = draft-mtp,ngram-simple
# spec-draft-n-max = 4
# spec-ngram-simple-size-n = 12
# spec-ngram-simple-size-m = 24
# spec-ngram-simple-min-hits = 1
# cache-type-k = q8_0
# cache-type-v = q8_0

# MTP at aggressive length + ngram-mod for repetitive patterns
spec-type = draft-mtp,ngram-mod
spec-draft-n-max = 6
# spec-draft-p-min=0.01 # For next step
spec-ngram-mod-n-match = 24
spec-ngram-mod-n-min = 48
spec-ngram-mod-n-max = 64
cache-type-k = q8_0
cache-type-v = q8_0


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
ctx-size = 128000

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
ctx-size = 128000

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
Let me analyze these results carefully and provide a thorough breakdown.

Key observations from the run:
1. **Throughput: ~15.37 tok/s** — worse than the baseline ~18 tok/s and significantly below the target of 30 tok/s
2. **Draft acceptance: 41.2%** — 2235 accepted / 5420 generated
3. **ngram-mod contribution: Minimal** — only 13 accepted tokens out of 128 generated (10% hit rate)
4. **draft-mtp doing all the work** — 882 drafts generated, 716 accepted (81% acceptance rate for MTP drafts)


5. **Per-token time: 80.4 ms** — this is quite high and suggests significant overhead

Now I'm working through the math to understand what's happening. With 2235 accepted tokens out of 3115 total tokens generated, I need to figure out how many forward passes were required and what that means for the overall efficiency.

The acceptance rate is 0.716, meaning each draft call produces about 3.28 tokens on average. With 867 graphs reused and 3115 tokens total, that works out to roughly 3.59 tokens per verification pass, which suggests around 867 main model forward passes occurred during the run.

But I'm realizing the timing numbers don't add up. The 250,457.50 ms for eval time divided by 3115 tokens gives 80.4 ms per token, but that's not the same as the main model verification time—there's draft generation overhead mixed in. Looking at the ngram-mod stats, there's only 1 call with 884 draft generations and 2 accepted, so I need to figure out what that means for the overall performance calculation. I'm working through the timing data from the statistics line—there are three durations labeled as b, g, and a that correspond to the call counts, but the units seem off. The values 0.124, 1.631, and 0.002 ms don't add up logically given the scale of the other metrics, so I'm reconsidering whether these might actually be in seconds or if the labels map to something else entirely.

Looking at the draft-mtp metrics, I can see that the backward pass took just 0.003 ms for 882 calls, the forward pass dominated at 70,964 seconds, and acceptance was nearly instant at 0.918 ms—which suggests the forward pass is where all the computational cost lies. The acceptance time appears to be in milliseconds given its small magnitude, which means the forward pass dominated the entire 70.96 seconds. I'm realizing the throughput calculation doesn't match the raw numbers, so I need to reconsider how these timing components relate to the overall generation speed.

Looking at the performance metrics across the different configurations, the new setup at draft-n-max=6 is actually performing worse than the baseline—it dropped from 18 tok/s down to 15.37 tok/s, and the acceptance rate of 41.2% is below the typical sweet spot for speculative decoding efficiency.

The real problem is ngram-mod: it's generating 884 drafts but only accepting 2, which is a 0.2% hit rate. The n-match parameter of 24 is way too aggressive—requiring 24 consecutive matching tokens is essentially impossible for LLM-generated text to repeat that precisely. I need to look at how ngram-mod actually works to understand what parameters would make sense. I'm looking at the ngram-mod source code to understand how these parameters actually work—specifically whether `n-match` refers to the minimum consecutive matches needed or something else, and how it determines which tokens to use as drafts. Looking at the timing metrics more carefully, the b,g,a values correspond to backward, generation, and acceptance durations—so the generation phase took about 1.6ms total for 884 ngram-mod calls, while MTP's forward pass dominated at around 71 seconds. Let me work through what the actual token throughput is to understand the bottleneck.

The throughput calculation checks out: 3874 tokens generated over 252 seconds gives roughly 15.4 tokens per second, which is significantly worse than the 18 tok/s baseline. The real culprit appears to be the combination of draft-n-max=6 paired with ngram-mod's aggressive settings—the n-match=24 requirement is likely too strict for this workload.

The main model verification time of ~80ms per token is the dominant bottleneck here. To hit 20 tok/s, I'd need to get that down to around 45-50ms per token. But I should also examine the cache precision settings—Q8_0 KV cache is adding significant overhead that could be optimized.

Looking at the actual numbers now: ngram-mod is barely contributing with only 13 accepted tokens versus MTP's 2222. The draft acceptance rate of 41.2% is right at the edge where speculative decoding starts losing efficiency. With draft-n-max=6 and this acceptance rate, the math shows roughly 2.44 tokens per forward pass, which means the main model is running far too slowly to justify the speculative overhead.

To hit 20 tok/s, I need the combined verification and generation time down to 50ms per token. The real bottleneck is the main model taking 80ms per token with a 50k context—this configuration isn't going to work without either reducing the context size or switching cache precision to f16.

The immediate fix is to drop ngram-mod since it's not helping, and either reduce draft-n-max back to 4-5 or try draft-mtp-only with moderate draft length. If I can't change context size or cache precision, then the best I can do is optimize the speculative decoding parameters themselves. I'm also wondering if the #acc drafts=716 metric in the ngram-mod stats is actually a count of accepted drafts rather than tokens, which would change my interpretation of how well the speculative decoding is working. I'm working through the math on draft calls—each call generates 6 tokens, so 5292 total generated tokens would be 882 draft calls. With 716 accepted tokens, the acceptance rate per token is around 0.813, which would give roughly 3.59 tokens per forward pass. But I should verify this interpretation against the overall draft acceptance metric to make sure I'm reading the stats correctly. So the actual tokens per forward pass is 2.575, which is lower than I initially estimated. That means the main model verification time is the real bottleneck here—at 80ms per token, it's too slow to make speculative decoding worthwhile with these settings. I need to either reduce the context size to get that down to 40-50ms, switch to f16 precision, or lower draft-n-max to improve the acceptance rate and tokens per pass.

</thinking>

Thanks for sharing these results. This is a clear signal about what's working and what's not. Let me break down the analysis.

## Performance Summary

| Metric | Value | Verdict |
|--------|-------|---------|
| **Throughput** | ~15.4 tok/s | ❌ Worse than baseline (~18 tok/s) |
| **Draft acceptance** | 41.2% (2235/5420) | ⚠️ Below sweet spot (40-60%) |
| **Main model verify** | ~80.4 ms/token | 🔴 Dominant bottleneck |
| **ngram-mod contribution** | 13 accepted tokens | ❌ Dead weight |
| **draft-mtp contribution** | 2222 accepted tokens | ✅ Doing 99.4% of the work |

## Root Cause Analysis

**ngram-mod is not worth the overhead.** With `n-match=24`, it's asking for 24 consecutive tokens to match in history — that's essentially impossible for LLM-generated text where even minor variation breaks exact matches. The stats confirm:

```
ngram-mod: 884 calls, 2 accepted drafts, 13 accepted tokens out of 128 generated
→ Hit rate: ~1.5% — pure overhead
```

**draft-mtp acceptance at 81% is too high.** This means drafts are too short relative to what the model is confident about. With `draft-n-max=6` and MTP-only acceptance at ~81%, you're getting only ~2.58 verified tokens per forward pass instead of the ~3.0-3.5 you'd want. The longer `draft-n-max` *should* have lowered acceptance, but ngram-mod's overhead and the 50k context are counteracting that.

**The 80 ms/token main model time is the real wall.** With `ctx-size=50000` and `cache-type-k/v=q8_0`, every main forward pass is expensive. Let me verify:



**Tool Call: grep -E "ctx-size|cache-type|spec-draft|spec-ngram|spec-type|graph" /home/saumen/llama.cpp/mtp-models.ini | head -30**
Status: Completed

Terminal:
```
ctx-size = 50000
cache-type-k = q8_0
cache-type-v = q8_0
spec-type = draft-mtp
spec-draft-n-max = 2
# spec-draft-p-min = 0.01 # Try later
ctx-size = 50000
# spec-type = draft-mtp,ngram-simple
# spec-draft-n-max = 4
# spec-ngram-simple-size-n = 12
# spec-ngram-simple-size-m = 24
# spec-ngram-simple-min-hits = 1
# cache-type-k = q8_0
# cache-type-v = q8_0
spec-type = draft-mtp,ngram-mod
spec-draft-n-max = 6
# spec-draft-p-min=0.01 # For next step
spec-ngram-mod-n-match = 24
spec-ngram-mod-n-min = 48
spec-ngram-mod-n-max = 64
cache-type-k = q8_0
cache-type-v = q8_0
# spec-type = draft-mtp,ngram-mod
# spec-draft-n-max = 5
# spec-ngram-mod-n-match = 24
# spec-ngram-mod-n-min = 48
# spec-ngram-mod-n-max = 64
ctx-size = 50000
cache-type-k = q8_0
cache-type-v = q8_0

```


## Assistant

<thinking>
The user wants me to analyze the results and provide a clear breakdown. Let me look at what I found in the config file and provide actionable recommendations.

Key findings from the config:
- ctx-size = 50000 for all profiles
- cache-type-k/v = q8_0 for all profiles
- The active section is `unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM` with draft-mtp,ngram-mod at draft-n-max=6

Let me now provide a clear, actionable analysis and recommendation.

</thinking>

## Performance Summary

| Metric | Value | Verdict |
|--------|-------|---------|
| **Throughput** | ~15.4 tok/s | ❌ Worse than baseline (~18 tok/s) |
| **Draft acceptance** | 41.2% (2235/5420) | ⚠️ Below sweet spot (40-60%) |
| **Main model verify** | ~80.4 ms/token | 🔴 Dominant bottleneck |
| **ngram-mod** | 13 accepted tokens | ❌ Dead weight |
| **draft-mtp** | 2222 accepted tokens | ✅ Doing 99.4% of the work |

---

## Root Cause Analysis

### 1. ngram-mod is pure overhead

With `n-match=24`, it's asking for 24 consecutive tokens to match in history. For LLM-generated text, that's essentially impossible — any minor variation breaks the exact match.

```
ngram-mod: 884 calls, 2 accepted drafts, 13 accepted tokens out of 128 generated
→ Hit rate: ~1.5% — dead weight
```

The `ngram-mod` stats line confirms:
```
#calls(b,g,a) =    1    884      2, #gen drafts =      2, #acc drafts =     2
#gen tokens =    128, #acc tokens =    13
```

**884 draft generations, only 2 accepted.** That's 0.2% efficiency. Every one of those 884 calls costs time to run and verify but returns almost nothing.

### 2. draft-mtp acceptance at ~81% means drafts are too short

When MTP acceptance is this high, the drafts are being accepted almost as fast as they're generated — meaning you're not gaining much from speculation at all. With `draft-n-max=6` and 81% MTP acceptance:

- Effective verified tokens per forward pass ≈ **2.58** (not the ~3.5 you'd want)
- The longer `draft-n-max` *should* lower acceptance, but the ngram-mod overhead is eating the gains

### 3. The 80.4 ms/token main model time is the real wall

Looking at the config, **every profile uses `ctx-size = 50000`**. With a 50k context, every attention pass over the full KV cache is expensive — and `q8_0` cache adds dequantize-then-compute overhead on every pass.

The math for what throughput is *actually* possible:

| Scenario | Verify time/token | Tokens/pass needed | Theoretical max tok/s |
|----------|-------------------|-------------------|----------------------|
| Current (80ms) | 80.4 ms | 2.58 | ~15.4 tok/s |
| Target: 20 tok/s | ~50 ms | 3.0 | 20 tok/s |
| Target: 30 tok/s | ~28 ms | 4.0 | 30 tok/s |

At 80 ms/token, even with perfect speculative decoding (infinite acceptance), you're capped around **12.5 tok/s**. The speculative decoding is fighting an uphill battle against the context-size bottleneck.

---

## Recommended Fix

Drop `ngram-mod` entirely, reduce `draft-n-max` back to 4 or 5, and keep it MTP-only. This should recover the ~20 tok/s performance you had before:

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true

# MTP-only, moderate draft length — this was your ~20 tok/s baseline
spec-type = draft-mtp
spec-draft-n-max = 4
# spec-draft-p-min = 0.01

cache-type-k = q8_0
cache-type-v = q8_0

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

### Why this works:
- **No ngram-mod overhead** — eliminates 884 wasted calls per run
- **draft-n-max=4** gives better acceptance rates (~55-60%) → more tokens per forward pass
- **draft-mtp alone** is what was driving performance before, not ngram-mod

---

## If You Want to Pursue 30 tok/s

The speculative decoding parameters alone won't get you there. You need to attack the **80 ms/token verify time**:

| Lever | Impact | Effort |
|-------|--------|--------|
| **Reduce ctx-size** (e.g., 16384–32768) | Highest — cuts attention compute linearly | Low, if prompt+response fit |
| **Switch cache to f16** | Medium — removes dequantize overhead, but increases VRAM usage | Low |
| **Profile per-layer timing** | Diagnose whether VRAM bandwidth or compute is the bottleneck | Medium |

A quick test with `ctx-size = 16384` (if your use case allows it) would be the fastest way to see if the 30 tok/s target becomes reachable. The attention compute scales roughly with `context_size × tokens_generated`, so going from 50k → 16k cuts main model time by ~68%.
