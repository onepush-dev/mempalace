# MemPalace on Railway: the official upstream image (MemPalace/mempalace v3.12.0, MIT), app unmodified.
# This layer only: runs the HTTP MCP hub (`mempalace serve`) on port 8080 with the idle watchdog off,
# and fixes ownership of the Railway volume at /data (mounted root-owned) before dropping to uid 1000.
FROM ghcr.io/mempalace/mempalace:3.12.0
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/mempalace"
USER root
COPY railway/start.sh /opt/railway/start.sh
RUN chmod 755 /opt/railway/start.sh && command -v setpriv
ENV MEMPALACE_MCP_IDLE_HOURS=0 \
    MEMPALACE_SERVE_PORT=8080
EXPOSE 8080
ENTRYPOINT ["/opt/railway/start.sh"]
