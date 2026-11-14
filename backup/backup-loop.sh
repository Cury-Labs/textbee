#!/bin/bash
# Runs one backup when the container starts (so every deploy proves the backup works),
# then one per day at BACKUP_HOUR_UTC (default 6 UTC = 3h in Brasília).
set -uo pipefail

hour="${BACKUP_HOUR_UTC:-6}"

/usr/local/bin/backup.sh

while true; do
  now=$(date -u +%s)
  next=$(date -u -d "today ${hour}:00" +%s)
  if [ "$next" -le "$now" ]; then
    next=$(date -u -d "tomorrow ${hour}:00" +%s)
  fi
  sleep $((next - now))
  /usr/local/bin/backup.sh
done
