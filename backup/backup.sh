#!/bin/bash
# Dumps the textbee database to a temporary gzip archive and uploads it to R2.
# Logs one JSON line per run. Never logs the Mongo URI or the R2 keys.
set -euo pipefail

name="textbee-$(date -u +%Y-%m-%dT%H%M%SZ).archive.gz"
key="textbee/${name}"
file="/tmp/${name}"

log() {
  printf '{"context":"textbee-backup","message":"%s","details":{"key":"%s"%s}}\n' "$1" "$key" "${2:-}"
}

cleanup() { rm -f "$file"; }
trap cleanup EXIT

if mongodump --uri "$MONGO_URI" --archive="$file" --gzip --quiet \
  && rclone copyto "$file" "r2:${R2_BUCKET}/${key}"; then
  log "Backup uploaded" ",\"bytes\":$(stat -c %s "$file")"
else
  log "Backup failed"
  exit 1
fi
