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

Updating: merge a newer upstream tag into `cury`, test, then redeploy.
