#!/bin/bash

set -e

print_usage() {
    # Get Restic version
    RESTIC_VERSION="$(restic version | cut -d' ' -f2)"

    echo "Usage: [command]"
    echo "Commands:"
    echo "  backup    - Perform a backup of all databases on the configured PostgreSQL server."
    echo "  download  - Download the latest backup from the Restic repository (downloads to /download)."
    echo "  shell     - Start a shell session in the container."
    echo "  sleep     - Keep the container running indefinitely."
    echo "  help, h   - Display this help message."
    echo ""
    echo "Required environment variables:"
    echo "  POSTGRES_HOST     - The hostname of the PostgreSQL server."
    echo "  POSTGRES_USER     - The username to connect to the PostgreSQL server."
    echo "  POSTGRES_PASSWORD - The password to connect to the PostgreSQL server."
    echo "  RESTIC_REPOSITORY - The Restic repository to use for backups."
    echo "  RESTIC_PASSWORD   - The password for the Restic repository."
    echo ""
    echo "Optional environment variables:"
    echo "  PORT              - The port of the PostgreSQL server (default: 5432)."
    echo "  RESTIC_TAGS       - Tags to apply to the backup."
    echo ""
    echo "Additional Restic environment variables may be required depending on your setup."
    echo "Go to https://restic.readthedocs.io/en/v${RESTIC_VERSION}/030_preparing_a_new_repo.html"
    echo "for more details on environment variables required for the backup sink."
}

if [ "$#" -eq 0 ]; then
    print_usage
    exit 1
fi

if [ "$1" = "help" ] || [ "$1" = "h" ]; then
    print_usage
    exit 0
fi

if [ "$1" = "backup" ]; then
    echo "Starting backup process..."
    /scripts/backup_script.sh
    echo "Backup completed."
    exit 0
elif [ "$1" = "download" ]; then
    echo "Starting download process..."
    /scripts/download_script.sh
    echo "Download completed."
    exit 0
elif [ "$1" = "shell" ]; then
    echo "Starting shell..."
    exec /bin/bash
elif [ "$1" = "sleep" ]; then
    echo "Starting sleep..."
    while true; do
        sleep 1m
    done
    exit 0
else
    echo "Unknown command: $1"
    print_usage
    exit 1
fi
