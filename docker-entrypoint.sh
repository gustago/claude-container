#!/bin/bash
set -euo pipefail

if [ -z "${PROJECTS_PATH_CONTAINER:-}" ]; then
    echo "Erro: PROJECTS_PATH_CONTAINER não definido." >&2
    exit 1
fi

mkdir -p "$PROJECTS_PATH_CONTAINER"
chown claude:claude "$PROJECTS_PATH_CONTAINER" 2>/dev/null || true

cd "$PROJECTS_PATH_CONTAINER"
exec "$@"
