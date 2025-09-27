#!/bin/bash

set -e

export PGHOST="${POSTGRES_HOST}"
export PGPORT="${PORT:-5432}"
export PGUSER="${POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD}"


export BACKUP_FLAGS=""
export FORGET_FLAGS=""

if [ -n "$RESTIC_TAGS" ]; then
    BACKUP_FLAGS="$BACKUP_FLAGS --tag '${RESTIC_TAGS}'"
fi

if [ -n "$KEEP_LAST" ]; then
    FORGET_FLAGS="$FORGET_FLAGS --keep-last ${KEEP_LAST}"
fi
if [ -n "$KEEP_HOURLY" ]; then
    FORGET_FLAGS="$FORGET_FLAGS --keep-hourly ${KEEP_HOURLY}"
fi
if [ -n "$KEEP_DAILY" ]; then
    FORGET_FLAGS="$FORGET_FLAGS --keep-daily ${KEEP_DAILY}"
fi
if [ -n "$KEEP_WEEKLY" ]; then
    FORGET_FLAGS="$FORGET_FLAGS --keep-weekly ${KEEP_WEEKLY}"
fi
if [ -n "$KEEP_MONTHLY" ]; then
    FORGET_FLAGS="$FORGET_FLAGS --keep-monthly ${KEEP_MONTHLY}"
fi
if [ -n "$KEEP_YEARLY" ]; then
    FORGET_FLAGS="$FORGET_FLAGS --keep-yearly ${KEEP_YEARLY}"
fi

# Create a temporary directory for the database dump
mkdir -p /tmp

# Dump all PostgreSQL databases to a SQL file
pg_dumpall -w --clean --if-exists > /tmp/backup.sql

# Exit if the dump failed
if [ $? -ne 0 ]; then
    echo "Error: Failed to dump PostgreSQL databases."
    exit 1
fi

# Initialize Restic repository if it doesn't exist
(restic cat config > /dev/null 2>&1) || restic init

# Backup the SQL dump
restic backup ${BACKUP_FLAGS} /tmp

# Clean up temporary files
rm -rf /tmp/*

# Prune old backups according to retention policy
# restic forget --prune ${FORGET_FLAGS}
