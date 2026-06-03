# Run A

## Settings

```ini
[unsloth/qwen3.6-27B-Q6_K-MTP-C]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q6_K.gguf
alias = unsloth/qwen3.6-27B-Q6_K-MTP-C
ctx-size = 50000

mmproj =
flash-attn = true
kv-unified = true
cache-type-k = q8_0
cache-type-v = q8_0

spec-type = draft-mtp
spec-draft-n-max = 6

temp = 0.3
top-p = 0.9
top-k = 20

cont-batching = true
parallel = 4
```

## Outcome

```text
[49745] 0.25.296.707 I srv  params_from_: Chat format: peg-native
[49745] 0.25.296.848 I slot get_availabl: id  3 | task -1 | selected slot by LRU, t_last = -1
[49745] 0.25.296.850 I srv  get_availabl: updating prompt cache
[49745] 0.25.296.852 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[49745] 0.25.296.854 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 50176 tokens, 8589934592 est)
[49745] 0.25.296.855 I srv  get_availabl: prompt cache update took 0.01 ms
[49745] 0.25.296.884 I slot launch_slot_: id  3 | task 0 | processing task, is_child = 0
[49745] 0.25.900.377 I slot create_check: id  3 | task 0 | created context checkpoint 1 of 32 (pos_min = 242, pos_max = 242, n_tokens = 243, size = 150.135 MiB)
[49745] 0.26.706.143 I slot create_check: id  3 | task 0 | created context checkpoint 2 of 32 (pos_min = 754, pos_max = 754, n_tokens = 755, size = 151.207 MiB)
[49745] 0.31.735.793 I slot print_timing: id  3 | task 0 | n_decoded =    103, tg =  21.10 t/s
[49745] 0.34.832.537 I slot print_timing: id  3 | task 0 | n_decoded =    178, tg =  22.31 t/s
[49745] 0.37.949.278 I slot print_timing: id  3 | task 0 | n_decoded =    278, tg =  25.06 t/s
[49745] 0.41.053.780 I slot print_timing: id  3 | task 0 | n_decoded =    353, tg =  24.86 t/s
[49745] 0.44.154.994 I slot print_timing: id  3 | task 0 | n_decoded =    417, tg =  24.10 t/s
[49745] 0.47.265.073 I slot print_timing: id  3 | task 0 | n_decoded =    463, tg =  22.68 t/s
[49745] 0.50.378.932 I slot print_timing: id  3 | task 0 | n_decoded =    523, tg =  22.23 t/s
[49745] 0.53.493.459 I slot print_timing: id  3 | task 0 | n_decoded =    566, tg =  21.25 t/s
[49745] 0.56.604.576 I slot print_timing: id  3 | task 0 | n_decoded =    619, tg =  20.81 t/s
[49745] 0.59.730.033 I slot print_timing: id  3 | task 0 | n_decoded =    696, tg =  21.17 t/s
[49745] 1.02.856.230 I slot print_timing: id  3 | task 0 | n_decoded =    754, tg =  20.94 t/s
[49745] 1.05.983.778 I slot print_timing: id  3 | task 0 | n_decoded =    795, tg =  20.32 t/s
[49745] 1.09.105.715 I slot print_timing: id  3 | task 0 | n_decoded =    856, tg =  20.26 t/s
[49745] 1.12.228.081 I slot print_timing: id  3 | task 0 | n_decoded =    912, tg =  20.10 t/s
[49745] 1.15.347.971 I slot print_timing: id  3 | task 0 | n_decoded =    963, tg =  19.86 t/s
[49745] 1.18.470.382 I slot print_timing: id  3 | task 0 | n_decoded =   1004, tg =  19.45 t/s
[49745] 1.21.603.447 I slot print_timing: id  3 | task 0 | n_decoded =   1062, tg =  19.40 t/s
[49745] 1.24.724.351 I slot print_timing: id  3 | task 0 | n_decoded =   1119, tg =  19.34 t/s
[49745] 1.27.844.845 I slot print_timing: id  3 | task 0 | n_decoded =   1167, tg =  19.13 t/s
[49745] 1.30.964.714 I slot print_timing: id  3 | task 0 | n_decoded =   1224, tg =  19.09 t/s
[49745] 1.34.094.756 I slot print_timing: id  3 | task 0 | n_decoded =   1288, tg =  19.16 t/s
[49745] 1.37.227.043 I slot print_timing: id  3 | task 0 | n_decoded =   1344, tg =  19.10 t/s
[49745] 1.40.347.040 I slot print_timing: id  3 | task 0 | n_decoded =   1428, tg =  19.43 t/s
[49745] 1.43.465.973 I slot print_timing: id  3 | task 0 | n_decoded =   1503, tg =  19.62 t/s
[49745] 1.46.601.455 I slot print_timing: id  3 | task 0 | n_decoded =   1559, tg =  19.55 t/s
[49745] 1.49.727.100 I slot print_timing: id  3 | task 0 | n_decoded =   1601, tg =  19.32 t/s
[49745] 1.52.858.007 I slot print_timing: id  3 | task 0 | n_decoded =   1641, tg =  19.08 t/s
[49745] 1.55.981.844 I slot print_timing: id  3 | task 0 | n_decoded =   1695, tg =  19.02 t/s
[49745] 1.59.107.458 I slot print_timing: id  3 | task 0 | n_decoded =   1740, tg =  18.86 t/s
[49745] 2.02.233.644 I slot print_timing: id  3 | task 0 | n_decoded =   1779, tg =  18.65 t/s
[49745] 2.05.372.555 I slot print_timing: id  3 | task 0 | n_decoded =   1821, tg =  18.48 t/s
[49745] 2.08.500.942 I slot print_timing: id  3 | task 0 | n_decoded =   1860, tg =  18.30 t/s
[49745] 2.11.626.581 I slot print_timing: id  3 | task 0 | n_decoded =   1907, tg =  18.20 t/s
[49745] 2.14.756.927 I slot print_timing: id  3 | task 0 | n_decoded =   1975, tg =  18.30 t/s
[49745] 2.17.892.137 I slot print_timing: id  3 | task 0 | n_decoded =   2019, tg =  18.18 t/s
[49745] 2.21.031.711 I slot print_timing: id  3 | task 0 | n_decoded =   2072, tg =  18.15 t/s
[49745] 2.24.165.224 I slot print_timing: id  3 | task 0 | n_decoded =   2121, tg =  18.08 t/s
[49745] 2.27.306.177 I slot print_timing: id  3 | task 0 | n_decoded =   2193, tg =  18.21 t/s
[49745] 2.30.438.615 I slot print_timing: id  3 | task 0 | n_decoded =   2272, tg =  18.38 t/s
[49745] 2.33.586.097 I slot print_timing: id  3 | task 0 | n_decoded =   2346, tg =  18.51 t/s
[49745] 2.36.725.890 I slot print_timing: id  3 | task 0 | n_decoded =   2428, tg =  18.70 t/s
[49745] 2.39.862.013 I slot print_timing: id  3 | task 0 | n_decoded =   2486, tg =  18.69 t/s
[49745] 2.42.993.469 I slot print_timing: id  3 | task 0 | n_decoded =   2548, tg =  18.72 t/s
[49745] 2.46.147.812 I slot print_timing: id  3 | task 0 | n_decoded =   2616, tg =  18.78 t/s
[49745] 2.49.280.721 I slot print_timing: id  3 | task 0 | n_decoded =   2666, tg =  18.72 t/s
[49745] 2.52.419.811 I slot print_timing: id  3 | task 0 | n_decoded =   2726, tg =  18.73 t/s
[49745] 2.55.553.726 I slot print_timing: id  3 | task 0 | n_decoded =   2793, tg =  18.78 t/s
[49745] 2.58.707.149 I slot print_timing: id  3 | task 0 | n_decoded =   2841, tg =  18.71 t/s
[49745] 3.01.853.179 I slot print_timing: id  3 | task 0 | n_decoded =   2892, tg =  18.66 t/s
[49745] 3.04.995.715 I slot print_timing: id  3 | task 0 | n_decoded =   2948, tg =  18.64 t/s
[49745] 3.08.138.909 I slot print_timing: id  3 | task 0 | n_decoded =   2986, tg =  18.51 t/s
[49745] 3.11.281.969 I slot print_timing: id  3 | task 0 | n_decoded =   3030, tg =  18.43 t/s
[49745] 3.14.429.842 I slot print_timing: id  3 | task 0 | n_decoded =   3092, tg =  18.45 t/s
[49745] 3.17.572.453 I slot print_timing: id  3 | task 0 | n_decoded =   3128, tg =  18.32 t/s
[49745] 3.17.971.330 I slot print_timing: id  3 | task 0 | prompt eval time =    1557.05 ms /   759 tokens (    2.05 ms per token,   487.46 tokens per second)
[49745] 3.17.971.333 I slot print_timing: id  3 | task 0 |        eval time =  171117.34 ms /  3132 tokens (   54.64 ms per token,    18.30 tokens per second)
[49745] 3.17.971.334 I slot print_timing: id  3 | task 0 |       total time =  172674.39 ms /  3891 tokens
[49745] 3.17.971.334 I slot print_timing: id  3 | task 0 |    graphs reused =        862
[49745] 3.17.971.335 I slot print_timing: id  3 | task 0 | draft acceptance = 0.43048 ( 2260 accepted /  5250 generated)
[49745] 3.17.971.351 I statistics        draft-mtp: #calls(b,g,a) =    1    875    875, #gen drafts =    875, #acc drafts =   710, #gen tokens =   5250, #acc tokens =  2260, dur(b,g,a) = 0.001, 40015.195, 0.486 ms
[49745] 3.17.971.375 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3894, truncated = 0
```
