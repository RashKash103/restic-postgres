FROM restic/restic:0.19.1

WORKDIR /

RUN apk add --no-cache \
    curl \
    jq \
    bash \
    postgresql-client

# Copy entrypoint script
COPY --chmod=755 entrypoint.sh .

# Copy backup and download scripts
COPY --chmod=755 scripts/backup_script.sh /scripts/backup_script.sh
COPY --chmod=755 scripts/download_script.sh /scripts/download_script.sh

ENTRYPOINT [ "./entrypoint.sh" ]
