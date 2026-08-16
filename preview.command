#!/bin/zsh

set -euo pipefail

PROJECT_DIR="${0:A:h}"
SOURCE_DIR="${PROJECT_DIR}/source"
SITE_DIR="${PROJECT_DIR}/docs"
PORT=8000
CSS_VERSION=$(shasum -a 256 "${SITE_DIR}/styles.css" | cut -c1-10)

cd "${SITE_DIR}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Pandoc is required to build the preview."
  exit 1
fi

pandoc "${SOURCE_DIR}/ghosts-in-the-machine.md" \
  --from=markdown+raw_html \
  --to=html5 \
  --standalone \
  --section-divs \
  --lua-filter="${SOURCE_DIR}/external-links.lua" \
  --metadata title= \
  --metadata "pagetitle=Ghosts in the Machines" \
  --css="styles.css?v=${CSS_VERSION}" \
  --output="${SITE_DIR}/index.html"

python3 -m http.server "${PORT}" --bind 127.0.0.1 >/tmp/ghosts-in-machines-preview.log 2>&1 &
SERVER_PID=$!

trap 'kill "${SERVER_PID}" 2>/dev/null || true' EXIT INT TERM

sleep 0.5
open "http://127.0.0.1:${PORT}/"
wait "${SERVER_PID}"
