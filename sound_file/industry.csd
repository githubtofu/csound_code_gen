<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

;------------------------------------------------------------------
; Industry
; by Hans Mikelson April 1998
;------------------------------------------------------------------
; ORCHESTRA

sr=44100
kr=22050
ksmps=2
nchnls=2

;------------------------------------------------------------------
; Industrial Loops
;------------------------------------------------------------------
        instr      2

idur    =          p3
iamp    =          p4*2
ifqc    =          cpspch(p5)
iplstab =          p6
irattab =          p7
iratrat =          p8
ipantab =          p9
imixtab =          p10
iloop   =          p11
adel    init       0

kprate  oscil      1, iratrat, irattab            ; Pulse Rate
kamp    oscil      iamp, kprate, iplstab          ; Amplitude Pulse
kloop   linseg     0, .005, 1, iloop-.01, 1, .005,  0, p3-iloop-.01, 0 ; Gate in delay loop
kpan    oscil      1, 1/idur, ipantab             ; Panning
kmix    oscil      1, 1/idur, imixtab             ; Fading

asig    rand       kamp                           ; Noise source
aflt    butterbp   asig, ifqc, ifqc/4             ; Band Filter
abal    balance    aflt, asig                     ; Bring level back up

aout    =          abal*kloop+adel                ; Gate in with feedback
adel    delay      aout, iloop                    ; Delay

        outs       aout*sqrt(kpan)*kmix, aout*sqrt(1-kpan)*kmix ; Output pan & fade

        endin

;------------------------------------------------------------------
; SciFi Loops
;------------------------------------------------------------------
        instr      3

idur    =          p3
iamp    =          p4
ifqc    =          cpspch(p5)
irattab =          p6
iratrat =          p7
ipantab =          p8
imixtab =          p9
iloop   =          p10
imodf   =          p11
imodl   =          p12
adel    init       0

krate   oscil      1, iratrat, irattab            ; Pulse Rate
kloop   linseg     0, .005, 1, iloop-.01, 1, .005,  0, p3-iloop-.01, 0 ; Gate in delay loop
kpan    oscil      1, 1/idur, ipantab             ; Panning
kmix    oscil      1, 1/idur, imixtab             ; Fading

;                Amp   Fqc         Car   Mod    MAmp    Wave
abal    foscil   iamp, ifqc*krate, 1,    imodf, imodl,  1    ; FM Source

aout    =          abal*kloop+adel                ; Gate in with feedback
adel    delay      aout, iloop                    ; Delay

        outs       aout*sqrt(kpan)*kmix, aout*sqrt(1-kpan)*kmix ; Output pan & fade

        endin



</CsInstruments>

<CsScore>
; SCORE
f1 0 8192 10 1 ; Sine

; Pulse Tables
f10  0 1024   7  0 256 0 256 1 256 0 256 0
f11 0 1024   7  0 256 0 128 0 128 1 128 0 128 0 256 0
f12 0 1024   7  0 512 1 512 0
; Rate Tables
f20  0 1024  -5  100  512  1000  512 100
f21  0 1024  -5  10  1024 1000
f22  0 1024  -5  100  512  10000 512  30
f23  0 1024  -5  25  1024  62
f24  0 1024  -7  500  1024  62
f25  0 1024  -5  5000 1024  1000
f26  0 1024  -7  50   512  500 512 50
f27  0 1024  -5  .5   512  2 512 .5
f28  0 1024  -5  .5   1024 4
f29  0 1024  -7  .5   250 .5 6 2 250 2 6 1 250 1 6 4 256 .5
; Pan Tables
f30  0 1024  7  0  1024  1
f31  0 1024  7  1  1024  0
f32  0 1024  7  1 512  0 512 1
f33  0 1024  -7 .5 1024 .5
; Mix Tables
f40  0 1024  5  .01 256 1 512 1 256 .01
f41  0 1024  5  .01 128 1 768 1 128 .01
f42  0 1024  5  1 1024 1

; Generate Industrial Loops
;   Sta  Dur  Amp   Pitch  PulsTab  RtTab  RtRt  PanTab  MixTab  Loop
i2  0    8    6000  9.00   11       22      1     31      41      .2
i2  3    10   8000  7.00   10       22      1     32      41      .3
i2  7    12   4000  9.00   11       23      10    30      40      .2
i2  9    12   8000  8.00   11       24      10    32      41      .05
i2  11   10   7000  7.00   11       25      4     31      40      .5
i2  12   19  15000  7.02   11       25      10    32      41      .2
i2  17   2   16000  8.00   11       26      10    33      42      .01
i2  19.5 2   16000  8.00   11       26      10    33      42      .01
i2  17   10  11000  8.05   11       26      10    31      41      .08

; Generate Sci-Fi Sounds
;   Sta  Dur  Amp   Pitch  RtTab  RtRt  PanTab  MixTab  Loop  FMFqc FMAmp
i3  1    4   10000  8.00   27     1     31      41      .1    2     3
i3  5    2   10000  7.00   28     4     33      41      .2    2     3
i3  14   6   10000  8.05   27     1     31      40      .05   2.53  4
i3  25   4   10000  9.00   29     2     32      41      .3    4.21  2
i3  8    5   10000  8.00   29     3     30      41      .45   .5    3

</CsScore>
</CsoundSynthesizer>
