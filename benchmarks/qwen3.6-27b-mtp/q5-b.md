# Run A

## Settings

```ini
[unsloth/Qwen3.6-27B-UD-Q5_K_XL-MTP-B]
model = /home/saumen/.lmstudio/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-UD-Q5_K_XL.gguf
alias = unsloth/Qwen3.6-27B-UD-Q5_K_XL-MTP-B
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
[43127] 0.20.583.400 I srv  params_from_: Chat format: peg-native
[43127] 0.20.583.632 I slot get_availabl: id  3 | task -1 | selected slot by LRU, t_last = -1
[43127] 0.20.583.635 I srv  get_availabl: updating prompt cache
[43127] 0.20.583.638 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[43127] 0.20.583.640 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 50176 tokens, 8589934592 est)
[43127] 0.20.583.640 I srv  get_availabl: prompt cache update took 0.01 ms
[43127] 0.20.583.672 I slot launch_slot_: id  3 | task 0 | processing task, is_child = 0
[43127] 0.21.136.050 I slot create_check: id  3 | task 0 | created context checkpoint 1 of 32 (pos_min = 242, pos_max = 242, n_tokens = 243, size = 150.135 MiB)
[43127] 0.21.861.205 I slot create_check: id  3 | task 0 | created context checkpoint 2 of 32 (pos_min = 754, pos_max = 754, n_tokens = 755, size = 151.207 MiB)
[43127] 0.26.461.032 I slot print_timing: id  3 | task 0 | n_decoded =    103, tg =  23.01 t/s
[43127] 0.29.520.383 I slot print_timing: id  3 | task 0 | n_decoded =    168, tg =  22.29 t/s
[43127] 0.32.580.849 I slot print_timing: id  3 | task 0 | n_decoded =    239, tg =  22.55 t/s
[43127] 0.35.650.440 I slot print_timing: id  3 | task 0 | n_decoded =    295, tg =  21.59 t/s
[43127] 0.38.722.670 I slot print_timing: id  3 | task 0 | n_decoded =    353, tg =  21.09 t/s
[43127] 0.41.788.841 I slot print_timing: id  3 | task 0 | n_decoded =    402, tg =  20.30 t/s
[43127] 0.44.856.785 I slot print_timing: id  3 | task 0 | n_decoded =    468, tg =  20.46 t/s
[43127] 0.47.939.471 I slot print_timing: id  3 | task 0 | n_decoded =    542, tg =  20.88 t/s
[43127] 0.51.013.236 I slot print_timing: id  3 | task 0 | n_decoded =    610, tg =  21.01 t/s
[43127] 0.54.087.023 I slot print_timing: id  3 | task 0 | n_decoded =    684, tg =  21.31 t/s
[43127] 0.57.159.067 I slot print_timing: id  3 | task 0 | n_decoded =    758, tg =  21.55 t/s
[43127] 1.00.248.423 I slot print_timing: id  3 | task 0 | n_decoded =    834, tg =  21.80 t/s
[43127] 1.03.336.331 I slot print_timing: id  3 | task 0 | n_decoded =    917, tg =  22.18 t/s
[43127] 1.06.421.476 I slot print_timing: id  3 | task 0 | n_decoded =   1001, tg =  22.53 t/s
[43127] 1.09.518.575 I slot print_timing: id  3 | task 0 | n_decoded =   1083, tg =  22.78 t/s
[43127] 1.12.608.732 I slot print_timing: id  3 | task 0 | n_decoded =   1150, tg =  22.72 t/s
[43127] 1.15.695.941 I slot print_timing: id  3 | task 0 | n_decoded =   1223, tg =  22.77 t/s
[43127] 1.18.797.923 I slot print_timing: id  3 | task 0 | n_decoded =   1308, tg =  23.02 t/s
[43127] 1.21.893.484 I slot print_timing: id  3 | task 0 | n_decoded =   1377, tg =  22.98 t/s
[43127] 1.24.988.335 I slot print_timing: id  3 | task 0 | n_decoded =   1451, tg =  23.03 t/s
[43127] 1.28.083.978 I slot print_timing: id  3 | task 0 | n_decoded =   1514, tg =  22.90 t/s
[43127] 1.31.189.166 I slot print_timing: id  3 | task 0 | n_decoded =   1590, tg =  22.98 t/s
[43127] 1.34.279.247 I slot print_timing: id  3 | task 0 | n_decoded =   1646, tg =  22.77 t/s
[43127] 1.37.373.653 I slot print_timing: id  3 | task 0 | n_decoded =   1695, tg =  22.48 t/s
[43127] 1.40.468.215 I slot print_timing: id  3 | task 0 | n_decoded =   1751, tg =  22.31 t/s
[43127] 1.43.577.670 I slot print_timing: id  3 | task 0 | n_decoded =   1821, tg =  22.32 t/s
[43127] 1.46.686.999 I slot print_timing: id  3 | task 0 | n_decoded =   1887, tg =  22.28 t/s
[43127] 1.49.783.850 I slot print_timing: id  3 | task 0 | n_decoded =   1951, tg =  22.22 t/s
[43127] 1.52.884.322 I slot print_timing: id  3 | task 0 | n_decoded =   2032, tg =  22.35 t/s
[43127] 1.55.998.806 I slot print_timing: id  3 | task 0 | n_decoded =   2106, tg =  22.40 t/s
[43127] 1.59.104.450 I slot print_timing: id  3 | task 0 | n_decoded =   2170, tg =  22.34 t/s
[43127] 2.02.203.074 I slot print_timing: id  3 | task 0 | n_decoded =   2229, tg =  22.24 t/s
[43127] 2.05.310.381 I slot print_timing: id  3 | task 0 | n_decoded =   2285, tg =  22.11 t/s
[43127] 2.08.418.255 I slot print_timing: id  3 | task 0 | n_decoded =   2339, tg =  21.98 t/s
[43127] 2.11.526.324 I slot print_timing: id  3 | task 0 | n_decoded =   2408, tg =  21.98 t/s
[43127] 2.14.633.721 I slot print_timing: id  3 | task 0 | n_decoded =   2479, tg =  22.01 t/s
[43127] 2.17.741.292 I slot print_timing: id  3 | task 0 | n_decoded =   2543, tg =  21.97 t/s
[43127] 2.20.856.858 I slot print_timing: id  3 | task 0 | n_decoded =   2602, tg =  21.89 t/s
[43127] 2.23.961.995 I slot print_timing: id  3 | task 0 | n_decoded =   2667, tg =  21.86 t/s
[43127] 2.27.064.350 I slot print_timing: id  3 | task 0 | n_decoded =   2726, tg =  21.79 t/s
[43127] 2.30.175.330 I slot print_timing: id  3 | task 0 | n_decoded =   2799, tg =  21.83 t/s
[43127] 2.33.293.183 I slot print_timing: id  3 | task 0 | n_decoded =   2873, tg =  21.88 t/s
[43127] 2.36.398.381 I slot print_timing: id  3 | task 0 | n_decoded =   2931, tg =  21.81 t/s
[43127] 2.39.508.440 I slot print_timing: id  3 | task 0 | n_decoded =   3005, tg =  21.85 t/s
[43127] 2.42.615.929 I slot print_timing: id  3 | task 0 | n_decoded =   3070, tg =  21.83 t/s
[43127] 2.45.745.889 I slot print_timing: id  3 | task 0 | n_decoded =   3148, tg =  21.90 t/s
[43127] 2.48.869.290 I slot print_timing: id  3 | task 0 | n_decoded =   3230, tg =  21.99 t/s
[43127] 2.51.980.109 I slot print_timing: id  3 | task 0 | n_decoded =   3303, tg =  22.02 t/s
[43127] 2.55.102.553 I slot print_timing: id  3 | task 0 | n_decoded =   3360, tg =  21.94 t/s
[43127] 2.58.224.418 I slot print_timing: id  3 | task 0 | n_decoded =   3430, tg =  21.95 t/s
[43127] 3.01.337.727 I slot print_timing: id  3 | task 0 | n_decoded =   3498, tg =  21.95 t/s
[43127] 3.04.453.243 I slot print_timing: id  3 | task 0 | n_decoded =   3566, tg =  21.95 t/s
[43127] 3.07.577.191 I slot print_timing: id  3 | task 0 | n_decoded =   3621, tg =  21.87 t/s
[43127] 3.10.701.339 I slot print_timing: id  3 | task 0 | n_decoded =   3685, tg =  21.84 t/s
[43127] 3.13.832.526 I slot print_timing: id  3 | task 0 | n_decoded =   3753, tg =  21.84 t/s
[43127] 3.16.949.176 I slot print_timing: id  3 | task 0 | n_decoded =   3821, tg =  21.84 t/s
[43127] 3.20.083.382 I slot print_timing: id  3 | task 0 | n_decoded =   3885, tg =  21.81 t/s
[43127] 3.23.212.468 I slot print_timing: id  3 | task 0 | n_decoded =   3947, tg =  21.78 t/s
[43127] 3.26.336.067 I slot print_timing: id  3 | task 0 | n_decoded =   4009, tg =  21.75 t/s
[43127] 3.26.478.517 I slot print_timing: id  3 | task 0 | prompt eval time =    1400.69 ms /   759 tokens (    1.85 ms per token,   541.88 tokens per second)
[43127] 3.26.478.520 I slot print_timing: id  3 | task 0 |        eval time =  184494.10 ms /  4013 tokens (   45.97 ms per token,    21.75 tokens per second)
[43127] 3.26.478.521 I slot print_timing: id  3 | task 0 |       total time =  185894.79 ms /  4772 tokens
[43127] 3.26.478.521 I slot print_timing: id  3 | task 0 |    graphs reused =       1293
[43127] 3.26.478.522 I slot print_timing: id  3 | task 0 | draft acceptance = 0.68831 ( 2703 accepted /  3927 generated)
[43127] 3.26.478.538 I statistics        draft-mtp: #calls(b,g,a) =    1   1309   1309, #gen drafts =   1309, #acc drafts =  1120, #gen tokens =   3927, #acc tokens =  2703, dur(b,g,a) = 0.002, 28395.226, 1.373 ms
[43127] 3.26.478.565 I slot      release: id  3 | task 0 | stop processing: n_tokens = 4771, truncated = 0
```
