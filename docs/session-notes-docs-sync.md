# Docs Sync Session Notes — llama-server-launcher

## Session: swordy-docs-sync-inline on /Users/swordfish/workspace/github/saumen/llama-server-launcher

### Harness Detected
- `HARNESS_TYPE=hermes`

### P0 Fixes Applied (Critical Factual Errors)

1. **Qwen3.8 port wrong everywhere** — docs said 8080; `launcher-qwen3.8.sh` runs
   `--port 8888`. Fixed in both launcher tables, workspace tree, curl instructions,
   and the port-collision warning (only Qwen3.6 + Gemma share 8080).

2. **Qwen3.8 tier naming + aliases stale** — docs used "flash" tier with aliases
   `Qwen3.8-27B-general, general` / `Qwen3.8-27B-IT, flash`; actual INI uses
   "Instruct" preset with single aliases `unsloth/qwen3.8-27b-general` and
   `unsloth/qwen3.8-27b-it`.

3. **Qwen3.8 base ctx-size stale** — docs said 175000; INI `[ * ]` has 262144.

4. **Phantom launcher script** — both docs referenced
   `launchers/gemma-4-mtp/launcher-gemma-4-mtp.sh`, which no longer exists (removed
   in the Gemma consolidation commit). `launcher-gemma.sh` is self-contained and
   still sources `.env.launcher` from the repo root, not a subdirectory.

5. **Gemma alias + mmproj claims false** — INI has no `alias` key for the preset
   (API exposes section name) and no `mmproj` in base defaults; launcher passes
   `--no-mmproj`. Docs claimed an alias and a BF16 vision projector.

6. **Supported-models table drifted from models.json** — table listed quantizations
   not in the include globs (UD-Q4_K_M, UD-Q8_K_XL for Qwen3.6; Q4 variants for
   Gemma). Rebuilt table directly from `models.json` include patterns.

### P1 Fixes Applied

- Added missing Qwen3.5-122B-A10B domain section to AGENTS.md (it was only in README)
  + documented the `HF_CACHE_DIR`/`HF_UNSLOTH_DIR` env requirement in README setup —
  without them the standalone launcher's model path resolves empty and fails.
- Added `launchers/qwen3.8-mtp/README.md` row to the file-purposes table.

### User Correction (style) — IMPORTANT

User interrupted mid-work: "why are you adding line breaks line by line? use some unix tool?"

I had been fixing MD013 line-length violations one `patch` call at a time (~8 calls).
Correct approach: write ONE awk script to /tmp and run it over the whole file.
Working recipe (see scripts/wrap120.awk):

```bash
awk -f wrap120.awk README.md > /tmp/out && mv /tmp/out README.md
```

Rules that made it work:
- Skip fenced code blocks (tree diagrams) and table rows — they are pre-existing
  style, not the agent's to reflow.
- Wrap at last space before col 120; continuation indent = original line indent
  (or "  " for list items with hanging indent).
- Trim trailing spaces on emitted segments (`sub(/[[:space:]]+$/, "", seg)`) —
  first version left one trailing space per wrapped line and created 23 new MD009s.

### Verification Gotchas

1. **Line-level co-occurrence checks produce false positives after wrapping** — a
   check like "line mentions qwen3.8 AND matches /808\d/" flagged correct lines
   ("Qwen3.6 and Gemma run on 8080, Qwen3.8 on 8888...") because both tokens share
   a line. Either scope the check to a value-pair (e.g. "qwen3.8" adjacent to "8080")
   or manually confirm flagged lines before treating them as P0.

2. **Tree-existence parsers must be nesting-aware** — a naive regex that extracts
   filenames from tree blocks and checks each at repo root produces bogus paths like
   `launchers/launchers/qwen3.6-mtp/...`. Track an indent→dirname stack: pop entries
   with indent >= current, join the remaining dirs as parent prefix.

3. **Lint baseline before claiming "fixed"** — compare against HEAD, not memory:
   `git show HEAD:README.md > /tmp/r.md && markdownlint /tmp/r.md` gives the pre-edit
   error set. This project's AGENTS.md uses compact table style (no spaces around
   pipes) which trips 106 MD060s at HEAD — those are pre-existing, not regressions.

4. **npx is broken on this machine** (npm chown error on /Users/swordfish/.npm);
   `markdownlint` is installed natively at /opt/homebrew/bin/markdownlint — use it directly.

### Drift Pattern Worth Remembering

This repo's docs drift in one direction: launcher scripts and INIs get refactored
(ports, aliases, quant tiers, removed sub-launchers) while README/AGENTS keep the
old values. The highest-yield audit checks are: every `--port N` in launcher .sh
files vs doc tables; every `alias =` line in catalog INIs vs doc alias columns;
every file named in doc trees vs `find`; models.json include globs vs the
supported-models table.
