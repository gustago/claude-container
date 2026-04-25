FROM node:22-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

RUN useradd -m -s /bin/bash claude && \
    mkdir -p /projects && \
    chown claude:claude /projects

USER claude
WORKDIR /projects

# Mantém o container rodando para uso via docker exec
CMD ["sleep", "infinity"]
