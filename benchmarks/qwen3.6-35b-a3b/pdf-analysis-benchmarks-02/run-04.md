# Run 03

## Settings

```ini
[unsloth/qwen3.6-35B-A3B]
model = /home/saumen/.cache/huggingface/hub/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf
alias = Qwen3.6-35B-A3B
ctx-size = 100000

spec-type = draft-mtp
spec-draft-n-max = 4
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
1.33.818.686 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 49965
[49965] 1.24.582.814 I srv  params_from_: Chat format: peg-native
[49965] 1.24.583.397 I slot get_availabl: id  2 | task -1 | selected slot by LRU, t_last = -1
[49965] 1.24.583.405 I srv  get_availabl: updating prompt cache
[49965] 1.24.583.409 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[49965] 1.24.583.413 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[49965] 1.24.583.413 I srv  get_availabl: prompt cache update took 0.01 ms
[49965] 1.24.583.516 I slot launch_slot_: id  2 | task 495 | processing task, is_child = 0
[49965] 1.24.583.517 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[49965] 1.24.583.665 W srv   prompt_save:  - saving prompt with length 1387, total state size = 92.665 MiB (draft: 2.735 MiB)
[49965] 1.24.631.895 I slot prompt_clear: id  3 | task -1 | clearing prompt with 1387 tokens
[49965] 1.24.632.197 I srv        update:  - cache state: 1 prompts, 155.743 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[49965] 1.24.632.198 I srv        update:    - prompt 0xb03a0ceed300:    1387 tokens, checkpoints:  1,   155.743 MiB
[49965] 1.27.877.588 I slot print_timing: id  2 | task 495 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.25 s / 1893.22 tokens per second
[49965] 1.28.978.116 I slot print_timing: id  2 | task 495 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.35 s / 1885.03 tokens per second
[49965] 1.28.978.390 I slot update_slots: id  2 | task 495 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[49965] 1.29.005.202 I slot create_check: id  2 | task 495 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[49965] 1.29.721.806 I slot print_timing: id  2 | task 495 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.09 s / 1843.60 tokens per second
[49965] 1.29.748.182 I slot create_check: id  2 | task 495 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[49965] 1.30.030.850 I slot print_timing: id  2 | task 495 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.40 s / 1832.90 tokens per second
[49965] 1.30.061.199 I slot create_check: id  2 | task 495 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[49965] 1.31.485.374 I slot print_timing: id  2 | task 495 | n_decoded =    101, tg =  72.77 t/s
[49965] 1.34.526.233 I slot print_timing: id  2 | task 495 | n_decoded =    353, tg =  79.71 t/s
[49965] 1.37.555.569 I slot print_timing: id  2 | task 495 | n_decoded =    580, tg =  77.77 t/s
[49965] 1.40.565.854 I slot print_timing: id  2 | task 495 | n_decoded =    804, tg =  76.80 t/s
[49965] 1.43.572.332 I slot print_timing: id  2 | task 495 | n_decoded =   1002, tg =  74.36 t/s
[49965] 1.46.589.670 I slot print_timing: id  2 | task 495 | n_decoded =   1174, tg =  71.19 t/s
[49965] 1.49.602.314 I slot print_timing: id  2 | task 495 | n_decoded =   1362, tg =  69.83 t/s
[49965] 1.52.613.847 I slot print_timing: id  2 | task 495 | n_decoded =   1524, tg =  67.68 t/s
[49965] 1.55.633.136 I slot print_timing: id  2 | task 495 | n_decoded =   1707, tg =  66.85 t/s
[49965] 1.58.658.538 I slot print_timing: id  2 | task 495 | n_decoded =   1904, tg =  66.66 t/s
[49965] 2.01.709.396 I slot print_timing: id  2 | task 495 | n_decoded =   2082, tg =  65.86 t/s
[49965] 2.04.721.862 I slot print_timing: id  2 | task 495 | n_decoded =   2258, tg =  65.21 t/s
[49965] 2.07.737.813 I slot print_timing: id  2 | task 495 | n_decoded =   2430, tg =  64.56 t/s
[49965] 2.10.751.945 I slot print_timing: id  2 | task 495 | n_decoded =   2588, tg =  63.66 t/s
[49965] 2.13.776.920 I slot print_timing: id  2 | task 495 | n_decoded =   2785, tg =  63.76 t/s
[49965] 2.16.792.044 I slot print_timing: id  2 | task 495 | n_decoded =   2998, tg =  64.20 t/s
[49965] 2.19.809.503 I slot print_timing: id  2 | task 495 | n_decoded =   3195, tg =  64.27 t/s
[49965] 2.22.817.202 I slot print_timing: id  2 | task 495 | n_decoded =   3369, tg =  63.90 t/s
[49965] 2.25.823.977 I slot print_timing: id  2 | task 495 | n_decoded =   3538, tg =  63.49 t/s
[49965] 2.28.836.021 I slot print_timing: id  2 | task 495 | n_decoded =   3703, tg =  63.04 t/s
[49965] 2.31.862.945 I slot print_timing: id  2 | task 495 | n_decoded =   3902, tg =  63.17 t/s
[49965] 2.34.883.364 I slot print_timing: id  2 | task 495 | n_decoded =   4111, tg =  63.46 t/s
[49965] 2.37.895.717 I slot print_timing: id  2 | task 495 | n_decoded =   4297, tg =  63.38 t/s
[49965] 2.40.915.024 I slot print_timing: id  2 | task 495 | n_decoded =   4524, tg =  63.88 t/s
[49965] 2.43.966.337 I slot print_timing: id  2 | task 495 | n_decoded =   4719, tg =  63.88 t/s
[49965] 2.46.980.647 I slot print_timing: id  2 | task 495 | n_decoded =   4905, tg =  63.80 t/s
[49965] 2.49.983.484 I slot print_timing: id  2 | task 495 | n_decoded =   5091, tg =  63.73 t/s
[49965] 2.52.997.041 I slot print_timing: id  2 | task 495 | n_decoded =   5266, tg =  63.52 t/s
[49965] 2.56.045.101 I slot print_timing: id  2 | task 495 | n_decoded =   5459, tg =  63.52 t/s
[49965] 2.59.067.194 I slot print_timing: id  2 | task 495 | n_decoded =   5633, tg =  63.31 t/s
[49965] 3.02.069.395 I slot print_timing: id  2 | task 495 | n_decoded =   5799, tg =  63.05 t/s
[49965] 3.05.078.778 I slot print_timing: id  2 | task 495 | n_decoded =   5998, tg =  63.15 t/s
[49965] 3.07.590.849 I slot print_timing: id  2 | task 495 | prompt eval time =    5465.08 ms /  9899 tokens (    0.55 ms per token,  1811.32 tokens per second)
[49965] 3.07.590.852 I slot print_timing: id  2 | task 495 |        eval time =   97493.37 ms /  6143 tokens (   15.87 ms per token,    63.01 tokens per second)
[49965] 3.07.590.853 I slot print_timing: id  2 | task 495 |       total time =  102958.45 ms / 16042 tokens
[49965] 3.07.590.853 I slot print_timing: id  2 | task 495 |    graphs reused =        892
[49965] 3.07.590.854 I slot print_timing: id  2 | task 495 | draft acceptance = 0.88546 ( 3610 accepted /  4077 generated)
[49965] 3.07.590.864 I statistics        draft-mtp: #calls(b,g,a) =    2   3027   2060, #gen drafts =   2060, #acc drafts =  1953, #gen tokens =   4973, #acc tokens =  4367, dur(b,g,a) = 0.000, 21997.581, 0.738 ms
[49965] 3.07.591.091 I slot      release: id  2 | task 495 | stop processing: n_tokens = 16044, truncated = 0
[49965] 3.07.591.111 I srv  update_slots: all slots are idle
```
