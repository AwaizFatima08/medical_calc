#!/usr/bin/env bash
# Backs up Medical Calc:
#   Local mirror + snapshot (INCLUDING ../medical_calc-secrets once it exists)
#   -> /mnt/storage/project_backups/medical_calc_backup/
# Google Drive: not set up yet (no Drive folder chosen).
# Git push to github.com/AwaizFatima08/medical_calc is done separately.
set -euo pipefail
SRC="$(cd "$(dirname "$0")/.." && pwd)"
SECRETS="$(dirname "$SRC")/medical_calc-secrets"
LOCAL=/mnt/storage/project_backups/medical_calc_backup
STAMP=$(date +%Y%m%d_%H%M)

EXCLUDES=(--exclude 'build/' --exclude '.dart_tool/' --exclude 'node_modules/'
          --exclude '.gradle/' --exclude '.idea/' --exclude '*.iml' --exclude '.cxx/')

echo "== Local mirror -> $LOCAL/current"
mkdir -p "$LOCAL"
rsync -a --delete "${EXCLUDES[@]}" "$SRC/" "$LOCAL/current/"
[ -d "$SECRETS" ] && rsync -a "$SECRETS/" "$LOCAL/secrets/" && chmod 700 "$LOCAL/secrets"

echo "== Local snapshot archive"
tar -C "$(dirname "$SRC")" -czf "$LOCAL/medical_calc_${STAMP}.tar.gz" \
  --exclude='*/build' --exclude='*/.dart_tool' --exclude='*/node_modules' --exclude='*/.gradle' \
  "$(basename "$SRC")"
# Keep the 10 newest snapshots.
ls -1t "$LOCAL"/medical_calc_*.tar.gz | tail -n +11 | xargs -r rm --

AAB="$SRC/build/app/outputs/bundle/release/app-release.aab"
if [ -f "$AAB" ]; then
  mkdir -p "$LOCAL/release"
  cp "$AAB" "$LOCAL/release/"
fi
echo "Backup complete ($STAMP)."
