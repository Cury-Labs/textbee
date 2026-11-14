#!/bin/bash
# Runs once when the container starts (so every deploy proves it works), then once per day at
# BACKUP_HOUR_UTC (default 6 UTC = 3h in Brasília): first the retention clean-up, then the backup.
set -uo pipefail

hour="${BACKUP_HOUR_UTC:-6}"

run_daily() {
  /usr/local/bin/maintenance.sh || echo '{"context":"textbee-maintenance","message":"Retention failed"}'
  /usr/local/bin/backup.sh
}

run_daily

while true; do
  now=$(date -u +%s)
  next=$(date -u -d "today ${hour}:00" +%s)
  if [ "$next" -le "$now" ]; then
    next=$(date -u -d "tomorrow ${hour}:00" +%s)
  fi
  sleep $((next - now))
  run_daily
done
