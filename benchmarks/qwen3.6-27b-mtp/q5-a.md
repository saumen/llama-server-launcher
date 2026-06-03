# Run A

## Settings

```ini
[unsloth/Qwen3.6-27B-UD-Q5_K_XL-A]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-UD-Q5_K_XL.gguf
alias = unsloth/Qwen3.6-27B-UD-Q5_K_XL-A
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

## Outcome

```text
[38191] 0.29.188.982 I srv  params_from_: Chat format: peg-native
[38191] 0.29.189.154 I slot get_availabl: id  3 | task -1 | selected slot by LRU, t_last = -1
[38191] 0.29.189.157 I srv  get_availabl: updating prompt cache
[38191] 0.29.189.159 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[38191] 0.29.189.162 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 50176 tokens, 8589934592 est)
[38191] 0.29.189.163 I srv  get_availabl: prompt cache update took 0.01 ms
[38191] 0.29.189.200 I slot launch_slot_: id  3 | task 0 | processing task, is_child = 0
[38191] 0.29.552.011 I slot create_check: id  3 | task 0 | created context checkpoint 1 of 32 (pos_min = 242, pos_max = 242, n_tokens = 243, size = 149.626 MiB)
[38191] 0.30.213.291 I slot create_check: id  3 | task 0 | created context checkpoint 2 of 32 (pos_min = 754, pos_max = 754, n_tokens = 755, size = 149.626 MiB)
[38191] 0.40.538.396 I slot print_timing: id  3 | task 0 | n_decoded =    100, tg =   9.79 t/s
[38191] 0.43.627.712 I slot print_timing: id  3 | task 0 | n_decoded =    130, tg =   9.77 t/s
[38191] 0.46.720.217 I slot print_timing: id  3 | task 0 | n_decoded =    160, tg =   9.76 t/s
[38191] 0.49.812.351 I slot print_timing: id  3 | task 0 | n_decoded =    190, tg =   9.75 t/s
[38191] 0.52.906.482 I slot print_timing: id  3 | task 0 | n_decoded =    220, tg =   9.74 t/s
[38191] 0.55.999.196 I slot print_timing: id  3 | task 0 | n_decoded =    250, tg =   9.74 t/s
[38191] 0.59.104.939 I slot print_timing: id  3 | task 0 | n_decoded =    280, tg =   9.73 t/s
[38191] 1.02.203.393 I slot print_timing: id  3 | task 0 | n_decoded =    310, tg =   9.73 t/s
[38191] 1.05.299.466 I slot print_timing: id  3 | task 0 | n_decoded =    340, tg =   9.72 t/s
[38191] 1.08.398.005 I slot print_timing: id  3 | task 0 | n_decoded =    370, tg =   9.72 t/s
[38191] 1.11.496.735 I slot print_timing: id  3 | task 0 | n_decoded =    400, tg =   9.72 t/s
[38191] 1.14.598.283 I slot print_timing: id  3 | task 0 | n_decoded =    430, tg =   9.71 t/s
[38191] 1.17.701.010 I slot print_timing: id  3 | task 0 | n_decoded =    460, tg =   9.71 t/s
[38191] 1.20.701.133 I slot print_timing: id  3 | task 0 | n_decoded =    489, tg =   9.71 t/s
[38191] 1.23.702.948 I slot print_timing: id  3 | task 0 | n_decoded =    518, tg =   9.70 t/s
[38191] 1.26.708.914 I slot print_timing: id  3 | task 0 | n_decoded =    547, tg =   9.70 t/s
[38191] 1.29.710.486 I slot print_timing: id  3 | task 0 | n_decoded =    576, tg =   9.70 t/s
[38191] 1.32.716.020 I slot print_timing: id  3 | task 0 | n_decoded =    605, tg =   9.70 t/s
[38191] 1.35.720.301 I slot print_timing: id  3 | task 0 | n_decoded =    634, tg =   9.70 t/s
[38191] 1.38.722.865 I slot print_timing: id  3 | task 0 | n_decoded =    663, tg =   9.69 t/s
[38191] 1.41.727.196 I slot print_timing: id  3 | task 0 | n_decoded =    692, tg =   9.69 t/s
[38191] 1.44.733.422 I slot print_timing: id  3 | task 0 | n_decoded =    721, tg =   9.69 t/s
[38191] 1.47.737.856 I slot print_timing: id  3 | task 0 | n_decoded =    750, tg =   9.69 t/s
[38191] 1.50.745.464 I slot print_timing: id  3 | task 0 | n_decoded =    779, tg =   9.69 t/s
[38191] 1.53.757.578 I slot print_timing: id  3 | task 0 | n_decoded =    808, tg =   9.68 t/s
[38191] 1.56.770.280 I slot print_timing: id  3 | task 0 | n_decoded =    837, tg =   9.68 t/s
[38191] 1.59.780.554 I slot print_timing: id  3 | task 0 | n_decoded =    866, tg =   9.68 t/s
[38191] 2.02.792.549 I slot print_timing: id  3 | task 0 | n_decoded =    895, tg =   9.68 t/s
[38191] 2.05.806.179 I slot print_timing: id  3 | task 0 | n_decoded =    924, tg =   9.68 t/s
[38191] 2.08.819.289 I slot print_timing: id  3 | task 0 | n_decoded =    953, tg =   9.68 t/s
[38191] 2.11.833.809 I slot print_timing: id  3 | task 0 | n_decoded =    982, tg =   9.67 t/s
[38191] 2.14.847.838 I slot print_timing: id  3 | task 0 | n_decoded =   1011, tg =   9.67 t/s
[38191] 2.17.868.998 I slot print_timing: id  3 | task 0 | n_decoded =   1040, tg =   9.67 t/s
[38191] 2.20.886.554 I slot print_timing: id  3 | task 0 | n_decoded =   1069, tg =   9.67 t/s
[38191] 2.23.901.325 I slot print_timing: id  3 | task 0 | n_decoded =   1098, tg =   9.67 t/s
[38191] 2.26.917.685 I slot print_timing: id  3 | task 0 | n_decoded =   1127, tg =   9.67 t/s
[38191] 2.29.933.503 I slot print_timing: id  3 | task 0 | n_decoded =   1156, tg =   9.67 t/s
[38191] 2.32.954.973 I slot print_timing: id  3 | task 0 | n_decoded =   1185, tg =   9.66 t/s
[38191] 2.35.971.103 I slot print_timing: id  3 | task 0 | n_decoded =   1214, tg =   9.66 t/s
[38191] 2.38.987.474 I slot print_timing: id  3 | task 0 | n_decoded =   1243, tg =   9.66 t/s
[38191] 2.42.005.766 I slot print_timing: id  3 | task 0 | n_decoded =   1272, tg =   9.66 t/s
[38191] 2.45.029.961 I slot print_timing: id  3 | task 0 | n_decoded =   1301, tg =   9.66 t/s
[38191] 2.48.049.011 I slot print_timing: id  3 | task 0 | n_decoded =   1330, tg =   9.66 t/s
[38191] 2.51.067.488 I slot print_timing: id  3 | task 0 | n_decoded =   1359, tg =   9.66 t/s
[38191] 2.54.087.745 I slot print_timing: id  3 | task 0 | n_decoded =   1388, tg =   9.65 t/s
[38191] 2.57.112.321 I slot print_timing: id  3 | task 0 | n_decoded =   1417, tg =   9.65 t/s
[38191] 3.00.130.868 I slot print_timing: id  3 | task 0 | n_decoded =   1446, tg =   9.65 t/s
[38191] 3.03.149.662 I slot print_timing: id  3 | task 0 | n_decoded =   1475, tg =   9.65 t/s
[38191] 3.06.172.119 I slot print_timing: id  3 | task 0 | n_decoded =   1504, tg =   9.65 t/s
[38191] 3.09.190.697 I slot print_timing: id  3 | task 0 | n_decoded =   1533, tg =   9.65 t/s
[38191] 3.12.214.163 I slot print_timing: id  3 | task 0 | n_decoded =   1562, tg =   9.65 t/s
[38191] 3.15.233.595 I slot print_timing: id  3 | task 0 | n_decoded =   1591, tg =   9.65 t/s
[38191] 3.18.254.184 I slot print_timing: id  3 | task 0 | n_decoded =   1620, tg =   9.65 t/s
[38191] 3.21.272.697 I slot print_timing: id  3 | task 0 | n_decoded =   1649, tg =   9.65 t/s
[38191] 3.24.291.220 I slot print_timing: id  3 | task 0 | n_decoded =   1678, tg =   9.65 t/s
[38191] 3.27.313.942 I slot print_timing: id  3 | task 0 | n_decoded =   1707, tg =   9.64 t/s
[38191] 3.30.332.267 I slot print_timing: id  3 | task 0 | n_decoded =   1736, tg =   9.64 t/s
[38191] 3.33.357.502 I slot print_timing: id  3 | task 0 | n_decoded =   1765, tg =   9.64 t/s
[38191] 3.36.377.891 I slot print_timing: id  3 | task 0 | n_decoded =   1794, tg =   9.64 t/s
[38191] 3.39.405.426 I slot print_timing: id  3 | task 0 | n_decoded =   1823, tg =   9.64 t/s
[38191] 3.42.429.311 I slot print_timing: id  3 | task 0 | n_decoded =   1852, tg =   9.64 t/s
[38191] 3.45.452.129 I slot print_timing: id  3 | task 0 | n_decoded =   1881, tg =   9.64 t/s
[38191] 3.48.476.813 I slot print_timing: id  3 | task 0 | n_decoded =   1910, tg =   9.64 t/s
[38191] 3.51.499.259 I slot print_timing: id  3 | task 0 | n_decoded =   1939, tg =   9.64 t/s
[38191] 3.54.524.127 I slot print_timing: id  3 | task 0 | n_decoded =   1968, tg =   9.64 t/s
[38191] 3.57.547.132 I slot print_timing: id  3 | task 0 | n_decoded =   1997, tg =   9.64 t/s
[38191] 4.00.568.715 I slot print_timing: id  3 | task 0 | n_decoded =   2026, tg =   9.64 t/s
[38191] 4.03.590.366 I slot print_timing: id  3 | task 0 | n_decoded =   2055, tg =   9.64 t/s
[38191] 4.06.618.812 I slot print_timing: id  3 | task 0 | n_decoded =   2084, tg =   9.64 t/s
[38191] 4.09.643.104 I slot print_timing: id  3 | task 0 | n_decoded =   2113, tg =   9.63 t/s
[38191] 4.12.666.961 I slot print_timing: id  3 | task 0 | n_decoded =   2142, tg =   9.63 t/s
[38191] 4.15.693.232 I slot print_timing: id  3 | task 0 | n_decoded =   2171, tg =   9.63 t/s
[38191] 4.18.719.114 I slot print_timing: id  3 | task 0 | n_decoded =   2200, tg =   9.63 t/s
[38191] 4.21.744.274 I slot print_timing: id  3 | task 0 | n_decoded =   2229, tg =   9.63 t/s
[38191] 4.24.767.954 I slot print_timing: id  3 | task 0 | n_decoded =   2258, tg =   9.63 t/s
[38191] 4.27.790.583 I slot print_timing: id  3 | task 0 | n_decoded =   2287, tg =   9.63 t/s
[38191] 4.30.817.883 I slot print_timing: id  3 | task 0 | n_decoded =   2316, tg =   9.63 t/s
[38191] 4.33.847.443 I slot print_timing: id  3 | task 0 | n_decoded =   2345, tg =   9.63 t/s
[38191] 4.36.873.680 I slot print_timing: id  3 | task 0 | n_decoded =   2374, tg =   9.63 t/s
[38191] 4.39.899.923 I slot print_timing: id  3 | task 0 | n_decoded =   2403, tg =   9.63 t/s
[38191] 4.42.927.603 I slot print_timing: id  3 | task 0 | n_decoded =   2432, tg =   9.63 t/s
[38191] 4.45.957.139 I slot print_timing: id  3 | task 0 | n_decoded =   2461, tg =   9.63 t/s
[38191] 4.48.986.860 I slot print_timing: id  3 | task 0 | n_decoded =   2490, tg =   9.63 t/s
[38191] 4.52.013.990 I slot print_timing: id  3 | task 0 | n_decoded =   2519, tg =   9.63 t/s
[38191] 4.55.040.602 I slot print_timing: id  3 | task 0 | n_decoded =   2548, tg =   9.63 t/s
[38191] 4.58.073.887 I slot print_timing: id  3 | task 0 | n_decoded =   2577, tg =   9.62 t/s
[38191] 5.01.105.518 I slot print_timing: id  3 | task 0 | n_decoded =   2606, tg =   9.62 t/s
[38191] 5.04.133.280 I slot print_timing: id  3 | task 0 | n_decoded =   2635, tg =   9.62 t/s
[38191] 5.07.162.421 I slot print_timing: id  3 | task 0 | n_decoded =   2664, tg =   9.62 t/s
[38191] 5.10.189.229 I slot print_timing: id  3 | task 0 | n_decoded =   2693, tg =   9.62 t/s
[38191] 5.13.215.742 I slot print_timing: id  3 | task 0 | n_decoded =   2722, tg =   9.62 t/s
[38191] 5.16.242.421 I slot print_timing: id  3 | task 0 | n_decoded =   2751, tg =   9.62 t/s
[38191] 5.19.272.048 I slot print_timing: id  3 | task 0 | n_decoded =   2780, tg =   9.62 t/s
[38191] 5.22.299.298 I slot print_timing: id  3 | task 0 | n_decoded =   2809, tg =   9.62 t/s
[38191] 5.25.333.458 I slot print_timing: id  3 | task 0 | n_decoded =   2838, tg =   9.62 t/s
[38191] 5.28.363.261 I slot print_timing: id  3 | task 0 | n_decoded =   2867, tg =   9.62 t/s
[38191] 5.31.392.359 I slot print_timing: id  3 | task 0 | n_decoded =   2896, tg =   9.62 t/s
[38191] 5.34.427.338 I slot print_timing: id  3 | task 0 | n_decoded =   2925, tg =   9.62 t/s
[38191] 5.37.456.867 I slot print_timing: id  3 | task 0 | n_decoded =   2954, tg =   9.62 t/s
[38191] 5.40.486.550 I slot print_timing: id  3 | task 0 | n_decoded =   2983, tg =   9.62 t/s
[38191] 5.43.515.769 I slot print_timing: id  3 | task 0 | n_decoded =   3012, tg =   9.62 t/s
[38191] 5.46.547.306 I slot print_timing: id  3 | task 0 | n_decoded =   3041, tg =   9.62 t/s
[38191] 5.49.579.137 I slot print_timing: id  3 | task 0 | n_decoded =   3070, tg =   9.62 t/s
[38191] 5.52.615.050 I slot print_timing: id  3 | task 0 | n_decoded =   3099, tg =   9.62 t/s
[38191] 5.55.645.313 I slot print_timing: id  3 | task 0 | n_decoded =   3128, tg =   9.62 t/s
[38191] 5.57.630.819 I slot print_timing: id  3 | task 0 | prompt eval time =    1138.15 ms /   759 tokens (    1.50 ms per token,   666.87 tokens per second)
[38191] 5.57.630.822 I slot print_timing: id  3 | task 0 |        eval time =  327303.46 ms /  3147 tokens (  104.00 ms per token,     9.61 tokens per second)
[38191] 5.57.630.823 I slot print_timing: id  3 | task 0 |       total time =  328441.61 ms /  3906 tokens
[38191] 5.57.630.823 I slot print_timing: id  3 | task 0 |    graphs reused =       3133
[38191] 5.57.630.851 I slot      release: id  3 | task 0 | stop processing: n_tokens = 3905, truncated = 0
```
