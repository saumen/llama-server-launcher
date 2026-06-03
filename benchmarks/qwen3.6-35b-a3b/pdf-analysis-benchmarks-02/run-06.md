# Run 03

## Settings

```ini
[unsloth/qwen3.6-35B-A3B]
model = /home/saumen/.cache/huggingface/hub/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf
alias = Qwen3.6-35B-A3B
ctx-size = 100000

spec-type = draft-mtp
spec-draft-n-max = 2
draft-p-min = 0.50

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
0.52.614.764 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 44427
[44427] 0.46.634.022 I srv  params_from_: Chat format: peg-native
[44427] 0.46.634.400 I slot get_availabl: id  2 | task -1 | selected slot by LRU, t_last = -1
[44427] 0.46.634.403 I srv  get_availabl: updating prompt cache
[44427] 0.46.634.405 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[44427] 0.46.634.407 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[44427] 0.46.634.407 I srv  get_availabl: prompt cache update took 0.00 ms
[44427] 0.46.634.453 I slot launch_slot_: id  2 | task 222 | processing task, is_child = 0
[44427] 0.46.634.454 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[44427] 0.46.634.570 W srv   prompt_save:  - saving prompt with length 746, total state size = 78.869 MiB (draft: 1.471 MiB)
[44427] 0.46.680.428 I slot prompt_clear: id  3 | task -1 | clearing prompt with 746 tokens
[44427] 0.46.680.655 I srv        update:  - cache state: 1 prompts, 142.101 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[44427] 0.46.680.657 I srv        update:    - prompt 0xaddd882e4ef0:     746 tokens, checkpoints:  1,   142.101 MiB
[44427] 0.49.888.875 I slot print_timing: id  2 | task 222 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.21 s / 1915.12 tokens per second
[44427] 0.50.982.899 I slot print_timing: id  2 | task 222 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.30 s / 1904.15 tokens per second
[44427] 0.50.983.158 I slot update_slots: id  2 | task 222 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[44427] 0.51.011.038 I slot create_check: id  2 | task 222 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[44427] 0.51.714.012 I slot print_timing: id  2 | task 222 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.03 s / 1864.19 tokens per second
[44427] 0.51.735.342 I slot create_check: id  2 | task 222 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[44427] 0.52.016.123 I slot print_timing: id  2 | task 222 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.34 s / 1854.59 tokens per second
[44427] 0.52.046.789 I slot create_check: id  2 | task 222 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[44427] 0.53.398.294 I slot print_timing: id  2 | task 222 | n_decoded =    100, tg =  75.86 t/s
[44427] 0.56.417.088 I slot print_timing: id  2 | task 222 | n_decoded =    353, tg =  81.39 t/s
[44427] 0.59.436.490 I slot print_timing: id  2 | task 222 | n_decoded =    574, tg =  78.03 t/s
[44427] 1.02.443.600 I slot print_timing: id  2 | task 222 | n_decoded =    807, tg =  77.87 t/s
[44427] 1.05.444.440 I slot print_timing: id  2 | task 222 | n_decoded =   1024, tg =  76.62 t/s
[44427] 1.08.472.763 I slot print_timing: id  2 | task 222 | n_decoded =   1209, tg =  73.75 t/s
[44427] 1.11.504.056 I slot print_timing: id  2 | task 222 | n_decoded =   1388, tg =  71.46 t/s
[44427] 1.14.537.087 I slot print_timing: id  2 | task 222 | n_decoded =   1584, tg =  70.53 t/s
[44427] 1.17.543.176 I slot print_timing: id  2 | task 222 | n_decoded =   1793, tg =  70.42 t/s
[44427] 1.20.556.420 I slot print_timing: id  2 | task 222 | n_decoded =   1974, tg =  69.32 t/s
[44427] 1.23.570.162 I slot print_timing: id  2 | task 222 | n_decoded =   2169, tg =  68.88 t/s
[44427] 1.26.573.597 I slot print_timing: id  2 | task 222 | n_decoded =   2366, tg =  68.59 t/s
[44427] 1.29.596.787 I slot print_timing: id  2 | task 222 | n_decoded =   2556, tg =  68.13 t/s
[44427] 1.32.599.152 I slot print_timing: id  2 | task 222 | n_decoded =   2767, tg =  68.29 t/s
[44427] 1.35.621.145 I slot print_timing: id  2 | task 222 | n_decoded =   2993, tg =  68.74 t/s
[44427] 1.38.650.655 I slot print_timing: id  2 | task 222 | n_decoded =   3231, tg =  69.38 t/s
[44427] 1.41.653.787 I slot print_timing: id  2 | task 222 | n_decoded =   3451, tg =  69.61 t/s
[44427] 1.44.678.999 I slot print_timing: id  2 | task 222 | n_decoded =   3652, tg =  69.43 t/s
[44427] 1.47.680.642 I slot print_timing: id  2 | task 222 | n_decoded =   3847, tg =  69.19 t/s
[44427] 1.50.700.524 I slot print_timing: id  2 | task 222 | n_decoded =   4056, tg =  69.19 t/s
[44427] 1.53.727.499 I slot print_timing: id  2 | task 222 | n_decoded =   4230, tg =  68.62 t/s
[44427] 1.56.758.633 I slot print_timing: id  2 | task 222 | n_decoded =   4432, tg =  68.52 t/s
[44427] 1.59.760.040 I slot print_timing: id  2 | task 222 | n_decoded =   4617, tg =  68.22 t/s
[44427] 2.02.229.022 I slot print_timing: id  2 | task 222 | prompt eval time =    5399.31 ms /  9899 tokens (    0.55 ms per token,  1833.38 tokens per second)
[44427] 2.02.229.026 I slot print_timing: id  2 | task 222 |        eval time =   70148.90 ms /  4758 tokens (   14.74 ms per token,    67.83 tokens per second)
[44427] 2.02.229.026 I slot print_timing: id  2 | task 222 |       total time =   75548.21 ms / 14657 tokens
[44427] 2.02.229.026 I slot print_timing: id  2 | task 222 |    graphs reused =       1417
[44427] 2.02.229.027 I slot print_timing: id  2 | task 222 | draft acceptance = 0.83720 ( 2705 accepted /  3231 generated)
[44427] 2.02.229.040 I statistics        draft-mtp: #calls(b,g,a) =    2   2272   1975, #gen drafts =   1975, #acc drafts =  1753, #gen tokens =   3608, #acc tokens =  3016, dur(b,g,a) = 0.002, 12844.289, 1.117 ms
[44427] 2.02.229.270 I slot      release: id  2 | task 222 | stop processing: n_tokens = 14657, truncated = 0
[44427] 2.02.229.288 I srv  update_slots: all slots are idle
```
