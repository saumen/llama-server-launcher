# Qwen3.6 Recommended settings

These are recommended settings from [huggingface/qwen](https://huggingface.co/Qwen/Qwen3.6-35B-A3B-FP8#using-qwen36-via-the-chat-completions-api) official site. Just cached here. Actual settings can be different.

**Do not edit. It must reflect huggingface/qwen official recommendation.**

## Thinking mode for general tasks

```ini
temperature = 1.0
top_p = 0.95
top_k = 20
min_p = 0.0
presence_penalty = 1.5
repetition_penalty = 1.0
```

## Thinking mode for precise coding tasks

```ini
temperature = 0.6
top_p = 0.95
top_k = 20
min_p = 0.0
presence_penalty = 0.0
repetition_penalty = 1.0
```

## Instruct or non-thinking mode

```ini
temperature = 0.7
top_p = 0.80
top_k = 20
min_p = 0.0
presence_penalty = 1.5
repetition_penalty = 1.0
```
