#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_ROOT="$ROOT/_site"          # keep this so Capistrano still rsyncs/_serves the same dir
DOCS_DIR="$ROOT/docs"
EXTRA_CSS="$DOCS_DIR/styles/extra.css"
MKDOCS_YML="$ROOT/mkdocs.yml"

# sanity checks
[[ -f "$MKDOCS_YML" ]] || { echo "Missing $MKDOCS_YML"; exit 1; }
[[ -d "$DOCS_DIR"    ]] || { echo "Missing $DOCS_DIR/"; exit 1; }
[[ -f "$EXTRA_CSS"   ]] || echo "Note: $EXTRA_CSS not found (ok if not used)."

# clean build dir
rm -rf "$BUILD_ROOT"
mkdir -p "$BUILD_ROOT"

# single build for the unified site -> _site
mkdocs build --clean --site-dir "$BUILD_ROOT"

echo "Build complete → $BUILD_ROOT"