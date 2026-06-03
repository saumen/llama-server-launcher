0.51.439.255 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 34933
[34933] 0.45.359.315 I srv  params_from_: Chat format: peg-native
[34933] 0.45.359.412 I slot get_availabl: id  1 | task -1 | selected slot by LRU, t_last = -1
[34933] 0.45.359.412 I srv  get_availabl: updating prompt cache
[34933] 0.45.359.414 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[34933] 0.45.359.416 I srv        update:  - cache state: 0 prompts, 0.000 MiB (limits: 8192.000 MiB, 100096 tokens, 8589934592 est)
[34933] 0.45.359.417 I srv  get_availabl: prompt cache update took 0.00 ms
[34933] 0.45.359.456 I slot launch_slot_: id  1 | task 10 | processing task, is_child = 0
[34933] 0.45.359.457 I slot slot_save_an: id  2 | task -1 | saving idle slot to prompt cache
[34933] 0.45.359.569 W srv   prompt_save:  - saving prompt with length 560, total state size = 74.866 MiB (draft: 1.104 MiB)
[34933] 0.45.406.968 I slot prompt_clear: id  2 | task -1 | clearing prompt with 560 tokens
[34933] 0.45.407.141 I srv        update:  - cache state: 1 prompts, 201.660 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[34933] 0.45.407.143 I srv        update:    - prompt 0xbf874f24b900:     560 tokens, checkpoints:  2,   201.660 MiB
[34933] 0.45.407.143 I slot slot_save_an: id  3 | task -1 | saving idle slot to prompt cache
[34933] 0.45.407.241 W srv   prompt_save:  - saving prompt with length 566, total state size = 74.995 MiB (draft: 1.116 MiB)
[34933] 0.45.455.530 I slot prompt_clear: id  3 | task -1 | clearing prompt with 566 tokens
[34933] 0.45.455.689 I srv        update:  - cache state: 2 prompts, 403.453 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[34933] 0.45.455.690 I srv        update:    - prompt 0xbf874f24b900:     560 tokens, checkpoints:  2,   201.660 MiB
[34933] 0.45.455.691 I srv        update:    - prompt 0xbf87403f8ea0:     566 tokens, checkpoints:  2,   201.793 MiB
[34933] 0.48.712.561 I slot print_timing: id  1 | task 10 | prompt processing, n_tokens =   6144, progress = 0.62, t =   3.26 s / 1886.50 tokens per second
[34933] 0.49.826.902 I slot print_timing: id  1 | task 10 | prompt processing, n_tokens =   8192, progress = 0.83, t =   4.37 s / 1874.09 tokens per second
[34933] 0.49.827.059 I slot update_slots: id  1 | task 10 | 8192 tokens since last checkpoint at 0, creating new checkpoint during processing at position 9383
[34933] 0.49.848.592 I slot create_check: id  1 | task 10 | created context checkpoint 1 of 32 (pos_min = 8191, pos_max = 8191, n_tokens = 8192, size = 78.970 MiB)
[34933] 0.50.560.429 I slot print_timing: id  1 | task 10 | prompt processing, n_tokens =   9383, progress = 0.95, t =   5.10 s / 1838.11 tokens per second
[34933] 0.50.580.393 I slot create_check: id  1 | task 10 | created context checkpoint 2 of 32 (pos_min = 9382, pos_max = 9382, n_tokens = 9383, size = 81.318 MiB)
[34933] 0.50.865.504 I slot print_timing: id  1 | task 10 | prompt processing, n_tokens =   9895, progress = 1.00, t =   5.41 s / 1829.09 tokens per second
[34933] 0.50.889.852 I slot create_check: id  1 | task 10 | created context checkpoint 3 of 32 (pos_min = 9894, pos_max = 9894, n_tokens = 9895, size = 82.328 MiB)
[34933] 0.52.332.727 I slot print_timing: id  1 | task 10 | n_decoded =    103, tg =  73.17 t/s
[34933] 0.55.336.835 I slot print_timing: id  1 | task 10 | n_decoded =    373, tg =  84.54 t/s
[34933] 0.58.343.985 I slot print_timing: id  1 | task 10 | n_decoded =    604, tg =  81.41 t/s
[34933] 1.01.357.374 I slot print_timing: id  1 | task 10 | n_decoded =    825, tg =  79.08 t/s
[34933] 1.04.388.573 I slot print_timing: id  1 | task 10 | n_decoded =   1051, tg =  78.06 t/s
[34933] 1.07.430.222 I slot print_timing: id  1 | task 10 | n_decoded =   1242, tg =  75.25 t/s
[34933] 1.10.459.168 I slot print_timing: id  1 | task 10 | n_decoded =   1434, tg =  73.41 t/s
[34933] 1.13.491.986 I slot print_timing: id  1 | task 10 | n_decoded =   1621, tg =  71.83 t/s
[34933] 1.16.521.515 I slot print_timing: id  1 | task 10 | n_decoded =   1813, tg =  70.83 t/s
[34933] 1.19.524.380 I slot print_timing: id  1 | task 10 | n_decoded =   1986, tg =  69.44 t/s
[34933] 1.22.525.205 I slot print_timing: id  1 | task 10 | n_decoded =   2142, tg =  67.78 t/s
[34933] 1.25.567.876 I slot print_timing: id  1 | task 10 | n_decoded =   2299, tg =  66.36 t/s
[34933] 1.28.569.043 I slot print_timing: id  1 | task 10 | n_decoded =   2452, tg =  65.14 t/s
[34933] 1.31.598.935 I slot print_timing: id  1 | task 10 | n_decoded =   2616, tg =  64.32 t/s
[34933] 1.34.616.403 I slot print_timing: id  1 | task 10 | n_decoded =   2783, tg =  63.70 t/s
[34933] 1.37.650.738 I slot print_timing: id  1 | task 10 | n_decoded =   2978, tg =  63.73 t/s
[34933] 1.40.688.169 I slot print_timing: id  1 | task 10 | n_decoded =   3147, tg =  63.24 t/s
[34933] 1.43.731.600 I slot print_timing: id  1 | task 10 | n_decoded =   3334, tg =  63.14 t/s
[34933] 1.46.778.412 I slot print_timing: id  1 | task 10 | n_decoded =   3530, tg =  63.20 t/s
[34933] 1.49.799.323 I slot print_timing: id  1 | task 10 | n_decoded =   3737, tg =  63.47 t/s
[34933] 1.52.801.158 I slot print_timing: id  1 | task 10 | n_decoded =   3934, tg =  63.58 t/s
[34933] 1.55.831.154 I slot print_timing: id  1 | task 10 | n_decoded =   4154, tg =  64.00 t/s
[34933] 1.58.847.589 I slot print_timing: id  1 | task 10 | n_decoded =   4349, tg =  64.03 t/s
[34933] 2.01.887.684 I slot print_timing: id  1 | task 10 | n_decoded =   4550, tg =  64.12 t/s
[34933] 2.04.900.107 I slot print_timing: id  1 | task 10 | n_decoded =   4725, tg =  63.87 t/s
[34933] 2.07.904.255 I slot print_timing: id  1 | task 10 | n_decoded =   4888, tg =  63.50 t/s
[34933] 2.10.939.012 I slot print_timing: id  1 | task 10 | n_decoded =   5064, tg =  63.29 t/s
[34933] 2.13.958.859 I slot print_timing: id  1 | task 10 | n_decoded =   5225, tg =  62.93 t/s
[34933] 2.15.175.128 I slot print_timing: id  1 | task 10 | prompt eval time =    5469.16 ms /  9899 tokens (    0.55 ms per token,  1809.97 tokens per second)
[34933] 2.15.175.132 I slot print_timing: id  1 | task 10 |        eval time =   84250.15 ms /  5292 tokens (   15.92 ms per token,    62.81 tokens per second)
[34933] 2.15.175.132 I slot print_timing: id  1 | task 10 |       total time =   89719.31 ms / 15191 tokens
[34933] 2.15.175.133 I slot print_timing: id  1 | task 10 |    graphs reused =       1722
[34933] 2.15.175.133 I slot print_timing: id  1 | task 10 | draft acceptance = 0.51064 ( 3552 accepted /  6956 generated)
[34933] 2.15.175.144 I statistics        draft-mtp: #calls(b,g,a) =    3   1744   1745, #gen drafts =   1745, #acc drafts =  1386, #gen tokens =   6980, #acc tokens =  3559, dur(b,g,a) = 0.001, 21268.153, 0.767 ms
[34933] 2.15.175.357 I slot      release: id  1 | task 10 | stop processing: n_tokens = 15190, truncated = 0
[34933] 2.15.175.374 I srv  update_slots: all slots are idle
2.38.141.281 I srv  proxy_reques: proxying request to model unsloth/qwen3.6-35B-A3B on port 34933
[34933] 2.32.044.520 I slot get_availabl: id  0 | task -1 | selected slot by LRU, t_last = -1
[34933] 2.32.044.523 I srv  get_availabl: updating prompt cache
[34933] 2.32.044.526 I srv          load:  - looking for better prompt, base f_keep = -1.000, sim = 0.000
[34933] 2.32.044.529 I srv          load:  - found better prompt with f_keep = 0.650, sim = 0.654
[34933] 2.32.055.427 I srv        update:  - cache state: 1 prompts, 201.793 MiB (limits: 8192.000 MiB, 100096 tokens, 100096 est)
[34933] 2.32.055.430 I srv        update:    - prompt 0xbf87403f8ea0:     566 tokens, checkpoints:  2,   201.793 MiB
[34933] 2.32.055.430 I srv  get_availabl: prompt cache update took 10.91 ms
[34933] 2.32.055.444 I slot launch_slot_: id  0 | task 1757 | processing task, is_child = 0
[34933] 2.32.055.445 I slot slot_save_an: id  1 | task -1 | saving idle slot to prompt cache
[34933] 2.32.055.940 W srv   prompt_save:  - saving prompt with length 15190, total state size = 389.741 MiB (draft: 29.958 MiB)
[34933] 2.32.200.700 I slot prompt_clear: id  1 | task -1 | clearing prompt with 15190 tokens
[34933] 2.32.202.580 I srv        update:  - cache state: 2 prompts, 834.150 MiB (limits: 8192.000 MiB, 100096 tokens, 154736 est)
[34933] 2.32.202.583 I srv        update:    - prompt 0xbf87403f8ea0:     566 tokens, checkpoints:  2,   201.793 MiB
[34933] 2.32.202.583 I srv        update:    - prompt 0xbf875381ea90:   15190 tokens, checkpoints:  3,   632.357 MiB
[34933] 2.32.203.085 W slot update_slots: id  0 | task 1757 | n_past = 364, slot.prompt.tokens.size() = 560, seq_id = 0, pos_min = 559, n_swa = 0
[34933] 2.32.203.087 I slot update_slots: id  0 | task 1757 | Checking checkpoint with [551, 551] against 363...
[34933] 2.32.203.088 I slot update_slots: id  0 | task 1757 | Checking checkpoint with [39, 39] against 363...
[34933] 2.32.204.989 W slot update_slots: id  0 | task 1757 | restored context checkpoint (pos_min = 39, pos_max = 39, n_tokens = 40, n_past = 40, size = 62.892 MiB)
[34933] 2.32.204.991 W slot update_slots: id  0 | task 1757 | erased invalidated context checkpoint (pos_min = 551, pos_max = 551, n_tokens = 552, n_swa = 0, pos_next = 40, size = 63.902 MiB)
[34933] 2.32.547.714 I slot create_check: id  0 | task 1757 | created context checkpoint 2 of 32 (pos_min = 552, pos_max = 552, n_tokens = 553, size = 63.904 MiB)
[34933] 2.32.882.131 I slot print_timing: id  0 | task 1757 | prompt eval time =     380.81 ms /   517 tokens (    0.74 ms per token,  1357.61 tokens per second)
[34933] 2.32.882.136 I slot print_timing: id  0 | task 1757 |        eval time =     298.14 ms /    20 tokens (   14.91 ms per token,    67.08 tokens per second)
[34933] 2.32.882.137 I slot print_timing: id  0 | task 1757 |       total time =     678.95 ms /   537 tokens
[34933] 2.32.882.138 I slot print_timing: id  0 | task 1757 |    graphs reused =       1727
[34933] 2.32.882.138 I slot print_timing: id  0 | task 1757 | draft acceptance = 0.54167 (   13 accepted /    24 generated)
[34933] 2.32.882.151 I statistics        draft-mtp: #calls(b,g,a) =    4   1750   1751, #gen drafts =   1751, #acc drafts =  1391, #gen tokens =   7004, #acc tokens =  3572, dur(b,g,a) = 0.001, 21337.769, 0.771 ms
[34933] 2.32.882.177 I slot      release: id  0 | task 1757 | stop processing: n_tokens = 576, truncated = 0
[34933] 2.32.882.181 I srv  update_slots: all slots are idle
