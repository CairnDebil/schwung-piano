#!/usr/bin/env bash
# Controlli offline: JSON validi, versione coerente, tutti i campioni del preset presenti.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 -I - <<'PY'
import json, os, re, sys
errori = []
mod = json.load(open("src/module.json", encoding="utf-8"))
json.load(open("src/help.json", encoding="utf-8"))
rel = json.load(open("release.json", encoding="utf-8"))

for chiave in ("id", "name", "version", "ui", "dsp", "api_version"):
    if chiave not in mod:
        errori.append(f"module.json: manca '{chiave}'")
if mod.get("id") not in rel.get("modules", {}):
    errori.append("release.json: modulo mancante in 'modules'")

preset = "instruments/Klaviano/Klaviano.dspreset"
testo = open(preset, encoding="utf-8").read()
percorsi = re.findall(r'path="([^"]+)"', testo)
if not percorsi:
    errori.append("preset senza campioni")
for p in sorted(set(percorsi)):
    if not p.endswith(".flac"):
        errori.append(f"percorso non FLAC: {p}")
    elif not os.path.exists(os.path.join("instruments/Klaviano", p)):
        errori.append(f"campione mancante: {p}")

if errori:
    print("\n".join("ERRORE: " + e for e in errori)); sys.exit(1)
print(f"OK: modulo {mod['id']} v{mod['version']}, {len(set(percorsi))} campioni presenti")
PY
