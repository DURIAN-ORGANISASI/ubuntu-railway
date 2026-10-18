FROM ubuntu:26.04
ARG DEBIAN_FRONTEND=noninteractive
ARG TTYD_VERSION=1.7.7
ARG TARGETARCH
RUN apt-get update && apt-get install -y --no-install-recommends bash ca-certificates curl coreutils && rm -rf /var/lib/apt/lists/*
RUN set -eux; case "${TARGETARCH:-amd64}" in amd64) TTYD_ASSET="ttyd.x86_64" ;; arm64) TTYD_ASSET="ttyd.aarch64" ;; *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; esac; curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/${TTYD_ASSET}" -o /usr/local/bin/ttyd; chmod +x /usr/local/bin/ttyd; /usr/local/bin/ttyd --version
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh && mkdir -p /data && chmod 0777 /data
ENV PORT=8080 TZ=Asia/Jakarta
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
