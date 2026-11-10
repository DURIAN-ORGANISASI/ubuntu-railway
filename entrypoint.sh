#!/usr/bin/env bash
set -Eeuo pipefail

: "${TERMINAL_USER:?Set TERMINAL_USER in Railway Variables}"
: "${TERMINAL_PASSWORD:?Set TERMINAL_PASSWORD in Railway Variables}"

if [[ "${TERMINAL_USER}" == *:* ]]; then
  echo "ERROR: TERMINAL_USER must not contain a colon (:)." >&2
  exit 1
fi

if [[ ${#TERMINAL_PASSWORD} -lt 16 ]]; then
  echo "ERROR: TERMINAL_PASSWORD must be at least 16 characters." >&2
  exit 1
fi

PORT="${PORT:-8080}"
export TZ="${TZ:-Asia/Jakarta}"
export HOME=/home/terminal
export USER=terminal
export LOGNAME=terminal

mkdir -p /data
# Migrate files created by previous root sessions so the new unprivileged user
# can still modify existing Railway Volume data after this upgrade.
chown -R --no-dereference terminal:terminal /data
chmod 0770 /data
cd /data

echo "Starting authenticated Ubuntu web terminal as unprivileged user terminal (UID 10001) on port ${PORT}."
# ttyd 1.7.7 prints the credential field at NOTICE level by default.
# Debug level 3 keeps ERROR/WARN logs and suppresses NOTICE to avoid logging
# the base64-encoded Basic Auth credential. check-origin restricts WebSocket
# access to the same origin as the terminal page.
# setpriv drops privileges before ttyd and every terminal shell are started.
exec setpriv --reuid=terminal --regid=terminal --init-groups \
  /usr/local/bin/ttyd \
  --debug 3 \
  --check-origin \
  --port "${PORT}" \
  --credential "${TERMINAL_USER}:${TERMINAL_PASSWORD}" \
  --writable \
  --cwd /data \
  bash --login
