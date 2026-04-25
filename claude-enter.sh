#!/bin/bash
# Coloque este script em /usr/local/bin/claude-enter na VPS e dê chmod +x
# Uso: claude-enter [subdiretório dentro de /projects]

SUBDIR="${1:-}"
WORKDIR="/projects${SUBDIR:+/$SUBDIR}"

exec docker exec -it -w "$WORKDIR" claude-code bash
