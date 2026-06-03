# Run A

## Settings

```ini
[unsloth/Qwen3.6-27B-UD-Q5_K_XL-MTP-C]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-UD-Q5_K_XL.gguf
alias = unsloth/Qwen3.6-27B-UD-Q5_K_XL-MTP-C
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
[51559] 0.17.759.497 I srv  params_from_: Chat format: peg-native
[51559] 0.17.759.646 I slot get_availabl: id  3 | task -1 | selected slot by LRU, t_last = -1
[51559] 0.17.759.649 I srv  get_availabl: updating prompt cache
[51559] 0.17.759.651 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[51559] 0.17.759.654 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 50176 tokens, 8589934592 est)
[51559] 0.17.759.654 I srv  get_availabl: prompt cache update took 0.01 ms
[51559] 0.17.759.698 I slot launch_slot_: id  3 | task 0 | processing task, is_child = 0
[51559] 0.18.312.226 I slot create_check: id  3 | task 0 | created context checkpoint 1 of 32 (pos_min = 242, pos_max = 242, n_tokens = 243, size = 150.135 MiB)
[51559] 0.19.043.748 I slot create_check: id  3 | task 0 | created context checkpoint 2 of 32 (pos_min = 754, pos_max = 754, n_tokens = 755, size = 151.207 MiB)
[51559] 0.23.707.003 I slot print_timing: id  3 | task 0 | n_decoded =    103, tg =  22.71 t/s
[51559] 0.26.864.909 I slot print_timing: id  3 | task 0 | n_decoded =    193, tg =  25.09 t/s
[51559] 0.29.865.526 I slot print_timing: id  3 | task 0 | n_decoded =    292, tg =  27.31 t/s
[51559] 0.33.026.176 I slot print_timing: id  3 | task 0 | n_decoded =    377, tg =  27.21 t/s
[51559] 0.36.183.755 I slot print_timing: id  3 | task 0 | n_decoded =    445, tg =  26.16 t/s
[51559] 0.39.351.221 I slot print_timing: id  3 | task 0 | n_decoded =    491, tg =  24.33 t/s
[51559] 0.42.351.716 I slot print_timing: id  3 | task 0 | n_decoded =    551, tg =  23.77 t/s
[51559] 0.45.354.613 I slot print_timing: id  3 | task 0 | n_decoded =    606, tg =  23.14 t/s
[51559] 0.48.510.560 I slot print_timing: id  3 | task 0 | n_decoded =    676, tg =  23.04 t/s
[51559] 0.51.676.537 I slot print_timing: id  3 | task 0 | n_decoded =    760, tg =  23.38 t/s
[51559] 0.54.686.678 I slot print_timing: id  3 | task 0 | n_decoded =    823, tg =  23.17 t/s
[51559] 0.57.690.127 I slot print_timing: id  3 | task 0 | n_decoded =    867, tg =  22.51 t/s
[51559] 1.00.694.623 I slot print_timing: id  3 | task 0 | n_decoded =    914, tg =  22.01 t/s
[51559] 1.03.860.202 I slot print_timing: id  3 | task 0 | n_decoded =    979, tg =  21.91 t/s
[51559] 1.06.861.406 I slot print_timing: id  3 | task 0 | n_decoded =   1025, tg =  21.49 t/s
[51559] 1.09.879.579 I slot print_timing: id  3 | task 0 | n_decoded =   1066, tg =  21.02 t/s
[51559] 1.12.886.083 I slot print_timing: id  3 | task 0 | n_decoded =   1117, tg =  20.80 t/s
[51559] 1.15.895.469 I slot print_timing: id  3 | task 0 | n_decoded =   1174, tg =  20.70 t/s
[51559] 1.18.911.348 I slot print_timing: id  3 | task 0 | n_decoded =   1231, tg =  20.61 t/s
[51559] 1.21.929.505 I slot print_timing: id  3 | task 0 | n_decoded =   1306, tg =  20.81 t/s
[51559] 1.24.939.751 I slot print_timing: id  3 | task 0 | n_decoded =   1381, tg =  21.00 t/s
[51559] 1.27.953.940 I slot print_timing: id  3 | task 0 | n_decoded =   1473, tg =  21.42 t/s
[51559] 1.30.956.711 I slot print_timing: id  3 | task 0 | n_decoded =   1541, tg =  21.47 t/s
[51559] 1.33.979.731 I slot print_timing: id  3 | task 0 | n_decoded =   1595, tg =  21.32 t/s
[51559] 1.36.994.122 I slot print_timing: id  3 | task 0 | n_decoded =   1646, tg =  21.15 t/s
[51559] 1.40.011.200 I slot print_timing: id  3 | task 0 | n_decoded =   1707, tg =  21.12 t/s
[51559] 1.43.031.870 I slot print_timing: id  3 | task 0 | n_decoded =   1772, tg =  21.13 t/s
[51559] 1.46.051.203 I slot print_timing: id  3 | task 0 | n_decoded =   1848, tg =  21.27 t/s
[51559] 1.49.069.866 I slot print_timing: id  3 | task 0 | n_decoded =   1901, tg =  21.15 t/s
[51559] 1.52.088.634 I slot print_timing: id  3 | task 0 | n_decoded =   1944, tg =  20.92 t/s
[51559] 1.55.106.903 I slot print_timing: id  3 | task 0 | n_decoded =   2005, tg =  20.90 t/s
[51559] 1.58.133.900 I slot print_timing: id  3 | task 0 | n_decoded =   2087, tg =  21.09 t/s
[51559] 2.01.160.352 I slot print_timing: id  3 | task 0 | n_decoded =   2129, tg =  20.87 t/s
[51559] 2.04.181.442 I slot print_timing: id  3 | task 0 | n_decoded =   2213, tg =  21.07 t/s
[51559] 2.07.206.045 I slot print_timing: id  3 | task 0 | n_decoded =   2277, tg =  21.08 t/s
[51559] 2.10.243.265 I slot print_timing: id  3 | task 0 | n_decoded =   2365, tg =  21.29 t/s
[51559] 2.13.262.103 I slot print_timing: id  3 | task 0 | n_decoded =   2427, tg =  21.27 t/s
[51559] 2.16.287.265 I slot print_timing: id  3 | task 0 | n_decoded =   2498, tg =  21.33 t/s
[51559] 2.19.318.839 I slot print_timing: id  3 | task 0 | n_decoded =   2573, tg =  21.42 t/s
[51559] 2.22.349.195 I slot print_timing: id  3 | task 0 | n_decoded =   2622, tg =  21.29 t/s
[51559] 2.25.373.120 I slot print_timing: id  3 | task 0 | n_decoded =   2677, tg =  21.21 t/s
[51559] 2.28.401.067 I slot print_timing: id  3 | task 0 | n_decoded =   2752, tg =  21.30 t/s
[51559] 2.31.425.041 I slot print_timing: id  3 | task 0 | n_decoded =   2801, tg =  21.18 t/s
[51559] 2.34.460.271 I slot print_timing: id  3 | task 0 | n_decoded =   2862, tg =  21.15 t/s
[51559] 2.37.485.383 I slot print_timing: id  3 | task 0 | n_decoded =   2900, tg =  20.97 t/s
[51559] 2.40.516.068 I slot print_timing: id  3 | task 0 | n_decoded =   2950, tg =  20.87 t/s
[51559] 2.42.879.445 I slot print_timing: id  3 | task 0 | prompt eval time =    1411.80 ms /   759 tokens (    1.86 ms per token,   537.61 tokens per second)
[51559] 2.42.879.449 I slot print_timing: id  3 | task 0 |        eval time =  143707.89 ms /  2994 tokens (   48.00 ms per token,    20.83 tokens per second)
[51559] 2.42.879.450 I slot print_timing: id  3 | task 0 |       total time =  145119.69 ms /  3753 tokens
[51559] 2.42.879.450 I slot print_timing: id  3 | task 0 |    graphs reused =        846
[51559] 2.42.879.451 I slot print_timing: id  3 | task 0 | draft acceptance = 0.49837 ( 2138 accepted /  4290 generated)
[51559] 2.42.879.468 I statistics        draft-mtp: #calls(b,g,a) =    1    858    858, #gen drafts =    858, #acc drafts =   702, #gen tokens =   4290, #acc tokens =  2138, dur(b,g,a) = 0.002, 31366.983, 0.544 ms
[51559] 2.42.879.491 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3755, truncated = 0
```
