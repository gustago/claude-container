FROM node:22-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- -d /usr/local/bin

RUN npm install -g @anthropic-ai/claude-code

RUN useradd -m -s /bin/bash claude

LABEL app=claude-code

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sleep", "infinity"]
