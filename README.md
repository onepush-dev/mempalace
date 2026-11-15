# MemPalace on Railway

[MemPalace](https://github.com/MemPalace/mempalace) (MIT) — local-first AI memory: verbatim storage, semantic search and a knowledge graph, served to your AI clients as an MCP server. This template runs it as an always-on, token-protected **HTTP MCP hub** that every client (Claude Code, Cursor, Codex, ...) can share. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/TEMPLATE_CODE)

## What this template runs

- One service from `ghcr.io/onepush-dev/mempalace:3.12.0`: the official `ghcr.io/mempalace/mempalace:3.12.0` image, app unmodified, plus a small start wrapper that runs `mempalace serve --host 0.0.0.0 --port 8080`.
- Public HTTPS domain on port 8080, healthcheck `/healthz` (no auth), restart policy Always.
- One volume at `/data` (`HOME`): the palace (ChromaDB, local embeddings), config and the embedding-model cache.

## Variables

| Variable | Value | Notes |
|---|---|---|
| `MEMPALACE_MCP_HTTP_TOKEN` | generated per deploy | Bearer token every MCP client must send. |

Baked into the image: `MEMPALACE_MCP_IDLE_HOURS=0` (an always-on hub should not exit when idle), `MEMPALACE_SERVE_PORT=8080`.

## Connect a client

```bash
claude mcp add --transport http mempalace https://<your-domain>/mcp \
  --header "Authorization: Bearer <MEMPALACE_MCP_HTTP_TOKEN>"
```

Check it: `curl https://<your-domain>/healthz` → `ok`; `curl -H "Authorization: Bearer <token>" https://<your-domain>/statusz` → JSON status.

## Notes

- Default storage is the embedded ChromaDB on the volume. The first write downloads the ~80 MB MiniLM embedding model into `/data/.cache`.
- Requests from browsers with a non-loopback `Origin` are refused by MemPalace (DNS-rebinding guard); MCP clients send no `Origin`, so they work.
- Not affiliated with the MemPalace project.
