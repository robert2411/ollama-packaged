#based on https://github.com/ilopezluna/dockerize-ollama-models
ARG OLLAMA_VERSION=latest
FROM ollama/ollama:${OLLAMA_VERSION} AS ollama

FROM ollama AS base
RUN apt-get update && apt-get -y install curl

FROM base AS builder

WORKDIR /model
ARG items

# Start the ollama serve service
RUN ollama serve & \
    # Wait for the service to be ready
    until curl -s http://localhost:11434; do \
        echo "Waiting for ollama serve to be ready..."; \
        sleep 5; \
    done && \
    for item in $items; do \
    ollama pull $item; \
    done;
FROM ollama
COPY --from=builder /root/.ollama /root/.ollama