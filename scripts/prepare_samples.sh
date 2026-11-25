#!/usr/bin/env bash
# Converte i campioni di Manthey Klaviano (WAV 24 bit) in FLAC lossless
# e prepara la cartella instruments/Klaviano del modulo Piano.
#
# Uso: ./scripts/prepare_samples.sh /percorso/Manthey_Klaviano.zip
# Richiede: unzip, ffmpeg, python3
set -euo pipefail

ZIP="${1:?uso: $0 /percorso/Manthey_Klaviano.zip}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
DST="$ROOT/instruments/Klaviano"
trap 'rm -rf "$TMP"' EXIT

unzip -q "$ZIP" -d "$TMP" -x '__MACOSX/*' '*.DS_Store'
SRC="$TMP/Manthey Klaviano"

mkdir -p "$DST/samples"
( cd "$SRC/samples" && ls *.wav | xargs -P 8 -I{} sh -c \
  'ffmpeg -v error -y -i "{}" -c:a flac -sample_fmt s32 -bits_per_raw_sample 24 \
     -compression_level 8 "'"$DST"'/samples/$(basename "{}" .wav).flac"' )

# Preset DecentSampler: percorsi .wav -> .flac, senza immagine di sfondo
sed -e 's/\.wav"/.flac"/g' -e 's/bgImage="resources\/manthey.jpg" //' \
    "$SRC/Manthey Klaviano.dspreset" > "$DST/Klaviano.dspreset"
cp "$SRC/ReadMe.txt" "$DST/ReadMe.txt"

echo "Campioni pronti in: $DST ($(ls "$DST/samples" | wc -l) file)"
