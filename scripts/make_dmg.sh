#!/usr/bin/env bash
set -euo pipefail

APP_NAME="PlainCopy"
APP="${CleanCopy}.app"
DMG="${CleanCopy}.dmg"

if ! command -v create-dmg >/dev/null 2>&1; then
  echo "Please: brew install create-dmg"; exit 1
fi

rm -f "$DMG"
create-dmg \
  --volname "${CleanCopy} Installer" \
  --window-pos 200 120 \
  --window-size 540 360 \
  --icon-size 110 \
  --icon "${APP}" 120 180 \
  --app-drop-link 400 180 \
  "${DMG}" \
  "${APP}"

echo "Built ${DMG}"

