# Benchmark comparison: `unsloth/qwen3.6-27B-Q6_K`

## No speculation

### Settings

```ini
[unsloth/qwen3.6-27B-Q6_K]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K
ctx-size = 50000

mmproj =
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

### Output

```text
[37557] 6.08.232.916 I slot print_timing: id  3 | task 0 | prompt eval time =    1257.57 ms /   759 tokens (    1.66 ms per token,   603.55 tokens per second)
[37557] 6.08.232.919 I slot print_timing: id  3 | task 0 |        eval time =  356233.66 ms /  3065 tokens (  116.23 ms per token,     8.60 tokens per second)
[37557] 6.08.232.919 I slot print_timing: id  3 | task 0 |       total time =  357491.23 ms /  3824 tokens
[37557] 6.08.232.920 I slot print_timing: id  3 | task 0 |    graphs reused =       3052
[37557] 6.08.232.943 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3823, truncated = 0
```

## MTP

### Settings

```ini
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

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

### Output

```text
[54447] 4.27.995.059 I slot print_timing: id  3 | task 0 | prompt eval time =    1516.93 ms /   759 tokens (    2.00 ms per token,   500.35 tokens per second)
[54447] 4.27.995.066 I slot print_timing: id  3 | task 0 |        eval time =  245099.75 ms /  4303 tokens (   56.96 ms per token,    17.56 tokens per second)
[54447] 4.27.995.067 I slot print_timing: id  3 | task 0 |       total time =  246616.68 ms /  5062 tokens
[54447] 4.27.995.068 I slot print_timing: id  3 | task 0 |    graphs reused =       1690
[54447] 4.27.995.070 I slot print_timing: id  3 | task 0 | draft acceptance = 0.76011 ( 2595 accepted /  3414 generated)
[54447] 4.27.995.102 I statistics        draft-mtp: #calls(b,g,a) =    1   1707   1707, #gen drafts =   1707, #acc drafts =  1462, #gen tokens =   3414, #acc tokens =  2595, dur(b,g,a) = 0.001, 26655.974, 0.923 ms
[54447] 4.27.995.154 I slot      release: id  3 | task 0 | stop processing: n_tokens = 5061, truncated = 0
```

## MTP + NGRAM-MOD

### Settings

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true

spec-type = draft-mtp,ngram-mod
spec-draft-n-max = 6

spec-ngram-mod-n-match = 24
spec-ngram-mod-n-min = 48
spec-ngram-mod-n-max = 64
cache-type-k = f16
cache-type-v = f16


temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

### Output

```text
[47405] 4.11.909.202 I slot print_timing: id  3 | task 0 | prompt eval time =    1703.64 ms /   759 tokens (    2.24 ms per token,   445.52 tokens per second)
[47405] 4.11.909.205 I slot print_timing: id  3 | task 0 |        eval time =  163743.06 ms /  2992 tokens (   54.73 ms per token,    18.27 tokens per second)
[47405] 4.11.909.205 I slot print_timing: id  3 | task 0 |       total time =  165446.70 ms /  3751 tokens
[47405] 4.11.909.206 I slot print_timing: id  3 | task 0 |    graphs reused =        829
[47405] 4.11.909.207 I slot print_timing: id  3 | task 0 | draft acceptance = 0.42628 ( 2151 accepted /  5046 generated)
[47405] 4.11.909.225 I statistics        ngram-mod: #calls(b,g,a) =    1    841      0, #gen drafts =      0, #acc drafts =     0, #gen tokens =      0, #acc tokens =     0, dur(b,g,a) = 0.140, 1.659, 0.000 ms
[47405] 4.11.909.227 I statistics        draft-mtp: #calls(b,g,a) =    1    841    841, #gen drafts =    841, #acc drafts =   673, #gen tokens =   5046, #acc tokens =  2151, dur(b,g,a) = 0.000, 37843.361, 0.959 ms
[47405] 4.11.909.254 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3751, truncated = 0
```

# MTP + NGRAM-Simple

### Settings

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-NGRAM
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true

##
# outcome: 18.51 tok/sec, 53% draft acceptance rate
spec-type = draft-mtp,ngram-simple
spec-draft-n-max = 4
spec-ngram-simple-size-n = 8    ; much smaller lookup
spec-ngram-simple-size-m = 16   ; shorter drafts from ngram

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

### Output

```text
[44259] 0.15.018.209 I srv  params_from_: Chat format: peg-native
[44259] 0.15.018.446 I slot get_availabl: id  3 | task -1 | selected slot by LRU, t_last = -1
[44259] 0.15.018.449 I srv  get_availabl: updating prompt cache
[44259] 0.15.018.451 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[44259] 0.15.018.454 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 50176 tokens, 8589934592 est)
[44259] 0.15.018.454 I srv  get_availabl: prompt cache update took 0.00 ms
[44259] 0.15.018.486 I slot launch_slot_: id  3 | task 0 | processing task, is_child = 0
[44259] 0.15.756.467 I slot create_check: id  3 | task 0 | created context checkpoint 1 of 32 (pos_min = 242, pos_max = 242, n_tokens = 243, size = 150.580 MiB)
[44259] 0.16.545.857 I slot create_check: id  3 | task 0 | created context checkpoint 2 of 32 (pos_min = 754, pos_max = 754, n_tokens = 755, size = 152.590 MiB)
[44259] 0.21.650.355 I slot print_timing: id  3 | task 0 | n_decoded =    103, tg =  20.74 t/s
[44259] 0.24.702.779 I slot print_timing: id  3 | task 0 | n_decoded =    178, tg =  22.20 t/s
[44259] 0.27.760.511 I slot print_timing: id  3 | task 0 | n_decoded =    259, tg =  23.38 t/s
[44259] 0.30.787.143 I slot print_timing: id  3 | task 0 | n_decoded =    332, tg =  23.54 t/s
[44259] 0.33.806.403 I slot print_timing: id  3 | task 0 | n_decoded =    398, tg =  23.24 t/s
[44259] 0.36.862.158 I slot print_timing: id  3 | task 0 | n_decoded =    442, tg =  21.90 t/s
[44259] 0.39.922.239 I slot print_timing: id  3 | task 0 | n_decoded =    492, tg =  21.17 t/s
[44259] 0.42.992.954 I slot print_timing: id  3 | task 0 | n_decoded =    540, tg =  20.53 t/s
[44259] 0.46.052.011 I slot print_timing: id  3 | task 0 | n_decoded =    595, tg =  20.26 t/s
[44259] 0.49.112.221 I slot print_timing: id  3 | task 0 | n_decoded =    655, tg =  20.20 t/s
[44259] 0.52.167.182 I slot print_timing: id  3 | task 0 | n_decoded =    705, tg =  19.87 t/s
[44259] 0.55.231.364 I slot print_timing: id  3 | task 0 | n_decoded =    756, tg =  19.61 t/s
[44259] 0.58.308.539 I slot print_timing: id  3 | task 0 | n_decoded =    816, tg =  19.60 t/s
[44259] 1.01.380.356 I slot print_timing: id  3 | task 0 | n_decoded =    871, tg =  19.49 t/s
[44259] 1.04.450.186 I slot print_timing: id  3 | task 0 | n_decoded =    929, tg =  19.45 t/s
[44259] 1.07.487.748 I slot print_timing: id  3 | task 0 | n_decoded =    991, tg =  19.51 t/s
[44259] 1.10.569.812 I slot print_timing: id  3 | task 0 | n_decoded =   1056, tg =  19.60 t/s
[44259] 1.13.650.979 I slot print_timing: id  3 | task 0 | n_decoded =   1117, tg =  19.61 t/s
[44259] 1.16.745.478 I slot print_timing: id  3 | task 0 | n_decoded =   1168, tg =  19.45 t/s
[44259] 1.19.795.105 I slot print_timing: id  3 | task 0 | n_decoded =   1224, tg =  19.39 t/s
[44259] 1.22.890.264 I slot print_timing: id  3 | task 0 | n_decoded =   1271, tg =  19.20 t/s
[44259] 1.26.004.201 I slot print_timing: id  3 | task 0 | n_decoded =   1317, tg =  19.00 t/s
[44259] 1.29.005.056 I slot print_timing: id  3 | task 0 | n_decoded =   1363, tg =  18.85 t/s
[44259] 1.32.008.517 I slot print_timing: id  3 | task 0 | n_decoded =   1410, tg =  18.72 t/s
[44259] 1.35.105.280 I slot print_timing: id  3 | task 0 | n_decoded =   1457, tg =  18.58 t/s
[44259] 1.38.260.927 I slot print_timing: id  3 | task 0 | n_decoded =   1516, tg =  18.58 t/s
[44259] 1.41.407.631 I slot print_timing: id  3 | task 0 | n_decoded =   1578, tg =  18.63 t/s
[44259] 1.44.547.798 I slot print_timing: id  3 | task 0 | n_decoded =   1632, tg =  18.57 t/s
[44259] 1.47.627.004 I slot print_timing: id  3 | task 0 | n_decoded =   1700, tg =  18.69 t/s
[44259] 1.50.637.828 I slot print_timing: id  3 | task 0 | n_decoded =   1738, tg =  18.50 t/s
[44259] 1.53.793.764 I slot print_timing: id  3 | task 0 | n_decoded =   1797, tg =  18.50 t/s
[44259] 1.56.945.046 I slot print_timing: id  3 | task 0 | n_decoded =   1855, tg =  18.50 t/s
[44259] 2.00.033.146 I slot print_timing: id  3 | task 0 | n_decoded =   1922, tg =  18.60 t/s
[44259] 2.03.095.792 I slot print_timing: id  3 | task 0 | n_decoded =   1989, tg =  18.69 t/s
[44259] 2.06.191.746 I slot print_timing: id  3 | task 0 | n_decoded =   2051, tg =  18.73 t/s
[44259] 2.09.267.114 I slot print_timing: id  3 | task 0 | n_decoded =   2108, tg =  18.72 t/s
[44259] 2.12.361.573 I slot print_timing: id  3 | task 0 | n_decoded =   2179, tg =  18.84 t/s
[44259] 2.15.384.783 I slot print_timing: id  3 | task 0 | n_decoded =   2243, tg =  18.90 t/s
[44259] 2.18.459.089 I slot print_timing: id  3 | task 0 | n_decoded =   2314, tg =  19.00 t/s
[44259] 2.21.478.767 I slot print_timing: id  3 | task 0 | n_decoded =   2372, tg =  19.01 t/s
[44259] 2.24.580.837 I slot print_timing: id  3 | task 0 | n_decoded =   2419, tg =  18.91 t/s
[44259] 2.27.672.326 I slot print_timing: id  3 | task 0 | n_decoded =   2478, tg =  18.92 t/s
[44259] 2.30.775.427 I slot print_timing: id  3 | task 0 | n_decoded =   2537, tg =  18.92 t/s
[44259] 2.33.887.011 I slot print_timing: id  3 | task 0 | n_decoded =   2587, tg =  18.86 t/s
[44259] 2.36.985.083 I slot print_timing: id  3 | task 0 | n_decoded =   2646, tg =  18.86 t/s
[44259] 2.40.086.345 I slot print_timing: id  3 | task 0 | n_decoded =   2684, tg =  18.72 t/s
[44259] 2.43.188.234 I slot print_timing: id  3 | task 0 | n_decoded =   2733, tg =  18.65 t/s
[44259] 2.46.286.270 I slot print_timing: id  3 | task 0 | n_decoded =   2779, tg =  18.58 t/s
[44259] 2.49.385.516 I slot print_timing: id  3 | task 0 | n_decoded =   2830, tg =  18.53 t/s
[44259] 2.52.486.459 I slot print_timing: id  3 | task 0 | n_decoded =   2883, tg =  18.50 t/s
[44259] 2.54.898.441 I slot print_timing: id  3 | task 0 | prompt eval time =    1665.35 ms /   759 tokens (    2.19 ms per token,   455.76 tokens per second)
[44259] 2.54.898.447 I slot print_timing: id  3 | task 0 |        eval time =  158214.49 ms /  2929 tokens (   54.02 ms per token,    18.51 tokens per second)
[44259] 2.54.898.448 I slot print_timing: id  3 | task 0 |       total time =  159879.84 ms /  3688 tokens
[44259] 2.54.898.448 I slot print_timing: id  3 | task 0 |    graphs reused =        872
[44259] 2.54.898.450 I slot print_timing: id  3 | task 0 | draft acceptance = 0.53095 ( 2024 accepted /  3812 generated)
[44259] 2.54.898.479 I statistics     ngram-simple: #calls(b,g,a) =    1    908     15, #gen drafts =     15, #acc drafts =    15, #gen tokens =    240, #acc tokens =    50, dur(b,g,a) = 0.000, 1.410, 0.004 ms
[44259] 2.54.898.481 I statistics        draft-mtp: #calls(b,g,a) =    1    893    893, #gen drafts =    893, #acc drafts =   740, #gen tokens =   3572, #acc tokens =  1974, dur(b,g,a) = 0.001, 26902.766, 0.877 ms
[44259] 2.54.898.530 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3691, truncated = 0
```
