#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_ROOT="$ROOT/_site"
SHARED_CSS="$ROOT/shared/extra.css"
SHARED_IMG_DIR="$ROOT/shared/img"

# Ensure shared assets exist (CSS required, images optional)
[[ -f "$SHARED_CSS" ]] || { echo "Missing $SHARED_CSS"; exit 1; }
[[ -d "$SHARED_IMG_DIR" ]] || echo "Note: $SHARED_IMG_DIR not found; skipping shared image sync."

# Sites to build
SITES=(home laravel react-native nodejs)

# Sync shared CSS into each site's docs/ so `mkdocs serve` works per-site
for SITE in "${SITES[@]}"; do
  mkdir -p "$ROOT/$SITE/docs/styles"
  cp "$SHARED_CSS" "$ROOT/$SITE/docs/styles/extra.css"

  # Sync shared images (to avoid name collisions, put them under img/shared/)
  if [[ -d "$SHARED_IMG_DIR" ]]; then
    mkdir -p "$ROOT/$SITE/docs/img/shared"
    # Use rsync if available for smarter syncing; fall back to cp -R
    if command -v rsync >/dev/null 2>&1; then
      rsync -a --delete "$SHARED_IMG_DIR"/ "$ROOT/$SITE/docs/img/shared/"
    else
      # crude sync; won’t delete removed files
      cp -R "$SHARED_IMG_DIR"/. "$ROOT/$SITE/docs/img/shared/" 2>/dev/null || true
    fi
  fi
done

# Clean build output
rm -rf "$BUILD_ROOT"
mkdir -p "$BUILD_ROOT"

# Build HOME → /
mkdocs build -f "$ROOT/home/mkdocs.yml" --clean --site-dir "$BUILD_ROOT/root"

# Build SECTIONS
mkdocs build -f "$ROOT/laravel/mkdocs.yml" --clean --site-dir "$BUILD_ROOT/laravel"
mkdocs build -f "$ROOT/react-native/mkdocs.yml" --clean --site-dir "$BUILD_ROOT/react-native"
mkdocs build -f "$ROOT/nodejs/mkdocs.yml" --clean --site-dir "$BUILD_ROOT/nodejs"

echo "Build complete → $BUILD_ROOT"