0.42.111.156 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 44105
0.42.131.249 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 44105
[44105] 0.25.524.345 I srv  params_from_: Chat format: peg-native
[44105] 0.25.524.683 I slot get_availabl: id  1 | task -1 | selected slot by LRU, t_last = -1
[44105] 0.25.524.683 I srv  get_availabl: updating prompt cache
[44105] 0.25.524.686 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[44105] 0.25.524.688 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[44105] 0.25.524.688 I srv  get_availabl: prompt cache update took 0.00 ms
[44105] 0.25.524.843 I slot launch_slot_: id  1 | task 11 | processing task, is_child = 0
[44105] 0.25.524.849 I slot slot_save_an: id  2 | task -1 | saving idle slot to prompt cache
[44105] 0.25.524.969 W srv   prompt_save:  - saving prompt with length 612, total state size = 75.985 MiB (draft: 1.207 MiB)
[44105] 0.25.572.659 I slot prompt_clear: id  2 | task -1 | clearing prompt with 612 tokens
[44105] 0.25.572.839 I srv        update:  - cache state: 1 prompts, 202.941 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[44105] 0.25.572.840 I srv        update:    - prompt 0xb59d2bab30b0:     612 tokens, checkpoints:  2,   202.941 MiB
[44105] 0.25.572.841 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[44105] 0.25.572.941 W srv   prompt_save:  - saving prompt with length 604, total state size = 75.813 MiB (draft: 1.191 MiB)
[44105] 0.25.622.348 I slot prompt_clear: id  3 | task -1 | clearing prompt with 604 tokens
[44105] 0.25.622.499 I srv        update:  - cache state: 2 prompts, 405.706 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[44105] 0.25.622.500 I srv        update:    - prompt 0xb59d2bab30b0:     612 tokens, checkpoints:  2,   202.941 MiB
[44105] 0.25.622.501 I srv        update:    - prompt 0xb59d3b62c330:     604 tokens, checkpoints:  2,   202.765 MiB
[44105] 0.28.890.701 I slot print_timing: id  1 | task 11 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.27 s / 1879.96 tokens per second
[44105] 0.29.991.944 I slot print_timing: id  1 | task 11 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.37 s / 1874.85 tokens per second
[44105] 0.29.992.199 I slot update_slots: id  1 | task 11 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[44105] 0.30.018.918 I slot create_check: id  1 | task 11 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[44105] 0.30.732.205 I slot print_timing: id  1 | task 11 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.11 s / 1836.32 tokens per second
[44105] 0.30.752.080 I slot create_check: id  1 | task 11 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[44105] 0.31.036.009 I slot print_timing: id  1 | task 11 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.41 s / 1827.85 tokens per second
[44105] 0.31.065.912 I slot create_check: id  1 | task 11 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[44105] 0.32.641.090 I slot print_timing: id  1 | task 11 | n_decoded =    100, tg =  64.97 t/s
[44105] 0.35.658.348 I slot print_timing: id  1 | task 11 | n_decoded =    328, tg =  71.99 t/s
[44105] 0.38.691.175 I slot print_timing: id  1 | task 11 | n_decoded =    559, tg =  73.66 t/s
[44105] 0.41.743.093 I slot print_timing: id  1 | task 11 | n_decoded =    772, tg =  72.55 t/s
[44105] 0.44.794.651 I slot print_timing: id  1 | task 11 | n_decoded =    961, tg =  70.18 t/s
[44105] 0.47.830.480 I slot print_timing: id  1 | task 11 | n_decoded =   1150, tg =  68.75 t/s
[44105] 0.50.871.253 I slot print_timing: id  1 | task 11 | n_decoded =   1273, tg =  64.39 t/s
[44105] 0.53.874.605 I slot print_timing: id  1 | task 11 | n_decoded =   1426, tg =  62.62 t/s
[44105] 0.56.880.341 I slot print_timing: id  1 | task 11 | n_decoded =   1577, tg =  61.18 t/s
[44105] 0.59.882.296 I slot print_timing: id  1 | task 11 | n_decoded =   1736, tg =  60.32 t/s
[44105] 1.02.903.031 I slot print_timing: id  1 | task 11 | n_decoded =   1893, tg =  59.53 t/s
[44105] 1.05.925.358 I slot print_timing: id  1 | task 11 | n_decoded =   2051, tg =  58.90 t/s
[44105] 1.08.938.387 I slot print_timing: id  1 | task 11 | n_decoded =   2192, tg =  57.93 t/s
[44105] 1.11.944.642 I slot print_timing: id  1 | task 11 | n_decoded =   2335, tg =  57.17 t/s
[44105] 1.14.947.376 I slot print_timing: id  1 | task 11 | n_decoded =   2476, tg =  56.47 t/s
[44105] 1.17.994.409 I slot print_timing: id  1 | task 11 | n_decoded =   2676, tg =  57.07 t/s
[44105] 1.21.048.457 I slot print_timing: id  1 | task 11 | n_decoded =   2848, tg =  57.02 t/s
[44105] 1.24.070.735 I slot print_timing: id  1 | task 11 | n_decoded =   3066, tg =  57.88 t/s
[44105] 1.27.102.379 I slot print_timing: id  1 | task 11 | n_decoded =   3225, tg =  57.59 t/s
[44105] 1.30.105.243 I slot print_timing: id  1 | task 11 | n_decoded =   3371, tg =  57.13 t/s
[44105] 1.33.123.188 I slot print_timing: id  1 | task 11 | n_decoded =   3522, tg =  56.79 t/s
[44105] 1.36.135.911 I slot print_timing: id  1 | task 11 | n_decoded =   3695, tg =  56.82 t/s
[44105] 1.39.156.094 I slot print_timing: id  1 | task 11 | n_decoded =   3874, tg =  56.93 t/s
[44105] 1.42.179.236 I slot print_timing: id  1 | task 11 | n_decoded =   4053, tg =  57.02 t/s
[44105] 1.45.211.327 I slot print_timing: id  1 | task 11 | n_decoded =   4204, tg =  56.73 t/s
[44105] 1.48.243.242 I slot print_timing: id  1 | task 11 | n_decoded =   4400, tg =  57.04 t/s
[44105] 1.51.269.822 I slot print_timing: id  1 | task 11 | n_decoded =   4588, tg =  57.23 t/s
[44105] 1.54.298.178 I slot print_timing: id  1 | task 11 | n_decoded =   4765, tg =  57.27 t/s
[44105] 1.57.338.113 I slot print_timing: id  1 | task 11 | n_decoded =   4930, tg =  57.17 t/s
[44105] 2.00.368.208 I slot print_timing: id  1 | task 11 | n_decoded =   5100, tg =  57.13 t/s
[44105] 2.03.378.449 I slot print_timing: id  1 | task 11 | n_decoded =   5265, tg =  57.06 t/s
[44105] 2.06.406.082 I slot print_timing: id  1 | task 11 | n_decoded =   5435, tg =  57.03 t/s
[44105] 2.09.428.156 I slot print_timing: id  1 | task 11 | n_decoded =   5585, tg =  56.80 t/s
[44105] 2.12.465.857 I slot print_timing: id  1 | task 11 | n_decoded =   5775, tg =  56.97 t/s
[44105] 2.15.500.337 I slot print_timing: id  1 | task 11 | n_decoded =   5943, tg =  56.93 t/s
[44105] 2.16.555.894 I slot print_timing: id  1 | task 11 | prompt eval time =    5479.39 ms /  9899 tokens (    0.55 ms per token,  1806.59 tokens per second)
[44105] 2.16.555.898 I slot print_timing: id  1 | task 11 |        eval time =  105453.88 ms /  5984 tokens (   17.62 ms per token,    56.75 tokens per second)
[44105] 2.16.555.898 I slot print_timing: id  1 | task 11 |       total time =  110933.27 ms / 15883 tokens
[44105] 2.16.555.899 I slot print_timing: id  1 | task 11 |    graphs reused =       1894
[44105] 2.16.555.900 I slot print_timing: id  1 | task 11 | draft acceptance = 0.42474 ( 4069 accepted /  9580 generated)
[44105] 2.16.555.910 I statistics        draft-mtp: #calls(b,g,a) =    3   1922   1924, #gen drafts =   1924, #acc drafts =  1520, #gen tokens =   9620, #acc tokens =  4084, dur(b,g,a) = 0.003, 29216.128, 0.526 ms
[44105] 2.16.556.118 I slot      release: id  1 | task 11 | stop processing: n_tokens = 15884, truncated = 0
[44105] 2.16.556.135 I srv  update_slots: all slots are idle
