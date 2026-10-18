FROM ubuntu:26.04
ARG DEBIAN_FRONTEND=noninteractive
ARG TTYD_VERSION=1.7.7
ARG TARGETARCH

ENV TZ=Asia/Jakarta \
    PORT=8080 \
    PATH="/root/.local/bin:/usr/local/bin:/usr/bin:/bin"

# General-purpose CLI environment: shell, network tools, Git, Python and common build tools.
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash ca-certificates curl coreutils procps sed git \
    python3 python3-venv python3-pip \
    build-essential pkg-config libffi-dev libssl-dev xz-utils \
    && (apt-get install -y --no-install-recommends fastfetch || true) \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) TTYD_ASSET="ttyd.x86_64" ;; \
      arm64) TTYD_ASSET="ttyd.aarch64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/${TTYD_ASSET}" -o /usr/local/bin/ttyd; \
    chmod +x /usr/local/bin/ttyd; \
    /usr/local/bin/ttyd --version

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY system-banner.sh /etc/profile.d/00-system-banner.sh

RUN chmod 0755 /usr/local/bin/entrypoint.sh /etc/profile.d/00-system-banner.sh \
    && mkdir -p /data \
    && chmod 0777 /data

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
