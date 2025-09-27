FROM restic/restic:0.18.1

WORKDIR /

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    postgresql-client

COPY --chmod=755 entrypoint.sh .

ENTRYPOINT [ "./entrypoint.sh" ]
