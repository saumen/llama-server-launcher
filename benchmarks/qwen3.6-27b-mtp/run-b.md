# Run A

## Settings

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-B]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-B
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

spec-type = draft-mtp
spec-draft-n-max = 5

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

## Outcome

```text
[36947] 0.57.555.489 I srv  params_from_: Chat format: peg-native
[36947] 0.57.555.663 I slot get_availabl: id  3 | task -1 | selected slot by LRU, t_last = -1
[36947] 0.57.555.666 I srv  get_availabl: updating prompt cache
[36947] 0.57.555.669 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[36947] 0.57.555.671 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 50176 tokens, 8589934592 est)
[36947] 0.57.555.672 I srv  get_availabl: prompt cache update took 0.01 ms
[36947] 0.57.555.709 I slot launch_slot_: id  3 | task 0 | processing task, is_child = 0
[36947] 0.58.163.548 I slot create_check: id  3 | task 0 | created context checkpoint 1 of 32 (pos_min = 242, pos_max = 242, n_tokens = 243, size = 150.135 MiB)
[36947] 0.58.963.210 I slot create_check: id  3 | task 0 | created context checkpoint 2 of 32 (pos_min = 754, pos_max = 754, n_tokens = 755, size = 151.207 MiB)
[36947] 1.03.858.093 I slot print_timing: id  3 | task 0 | n_decoded =    101, tg =  21.25 t/s
[36947] 1.06.937.549 I slot print_timing: id  3 | task 0 | n_decoded =    175, tg =  22.34 t/s
[36947] 1.10.014.225 I slot print_timing: id  3 | task 0 | n_decoded =    262, tg =  24.02 t/s
[36947] 1.13.106.826 I slot print_timing: id  3 | task 0 | n_decoded =    335, tg =  23.93 t/s
[36947] 1.16.187.580 I slot print_timing: id  3 | task 0 | n_decoded =    395, tg =  23.12 t/s
[36947] 1.19.274.038 I slot print_timing: id  3 | task 0 | n_decoded =    444, tg =  22.01 t/s
[36947] 1.22.366.335 I slot print_timing: id  3 | task 0 | n_decoded =    493, tg =  21.19 t/s
[36947] 1.25.458.789 I slot print_timing: id  3 | task 0 | n_decoded =    537, tg =  20.38 t/s
[36947] 1.28.545.036 I slot print_timing: id  3 | task 0 | n_decoded =    584, tg =  19.84 t/s
[36947] 1.31.644.527 I slot print_timing: id  3 | task 0 | n_decoded =    641, tg =  19.70 t/s
[36947] 1.34.748.442 I slot print_timing: id  3 | task 0 | n_decoded =    700, tg =  19.64 t/s
[36947] 1.37.852.399 I slot print_timing: id  3 | task 0 | n_decoded =    761, tg =  19.64 t/s
[36947] 1.40.973.300 I slot print_timing: id  3 | task 0 | n_decoded =    834, tg =  19.92 t/s
[36947] 1.44.081.841 I slot print_timing: id  3 | task 0 | n_decoded =    896, tg =  19.92 t/s
[36947] 1.47.184.162 I slot print_timing: id  3 | task 0 | n_decoded =    970, tg =  20.17 t/s
[36947] 1.50.297.774 I slot print_timing: id  3 | task 0 | n_decoded =   1035, tg =  20.22 t/s
[36947] 1.53.410.982 I slot print_timing: id  3 | task 0 | n_decoded =   1089, tg =  20.05 t/s
[36947] 1.56.516.832 I slot print_timing: id  3 | task 0 | n_decoded =   1146, tg =  19.96 t/s
[36947] 1.59.632.395 I slot print_timing: id  3 | task 0 | n_decoded =   1193, tg =  19.71 t/s
[36947] 2.02.751.739 I slot print_timing: id  3 | task 0 | n_decoded =   1254, tg =  19.70 t/s
[36947] 2.05.875.952 I slot print_timing: id  3 | task 0 | n_decoded =   1302, tg =  19.50 t/s
[36947] 2.08.989.301 I slot print_timing: id  3 | task 0 | n_decoded =   1341, tg =  19.19 t/s
[36947] 2.12.102.754 I slot print_timing: id  3 | task 0 | n_decoded =   1381, tg =  18.92 t/s
[36947] 2.15.213.271 I slot print_timing: id  3 | task 0 | n_decoded =   1428, tg =  18.76 t/s
[36947] 2.18.320.439 I slot print_timing: id  3 | task 0 | n_decoded =   1483, tg =  18.72 t/s
[36947] 2.21.437.786 I slot print_timing: id  3 | task 0 | n_decoded =   1524, tg =  18.51 t/s
[36947] 2.24.559.817 I slot print_timing: id  3 | task 0 | n_decoded =   1573, tg =  18.41 t/s
[36947] 2.27.666.913 I slot print_timing: id  3 | task 0 | n_decoded =   1630, tg =  18.41 t/s
[36947] 2.30.779.599 I slot print_timing: id  3 | task 0 | n_decoded =   1681, tg =  18.34 t/s
[36947] 2.33.898.594 I slot print_timing: id  3 | task 0 | n_decoded =   1731, tg =  18.26 t/s
[36947] 2.37.007.070 I slot print_timing: id  3 | task 0 | n_decoded =   1785, tg =  18.23 t/s
[36947] 2.40.132.809 I slot print_timing: id  3 | task 0 | n_decoded =   1828, tg =  18.09 t/s
[36947] 2.43.245.488 I slot print_timing: id  3 | task 0 | n_decoded =   1909, tg =  18.33 t/s
[36947] 2.46.358.706 I slot print_timing: id  3 | task 0 | n_decoded =   1957, tg =  18.25 t/s
[36947] 2.49.475.943 I slot print_timing: id  3 | task 0 | n_decoded =   2034, tg =  18.43 t/s
[36947] 2.52.598.928 I slot print_timing: id  3 | task 0 | n_decoded =   2074, tg =  18.27 t/s
[36947] 2.55.721.839 I slot print_timing: id  3 | task 0 | n_decoded =   2134, tg =  18.30 t/s
[36947] 2.58.846.756 I slot print_timing: id  3 | task 0 | n_decoded =   2206, tg =  18.42 t/s
[36947] 3.01.965.309 I slot print_timing: id  3 | task 0 | n_decoded =   2279, tg =  18.55 t/s
[36947] 3.05.101.133 I slot print_timing: id  3 | task 0 | n_decoded =   2352, tg =  18.67 t/s
[36947] 3.08.222.159 I slot print_timing: id  3 | task 0 | n_decoded =   2418, tg =  18.73 t/s
[36947] 3.11.352.304 I slot print_timing: id  3 | task 0 | n_decoded =   2487, tg =  18.81 t/s
[36947] 3.14.471.810 I slot print_timing: id  3 | task 0 | n_decoded =   2561, tg =  18.92 t/s
[36947] 3.17.609.013 I slot print_timing: id  3 | task 0 | n_decoded =   2645, tg =  19.10 t/s
[36947] 3.20.740.166 I slot print_timing: id  3 | task 0 | n_decoded =   2723, tg =  19.23 t/s
[36947] 3.23.870.929 I slot print_timing: id  3 | task 0 | n_decoded =   2795, tg =  19.31 t/s
[36947] 3.27.010.233 I slot print_timing: id  3 | task 0 | n_decoded =   2866, tg =  19.38 t/s
[36947] 3.30.136.456 I slot print_timing: id  3 | task 0 | n_decoded =   2934, tg =  19.43 t/s
[36947] 3.33.262.875 I slot print_timing: id  3 | task 0 | n_decoded =   3000, tg =  19.46 t/s
[36947] 3.36.394.022 I slot print_timing: id  3 | task 0 | n_decoded =   3055, tg =  19.42 t/s
[36947] 3.39.527.479 I slot print_timing: id  3 | task 0 | n_decoded =   3116, tg =  19.42 t/s
[36947] 3.42.658.190 I slot print_timing: id  3 | task 0 | n_decoded =   3168, tg =  19.37 t/s
[36947] 3.45.789.941 I slot print_timing: id  3 | task 0 | n_decoded =   3218, tg =  19.31 t/s
[36947] 3.48.931.909 I slot print_timing: id  3 | task 0 | n_decoded =   3273, tg =  19.27 t/s
[36947] 3.52.064.039 I slot print_timing: id  3 | task 0 | n_decoded =   3333, tg =  19.27 t/s
[36947] 3.55.201.615 I slot print_timing: id  3 | task 0 | n_decoded =   3375, tg =  19.17 t/s
[36947] 3.58.331.701 I slot print_timing: id  3 | task 0 | n_decoded =   3425, tg =  19.11 t/s
[36947] 4.01.465.850 I slot print_timing: id  3 | task 0 | n_decoded =   3490, tg =  19.14 t/s
[36947] 4.04.600.413 I slot print_timing: id  3 | task 0 | n_decoded =   3547, tg =  19.12 t/s
[36947] 4.06.440.634 I slot print_timing: id  3 | task 0 | prompt eval time =    1548.89 ms /   759 tokens (    2.04 ms per token,   490.03 tokens per second)
[36947] 4.06.440.637 I slot print_timing: id  3 | task 0 |        eval time =  187335.98 ms /  3573 tokens (   52.43 ms per token,    19.07 tokens per second)
[36947] 4.06.440.638 I slot print_timing: id  3 | task 0 |       total time =  188884.87 ms /  4332 tokens
[36947] 4.06.440.639 I slot print_timing: id  3 | task 0 |    graphs reused =       1008
[36947] 4.06.440.640 I slot print_timing: id  3 | task 0 | draft acceptance = 0.49980 ( 2554 accepted /  5110 generated)
[36947] 4.06.440.657 I statistics        draft-mtp: #calls(b,g,a) =    1   1022   1022, #gen drafts =   1022, #acc drafts =   838, #gen tokens =   5110, #acc tokens =  2554, dur(b,g,a) = 0.001, 38746.676, 1.172 ms
[36947] 4.06.440.682 I slot      release: id  3 | task 0 | stop processing: n_tokens = 4335, truncated = 0
```
