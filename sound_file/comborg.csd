<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
kr = 22050
ksmps = 2
nchnls=2
zakinit 30, 30

;---------------------------------------------------------------------------------
; Low Frequency Oscillator
       instr    1

iamp   =        p4
ilfo   =        p5
iwave  =        p6
ioutch =        p7

klfo   oscil    iamp, ilfo, iwave
       zkw      klfo, ioutch

       endin

;---------------------------------------------------------------------------------
; Rectangle Additive Wave (Band Limited Impulse Train)
        instr   10

idur    =       p3
iamp    =       p4
ifqc    =       cpspch(p5)
ifqc2   =       ifqc*p6
iamp2   =       p7
ifqc3   =       ifqc*p8
iamp3   =       p9
ifqc4   =       ifqc*p10
iamp4   =       p11
ifco    =       p13

kdclik  linseg  0, .002, iamp, idur-.004, iamp, .002, 0
klfo    zkr     p12
kfqc    =       ifqc*(1+klfo)
kfqc2   =       kfqc*p6
kfqc3   =       kfqc*p8
kfqc4   =       kfqc*p10

apulse1 buzz    1, kfqc, sr/2/ifqc, 1  ; Avoid aliasing by not going over sr/2/fqc
apulsd1 delay   apulse1, .5/ifqc
asquar1 =       apulse1 - apulsd1      ; two inverted pulses at variable distance

apulse2 buzz    iamp2, kfqc2, sr/2/ifqc2, 1 ; Avoid aliasing
apulsd2 delay   apulse2, .5/ifqc2
asquar2 =       apulse2 - apulsd2      ; two inverted pulses at variable distance

apulse3 buzz    iamp3, kfqc3, sr/2/ifqc3, 1 ; Avoid aliasing
apulsd3 delay   apulse3, .5/ifqc3
asquar3 =       apulse3 - apulsd3      ; two inverted pulses at variable distance

apulse4 buzz    iamp4, kfqc4, sr/2/ifqc4, 1 ; Avoid aliasing
apulsd4 delay   apulse4, .5/ifqc4
asquar4 =       apulse4 - apulsd4      ; two inverted pulses at variable distance

asquare integ   asquar1+asquar2+asquar3+asquar4

aout   butterlp asquare, ifco


       outs     kdclik*aout, kdclik*aout
       endin


</CsInstruments>

<CsScore>
f1 0 16384 10 1                               ; Sine

;    Sta  Dur  Amp   Fqc  Wave  OutKCh
i1   0    7.5  .004  6    1     1

;    Sta  Dur  Amp    Pitch  Fqc2  Amp2  Fqc3  Amp3  Fqc4  Amp4  LFOCh  Fco
i10  0    0.6  10000  8.04   1.5   .5    2.0   .7    3.0   .2    1      8000
i10  +    0.6  .      8.04   .     .     .     .     .     .     .      .
i10  .    0.3  .      8.07   .     .     .     .     .     .     .      .
i10  .    0.3  .      8.06   .     .     .     .     .     .     .      .
i10  .    0.3  .      8.02   .     .     .     .     .     .     .      .
i10  .    0.6  .      8.04   .     .     .     .     .     .     .      .
i10  .    0.6  .      8.11   .     .     .     .     .     .     .      .
i10  .    0.6  .      8.09   .     .     .     .     .     .     .      .
i10  .    0.6  .      8.07   .     .     .     .     .     .     .      .
i10  .    0.3  .      8.02   .     .     .     .     .     .     .      .
i10  .    0.6  .      8.04   .     .     .     .     .     .     .      .
i10  .    0.6  .      8.04   .     .     .     .     .     .     .      .
i10  .    0.3  .      8.07   .     .     .     .     .     .     .      .
i10  .    0.3  .      8.06   .     .     .     .     .     .     .      .
i10  .    0.3  .      8.02   .     .     .     .     .     .     .      .
i10  .    0.6  .      8.04   .     .     .     .     .     .     .      .

</CsScore>
</CsoundSynthesizer>
