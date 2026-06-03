# Run A

## Settings

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-A]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-A
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

spec-type = draft-mtp
spec-draft-n-max = 3

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

## Outcome

```text
[45927] 0.13.802.821 I srv  params_from_: Chat format: peg-native
[45927] 0.13.802.990 I slot get_availabl: id  3 | task -1 | selected slot by LRU, t_last = -1
[45927] 0.13.802.993 I srv  get_availabl: updating prompt cache
[45927] 0.13.802.996 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[45927] 0.13.802.998 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 50176 tokens, 8589934592 est)
[45927] 0.13.802.998 I srv  get_availabl: prompt cache update took 0.00 ms
[45927] 0.13.803.033 I slot launch_slot_: id  3 | task 0 | processing task, is_child = 0
[45927] 0.14.392.439 I slot create_check: id  3 | task 0 | created context checkpoint 1 of 32 (pos_min = 242, pos_max = 242, n_tokens = 243, size = 150.135 MiB)
[45927] 0.15.181.638 I slot create_check: id  3 | task 0 | created context checkpoint 2 of 32 (pos_min = 754, pos_max = 754, n_tokens = 755, size = 151.207 MiB)
[45927] 0.20.090.931 I slot print_timing: id  3 | task 0 | n_decoded =    103, tg =  21.57 t/s
[45927] 0.23.145.996 I slot print_timing: id  3 | task 0 | n_decoded =    174, tg =  22.22 t/s
[45927] 0.26.201.393 I slot print_timing: id  3 | task 0 | n_decoded =    247, tg =  22.69 t/s
[45927] 0.29.268.450 I slot print_timing: id  3 | task 0 | n_decoded =    325, tg =  23.29 t/s
[45927] 0.32.329.958 I slot print_timing: id  3 | task 0 | n_decoded =    388, tg =  22.81 t/s
[45927] 0.35.393.584 I slot print_timing: id  3 | task 0 | n_decoded =    438, tg =  21.82 t/s
[45927] 0.38.455.181 I slot print_timing: id  3 | task 0 | n_decoded =    493, tg =  21.31 t/s
[45927] 0.41.528.811 I slot print_timing: id  3 | task 0 | n_decoded =    549, tg =  20.94 t/s
[45927] 0.44.597.696 I slot print_timing: id  3 | task 0 | n_decoded =    606, tg =  20.70 t/s
[45927] 0.47.665.971 I slot print_timing: id  3 | task 0 | n_decoded =    665, tg =  20.56 t/s
[45927] 0.50.738.288 I slot print_timing: id  3 | task 0 | n_decoded =    728, tg =  20.55 t/s
[45927] 0.53.814.608 I slot print_timing: id  3 | task 0 | n_decoded =    783, tg =  20.34 t/s
[45927] 0.56.892.864 I slot print_timing: id  3 | task 0 | n_decoded =    850, tg =  20.44 t/s
[45927] 0.59.965.699 I slot print_timing: id  3 | task 0 | n_decoded =    913, tg =  20.45 t/s
[45927] 1.03.039.256 I slot print_timing: id  3 | task 0 | n_decoded =    963, tg =  20.18 t/s
[45927] 1.06.114.740 I slot print_timing: id  3 | task 0 | n_decoded =   1023, tg =  20.14 t/s
[45927] 1.09.199.467 I slot print_timing: id  3 | task 0 | n_decoded =   1084, tg =  20.12 t/s
[45927] 1.12.280.224 I slot print_timing: id  3 | task 0 | n_decoded =   1142, tg =  20.05 t/s
[45927] 1.15.371.672 I slot print_timing: id  3 | task 0 | n_decoded =   1188, tg =  19.78 t/s
[45927] 1.18.452.804 I slot print_timing: id  3 | task 0 | n_decoded =   1242, tg =  19.67 t/s
[45927] 1.21.548.547 I slot print_timing: id  3 | task 0 | n_decoded =   1301, tg =  19.64 t/s
[45927] 1.24.631.743 I slot print_timing: id  3 | task 0 | n_decoded =   1353, tg =  19.52 t/s
[45927] 1.27.718.451 I slot print_timing: id  3 | task 0 | n_decoded =   1420, tg =  19.61 t/s
[45927] 1.30.805.148 I slot print_timing: id  3 | task 0 | n_decoded =   1484, tg =  19.66 t/s
[45927] 1.33.893.493 I slot print_timing: id  3 | task 0 | n_decoded =   1541, tg =  19.61 t/s
[45927] 1.36.988.746 I slot print_timing: id  3 | task 0 | n_decoded =   1600, tg =  19.59 t/s
[45927] 1.40.081.088 I slot print_timing: id  3 | task 0 | n_decoded =   1654, tg =  19.51 t/s
[45927] 1.43.166.296 I slot print_timing: id  3 | task 0 | n_decoded =   1700, tg =  19.35 t/s
[45927] 1.46.251.643 I slot print_timing: id  3 | task 0 | n_decoded =   1761, tg =  19.37 t/s
[45927] 1.49.362.160 I slot print_timing: id  3 | task 0 | n_decoded =   1809, tg =  19.24 t/s
[45927] 1.52.456.293 I slot print_timing: id  3 | task 0 | n_decoded =   1878, tg =  19.33 t/s
[45927] 1.55.555.989 I slot print_timing: id  3 | task 0 | n_decoded =   1943, tg =  19.38 t/s
[45927] 1.58.652.792 I slot print_timing: id  3 | task 0 | n_decoded =   2003, tg =  19.38 t/s
[45927] 2.01.750.666 I slot print_timing: id  3 | task 0 | n_decoded =   2061, tg =  19.36 t/s
[45927] 2.04.856.724 I slot print_timing: id  3 | task 0 | n_decoded =   2129, tg =  19.44 t/s
[45927] 2.07.956.979 I slot print_timing: id  3 | task 0 | n_decoded =   2179, tg =  19.34 t/s
[45927] 2.11.061.518 I slot print_timing: id  3 | task 0 | n_decoded =   2233, tg =  19.29 t/s
[45927] 2.14.160.175 I slot print_timing: id  3 | task 0 | n_decoded =   2296, tg =  19.32 t/s
[45927] 2.17.274.320 I slot print_timing: id  3 | task 0 | n_decoded =   2352, tg =  19.29 t/s
[45927] 2.20.384.460 I slot print_timing: id  3 | task 0 | n_decoded =   2423, tg =  19.37 t/s
[45927] 2.23.487.250 I slot print_timing: id  3 | task 0 | n_decoded =   2485, tg =  19.39 t/s
[45927] 2.26.586.462 I slot print_timing: id  3 | task 0 | n_decoded =   2547, tg =  19.40 t/s
[45927] 2.29.698.993 I slot print_timing: id  3 | task 0 | n_decoded =   2611, tg =  19.43 t/s
[45927] 2.32.808.446 I slot print_timing: id  3 | task 0 | n_decoded =   2671, tg =  19.43 t/s
[45927] 2.35.912.328 I slot print_timing: id  3 | task 0 | n_decoded =   2725, tg =  19.38 t/s
[45927] 2.39.015.658 I slot print_timing: id  3 | task 0 | n_decoded =   2780, tg =  19.35 t/s
[45927] 2.42.128.420 I slot print_timing: id  3 | task 0 | n_decoded =   2834, tg =  19.30 t/s
[45927] 2.45.230.774 I slot print_timing: id  3 | task 0 | n_decoded =   2888, tg =  19.26 t/s
[45927] 2.48.344.046 I slot print_timing: id  3 | task 0 | n_decoded =   2935, tg =  19.18 t/s
[45927] 2.51.457.695 I slot print_timing: id  3 | task 0 | n_decoded =   2973, tg =  19.04 t/s
[45927] 2.54.566.909 I slot print_timing: id  3 | task 0 | n_decoded =   3023, tg =  18.98 t/s
[45927] 2.57.671.903 I slot print_timing: id  3 | task 0 | n_decoded =   3078, tg =  18.96 t/s
[45927] 3.00.787.483 I slot print_timing: id  3 | task 0 | n_decoded =   3131, tg =  18.92 t/s
[45927] 3.03.888.356 I slot print_timing: id  3 | task 0 | n_decoded =   3170, tg =  18.81 t/s
[45927] 3.05.130.839 I slot print_timing: id  3 | task 0 | prompt eval time =    1513.71 ms /   759 tokens (    1.99 ms per token,   501.42 tokens per second)
[45927] 3.05.130.845 I slot print_timing: id  3 | task 0 |        eval time =  169813.95 ms /  3191 tokens (   53.22 ms per token,    18.79 tokens per second)
[45927] 3.05.130.846 I slot print_timing: id  3 | task 0 |       total time =  171327.67 ms /  3950 tokens
[45927] 3.05.130.847 I slot print_timing: id  3 | task 0 |    graphs reused =       1086
[45927] 3.05.130.849 I slot print_timing: id  3 | task 0 | draft acceptance = 0.63421 ( 2091 accepted /  3297 generated)
[45927] 3.05.130.885 I statistics        draft-mtp: #calls(b,g,a) =    1   1099   1099, #gen drafts =   1099, #acc drafts =   902, #gen tokens =   3297, #acc tokens =  2091, dur(b,g,a) = 0.002, 24847.492, 1.359 ms
[45927] 3.05.130.947 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3949, truncated = 0
```
