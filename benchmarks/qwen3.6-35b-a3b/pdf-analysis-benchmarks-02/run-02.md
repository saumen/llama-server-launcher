# Run 02

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
1.00.882.343 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 43639
[43639] 0.56.754.109 I srv  params_from_: Chat format: peg-native
[43639] 0.56.754.308 I slot get_availabl: id  3 | task -1 | selected slot by LCP similarity, sim_best = 1.000 (> 0.100 thold), f_keep = 0.755
[43639] 0.56.754.384 I slot launch_slot_: id  3 | task 443 | processing task, is_child = 0
[43639] 0.56.754.393 W slot update_slots: id  3 | task 443 | n_past = 9897, slot.prompt.tokens.size() = 13103, seq_id = 3, pos_min = 13102, n_swa = 0
[43639] 0.56.754.394 I slot update_slots: id  3 | task 443 | Checking checkpoint with [12122, 12122] against 9896...
[43639] 0.56.754.394 I slot update_slots: id  3 | task 443 | Checking checkpoint with [11610, 11610] against 9896...
[43639] 0.56.754.395 I slot update_slots: id  3 | task 443 | Checking checkpoint with [8191, 8191] against 9896...
[43639] 0.56.758.489 W slot update_slots: id  3 | task 443 | restored context checkpoint (pos_min = 8191, pos_max = 8191, n_tokens = 8192, n_past = 8192, size = 78.970 MiB)
[43639] 0.56.758.491 W slot update_slots: id  3 | task 443 | erased invalidated context checkpoint (pos_min = 11610, pos_max = 11610, n_tokens = 11611, n_swa = 0, pos_next = 8192, size = 85.712 MiB)
[43639] 0.56.767.952 W slot update_slots: id  3 | task 443 | erased invalidated context checkpoint (pos_min = 12122, pos_max = 12122, n_tokens = 12123, n_swa = 0, pos_next = 8192, size = 86.722 MiB)
[43639] 0.57.507.709 I slot create_check: id  3 | task 443 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[43639] 0.57.817.847 I slot create_check: id  3 | task 443 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[43639] 0.59.236.008 I slot print_timing: id  3 | task 443 | n_decoded =    100, tg =  72.27 t/s
[43639] 1.02.240.576 I slot print_timing: id  3 | task 443 | n_decoded =    331, tg =  75.43 t/s
[43639] 1.05.243.873 I slot print_timing: id  3 | task 443 | n_decoded =    566, tg =  76.57 t/s
[43639] 1.08.250.105 I slot print_timing: id  3 | task 443 | n_decoded =    811, tg =  78.00 t/s
[43639] 1.11.251.579 I slot print_timing: id  3 | task 443 | n_decoded =   1021, tg =  76.20 t/s
[43639] 1.14.267.278 I slot print_timing: id  3 | task 443 | n_decoded =   1217, tg =  74.14 t/s
[43639] 1.17.272.336 I slot print_timing: id  3 | task 443 | n_decoded =   1404, tg =  72.30 t/s
[43639] 1.20.277.990 I slot print_timing: id  3 | task 443 | n_decoded =   1579, tg =  70.41 t/s
[43639] 1.23.301.989 I slot print_timing: id  3 | task 443 | n_decoded =   1760, tg =  69.16 t/s
[43639] 1.26.308.832 I slot print_timing: id  3 | task 443 | n_decoded =   1923, tg =  67.58 t/s
[43639] 1.29.312.534 I slot print_timing: id  3 | task 443 | n_decoded =   2087, tg =  66.34 t/s
[43639] 1.32.316.320 I slot print_timing: id  3 | task 443 | n_decoded =   2257, tg =  65.49 t/s
[43639] 1.35.334.097 I slot print_timing: id  3 | task 443 | n_decoded =   2422, tg =  64.62 t/s
[43639] 1.38.343.382 I slot print_timing: id  3 | task 443 | n_decoded =   2636, tg =  65.10 t/s
[43639] 1.41.356.515 I slot print_timing: id  3 | task 443 | n_decoded =   2831, tg =  65.07 t/s
[43639] 1.44.377.989 I slot print_timing: id  3 | task 443 | n_decoded =   3012, tg =  64.74 t/s
[43639] 1.47.414.355 I slot print_timing: id  3 | task 443 | n_decoded =   3214, tg =  64.85 t/s
[43639] 1.50.445.882 I slot print_timing: id  3 | task 443 | n_decoded =   3429, tg =  65.20 t/s
[43639] 1.53.480.897 I slot print_timing: id  3 | task 443 | n_decoded =   3654, tg =  65.69 t/s
[43639] 1.56.493.164 I slot print_timing: id  3 | task 443 | n_decoded =   3849, tg =  65.64 t/s
[43639] 1.59.529.740 I slot print_timing: id  3 | task 443 | n_decoded =   4037, tg =  65.45 t/s
[43639] 2.02.547.166 I slot print_timing: id  3 | task 443 | n_decoded =   4235, tg =  65.46 t/s
[43639] 2.05.561.896 I slot print_timing: id  3 | task 443 | n_decoded =   4428, tg =  65.40 t/s
[43639] 2.08.593.109 I slot print_timing: id  3 | task 443 | n_decoded =   4610, tg =  65.17 t/s
[43639] 2.11.614.678 I slot print_timing: id  3 | task 443 | n_decoded =   4795, tg =  65.01 t/s
[43639] 2.13.309.802 I slot print_timing: id  3 | task 443 | prompt eval time =    1097.83 ms /  1707 tokens (    0.64 ms per token,  1554.88 tokens per second)
[43639] 2.13.309.806 I slot print_timing: id  3 | task 443 |        eval time =   75457.49 ms /  4897 tokens (   15.41 ms per token,    64.90 tokens per second)
[43639] 2.13.309.807 I slot print_timing: id  3 | task 443 |       total time =   76555.32 ms /  6604 tokens
[43639] 2.13.309.807 I slot print_timing: id  3 | task 443 |    graphs reused =        916
[43639] 2.13.309.808 I slot print_timing: id  3 | task 443 | draft acceptance = 0.90378 ( 2799 accepted /  3097 generated)
[43639] 2.13.309.819 I statistics        draft-mtp: #calls(b,g,a) =    2   2534   1724, #gen drafts =   1724, #acc drafts =  1645, #gen tokens =   3709, #acc tokens =  3341, dur(b,g,a) = 0.002, 16279.949, 0.815 ms
[43639] 2.13.310.038 I slot      release: id  3 | task 443 | stop processing: n_tokens = 14798, truncated = 0
[43639] 2.13.310.060 I srv  update_slots: all slots are idle
```
