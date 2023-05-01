#!/bin/sh

HOST=$1
PORT=$2
TIMEOUT=360

echo "Waiting for ${HOST}:${PORT} to become available"

while [ "${TIMEOUT}" -gt 0 ]; do
  nc -z "${HOST}" "${PORT}"
  if [ $? -eq 0 ]; then
    echo "${HOST}:${PORT} is available"
    exit 0
  fi
  TIMEOUT=$((TIMEOUT - 1))
  sleep 5
done

echo "Timeout reached: ${HOST}:${PORT} is not available"
exit 1
