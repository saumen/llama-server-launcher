# Qwen3.6 Recommended settings

## Using Qwen3.6 via the Chat Completions API

### Thinking mode for general tasks

```toml
temperature = 1.0
top_p = 0.95
top_k = 20
min_p = 0.0
presence_penalty = 1.5
repetition_penalty = 1.0
```

### Thinking mode for precise coding tasks

```toml
temperature = 0.6
top_p = 0.95
top_k=20
min_p = 0.0
presence_penalty = 0.0
repetition_penalty = 1.0
```

### Instruct or non-thinking mode

```toml
temperature = 0.7
top_p = 0.80
top_k = 20
min_p = 0.0
presence_penalty = 1.5
repetition_penalty = 1.0
```

> [!NOTE] source: https://huggingface.co/Qwen/Qwen3.6-35B-A3B-FP8#using-qwen36-via-the-chat-completions-api
