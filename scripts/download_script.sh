#!/bin/bash

set -e

export DOWNLOAD_DIR="${DOWNLOAD_DIR:-/download}"

mkdir -p "$DOWNLOAD_DIR"

# Restore the latest backup to /restore directory
restic restore latest --target "$DOWNLOAD_DIR"

# Exit if the restore failed
if [ $? -ne 0 ]; then
    echo "Error: Failed to restore the backup."
    exit 1
fi
