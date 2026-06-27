# Ornith Model Routing

## Executive Summary

Ornith-1.0 is a self-improving family of open-source models for agentic coding, post-trained on top of Gemma 4 and Qwen 3.5. Ornith-1.0-35B is a MoE model (~3B active params) designed for efficient single-GPU deployment. MIT licensed.

## Benchmarks

| Benchmark | Ornith-1.0-35B | Qwen3.5-35B | Qwen3.6-35B | Gemma4-31B | Qwen3.5-397B |
|---|---|---|---|---|---|
| Terminal-Bench 2.1 (Terminus-2) | **64.2** | 41.4 | 52.5 | 42.1 | 53.5 |
| Terminal-Bench 2.1 (Claude Code) | **62.8** | 38.9 | 49.2 | – | 48.6 |
| SWE-bench Verified | **75.6** | 70.0 | 73.4 | 52.0 | 76.4 |
| SWE-bench Pro | **50.4** | 44.6 | 49.5 | 35.7 | 51.6 |
| SWE-bench Multilingual | **69.3** | 60.3 | 67.2 | 51.7 | 69.3 |
| NL2Repo | **34.6** | 20.5 | 29.4 | 15.5 | 36.8 |
| Claw-eval Avg | **69.8** | 65.4 | 68.7 | 48.5 | 70.7 |
| SWE Atlas – QnA | **37.1** | 13.2 | 15.5 | – | 20.4 |
| SWE Atlas – RF | **29.7** | 10.2 | 11.4 | – | 18.4 |
| SWE Atlas – TW | **27.8** | 9.8 | 13.3 | – | 18.5 |

## Decision Matrix

| Tier | Use Case | Preset | Context | Reasoning |
|---|---|---|---|---|
| `ornith-flash` | Fast/simple tasks, low latency | `ornith-catalog.ini` [Ornith-1.0-35B-Q5-IT] | 80K | on (no CoT) |
| `ornith-general` | General agentic tasks, tool use | `ornith-catalog.ini` [Ornith-1.0-35B-Q5-general] | 120K | on (thinking) |
| `ornith-coder` | Coding agent, code generation | `ornith-catalog.ini` [Ornith-1.0-35B-Q5-coder] | 120K | on (thinking) |

### How to choose

- **Flash** (`enable_thinking:false`, `temp=0.7`, `top-p=0.80`, 80K ctx): Fast/simple tasks, low-latency queries. Reasoning stays on for tool-calling but skips the CoT block.
- **General** (`presence-penalty=1.5`, thinking on): Default for exploratory tasks, research, multi-domain work.
- **Coder** (`presence-penalty=0.0`, thinking on): Code-heavy tasks where repetition of tool calls is expected.

## Sources

- [HuggingFace: deepreinforce-ai/Ornith-1.0-35B-GGUF](https://huggingface.co/deepreinforce-ai/Ornith-1.0-35B-GGUF)
- [HuggingFace: deepreinforce-ai/Ornith-1.0-35B](https://huggingface.co/deepreinforce-ai/Ornith-1.0-35B)
- [Ornith Blog](https://deep-reinforce.com/ornith.html)
