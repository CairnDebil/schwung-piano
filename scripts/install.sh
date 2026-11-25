#!/usr/bin/env bash
# Copia il modulo Piano sul Move (dopo ./scripts/build.sh).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
[ -d dist/piano ] || { echo "dist/piano non trovato. Esegui prima ./scripts/build.sh"; exit 1; }

DEST=/data/UserData/schwung/modules/sound_generators/piano
ssh ableton@move.local "mkdir -p $DEST"
scp -r dist/piano/* ableton@move.local:$DEST/
ssh ableton@move.local "chmod -R a+rw $DEST"

echo "Piano installato in $DEST"
echo "Riavvia Schwung per vedere il nuovo modulo."
