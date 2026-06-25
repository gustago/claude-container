#!/bin/bash
# Coloque este script em /usr/local/bin/claude-enter na VPS e dê chmod +x
# Uso: claude-enter [subdiretório dentro de PROJECTS_PATH_CONTAINER]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

load_env() {
    local env_file
    for env_file in "$SCRIPT_DIR/.env" "${CLAUDE_CONTAINER_ENV:-/etc/claude-container.env}"; do
        if [ -f "$env_file" ]; then
            set -a
            # shellcheck source=/dev/null
            source "$env_file"
            set +a
            return
        fi
    done
}

load_env

if [ -z "$PROJECTS_PATH_CONTAINER" ]; then
    echo "Erro: PROJECTS_PATH_CONTAINER não definido."
    echo "Configure em .env (teste local) ou /etc/claude-container.env (VPS)."
    exit 1
fi

CONTAINER=$(docker ps --filter "label=app=claude-code" --format "{{.Names}}" | head -1)

if [ -z "$CONTAINER" ]; then
    echo "Erro: container claude-code não encontrado ou não está rodando."
    exit 1
fi

SUBDIR="${1:-}"
WORKDIR="${PROJECTS_PATH_CONTAINER}${SUBDIR:+/$SUBDIR}"

exec docker exec -it -w "$WORKDIR" "$CONTAINER" bash
