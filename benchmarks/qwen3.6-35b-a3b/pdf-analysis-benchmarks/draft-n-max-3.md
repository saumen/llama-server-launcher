0.30.969.177 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 33727
[33727] 0.26.071.971 I srv  params_from_: Chat format: peg-native
[33727] 0.26.072.473 I slot get_availabl: id  1 | task -1 | selected slot by LRU, t_last = -1
[33727] 0.26.072.481 I srv  get_availabl: updating prompt cache
[33727] 0.26.072.485 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[33727] 0.26.072.488 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[33727] 0.26.072.489 I srv  get_availabl: prompt cache update took 0.01 ms
[33727] 0.26.072.573 I slot launch_slot_: id  1 | task 22 | processing task, is_child = 0
[33727] 0.26.072.574 I slot slot_save_an: id  2 | task -1 | saving idle slot to prompt cache
[33727] 0.26.072.703 W srv   prompt_save:  - saving prompt with length 579, total state size = 75.275 MiB (draft: 1.142 MiB)
[33727] 0.26.135.124 I slot prompt_clear: id  2 | task -1 | clearing prompt with 579 tokens
[33727] 0.26.135.301 I srv        update:  - cache state: 1 prompts, 202.144 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[33727] 0.26.135.302 I srv        update:    - prompt 0xaf00b9976400:     579 tokens, checkpoints:  2,   202.144 MiB
[33727] 0.26.135.303 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[33727] 0.26.135.407 W srv   prompt_save:  - saving prompt with length 633, total state size = 76.437 MiB (draft: 1.248 MiB)
[33727] 0.26.198.458 I slot prompt_clear: id  3 | task -1 | clearing prompt with 633 tokens
[33727] 0.26.198.624 I srv        update:  - cache state: 2 prompts, 405.454 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[33727] 0.26.198.625 I srv        update:    - prompt 0xaf00b9976400:     579 tokens, checkpoints:  2,   202.144 MiB
[33727] 0.26.198.625 I srv        update:    - prompt 0xaf009cd82b00:     633 tokens, checkpoints:  2,   203.310 MiB
[33727] 0.29.450.132 I slot print_timing: id  1 | task 22 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.25 s / 1889.61 tokens per second
[33727] 0.30.546.691 I slot print_timing: id  1 | task 22 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.35 s / 1884.07 tokens per second
[33727] 0.30.546.819 I slot update_slots: id  1 | task 22 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[33727] 0.30.567.672 I slot create_check: id  1 | task 22 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[33727] 0.31.278.290 I slot print_timing: id  1 | task 22 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.08 s / 1847.18 tokens per second
[33727] 0.31.298.124 I slot create_check: id  1 | task 22 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[33727] 0.31.581.769 I slot print_timing: id  1 | task 22 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.38 s / 1838.16 tokens per second
[33727] 0.31.611.846 I slot create_check: id  1 | task 22 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[33727] 0.32.901.807 I slot print_timing: id  1 | task 22 | n_decoded =    100, tg =  79.55 t/s
[33727] 0.35.903.450 I slot print_timing: id  1 | task 22 | n_decoded =    354, tg =  83.12 t/s
[33727] 0.38.937.257 I slot print_timing: id  1 | task 22 | n_decoded =    603, tg =  82.69 t/s
[33727] 0.41.962.990 I slot print_timing: id  1 | task 22 | n_decoded =    876, tg =  84.90 t/s
[33727] 0.44.975.762 I slot print_timing: id  1 | task 22 | n_decoded =   1139, tg =  85.44 t/s
[33727] 0.48.012.927 I slot print_timing: id  1 | task 22 | n_decoded =   1329, tg =  81.19 t/s
[33727] 0.51.036.691 I slot print_timing: id  1 | task 22 | n_decoded =   1513, tg =  78.02 t/s
[33727] 0.54.072.234 I slot print_timing: id  1 | task 22 | n_decoded =   1702, tg =  75.89 t/s
[33727] 0.57.097.602 I slot print_timing: id  1 | task 22 | n_decoded =   1888, tg =  74.18 t/s
[33727] 1.00.137.043 I slot print_timing: id  1 | task 22 | n_decoded =   2068, tg =  72.58 t/s
[33727] 1.03.173.456 I slot print_timing: id  1 | task 22 | n_decoded =   2257, tg =  71.59 t/s
[33727] 1.06.207.126 I slot print_timing: id  1 | task 22 | n_decoded =   2432, tg =  70.37 t/s
[33727] 1.09.239.286 I slot print_timing: id  1 | task 22 | n_decoded =   2630, tg =  69.96 t/s
[33727] 1.12.265.802 I slot print_timing: id  1 | task 22 | n_decoded =   2857, tg =  70.33 t/s
[33727] 1.15.281.847 I slot print_timing: id  1 | task 22 | n_decoded =   3036, tg =  69.57 t/s
[33727] 1.18.296.429 I slot print_timing: id  1 | task 22 | n_decoded =   3255, tg =  69.77 t/s
[33727] 1.21.311.230 I slot print_timing: id  1 | task 22 | n_decoded =   3514, tg =  70.75 t/s
[33727] 1.24.335.371 I slot print_timing: id  1 | task 22 | n_decoded =   3755, tg =  71.27 t/s
[33727] 1.27.344.936 I slot print_timing: id  1 | task 22 | n_decoded =   3987, tg =  71.58 t/s
[33727] 1.30.357.781 I slot print_timing: id  1 | task 22 | n_decoded =   4193, tg =  71.42 t/s
[33727] 1.33.369.664 I slot print_timing: id  1 | task 22 | n_decoded =   4405, tg =  71.37 t/s
[33727] 1.36.404.637 I slot print_timing: id  1 | task 22 | n_decoded =   4593, tg =  70.92 t/s
[33727] 1.39.416.678 I slot print_timing: id  1 | task 22 | n_decoded =   4789, tg =  70.66 t/s
[33727] 1.42.417.199 I slot print_timing: id  1 | task 22 | n_decoded =   4972, tg =  70.25 t/s
[33727] 1.45.446.008 I slot print_timing: id  1 | task 22 | n_decoded =   5143, tg =  69.69 t/s
[33727] 1.47.962.753 I slot print_timing: id  1 | task 22 | prompt eval time =    5446.02 ms /  9899 tokens (    0.55 ms per token,  1817.66 tokens per second)
[33727] 1.47.962.756 I slot print_timing: id  1 | task 22 |        eval time =   76317.99 ms /  5310 tokens (   14.37 ms per token,    69.58 tokens per second)
[33727] 1.47.962.756 I slot print_timing: id  1 | task 22 |       total time =   81764.01 ms / 15209 tokens
[33727] 1.47.962.757 I slot print_timing: id  1 | task 22 |    graphs reused =       1830
[33727] 1.47.962.757 I slot print_timing: id  1 | task 22 | draft acceptance = 0.63108 ( 3476 accepted /  5508 generated)
[33727] 1.47.962.767 I statistics        draft-mtp: #calls(b,g,a) =    3   1853   1854, #gen drafts =   1854, #acc drafts =  1528, #gen tokens =   5562, #acc tokens =  3519, dur(b,g,a) = 0.003, 16979.744, 0.510 ms
[33727] 1.47.962.980 I slot      release: id  1 | task 22 | stop processing: n_tokens = 15211, truncated = 0
[33727] 1.47.962.998 I srv  update_slots: all slots are idle
1.52.901.092 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 33727
2.06.048.165 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 33727
[33727] 2.01.134.531 I slot get_availabl: id  0 | task -1 | selected slot by LRU, t_last = -1
[33727] 2.01.134.534 I srv  get_availabl: updating prompt cache
[33727] 2.01.134.537 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[33727] 2.01.134.540 I srv          load:  - found better prompt with f_keep = 0.598, sim = 0.600
[33727] 2.01.148.503 I srv        update:  - cache state: 1 prompts, 203.310 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[33727] 2.01.148.506 I srv        update:    - prompt 0xaf009cd82b00:     633 tokens, checkpoints:  2,   203.310 MiB
[33727] 2.01.148.507 I srv  get_availabl: prompt cache update took 13.97 ms
[33727] 2.01.148.519 I slot launch_slot_: id  0 | task 1866 | processing task, is_child = 0
[33727] 2.01.148.520 I slot slot_save_an: id  1 | task -1 | saving idle slot to prompt cache
[33727] 2.01.149.012 W srv   prompt_save:  - saving prompt with length 15211, total state size = 390.193 MiB (draft: 29.999 MiB)
[33727] 2.01.290.576 I slot prompt_clear: id  1 | task -1 | clearing prompt with 15211 tokens
[33727] 2.01.292.414 I srv        update:  - cache state: 2 prompts, 836.119 MiB (limits: 8192.000 MiB, 100096 tokens, 155233 est)
[33727] 2.01.292.417 I srv        update:    - prompt 0xaf009cd82b00:     633 tokens, checkpoints:  2,   203.310 MiB
[33727] 2.01.292.417 I srv        update:    - prompt 0xaf00a961e8e0:   15211 tokens, checkpoints:  3,   632.809 MiB
[33727] 2.01.292.937 W slot update_slots: id  0 | task 1866 | n_past = 346, slot.prompt.tokens.size() = 579, seq_id = 0, pos_min = 578, n_swa = 0
[33727] 2.01.292.940 I slot update_slots: id  0 | task 1866 | Checking checkpoint with [570, 570] against 345...
[33727] 2.01.292.940 I slot update_slots: id  0 | task 1866 | Checking checkpoint with [58, 58] against 345...
[33727] 2.01.294.826 W slot update_slots: id  0 | task 1866 | restored context checkpoint (pos_min = 58, pos_max = 58, n_tokens = 59, n_past = 59, size = 62.930 MiB)
[33727] 2.01.294.829 W slot update_slots: id  0 | task 1866 | erased invalidated context checkpoint (pos_min = 570, pos_max = 570, n_tokens = 571, n_swa = 0, pos_next = 59, size = 63.939 MiB)
[33727] 2.01.636.130 I slot create_check: id  0 | task 1866 | created context checkpoint 2 of 32 (pos_min = 572, pos_max = 572, n_tokens = 573, size = 63.943 MiB)
[33727] 2.02.554.655 I slot print_timing: id  0 | task 1866 | prompt eval time =     378.34 ms /   518 tokens (    0.73 ms per token,  1369.13 tokens per second)
[33727] 2.02.554.666 I slot print_timing: id  0 | task 1866 |        eval time =     883.29 ms /    64 tokens (   13.80 ms per token,    72.46 tokens per second)
[33727] 2.02.554.667 I slot print_timing: id  0 | task 1866 |       total time =    1261.63 ms /   582 tokens
[33727] 2.02.554.667 I slot print_timing: id  0 | task 1866 |    graphs reused =       1849
[33727] 2.02.554.668 I slot print_timing: id  0 | task 1866 | draft acceptance = 0.67742 (   42 accepted /    62 generated)
[33727] 2.02.554.679 I statistics        draft-mtp: #calls(b,g,a) =    4   1874   1875, #gen drafts =   1875, #acc drafts =  1544, #gen tokens =   5624, #acc tokens =  3561, dur(b,g,a) = 0.003, 17164.079, 0.513 ms
[33727] 2.02.554.707 I slot      release: id  0 | task 1866 | stop processing: n_tokens = 640, truncated = 0
[33727] 2.02.554.715 I srv  update_slots: all slots are idle
