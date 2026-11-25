/*
 * Piano - modulo Schwung
 *
 * Pianoforte con campioni integrati (Manthey Klaviano).
 * Il motore audio e' quello del Multisampler; qui c'e' solo
 * l'interfaccia, senza navigazione tra librerie.
 */

/* Percorso assoluto: il modulo funziona da qualsiasi cartella */
import { createSoundGeneratorUI } from '/data/UserData/schwung/shared/sound_generator_ui.mjs';

const ui = createSoundGeneratorUI({
    moduleName: 'Piano',
    showPolyphony: true,
    showOctave: true,
});

globalThis.init = ui.init;
globalThis.tick = ui.tick;
globalThis.onMidiMessageInternal = ui.onMidiMessageInternal;
globalThis.onMidiMessageExternal = ui.onMidiMessageExternal;
