# Run A

## Settings

```ini
[unsloth/qwen3.6-35B-A3B]
model = /home/saumen/.cache/huggingface/hub/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf
alias = Qwen3.6-35B-A3B
ctx-size = 100000

spec-type = draft-mtp
spec-draft-n-max = 2
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
3.18.015.287 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 33471
[33471] 2.43.733.893 I srv  params_from_: Chat format: peg-native
[33471] 2.43.734.169 I slot get_availabl: id  2 | task -1 | selected slot by LRU, t_last = -1
[33471] 2.43.734.173 I srv  get_availabl: updating prompt cache
[33471] 2.43.734.175 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[33471] 2.43.734.178 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[33471] 2.43.734.178 I srv  get_availabl: prompt cache update took 0.00 ms
[33471] 2.43.734.227 I slot launch_slot_: id  2 | task 1161 | processing task, is_child = 0
[33471] 2.43.734.228 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[33471] 2.43.734.409 W srv   prompt_save:  - saving prompt with length 2621, total state size = 119.224 MiB (draft: 5.169 MiB)
[33471] 2.43.771.827 I slot prompt_clear: id  3 | task -1 | clearing prompt with 2621 tokens
[33471] 2.43.772.356 I srv        update:  - cache state: 1 prompts, 119.224 MiB (limits: 8192.000 MiB, 100096 tokens, 180091 est)
[33471] 2.43.772.357 I srv        update:    - prompt 0xb07db42ee860:    2621 tokens, checkpoints:  0,   119.224 MiB
[33471] 2.47.003.684 I slot print_timing: id  2 | task 1161 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.23 s / 1901.49 tokens per second
[33471] 2.48.099.201 I slot print_timing: id  2 | task 1161 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.33 s / 1893.37 tokens per second
[33471] 2.48.099.522 I slot update_slots: id  2 | task 1161 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[33471] 2.48.121.271 I slot create_check: id  2 | task 1161 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[33471] 2.48.823.873 I slot print_timing: id  2 | task 1161 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.05 s / 1857.53 tokens per second
[33471] 2.48.840.606 I slot create_check: id  2 | task 1161 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[33471] 2.49.119.834 I slot print_timing: id  2 | task 1161 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.35 s / 1850.46 tokens per second
[33471] 2.49.144.724 I slot create_check: id  2 | task 1161 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[33471] 2.50.571.996 I slot print_timing: id  2 | task 1161 | n_decoded =    101, tg =  72.51 t/s
[33471] 2.53.582.405 I slot print_timing: id  2 | task 1161 | n_decoded =    340, tg =  77.22 t/s
[33471] 2.56.605.271 I slot print_timing: id  2 | task 1161 | n_decoded =    570, tg =  76.76 t/s
[33471] 2.59.605.884 I slot print_timing: id  2 | task 1161 | n_decoded =    791, tg =  75.86 t/s
[33471] 3.02.608.535 I slot print_timing: id  2 | task 1161 | n_decoded =   1029, tg =  76.62 t/s
[33471] 3.05.619.714 I slot print_timing: id  2 | task 1161 | n_decoded =   1255, tg =  76.34 t/s
[33471] 3.08.632.779 I slot print_timing: id  2 | task 1161 | n_decoded =   1427, tg =  73.35 t/s
[33471] 3.11.641.688 I slot print_timing: id  2 | task 1161 | n_decoded =   1606, tg =  71.50 t/s
[33471] 3.14.656.322 I slot print_timing: id  2 | task 1161 | n_decoded =   1787, tg =  70.14 t/s
[33471] 3.17.662.025 I slot print_timing: id  2 | task 1161 | n_decoded =   1972, tg =  69.23 t/s
[33471] 3.20.673.035 I slot print_timing: id  2 | task 1161 | n_decoded =   2143, tg =  68.04 t/s
[33471] 3.23.675.806 I slot print_timing: id  2 | task 1161 | n_decoded =   2301, tg =  66.70 t/s
[33471] 3.26.679.446 I slot print_timing: id  2 | task 1161 | n_decoded =   2469, tg =  65.84 t/s
[33471] 3.29.707.656 I slot print_timing: id  2 | task 1161 | n_decoded =   2657, tg =  65.56 t/s
[33471] 3.32.723.100 I slot print_timing: id  2 | task 1161 | n_decoded =   2824, tg =  64.85 t/s
[33471] 3.35.742.935 I slot print_timing: id  2 | task 1161 | n_decoded =   3001, tg =  64.45 t/s
[33471] 3.38.743.873 I slot print_timing: id  2 | task 1161 | n_decoded =   3186, tg =  64.28 t/s
[33471] 3.41.746.793 I slot print_timing: id  2 | task 1161 | n_decoded =   3368, tg =  64.07 t/s
[33471] 3.44.776.259 I slot print_timing: id  2 | task 1161 | n_decoded =   3566, tg =  64.14 t/s
[33471] 3.47.800.339 I slot print_timing: id  2 | task 1161 | n_decoded =   3769, tg =  64.29 t/s
[33471] 3.50.801.894 I slot print_timing: id  2 | task 1161 | n_decoded =   3946, tg =  64.03 t/s
[33471] 3.53.805.118 I slot print_timing: id  2 | task 1161 | n_decoded =   4148, tg =  64.18 t/s
[33471] 3.56.841.235 I slot print_timing: id  2 | task 1161 | n_decoded =   4361, tg =  64.45 t/s
[33471] 3.59.871.645 I slot print_timing: id  2 | task 1161 | n_decoded =   4567, tg =  64.60 t/s
[33471] 4.02.877.855 I slot print_timing: id  2 | task 1161 | n_decoded =   4776, tg =  64.80 t/s
[33471] 4.05.896.616 I slot print_timing: id  2 | task 1161 | n_decoded =   4963, tg =  64.69 t/s
[33471] 4.08.909.755 I slot print_timing: id  2 | task 1161 | n_decoded =   5146, tg =  64.54 t/s
[33471] 4.11.924.065 I slot print_timing: id  2 | task 1161 | n_decoded =   5332, tg =  64.44 t/s
[33471] 4.14.941.668 I slot print_timing: id  2 | task 1161 | n_decoded =   5512, tg =  64.27 t/s
[33471] 4.17.945.799 I slot print_timing: id  2 | task 1161 | n_decoded =   5693, tg =  64.13 t/s
[33471] 4.20.948.187 I slot print_timing: id  2 | task 1161 | n_decoded =   5869, tg =  63.95 t/s
[33471] 4.22.263.419 I slot print_timing: id  2 | task 1161 | prompt eval time =    5406.49 ms /  9899 tokens (    0.55 ms per token,  1830.95 tokens per second)
[33471] 4.22.263.423 I slot print_timing: id  2 | task 1161 |        eval time =   93084.30 ms /  5939 tokens (   15.67 ms per token,    63.80 tokens per second)
[33471] 4.22.263.424 I slot print_timing: id  2 | task 1161 |       total time =   98490.79 ms / 15838 tokens
[33471] 4.22.263.424 I slot print_timing: id  2 | task 1161 |    graphs reused =       1940
[33471] 4.22.263.425 I slot print_timing: id  2 | task 1161 | draft acceptance = 0.92817 ( 3101 accepted /  3341 generated)
[33471] 4.22.263.437 I statistics        draft-mtp: #calls(b,g,a) =    2   3995   2880, #gen drafts =   2880, #acc drafts =  2740, #gen tokens =   4895, #acc tokens =  4520, dur(b,g,a) = 0.002, 20512.259, 1.329 ms
[33471] 4.22.263.662 I slot      release: id  2 | task 1161 | stop processing: n_tokens = 15837, truncated = 0
[33471] 4.22.263.682 I srv  update_slots: all slots are idle
```
