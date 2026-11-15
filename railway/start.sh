#!/bin/sh
# Railway volumes mount root-owned; MemPalace runs as uid 1000 with HOME=/data.
set -e
mkdir -p /data
chown -R 1000:1000 /data 2>/dev/null || true
if [ -z "${MEMPALACE_MCP_HTTP_TOKEN:-}" ]; then
  echo "railway: MEMPALACE_MCP_HTTP_TOKEN is not set; refusing to expose the hub without a token" >&2
  exit 1
fi
echo "railway: MemPalace MCP hub on :${MEMPALACE_SERVE_PORT:-8080} (endpoint /mcp, health /healthz)"
if [ "$#" -gt 0 ]; then
  exec setpriv --reuid=1000 --regid=1000 --init-groups docker-entrypoint.sh "$@"
fi
exec setpriv --reuid=1000 --regid=1000 --init-groups docker-entrypoint.sh serve --host 0.0.0.0 --port "${MEMPALACE_SERVE_PORT:-8080}"
