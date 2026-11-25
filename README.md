# Piano — modulo Schwung per Ableton Move

Pianoforte pronto all'uso, con i campioni **integrati nel modulo**: nessuna libreria da caricare.
Suona il **Manthey Klaviano** di Michele Pedrazzi (spinet costruito a Berlino negli anni '60-'70):
4 livelli di dinamica, 2 round robin, rumori di rilascio, 137 campioni stereo a 24 bit / 44.1 kHz.

## Come è fatto

Piano è un modulo *sound generator* che riusa il motore del [Multisampler](https://github.com/charlesvestal/schwung-sfz)
(xsynth, LGPL-3.0) senza modificarlo, e lo accompagna con:

- `src/module.json`, `src/ui.js`, `src/help.json`: identità del modulo (id `piano`), interfaccia e guida sul dispositivo.
- `instruments/Klaviano/`: il preset DecentSampler originale (percorsi adattati) e i campioni convertiti in **FLAC lossless**
  (da 454 MB a 169 MB, identici agli originali).
- `dsp.so`: motore precompilato del Multisampler v0.6.6 (scaricato e verificato con SHA-256 da `build.sh`).

Il Multisampler esistente sul Move non viene toccato: Piano si installa in una cartella propria (`.../sound_generators/piano`).

## Controlli

| Controllo | Effetto |
|---|---|
| Manopole 1-3 | Attack, Release, Tone (dal preset originale) |
| Octave | Trasposizione da -4 a +4 ottave |
| Gain | Volume di uscita |
| Voices | Polifonia massima |
| Funverb | Riverbero aggiuntivo del motore |

Chorus ed eco del preset originale non sono supportati dal motore: usa un effetto dopo Piano nella catena.

## Installazione

1. Scarica `piano-module.tar.gz` dalla pagina [Releases](https://github.com/CairnDebil/schwung-piano/releases).
2. Scompattalo e copia la cartella `piano` in `/data/UserData/schwung/modules/sound_generators/` sul Move.
3. Riavvia Schwung: Piano compare tra i sound generator.

## Costruire dai sorgenti

```bash
./scripts/build.sh      # crea dist/piano-module.tar.gz (campioni già inclusi nel repository)
./scripts/install.sh    # copia su move.local
```

Servono `curl` e `ssh/scp`. `scripts/prepare_samples.sh` serve solo per rigenerare i FLAC dall'archivio originale
del Klaviano (richiede anche `ffmpeg` e `unzip`).

## Primo caricamento su GitHub

Crea il repository vuoto `schwung-piano` sulla tua pagina, poi:

```bash
cd schwung-piano
git init -b main
git add -A
git commit -m "feat: modulo Piano v0.1.0 con campioni Manthey Klaviano integrati"
git remote add origin https://github.com/CairnDebil/schwung-piano.git
git push -u origin main
git tag v0.1.0 && git push origin v0.1.0
```

Il tag avvia la release: GitHub Actions esegue i controlli, costruisce il pacchetto,
lo allega alla release con le note prese dal `CHANGELOG.md` e aggiorna `release.json`.

## Pubblicare una nuova versione

Aggiorna `version` in `src/module.json`, aggiungi la sezione corrispondente al `CHANGELOG.md`,
poi crea e invia il tag (ad esempio `v0.1.1`). I tag `v0.*` escono come prerelease, come in HEIMAT.

`./scripts/test.sh` esegue gli stessi controlli della pipeline: JSON validi, versione coerente
tra `module.json` e `release.json`, e presenza di tutti i campioni richiesti dal preset.

## Crediti e licenze

- Campioni: **Manthey Klaviano** v1.1 di Michele Pedrazzi, da [Pianobook](https://www.pianobook.co.uk/). Il suo `ReadMe.txt` è incluso (vedi anche `NOTICE`). Verifica le condizioni d'uso indicate nella pagina Pianobook prima di ridistribuire il modulo.
- Motore: Multisampler di charlesvestal, basato su [xsynth](https://github.com/arduano/xsynth) (LGPL-3.0). `LICENSE`, `NOTICE` e `licenses/` viaggiano con il pacchetto.
- Modulo Piano: CairnDebil — https://github.com/CairnDebil
