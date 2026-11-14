#!/bin/bash
# Dumps the textbee database and streams it to R2 as a gzip archive.
# Logs one JSON line per run. Never logs the Mongo URI or the R2 keys.
set -euo pipefail

key="textbee/textbee-$(date -u +%Y-%m-%dT%H%M%SZ).archive.gz"
target="r2:${R2_BUCKET}/${key}"

log() {
  printf '{"context":"textbee-backup","message":"%s","details":{"key":"%s"%s}}\n' "$1" "$key" "${2:-}"
}

if mongodump --uri "$MONGO_URI" --archive --gzip --quiet | rclone rcat "$target"; then
  size=$(rclone lsf --format s "$target")
  log "Backup uploaded" ",\"bytes\":${size:-0}"
else
  rclone deletefile "$target" >/dev/null 2>&1 || true
  log "Backup failed"
  exit 1
fi
