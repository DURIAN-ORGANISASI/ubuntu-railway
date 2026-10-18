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
HERMES_HOME="${HERMES_HOME:-/opt/data}"
export HERMES_HOME
mkdir -p /data "${HERMES_HOME}"
cd /data

# Start Gateway only after the user has completed Hermes setup and config exists.
if [[ "${HERMES_AUTOSTART:-true}" == "true" || "${HERMES_AUTOSTART:-true}" == "1" ]]; then
  if [[ -f "${HERMES_HOME}/config.yaml" ]]; then
    (
      echo "Hermes config found; starting supervised Gateway loop."
      while true; do
        echo "Starting Hermes Gateway..."
        hermes gateway || true
        echo "Hermes Gateway exited; retrying in 5 seconds."
        sleep 5
      done
    ) &
  else
    echo "Hermes is installed, but no config was found at ${HERMES_HOME}/config.yaml."
    echo "Open the terminal, run 'hermes setup' and 'hermes gateway setup', then restart the service."
  fi
fi

echo "Starting authenticated Ubuntu web terminal on port ${PORT}."
exec /usr/local/bin/ttyd --port "${PORT}" --credential "${TERMINAL_USER}:${TERMINAL_PASSWORD}" --writable --cwd /data bash --login
