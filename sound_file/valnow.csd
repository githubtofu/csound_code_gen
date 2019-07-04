<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr=44100
kr=22050
ksmps=2
nchnls=1
zakinit 30, 30

;---------------------------------------------------------------------------
; Waveguide Pluck
;---------------------------------------------------------------------------
       instr  2

iamp   =      p4
ifqc   =      cpspch(p5)  ; Convert to frequency
itab1  =      p6          ; Initial table
imeth  =      p7          ; Decay method
ioutch =      p8          ; Output channel
isus   =      p9
p3     =      p3+isus

kamp   linseg 0, .02, 1, p3-.07, 1, .05, 0 ; Amplitude

aplk   pluck    iamp, ifqc, ifqc, itab1, imeth    ; Pluck waveguide model
       ;zawm     aplk*kamp, ioutch                 ; Write to output
       outs aplk
       endin

</CsInstruments>

<CsScore>
;---------------------------------------------------------------------------
; Em Arpeggio Intro (10.0-29.2)
;---------------------------------------------------------------------------
;    Sta  Dur  Amp    Fqc   Func  Meth  OutCh  Sus
i2  0.0  0.2  16000  7.04   0     1    1      1.4
i2  +     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0

</CsScore>
</CsoundSynthesizer>
