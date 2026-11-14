# Cury Labs fork of textbee

Fork of [vernu/textbee](https://github.com/vernu/textbee) (AGPL-3.0) used by
[Cury Avisa](https://github.com/Cury-Labs/cury-avisa). Deployed branch: `cury`,
based on upstream tag `v2.9.0`.

Changes from upstream (published here to comply with the AGPL):

- `docker-compose.coolify.yaml`: deployment for Coolify (no host ports, pinned
  images, memory limits, settings from environment variables).
- `web/Dockerfile`: `NEXT_PUBLIC_*` values enter the build as build args.
- `android/app/build.gradle`: the prod flavor calls `https://textbee.curylabs.com.br/api/v1/` and
  the app is named "Cury Avisa SMS". `google-services.json` is git-ignored.
- `scripts/build-apk.sh`: builds the APK in Docker (no Android Studio needed); usage in the file.
- `backup/` and the `textbee-backup` service: `mongodump` streamed to a private Cloudflare R2
  bucket (`textbee/` prefix), once on start and daily at `BACKUP_HOUR_UTC` (default 6 UTC).
  Needs `R2_ENDPOINT`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY` (and optional `R2_BUCKET`).
  Retention is a lifecycle rule on the bucket.
- `backup/maintenance.sh` (same service, before each daily backup): wipes SMS texts older than
  24 hours (they include login codes) and deletes SMS, batches and webhook notifications older
  than 3 months.

Updating: merge a newer upstream tag into `cury`, test, then redeploy.
