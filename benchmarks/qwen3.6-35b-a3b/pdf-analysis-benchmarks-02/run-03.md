# Run 03

## Settings

```ini
[unsloth/qwen3.6-35B-A3B]
model = /home/saumen/.cache/huggingface/hub/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf
alias = Qwen3.6-35B-A3B
ctx-size = 100000

spec-type = draft-mtp
spec-draft-n-max = 3
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
4.03.527.760 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 42863
[42863] 3.54.960.235 I srv  params_from_: Chat format: peg-native
[42863] 3.54.960.495 I slot get_availabl: id  2 | task -1 | selected slot by LRU, t_last = -1
[42863] 3.54.960.498 I srv  get_availabl: updating prompt cache
[42863] 3.54.960.500 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[42863] 3.54.960.502 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[42863] 3.54.960.503 I srv  get_availabl: prompt cache update took 0.01 ms
[42863] 3.54.960.553 I slot launch_slot_: id  2 | task 1513 | processing task, is_child = 0
[42863] 3.54.960.554 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[42863] 3.54.960.765 W srv   prompt_save:  - saving prompt with length 4118, total state size = 151.443 MiB (draft: 8.122 MiB)
[42863] 3.55.028.884 I slot prompt_clear: id  3 | task -1 | clearing prompt with 4118 tokens
[42863] 3.55.029.679 I srv        update:  - cache state: 1 prompts, 214.404 MiB (limits: 8192.000 MiB, 100096 tokens, 157341 est)
[42863] 3.55.029.682 I srv        update:    - prompt 0xbb5105d72a00:    4118 tokens, checkpoints:  1,   214.404 MiB
[42863] 3.58.281.792 I slot print_timing: id  2 | task 1513 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.25 s / 1889.42 tokens per second
[42863] 3.59.385.751 I slot print_timing: id  2 | task 1513 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.36 s / 1880.73 tokens per second
[42863] 3.59.386.034 I slot update_slots: id  2 | task 1513 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[42863] 3.59.413.115 I slot create_check: id  2 | task 1513 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[42863] 4.00.123.569 I slot print_timing: id  2 | task 1513 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.09 s / 1842.13 tokens per second
[42863] 4.00.150.400 I slot create_check: id  2 | task 1513 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[42863] 4.00.431.938 I slot print_timing: id  2 | task 1513 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.40 s / 1831.75 tokens per second
[42863] 4.00.462.281 I slot create_check: id  2 | task 1513 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[42863] 4.01.960.870 I slot print_timing: id  2 | task 1513 | n_decoded =    102, tg =  69.66 t/s
[42863] 4.04.978.435 I slot print_timing: id  2 | task 1513 | n_decoded =    341, tg =  76.08 t/s
[42863] 4.07.983.325 I slot print_timing: id  2 | task 1513 | n_decoded =    575, tg =  76.80 t/s
[42863] 4.10.988.224 I slot print_timing: id  2 | task 1513 | n_decoded =    798, tg =  76.06 t/s
[42863] 4.14.010.245 I slot print_timing: id  2 | task 1513 | n_decoded =    981, tg =  72.59 t/s
[42863] 4.17.021.274 I slot print_timing: id  2 | task 1513 | n_decoded =   1159, tg =  70.14 t/s
[42863] 4.20.038.910 I slot print_timing: id  2 | task 1513 | n_decoded =   1339, tg =  68.52 t/s
[42863] 4.23.061.390 I slot print_timing: id  2 | task 1513 | n_decoded =   1510, tg =  66.92 t/s
[42863] 4.26.062.026 I slot print_timing: id  2 | task 1513 | n_decoded =   1687, tg =  65.99 t/s
[42863] 4.29.101.922 I slot print_timing: id  2 | task 1513 | n_decoded =   1869, tg =  65.34 t/s
[42863] 4.32.103.855 I slot print_timing: id  2 | task 1513 | n_decoded =   2039, tg =  64.51 t/s
[42863] 4.35.108.901 I slot print_timing: id  2 | task 1513 | n_decoded =   2202, tg =  63.62 t/s
[42863] 4.38.118.150 I slot print_timing: id  2 | task 1513 | n_decoded =   2373, tg =  63.08 t/s
[42863] 4.41.150.129 I slot print_timing: id  2 | task 1513 | n_decoded =   2577, tg =  63.39 t/s
[42863] 4.44.170.041 I slot print_timing: id  2 | task 1513 | n_decoded =   2792, tg =  63.93 t/s
[42863] 4.47.193.384 I slot print_timing: id  2 | task 1513 | n_decoded =   2972, tg =  63.64 t/s
[42863] 4.50.239.141 I slot print_timing: id  2 | task 1513 | n_decoded =   3161, tg =  63.55 t/s
[42863] 4.53.265.063 I slot print_timing: id  2 | task 1513 | n_decoded =   3357, tg =  63.62 t/s
[42863] 4.56.277.513 I slot print_timing: id  2 | task 1513 | n_decoded =   3532, tg =  63.32 t/s
[42863] 4.59.295.097 I slot print_timing: id  2 | task 1513 | n_decoded =   3741, tg =  63.62 t/s
[42863] 5.02.325.047 I slot print_timing: id  2 | task 1513 | n_decoded =   3947, tg =  63.84 t/s
[42863] 5.05.345.349 I slot print_timing: id  2 | task 1513 | n_decoded =   4167, tg =  64.26 t/s
[42863] 5.08.389.548 I slot print_timing: id  2 | task 1513 | n_decoded =   4348, tg =  64.04 t/s
[42863] 5.11.390.627 I slot print_timing: id  2 | task 1513 | n_decoded =   4533, tg =  63.94 t/s
[42863] 5.14.395.232 I slot print_timing: id  2 | task 1513 | n_decoded =   4711, tg =  63.75 t/s
[42863] 5.17.412.811 I slot print_timing: id  2 | task 1513 | n_decoded =   4897, tg =  63.67 t/s
[42863] 5.20.435.429 I slot print_timing: id  2 | task 1513 | n_decoded =   5079, tg =  63.54 t/s
[42863] 5.23.458.904 I slot print_timing: id  2 | task 1513 | n_decoded =   5251, tg =  63.29 t/s
[42863] 5.26.480.743 I slot print_timing: id  2 | task 1513 | n_decoded =   5422, tg =  63.06 t/s
[42863] 5.29.048.113 I slot print_timing: id  2 | task 1513 | prompt eval time =    5466.49 ms /  9899 tokens (    0.55 ms per token,  1810.85 tokens per second)
[42863] 5.29.048.120 I slot print_timing: id  2 | task 1513 |        eval time =   88551.53 ms /  5563 tokens (   15.92 ms per token,    62.82 tokens per second)
[42863] 5.29.048.121 I slot print_timing: id  2 | task 1513 |       total time =   94018.01 ms / 15462 tokens
[42863] 5.29.048.121 I slot print_timing: id  2 | task 1513 |    graphs reused =       1502
[42863] 5.29.048.122 I slot print_timing: id  2 | task 1513 | draft acceptance = 0.90356 ( 3120 accepted /  3453 generated)
[42863] 5.29.048.134 I statistics        draft-mtp: #calls(b,g,a) =    2   3954   2842, #gen drafts =   2842, #acc drafts =  2712, #gen tokens =   6222, #acc tokens =  5649, dur(b,g,a) = 0.002, 26039.316, 1.806 ms
[42863] 5.29.048.362 I slot      release: id  2 | task 1513 | stop processing: n_tokens = 15463, truncated = 0
[42863] 5.29.048.382 I srv  update_slots: all slots are idle
```
