# Run 03

## Settings

```ini
[unsloth/qwen3.6-35B-A3B]
model = /home/saumen/.cache/huggingface/hub/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf
alias = Qwen3.6-35B-A3B
ctx-size = 100000

spec-type = draft-mtp
spec-draft-n-max = 5
draft-p-min = 0.75

temp = 0.6
top-p = 0.95

mmproj =
flash-attn = true
kv-unified = true

cache-type-k = q8_0
cache-type-v = q8_0

cont-batching = true
parallel = 32
```

## Outcome

```text
1.00.707.329 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 53887
[53887] 0.38.819.625 I srv  params_from_: Chat format: peg-native
[53887] 0.38.820.185 I slot get_availabl: id  2 | task -1 | selected slot by LRU, t_last = -1
[53887] 0.38.820.190 I srv  get_availabl: updating prompt cache
[53887] 0.38.820.192 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[53887] 0.38.820.194 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[53887] 0.38.820.195 I srv  get_availabl: prompt cache update took 0.01 ms
[53887] 0.38.820.255 I slot launch_slot_: id  2 | task 176 | processing task, is_child = 0
[53887] 0.38.820.256 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[53887] 0.38.820.369 W srv   prompt_save:  - saving prompt with length 625, total state size = 76.265 MiB (draft: 1.233 MiB)
[53887] 0.38.861.521 I slot prompt_clear: id  3 | task -1 | clearing prompt with 625 tokens
[53887] 0.38.861.727 I srv        update:  - cache state: 1 prompts, 139.402 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[53887] 0.38.861.728 I srv        update:    - prompt 0xc6c7d3276470:     625 tokens, checkpoints:  1,   139.402 MiB
[53887] 0.42.122.133 I slot print_timing: id  2 | task 176 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.26 s / 1884.46 tokens per second
[53887] 0.43.218.867 I slot print_timing: id  2 | task 176 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.36 s / 1880.16 tokens per second
[53887] 0.43.219.076 I slot update_slots: id  2 | task 176 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[53887] 0.43.242.667 I slot create_check: id  2 | task 176 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[53887] 0.43.957.008 I slot print_timing: id  2 | task 176 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.10 s / 1841.53 tokens per second
[53887] 0.43.982.609 I slot create_check: id  2 | task 176 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[53887] 0.44.266.142 I slot print_timing: id  2 | task 176 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.40 s / 1830.93 tokens per second
[53887] 0.44.295.764 I slot create_check: id  2 | task 176 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[53887] 0.45.897.147 I slot print_timing: id  2 | task 176 | n_decoded =    102, tg =  65.20 t/s
[53887] 0.48.912.819 I slot print_timing: id  2 | task 176 | n_decoded =    288, tg =  62.88 t/s
[53887] 0.51.949.888 I slot print_timing: id  2 | task 176 | n_decoded =    529, tg =  69.45 t/s
[53887] 0.54.968.168 I slot print_timing: id  2 | task 176 | n_decoded =    734, tg =  69.01 t/s
[53887] 0.57.970.140 I slot print_timing: id  2 | task 176 | n_decoded =    972, tg =  71.27 t/s
[53887] 1.01.016.428 I slot print_timing: id  2 | task 176 | n_decoded =   1209, tg =  72.47 t/s
[53887] 1.04.019.541 I slot print_timing: id  2 | task 176 | n_decoded =   1382, tg =  70.20 t/s
[53887] 1.07.052.575 I slot print_timing: id  2 | task 176 | n_decoded =   1554, tg =  68.40 t/s
[53887] 1.10.071.952 I slot print_timing: id  2 | task 176 | n_decoded =   1732, tg =  67.29 t/s
[53887] 1.13.104.783 I slot print_timing: id  2 | task 176 | n_decoded =   1919, tg =  66.70 t/s
[53887] 1.16.112.589 I slot print_timing: id  2 | task 176 | n_decoded =   2105, tg =  66.24 t/s
[53887] 1.19.127.044 I slot print_timing: id  2 | task 176 | n_decoded =   2272, tg =  65.30 t/s
[53887] 1.22.127.337 I slot print_timing: id  2 | task 176 | n_decoded =   2429, tg =  64.27 t/s
[53887] 1.25.130.235 I slot print_timing: id  2 | task 176 | n_decoded =   2601, tg =  63.75 t/s
[53887] 1.28.176.402 I slot print_timing: id  2 | task 176 | n_decoded =   2769, tg =  63.16 t/s
[53887] 1.31.210.166 I slot print_timing: id  2 | task 176 | n_decoded =   2936, tg =  62.63 t/s
[53887] 1.34.224.749 I slot print_timing: id  2 | task 176 | n_decoded =   3090, tg =  61.93 t/s
[53887] 1.37.234.715 I slot print_timing: id  2 | task 176 | n_decoded =   3266, tg =  61.74 t/s
[53887] 1.40.269.142 I slot print_timing: id  2 | task 176 | n_decoded =   3470, tg =  62.03 t/s
[53887] 1.43.304.479 I slot print_timing: id  2 | task 176 | n_decoded =   3657, tg =  62.01 t/s
[53887] 1.46.332.880 I slot print_timing: id  2 | task 176 | n_decoded =   3846, tg =  62.03 t/s
[53887] 1.49.355.736 I slot print_timing: id  2 | task 176 | n_decoded =   4039, tg =  62.12 t/s
[53887] 1.52.380.743 I slot print_timing: id  2 | task 176 | n_decoded =   4221, tg =  62.03 t/s
[53887] 1.55.405.211 I slot print_timing: id  2 | task 176 | n_decoded =   4461, tg =  62.77 t/s
[53887] 1.58.430.385 I slot print_timing: id  2 | task 176 | n_decoded =   4678, tg =  63.13 t/s
[53887] 2.01.457.473 I slot print_timing: id  2 | task 176 | n_decoded =   4861, tg =  63.03 t/s
[53887] 2.04.480.986 I slot print_timing: id  2 | task 176 | n_decoded =   5042, tg =  62.91 t/s
[53887] 2.07.494.195 I slot print_timing: id  2 | task 176 | n_decoded =   5214, tg =  62.70 t/s
[53887] 2.10.528.167 I slot print_timing: id  2 | task 176 | n_decoded =   5397, tg =  62.61 t/s
[53887] 2.13.530.747 I slot print_timing: id  2 | task 176 | n_decoded =   5586, tg =  62.62 t/s
[53887] 2.16.536.388 I slot print_timing: id  2 | task 176 | n_decoded =   5750, tg =  62.36 t/s
[53887] 2.19.537.396 I slot print_timing: id  2 | task 176 | n_decoded =   5914, tg =  62.12 t/s
[53887] 2.22.550.404 I slot print_timing: id  2 | task 176 | n_decoded =   6073, tg =  61.83 t/s
[53887] 2.22.853.116 I slot print_timing: id  2 | task 176 | prompt eval time =    5470.75 ms /  9899 tokens (    0.55 ms per token,  1809.44 tokens per second)
[53887] 2.22.853.119 I slot print_timing: id  2 | task 176 |        eval time =   98520.49 ms /  6087 tokens (   16.19 ms per token,    61.78 tokens per second)
[53887] 2.22.853.120 I slot print_timing: id  2 | task 176 |       total time =  103991.24 ms / 15986 tokens
[53887] 2.22.853.120 I slot print_timing: id  2 | task 176 |    graphs reused =        702
[53887] 2.22.853.121 I slot print_timing: id  2 | task 176 | draft acceptance = 0.86198 ( 3666 accepted /  4253 generated)
[53887] 2.22.853.132 I statistics        draft-mtp: #calls(b,g,a) =    2   2597   1769, #gen drafts =   1769, #acc drafts =  1674, #gen tokens =   4588, #acc tokens =  3950, dur(b,g,a) = 0.001, 20584.934, 0.887 ms
[53887] 2.22.853.345 I slot      release: id  2 | task 176 | stop processing: n_tokens = 15989, truncated = 0
[53887] 2.22.853.365 I srv  update_slots: all slots are idle
```
