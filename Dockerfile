# syntax=docker/dockerfile:1.7
FROM ubuntu:26.04
ARG DEBIAN_FRONTEND=noninteractive
ARG TTYD_VERSION=1.7.7
ARG TARGETARCH

ENV TZ=Asia/Jakarta \
    PORT=8080 \
    HOME=/home/terminal \
    USER=terminal \
    LOGNAME=terminal \
    PATH="/home/terminal/.local/bin:/home/terminal/.local/share/uv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Cache downloaded apt archives between builds without keeping them in the final image.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    bash ca-certificates curl coreutils procps sed git \
    python3 python3-venv python3-pip \
    build-essential pkg-config libffi-dev libssl-dev xz-utils tzdata \
    passwd util-linux \
    && (apt-get install -y --no-install-recommends fastfetch || true) \
    && ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime \
    && printf '%s\n' "${TZ}" > /etc/timezone \
    && groupadd --gid 10001 terminal \
    && useradd --uid 10001 --gid 10001 --create-home --home-dir /home/terminal --shell /bin/bash terminal \
    && install -d --owner=terminal --group=terminal --mode=0770 /data \
    && rm -rf /var/lib/apt/lists/*

# ttyd 1.7.7 is pinned; entrypoint suppresses NOTICE logs that include its credential field.
RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) TTYD_ASSET="ttyd.x86_64" ;; \
      arm64) TTYD_ASSET="ttyd.aarch64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/${TTYD_ASSET}" -o /usr/local/bin/ttyd; \
    chmod 0755 /usr/local/bin/ttyd; \
    /usr/local/bin/ttyd --version

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY system-banner.sh /etc/profile.d/00-system-banner.sh

RUN chmod 0755 /usr/local/bin/entrypoint.sh /etc/profile.d/00-system-banner.sh \
    && bash -n /usr/local/bin/entrypoint.sh /etc/profile.d/00-system-banner.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
