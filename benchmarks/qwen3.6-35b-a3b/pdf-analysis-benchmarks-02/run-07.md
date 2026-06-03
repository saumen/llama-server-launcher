# Run 07

## Settings

```ini
[unsloth/qwen3.6-35B-A3B]
model = /home/saumen/.cache/huggingface/hub/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf
alias = Qwen3.6-35B-A3B
ctx-size = 100000

spec-type = draft-mtp
spec-draft-n-max = 2
draft-p-min = 0.65

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
1.43.138.454 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 36225
[36225] 1.07.753.326 I srv  params_from_: Chat format: peg-native
[36225] 1.07.753.792 I slot get_availabl: id  2 | task -1 | selected slot by LRU, t_last = -1
[36225] 1.07.753.796 I srv  get_availabl: updating prompt cache
[36225] 1.07.753.799 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[36225] 1.07.753.801 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[36225] 1.07.753.802 I srv  get_availabl: prompt cache update took 0.01 ms
[36225] 1.07.753.865 I slot launch_slot_: id  2 | task 359 | processing task, is_child = 0
[36225] 1.07.753.866 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[36225] 1.07.753.990 W srv   prompt_save:  - saving prompt with length 1055, total state size = 85.520 MiB (draft: 2.081 MiB)
[36225] 1.07.801.114 I slot prompt_clear: id  3 | task -1 | clearing prompt with 1055 tokens
[36225] 1.07.801.366 I srv        update:  - cache state: 1 prompts, 148.810 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[36225] 1.07.801.367 I srv        update:    - prompt 0xc2906e358e60:    1055 tokens, checkpoints:  1,   148.810 MiB
[36225] 1.11.024.830 I slot print_timing: id  2 | task 359 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.22 s / 1906.07 tokens per second
[36225] 1.12.120.448 I slot print_timing: id  2 | task 359 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.32 s / 1896.74 tokens per second
[36225] 1.12.120.687 I slot update_slots: id  2 | task 359 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[36225] 1.12.147.629 I slot create_check: id  2 | task 359 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[36225] 1.12.847.855 I slot print_timing: id  2 | task 359 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.05 s / 1859.35 tokens per second
[36225] 1.12.868.929 I slot create_check: id  2 | task 359 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[36225] 1.13.148.855 I slot print_timing: id  2 | task 359 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.35 s / 1850.43 tokens per second
[36225] 1.13.179.257 I slot create_check: id  2 | task 359 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[36225] 1.14.535.994 I slot print_timing: id  2 | task 359 | n_decoded =    100, tg =  75.53 t/s
[36225] 1.17.537.832 I slot print_timing: id  2 | task 359 | n_decoded =    343, tg =  79.29 t/s
[36225] 1.20.571.515 I slot print_timing: id  2 | task 359 | n_decoded =    571, tg =  77.59 t/s
[36225] 1.23.589.219 I slot print_timing: id  2 | task 359 | n_decoded =    803, tg =  77.38 t/s
[36225] 1.26.589.773 I slot print_timing: id  2 | task 359 | n_decoded =   1053, tg =  78.71 t/s
[36225] 1.29.602.234 I slot print_timing: id  2 | task 359 | n_decoded =   1272, tg =  77.61 t/s
[36225] 1.32.613.614 I slot print_timing: id  2 | task 359 | n_decoded =   1461, tg =  75.30 t/s
[36225] 1.35.626.299 I slot print_timing: id  2 | task 359 | n_decoded =   1643, tg =  73.30 t/s
[36225] 1.38.628.978 I slot print_timing: id  2 | task 359 | n_decoded =   1818, tg =  71.53 t/s
[36225] 1.41.648.251 I slot print_timing: id  2 | task 359 | n_decoded =   2005, tg =  70.51 t/s
[36225] 1.44.663.086 I slot print_timing: id  2 | task 359 | n_decoded =   2190, tg =  69.63 t/s
[36225] 1.47.674.028 I slot print_timing: id  2 | task 359 | n_decoded =   2375, tg =  68.92 t/s
[36225] 1.50.702.785 I slot print_timing: id  2 | task 359 | n_decoded =   2553, tg =  68.10 t/s
[36225] 1.53.721.327 I slot print_timing: id  2 | task 359 | n_decoded =   2733, tg =  67.47 t/s
[36225] 1.56.739.005 I slot print_timing: id  2 | task 359 | n_decoded =   2903, tg =  66.69 t/s
[36225] 1.59.748.032 I slot print_timing: id  2 | task 359 | n_decoded =   3088, tg =  66.36 t/s
[36225] 2.02.779.968 I slot print_timing: id  2 | task 359 | n_decoded =   3307, tg =  66.72 t/s
[36225] 2.05.786.992 I slot print_timing: id  2 | task 359 | n_decoded =   3511, tg =  66.78 t/s
[36225] 2.08.813.652 I slot print_timing: id  2 | task 359 | n_decoded =   3691, tg =  66.38 t/s
[36225] 2.11.815.982 I slot print_timing: id  2 | task 359 | n_decoded =   3867, tg =  65.99 t/s
[36225] 2.14.817.997 I slot print_timing: id  2 | task 359 | n_decoded =   4074, tg =  66.13 t/s
[36225] 2.17.851.831 I slot print_timing: id  2 | task 359 | n_decoded =   4274, tg =  66.12 t/s
[36225] 2.20.854.043 I slot print_timing: id  2 | task 359 | n_decoded =   4476, tg =  66.17 t/s
[36225] 2.23.858.091 I slot print_timing: id  2 | task 359 | n_decoded =   4668, tg =  66.08 t/s
[36225] 2.26.885.742 I slot print_timing: id  2 | task 359 | n_decoded =   4893, tg =  66.41 t/s
[36225] 2.29.898.518 I slot print_timing: id  2 | task 359 | n_decoded =   5070, tg =  66.11 t/s
[36225] 2.32.919.541 I slot print_timing: id  2 | task 359 | n_decoded =   5294, tg =  66.42 t/s
[36225] 2.35.929.516 I slot print_timing: id  2 | task 359 | n_decoded =   5480, tg =  66.25 t/s
[36225] 2.38.931.656 I slot print_timing: id  2 | task 359 | n_decoded =   5669, tg =  66.13 t/s
[36225] 2.41.955.823 I slot print_timing: id  2 | task 359 | n_decoded =   5848, tg =  65.90 t/s
[36225] 2.44.958.368 I slot print_timing: id  2 | task 359 | n_decoded =   6015, tg =  65.56 t/s
[36225] 2.47.963.536 I slot print_timing: id  2 | task 359 | n_decoded =   6208, tg =  65.52 t/s
[36225] 2.48.844.212 I slot print_timing: id  2 | task 359 | prompt eval time =    5410.45 ms /  9899 tokens (    0.55 ms per token,  1829.61 tokens per second)
[36225] 2.48.844.216 I slot print_timing: id  2 | task 359 |        eval time =   95632.22 ms /  6270 tokens (   15.25 ms per token,    65.56 tokens per second)
[36225] 2.48.844.217 I slot print_timing: id  2 | task 359 |       total time =  101042.67 ms / 16169 tokens
[36225] 2.48.844.217 I slot print_timing: id  2 | task 359 |    graphs reused =       1664
[36225] 2.48.844.217 I slot print_timing: id  2 | task 359 | draft acceptance = 0.89771 ( 3405 accepted /  3793 generated)
[36225] 2.48.844.228 I statistics        draft-mtp: #calls(b,g,a) =    2   3220   2477, #gen drafts =   2477, #acc drafts =  2301, #gen tokens =   4304, #acc tokens =  3858, dur(b,g,a) = 0.002, 17227.157, 1.162 ms
[36225] 2.48.844.444 I slot      release: id  2 | task 359 | stop processing: n_tokens = 16168, truncated = 0
[36225] 2.48.844.463 I srv  update_slots: all slots are idle
```
