0.42.446.065 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 57325
[57325] 0.34.874.075 I srv  params_from_: Chat format: peg-native
[57325] 0.34.874.648 I slot get_availabl: id  2 | task -1 | selected slot by LRU, t_last = -1
[57325] 0.34.874.653 I srv  get_availabl: updating prompt cache
[57325] 0.34.874.655 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[57325] 0.34.874.658 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[57325] 0.34.874.658 I srv  get_availabl: prompt cache update took 0.00 ms
[57325] 0.34.874.715 I slot launch_slot_: id  2 | task 12 | processing task, is_child = 0
[57325] 0.34.874.716 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[57325] 0.34.874.827 W srv   prompt_save:  - saving prompt with length 599, total state size = 75.705 MiB (draft: 1.181 MiB)
[57325] 0.34.937.296 I slot prompt_clear: id  3 | task -1 | clearing prompt with 599 tokens
[57325] 0.34.937.459 I srv        update:  - cache state: 1 prompts, 202.582 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[57325] 0.34.937.461 I srv        update:    - prompt 0xc99b8a2e3db0:     599 tokens, checkpoints:  2,   202.582 MiB
[57325] 0.38.175.895 I slot print_timing: id  2 | task 12 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.24 s / 1897.24 tokens per second
[57325] 0.39.276.998 I slot print_timing: id  2 | task 12 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.34 s / 1887.78 tokens per second
[57325] 0.39.277.245 I slot update_slots: id  2 | task 12 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[57325] 0.39.304.131 I slot create_check: id  2 | task 12 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[57325] 0.40.011.090 I slot print_timing: id  2 | task 12 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.07 s / 1849.38 tokens per second
[57325] 0.40.031.138 I slot create_check: id  2 | task 12 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[57325] 0.40.314.189 I slot print_timing: id  2 | task 12 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.38 s / 1840.35 tokens per second
[57325] 0.40.337.659 I slot create_check: id  2 | task 12 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[57325] 0.41.718.309 I slot print_timing: id  2 | task 12 | n_decoded =    102, tg =  75.72 t/s
[57325] 0.44.743.266 I slot print_timing: id  2 | task 12 | n_decoded =    349, tg =  79.83 t/s
[57325] 0.47.771.780 I slot print_timing: id  2 | task 12 | n_decoded =    598, tg =  80.80 t/s
[57325] 0.50.798.929 I slot print_timing: id  2 | task 12 | n_decoded =    824, tg =  79.02 t/s
[57325] 0.53.810.815 I slot print_timing: id  2 | task 12 | n_decoded =   1041, tg =  77.46 t/s
[57325] 0.56.812.348 I slot print_timing: id  2 | task 12 | n_decoded =   1238, tg =  75.30 t/s
[57325] 0.59.821.535 I slot print_timing: id  2 | task 12 | n_decoded =   1445, tg =  74.29 t/s
[57325] 1.02.824.927 I slot print_timing: id  2 | task 12 | n_decoded =   1628, tg =  72.50 t/s
[57325] 1.05.833.571 I slot print_timing: id  2 | task 12 | n_decoded =   1841, tg =  72.30 t/s
[57325] 1.08.864.618 I slot print_timing: id  2 | task 12 | n_decoded =   2034, tg =  71.38 t/s
[57325] 1.11.873.901 I slot print_timing: id  2 | task 12 | n_decoded =   2207, tg =  70.06 t/s
[57325] 1.14.880.884 I slot print_timing: id  2 | task 12 | n_decoded =   2406, tg =  69.72 t/s
[57325] 1.17.910.211 I slot print_timing: id  2 | task 12 | n_decoded =   2641, tg =  70.35 t/s
[57325] 1.20.938.210 I slot print_timing: id  2 | task 12 | n_decoded =   2841, tg =  70.03 t/s
[57325] 1.23.939.602 I slot print_timing: id  2 | task 12 | n_decoded =   3044, tg =  69.87 t/s
[57325] 1.26.971.533 I slot print_timing: id  2 | task 12 | n_decoded =   3249, tg =  69.72 t/s
[57325] 1.29.989.286 I slot print_timing: id  2 | task 12 | n_decoded =   3465, tg =  69.83 t/s
[57325] 1.33.009.821 I slot print_timing: id  2 | task 12 | n_decoded =   3701, tg =  70.31 t/s
[57325] 1.36.025.542 I slot print_timing: id  2 | task 12 | n_decoded =   3912, tg =  70.29 t/s
[57325] 1.39.045.513 I slot print_timing: id  2 | task 12 | n_decoded =   4123, tg =  70.27 t/s
[57325] 1.42.074.790 I slot print_timing: id  2 | task 12 | n_decoded =   4336, tg =  70.27 t/s
[57325] 1.45.097.767 I slot print_timing: id  2 | task 12 | n_decoded =   4542, tg =  70.17 t/s
[57325] 1.48.105.521 I slot print_timing: id  2 | task 12 | n_decoded =   4763, tg =  70.32 t/s
[57325] 1.51.105.851 I slot print_timing: id  2 | task 12 | n_decoded =   4974, tg =  70.32 t/s
[57325] 1.54.120.067 I slot print_timing: id  2 | task 12 | n_decoded =   5169, tg =  70.09 t/s
[57325] 1.57.143.239 I slot print_timing: id  2 | task 12 | n_decoded =   5360, tg =  69.82 t/s
[57325] 1.57.283.819 I slot print_timing: id  2 | task 12 | prompt eval time =    5433.63 ms /  9899 tokens (    0.55 ms per token,  1821.80 tokens per second)
[57325] 1.57.283.821 I slot print_timing: id  2 | task 12 |        eval time =   76912.62 ms /  5369 tokens (   14.33 ms per token,    69.81 tokens per second)
[57325] 1.57.283.822 I slot print_timing: id  2 | task 12 |       total time =   82346.24 ms / 15268 tokens
[57325] 1.57.283.822 I slot print_timing: id  2 | task 12 |    graphs reused =       2210
[57325] 1.57.283.823 I slot print_timing: id  2 | task 12 | draft acceptance = 0.70706 ( 3145 accepted /  4448 generated)
[57325] 1.57.283.832 I statistics        draft-mtp: #calls(b,g,a) =    2   2232   2232, #gen drafts =   2232, #acc drafts =  1800, #gen tokens =   4464, #acc tokens =  3159, dur(b,g,a) = 0.001, 13750.242, 0.629 ms
[57325] 1.57.284.047 I slot      release: id  2 | task 12 | stop processing: n_tokens = 15268, truncated = 0
[57325] 1.57.284.062 I srv  update_slots: all slots are idle
2.22.262.505 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 57325
[57325] 2.14.663.558 I slot get_availabl: id  1 | task -1 | selected slot by LRU, t_last = -1
[57325] 2.14.663.561 I srv  get_availabl: updating prompt cache
[57325] 2.14.663.563 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[57325] 2.14.663.565 I srv          load:  - found better prompt with f_keep = 0.578, sim = 0.600
[57325] 2.14.673.428 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[57325] 2.14.673.430 I srv  get_availabl: prompt cache update took 9.87 ms
[57325] 2.14.673.442 I slot launch_slot_: id  1 | task 2244 | processing task, is_child = 0
[57325] 2.14.673.443 I slot slot_save_an: id  2 | task -1 | saving idle slot to prompt cache
[57325] 2.14.673.945 W srv   prompt_save:  - saving prompt with length 15268, total state size = 391.419 MiB (draft: 30.112 MiB)
[57325] 2.14.866.220 I slot prompt_clear: id  2 | task -1 | clearing prompt with 15268 tokens
[57325] 2.14.868.118 I srv        update:  - cache state: 1 prompts, 634.035 MiB (limits: 8192.000 MiB, 100096 tokens, 197268 est)
[57325] 2.14.868.121 I srv        update:    - prompt 0xc99b89a56170:   15268 tokens, checkpoints:  3,   634.035 MiB
[57325] 2.14.868.637 W slot update_slots: id  1 | task 2244 | n_past = 346, slot.prompt.tokens.size() = 599, seq_id = 1, pos_min = 598, n_swa = 0
[57325] 2.14.868.639 I slot update_slots: id  1 | task 2244 | Checking checkpoint with [572, 572] against 345...
[57325] 2.14.868.640 I slot update_slots: id  1 | task 2244 | Checking checkpoint with [60, 60] against 345...
[57325] 2.14.870.512 W slot update_slots: id  1 | task 2244 | restored context checkpoint (pos_min = 60, pos_max = 60, n_tokens = 61, n_past = 61, size = 62.934 MiB)
[57325] 2.14.870.514 W slot update_slots: id  1 | task 2244 | erased invalidated context checkpoint (pos_min = 572, pos_max = 572, n_tokens = 573, n_swa = 0, pos_next = 61, size = 63.943 MiB)
[57325] 2.15.181.141 I slot create_check: id  1 | task 2244 | created context checkpoint 2 of 32 (pos_min = 572, pos_max = 572, n_tokens = 573, size = 63.943 MiB)
[57325] 2.15.848.286 I slot print_timing: id  1 | task 2244 | prompt eval time =     346.44 ms /   516 tokens (    0.67 ms per token,  1489.43 tokens per second)
[57325] 2.15.848.294 I slot print_timing: id  1 | task 2244 |        eval time =     633.12 ms /    44 tokens (   14.39 ms per token,    69.50 tokens per second)
[57325] 2.15.848.294 I slot print_timing: id  1 | task 2244 |       total time =     979.56 ms /   560 tokens
[57325] 2.15.848.295 I slot print_timing: id  1 | task 2244 |    graphs reused =       2227
[57325] 2.15.848.296 I slot print_timing: id  1 | task 2244 | draft acceptance = 0.69444 (   25 accepted /    36 generated)
[57325] 2.15.848.320 I statistics        draft-mtp: #calls(b,g,a) =    3   2250   2250, #gen drafts =   2250, #acc drafts =  1814, #gen tokens =   4500, #acc tokens =  3184, dur(b,g,a) = 0.002, 13855.806, 0.633 ms
[57325] 2.15.848.372 I slot      release: id  1 | task 2244 | stop processing: n_tokens = 620, truncated = 0
[57325] 2.15.848.375 I srv  update_slots: all slots are idle
