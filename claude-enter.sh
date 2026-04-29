#!/bin/bash
# Coloque este script em /usr/local/bin/claude-enter na VPS e dê chmod +x
# Uso: claude-enter [subdiretório dentro de /projects]

CONTAINER=$(docker ps --filter "label=app=claude-code" --format "{{.Names}}" | head -1)

if [ -z "$CONTAINER" ]; then
    echo "Erro: container claude-code não encontrado ou não está rodando."
    exit 1
fi

SUBDIR="${1:-}"
WORKDIR="/projects${SUBDIR:+/$SUBDIR}"

exec docker exec -it -w "$WORKDIR" "$CONTAINER" bash
