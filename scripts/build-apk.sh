#!/bin/bash
# Builds the textbee Android APK (prod flavor, release) inside a JDK 17 container.
# Usage (from the repo root, with android/app/google-services.json copied in):
#   docker run --rm -v "$PWD:/src" -v "$PWD/scripts/build-apk.sh:/build-apk.sh:ro" #     -v cury-gradle-cache:/root/.gradle -e DEBIAN_FRONTEND=noninteractive #     eclipse-temurin:17-jdk bash /build-apk.sh
# Output: android/app/build/outputs/apk/prod/release/app-prod-release.apk
set -euo pipefail
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
apt-get update -qq && apt-get install -y -qq unzip wget >/dev/null
mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
cd /tmp
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip
unzip -q tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools
mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest
(yes || true) | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses >/dev/null || true
$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager "platforms;android-34" "build-tools;34.0.0" "platform-tools" >/dev/null
mkdir -p ~/.android
keytool -genkeypair -v -keystore ~/.android/debug.keystore -storepass android -alias androiddebugkey \
  -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US" >/dev/null 2>&1
cd /src/android
chmod +x gradlew
./gradlew --no-daemon -q assembleProdRelease
ls -la app/build/outputs/apk/prod/release/
