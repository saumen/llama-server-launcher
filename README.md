# `llama.cpp server` launcher

A collection of scripts and configurations for launching `llama.cpp server` with various GGUF models with optimized
settings.

## Usage Examples

### Downloading Models

The `huggingface-scripts/download-models.sh` script automates the downloading of models defined in
`huggingface-scripts/models.json`.

Models are managed via this central configuration file, which defines:

- `cacheDir`: The base directory where models are cached.
- `models`: A list of configurations containing:
  - `modelId`: The Hugging Face repository ID.
  - `localDir`: The destination directory for the downloaded files.
  - `include`: A list of file patterns (globs) to selectively download specific weights or components (e.g., specific
    quantization levels or MTP files).

**Prerequisites:** Before using the script, you must have the Hugging Face CLI installed. You can install it via `pip`
([official guide](https://huggingface.co/docs/huggingface_hub/en/installation)):

```bash
pip install huggingface_hub
```

**Examples:**

1. **Download all models defined in the config:**

   ```bash
   ./huggingface-scripts/download-models.sh
   ```

2. **Download a specific model by its ID (from config):**

   ```bash
   ./huggingface-scripts/download-models.sh <model_id>
   ```

3. **List all available model IDs in the config:**

   ```bash
   ./huggingface-scripts/download-models.sh --list
   ```

4. **Perform a dry run to see what would be downloaded:**
   ```bash
   ./huggingface-scripts/download-models.sh --dry-run
   ```

### Serving models

The `launchers/` directory contains shell scripts to start `llama-server` with pre-configured settings for specific
model families.

**Examples:**

1. **Launch Gemma-4 MTP server:**

```bash
./launchers/launcher-gemma.sh
```

### Gemma-4 MTP Decision Matrix

| Tier           | Model ID             | Quant        | Task Profile         | Use Case                          |
| :------------- | :------------------- | :----------- | :------------------- | :-------------------------------- |
| **flash-lite** | `gemma-4-flash-lite` | Q4_K_M (UD)  | High-Volume          | Log analysis, data cleaning       |
| **flash**      | `gemma-4-flash`      | Q4_K_XL (UD) | Agentic / Rapid Chat | Boilerplate, documentation        |
| **flash-high** | `gemma-4-flash-high` | Q5_K_M       | Logic / Math / Code  | Debugging, math proofs            |
| **pro**        | `gemma-4-pro`        | Q5_K_XL      | High-Stakes / Batch  | Legal/medical, codebase migration |

_See [detailed routing document](launchers/gemma-4-mtp/gemma-4-model-routing.md) for full benchmarks and analysis._

2. **Launch Qwen 3.6 MTP server:**

```bash
./launchers/launcher-qwen.sh
```

## Testing OpenAI Compatible Endpoints

Once you have launched a server, you can test its OpenAI-compatible endpoints using `curl`.

Replace `localhost:PORT` with the actual host and port where your server is running (e.g., `localhost:8080`,
`localhost:8081`, or `localhost:8082`).

### 1. Ask a Question (Chat Completions)

Use the `/v1/chat/completions` endpoint to send a message to the model.

```bash
curl http://localhost:PORT/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "model-name",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Hello! Who are you?"}
    ]
  }'
```

_Note: If you are unsure of the model name, you can use the "List Models" command below first._

### 2. List Models

Use the `/v1/models` endpoint to see which models are currently loaded and available.

```bash
curl http://localhost:PORT/v1/models
```
