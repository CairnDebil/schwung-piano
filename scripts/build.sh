#!/usr/bin/env bash
# Crea dist/piano-module.tar.gz (modulo Piano per Schwung / Ableton Move).
#
# Il motore audio (dsp.so) e' quello gia' compilato del Multisampler
# (release ufficiale), quindi non serve Docker ne' Rust.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ENGINE_URL="https://github.com/charlesvestal/schwung-sfz/releases/download/v0.6.6/sfz-module.tar.gz"
ENGINE_DSP_SHA256="94b65365e77e45f024d4ba36fccb8e0e77e383e32f54a11139cd9e1d2ec587f5"

[ -d instruments/Klaviano/samples ] || {
  echo "Mancano i campioni. Esegui prima: ./scripts/prepare_samples.sh Manthey_Klaviano.zip"; exit 1; }

mkdir -p build dist
if [ ! -f build/dsp.so ]; then
  echo "Scarico il motore Multisampler v0.6.6..."
  curl -fsSL "$ENGINE_URL" -o build/sfz-module.tar.gz
  tar -xzf build/sfz-module.tar.gz -C build sfz/dsp.so
  mv build/sfz/dsp.so build/dsp.so && rmdir build/sfz
fi
echo "$ENGINE_DSP_SHA256  build/dsp.so" | sha256sum -c -

rm -rf dist/piano && mkdir -p dist/piano/licenses
cp src/module.json src/ui.js src/help.json dist/piano/
cp build/dsp.so dist/piano/dsp.so && chmod +x dist/piano/dsp.so
cp LICENSE NOTICE dist/piano/
cp licenses/* dist/piano/licenses/
cp -r instruments dist/piano/instruments

( cd dist && tar -czf piano-module.tar.gz piano/ )
echo "Pronto: dist/piano-module.tar.gz"
echo "Installa con: ./scripts/install.sh"
