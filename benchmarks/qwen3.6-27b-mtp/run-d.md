# Run A

## Settings

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-D]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-D
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

spec-type = draft-mtp,ngram-simple
spec-draft-n-max = 6
spec-ngram-simple-size-n = 8
spec-ngram-simple-size-m = 16

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

## Outcome

```text
[36491] 0.15.407.611 I srv  params_from_: Chat format: peg-native
[36491] 0.15.407.759 I slot get_availabl: id  3 | task -1 | selected slot by LRU, t_last = -1
[36491] 0.15.407.761 I srv  get_availabl: updating prompt cache
[36491] 0.15.407.763 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[36491] 0.15.407.766 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 50176 tokens, 8589934592 est)
[36491] 0.15.407.767 I srv  get_availabl: prompt cache update took 0.01 ms
[36491] 0.15.407.794 I slot launch_slot_: id  3 | task 0 | processing task, is_child = 0
[36491] 0.16.011.645 I slot create_check: id  3 | task 0 | created context checkpoint 1 of 32 (pos_min = 242, pos_max = 242, n_tokens = 243, size = 150.135 MiB)
[36491] 0.16.809.561 I slot create_check: id  3 | task 0 | created context checkpoint 2 of 32 (pos_min = 754, pos_max = 754, n_tokens = 755, size = 151.207 MiB)
[36491] 0.22.219.439 I slot print_timing: id  3 | task 0 | n_decoded =    101, tg =  19.18 t/s
[36491] 0.25.295.209 I slot print_timing: id  3 | task 0 | n_decoded =    146, tg =  17.50 t/s
[36491] 0.28.399.148 I slot print_timing: id  3 | task 0 | n_decoded =    214, tg =  18.70 t/s
[36491] 0.31.495.789 I slot print_timing: id  3 | task 0 | n_decoded =    259, tg =  17.81 t/s
[36491] 0.34.618.152 I slot print_timing: id  3 | task 0 | n_decoded =    314, tg =  17.77 t/s
[36491] 0.37.671.644 I slot print_timing: id  3 | task 0 | n_decoded =    394, tg =  19.02 t/s
[36491] 0.40.728.758 I slot print_timing: id  3 | task 0 | n_decoded =    457, tg =  19.22 t/s
[36491] 0.43.767.841 I slot print_timing: id  3 | task 0 | n_decoded =    537, tg =  20.03 t/s
[36491] 0.46.897.309 I slot print_timing: id  3 | task 0 | n_decoded =    593, tg =  19.80 t/s
[36491] 0.50.026.196 I slot print_timing: id  3 | task 0 | n_decoded =    648, tg =  19.59 t/s
[36491] 0.53.145.566 I slot print_timing: id  3 | task 0 | n_decoded =    702, tg =  19.40 t/s
[36491] 0.56.263.141 I slot print_timing: id  3 | task 0 | n_decoded =    762, tg =  19.38 t/s
[36491] 0.59.396.463 I slot print_timing: id  3 | task 0 | n_decoded =    808, tg =  19.04 t/s
[36491] 1.02.473.069 I slot print_timing: id  3 | task 0 | n_decoded =    866, tg =  19.02 t/s
[36491] 1.05.535.572 I slot print_timing: id  3 | task 0 | n_decoded =    923, tg =  19.00 t/s
[36491] 1.08.789.432 I slot print_timing: id  3 | task 0 | n_decoded =    977, tg =  18.85 t/s
[36491] 1.11.922.855 I slot print_timing: id  3 | task 0 | n_decoded =   1027, tg =  18.68 t/s
[36491] 1.15.065.772 I slot print_timing: id  3 | task 0 | n_decoded =   1077, tg =  18.53 t/s
[36491] 1.18.191.806 I slot print_timing: id  3 | task 0 | n_decoded =   1136, tg =  18.55 t/s
[36491] 1.21.323.852 I slot print_timing: id  3 | task 0 | n_decoded =   1184, tg =  18.39 t/s
[36491] 1.24.455.368 I slot print_timing: id  3 | task 0 | n_decoded =   1233, tg =  18.27 t/s
[36491] 1.27.576.330 I slot print_timing: id  3 | task 0 | n_decoded =   1269, tg =  17.97 t/s
[36491] 1.30.712.015 I slot print_timing: id  3 | task 0 | n_decoded =   1328, tg =  18.00 t/s
[36491] 1.33.838.384 I slot print_timing: id  3 | task 0 | n_decoded =   1367, tg =  17.78 t/s
[36491] 1.36.967.280 I slot print_timing: id  3 | task 0 | n_decoded =   1415, tg =  17.68 t/s
[36491] 1.40.101.200 I slot print_timing: id  3 | task 0 | n_decoded =   1466, tg =  17.63 t/s
[36491] 1.43.177.805 I slot print_timing: id  3 | task 0 | n_decoded =   1544, tg =  17.91 t/s
[36491] 1.46.323.720 I slot print_timing: id  3 | task 0 | n_decoded =   1605, tg =  17.96 t/s
[36491] 1.49.456.920 I slot print_timing: id  3 | task 0 | n_decoded =   1672, tg =  18.07 t/s
[36491] 1.52.590.355 I slot print_timing: id  3 | task 0 | n_decoded =   1723, tg =  18.02 t/s
[36491] 1.55.657.121 I slot print_timing: id  3 | task 0 | n_decoded =   1788, tg =  18.11 t/s
[36491] 1.58.810.885 I slot print_timing: id  3 | task 0 | n_decoded =   1854, tg =  18.20 t/s
[36491] 2.01.942.228 I slot print_timing: id  3 | task 0 | n_decoded =   1905, tg =  18.14 t/s
[36491] 2.05.084.084 I slot print_timing: id  3 | task 0 | n_decoded =   1945, tg =  17.99 t/s
[36491] 2.08.153.909 I slot print_timing: id  3 | task 0 | n_decoded =   2024, tg =  18.20 t/s
[36491] 2.11.311.179 I slot print_timing: id  3 | task 0 | n_decoded =   2074, tg =  18.14 t/s
[36491] 2.14.458.708 I slot print_timing: id  3 | task 0 | n_decoded =   2131, tg =  18.14 t/s
[36491] 2.17.599.424 I slot print_timing: id  3 | task 0 | n_decoded =   2187, tg =  18.13 t/s
[36491] 2.20.734.745 I slot print_timing: id  3 | task 0 | n_decoded =   2235, tg =  18.06 t/s
[36491] 2.23.804.936 I slot print_timing: id  3 | task 0 | n_decoded =   2281, tg =  17.98 t/s
[36491] 2.26.881.516 I slot print_timing: id  3 | task 0 | n_decoded =   2337, tg =  17.99 t/s
[36491] 2.29.956.737 I slot print_timing: id  3 | task 0 | n_decoded =   2379, tg =  17.89 t/s
[36491] 2.33.105.651 I slot print_timing: id  3 | task 0 | n_decoded =   2435, tg =  17.88 t/s
[36491] 2.36.244.236 I slot print_timing: id  3 | task 0 | n_decoded =   2502, tg =  17.96 t/s
[36491] 2.39.383.755 I slot print_timing: id  3 | task 0 | n_decoded =   2535, tg =  17.80 t/s
[36491] 2.39.970.244 I slot print_timing: id  3 | task 0 | prompt eval time =    1544.58 ms /   759 tokens (    2.04 ms per token,   491.40 tokens per second)
[36491] 2.39.970.246 I slot print_timing: id  3 | task 0 |        eval time =  143017.81 ms /  2539 tokens (   56.33 ms per token,    17.75 tokens per second)
[36491] 2.39.970.247 I slot print_timing: id  3 | task 0 |       total time =  144562.40 ms /  3298 tokens
[36491] 2.39.970.247 I slot print_timing: id  3 | task 0 |    graphs reused =        685
[36491] 2.39.970.249 I slot print_timing: id  3 | task 0 | draft acceptance = 0.40516 ( 1820 accepted /  4492 generated)
[36491] 2.39.970.262 I statistics     ngram-simple: #calls(b,g,a) =    1    722     16, #gen drafts =     16, #acc drafts =    16, #gen tokens =    256, #acc tokens =    81, dur(b,g,a) = 0.000, 0.872, 0.000 ms
[36491] 2.39.970.263 I statistics        draft-mtp: #calls(b,g,a) =    1    706    706, #gen drafts =    706, #acc drafts =   577, #gen tokens =   4236, #acc tokens =  1739, dur(b,g,a) = 0.001, 32272.180, 0.409 ms
[36491] 2.39.970.287 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3301, truncated = 0
```
