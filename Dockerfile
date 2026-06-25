FROM node:22-slim                                                                                                       
                                                                                                                        
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \                                                                                                               
    curl \                                                                                                            
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code                                                                            

ARG PROJECTS_PATH_CONTAINER

RUN useradd -m -s /bin/bash claude && \
    mkdir -p "${PROJECTS_PATH_CONTAINER}" && \
    chown claude:claude "${PROJECTS_PATH_CONTAINER}"

LABEL app=claude-code

WORKDIR ${PROJECTS_PATH_CONTAINER}                                                                                                     
CMD ["sleep", "infinity"]
