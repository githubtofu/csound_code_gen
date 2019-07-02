<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

;---------------------------------------------------------------------------------
; A Set of Band Limited Instruments with Resonant Filter
; by Hans Mikelson 11/20/97
; partially derived from code by Josep Mª Comajuncosas-Csound & Tim Stilson-CCRMA
;---------------------------------------------------------------------------------
sr = 22050
kr = 2205
ksmps = 10
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
; Envelope
       instr    2

idur   =        p3
iamp   =        p4
ishape =        p5
ioutch =        p6

kenv   oscil    iamp, 1/idur, ishape
       zkw      kenv, ioutch

       endin

;---------------------------------------------------------------------------------
; Pulse Width Modulation (Band Limited Impulse Train)
        instr   10

idur    =       p3
iamp    =       p4
ifqc    =       cpspch(p5)
iampenv =       p6
ifcotab =       p7
ireztab =       p8
ifcoch  =       p9
irezch  =       p10
ilfoch  =       p11
ipanl   =       sqrt(p12)
ipanr   =       sqrt(1-p12)

kdclik linseg   0, .002, iamp, idur-.004, iamp, .002, 0
kamp   oscil    kdclik, 1/idur, iampenv 
kfcoe  oscil    1, 1/idur, ifcotab
kreze  oscil    1, 1/idur, ireztab
kfcoc  zkr      ifcoch
krezc  zkr      irezch
kfco   =        kfcoe*kfcoc
krez   =        kreze*krezc
ifqcadj =       6600

klfo   zkr      ilfoch
kfqc   =        ifqc+klfo
kfco   oscil    1, 1/idur, ifcotab
krez   oscil    1, 1/idur, ireztab

apulse1 buzz    1,ifqc, sr/2/ifqc, 1 ; Avoid aliasing
apulse3 buzz    1,kfqc, sr/2/kfqc, 1
apulse2 delay   apulse3, 1/ifqc/2         ; a better idea?
avpw    =       apulse1 - apulse2         ; two inverted pulses at variable distance
apwmdc  integ   avpw
axn     =       apwmdc-.5                ; remove DC offset caused by integ

; Resonant Lowpass Filter (4 Pole)
ka1    =        ifqcadj/krez/kfco-1
ka2    =        ifqcadj/kfco
kasq   =        ka2*ka2
kb     =        1+ka1+kasq

ayn    nlfilt   axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

       outs     kamp*ayn2*ipanl, kamp*ayn2*ipanr
       endin

;---------------------------------------------------------------------------------
; Rectangle Wave (Band Limited Impulse Train)
        instr   11

idur    =       p3
iamp    =       p4
ifqc    =       cpspch(p5)
iampenv =       p6
ifcotab =       p7
ireztab =       p8
ifcoch  =       p9
irezch  =       p10
ipw     =       p11

kdclik linseg   0, .002, iamp, idur-.004, iamp, .002, 0
kamp   oscil    kdclik, 1/idur, iampenv 
kfcoe  oscil    1, 1/idur, ifcotab
kreze  oscil    1, 1/idur, ireztab
kfcoc  zkr      ifcoch
krezc  zkr      irezch
kfco   =        kfcoe*kfcoc
krez   =        kreze*krezc

kfco   oscil    1, 1/idur, ifcotab
krez   oscil    1, 1/idur, ireztab

apulse1 buzz    1,ifqc, sr/2/ifqc, 1 ; Avoid aliasing
apulse3 buzz    1,ifqc, sr/2/ifqc, 1
apulse2 delay   apulse3, 1/ifqc*ipw         ; a better idea?
avpw    =       apulse1 - apulse2         ; two inverted pulses at variable distance
apwmdc  integ   avpw
axn     =       apwmdc-.5                 ; remove DC offset caused by integ

; Resonant Lowpass Filter (4 Pole)
ka1    =        1000/krez/kfco-1
ka2    =        100000/kfco/kfco
kb     =        1+ka1+ka2
ayn    nlfilt   axn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1

       outs     kamp*ayn2, kamp*ayn2
       endin

;---------------------------------------------------------------------------------
; Sawtooth (Band Limited Impulse Train)
        instr   12

idur    =       p3
iamp    =       p4
ifqc    =       cpspch(p5)
iampenv =       p6
ifcotab =       p7
ireztab =       p8
ifcoch  =       p9
irezch  =       p10
ipanl   =       sqrt(p11)
ipanr   =       sqrt(1-p11)
ioutch1 =       p12
ioutch2 =       p13

kdclik linseg   0, .002, iamp, idur-.004, iamp, .002, 0
kamp   oscil    kdclik, 1/idur, iampenv 
kfcoe  oscil    1, 1/idur, ifcotab
kreze  oscil    1, 1/idur, ireztab
kfcoc  zkr      ifcoch
krezc  zkr      irezch
kfco   =        kfcoe*kfcoc
krez   =        kreze*krezc

apulse buzz     1,ifqc, sr/2/ifqc, 1 ; Avoid aliasing
asawdc integ    apulse
axn    =        asawdc-.5

; Resonant Lowpass Filter (4 Pole)
ka1    =        1000/krez/kfco-1
ka2    =        100000/kfco/kfco
kb     =        1+ka1+ka2
ayn    nlfilt   axn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1

aoutl  =        kamp*ayn2*ipanl
aoutr  =        kamp*ayn2*ipanr
       outs     aoutl, aoutr
       zawm     aoutl, ioutch1
       zawm     aoutr, ioutch2

       endin

;---------------------------------------------------------------------------------
; Two Oscillator Sawtooth  (Band Limited Impulse Train)
        instr   13

idur    =       p3
iamp    =       p4
ifqcm   =       cpspch(p5)
ifqcs   =       p6*ifqcm
iamps   =       p7
iampenv =       p8
ifcotab =       p9
ireztab =       p10
ifcoch  =       p11
irezch  =       p12
ipanl   =       sqrt(p13)
ipanr   =       sqrt(1-p13)
ioutchl =       p14
ioutchr =       p15

kamp   linseg   0, .02, iamp, idur-.07, .6*iamp, .05, 0 
kfcoe  oscil    1, 1/idur, ifcotab
kreze  oscil    1, 1/idur, ireztab
kfcoc  zkr      ifcoch
krezc  zkr      irezch
kfco   =        kfcoe*kfcoc
krez   =        kreze*krezc

apuls1 buzz     1,ifqcm, sr/2/ifqcm, 1 ; Avoid aliasing
apuls2 buzz     iamps,ifqcs, sr/2/ifqcs, 1
asawos integ    apuls1+apuls2
axn    =        asawos-1

; Resonant Lowpass Filter (4 Pole)
ka1    =        1000/krez/kfco-1
ka2    =        100000/kfco/kfco
kb     =        1+ka1+ka2
ayn    nlfilt   axn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1

aoutl  =        kamp*ayn2*ipanl
aoutr  =        kamp*ayn2*ipanr
       outs     aoutl, aoutr
       zawm     aoutl, ioutchl
       zawm     aoutr, ioutchr
       endin

;---------------------------------------------------------------------------------
; Ramp/Saw Modulation (Band Limited Impulse Train) Levels need adjusting
        instr   14

idur    =       p3
iamp    =       p4
ifqc    =       cpspch(p5)
iampenv =       p6
ifcotab =       p7
ireztab =       p8
ifcoch  =       p9
irezch  =       p10
ilfoch  =       p11

kdclik linseg   0, .002, iamp, idur-.004, iamp, .002, 0
kamp   oscil    kdclik, 1/idur, iampenv 
kfcoe  oscil    1, 1/idur, ifcotab
kreze  oscil    1, 1/idur, ireztab
kfcoc  zkr      ifcoch
krezc  zkr      irezch
kfco   =        kfcoe*kfcoc
krez   =        kreze*krezc

klfo   zkr      ilfoch
kfqc   =        ifqc+klfo
kfco   oscil    1, 1/idur, ifcotab
krez   oscil    1, 1/idur, ireztab

apulse1 buzz    1,ifqc, sr/2/ifqc, 1      ; Avoid aliasing
apulse3 buzz    1,kfqc, sr/2/kfqc, 1
apulse2 delay   apulse3, 1/ifqc/2         ; a better idea?
avpw    =       apulse1 - apulse2         ; two inverted pulses at variable distance
apwmdc  integ   avpw
apwm    butterhp apwmdc,5                 ; remove DC offset caused by integ
asawrmp integ   apwm
asrnorm =       2*ifqc/sr/klfo/1.5/(1-klfo/1.5)/100
axn     butterhp asrnorm,10

; Resonant Lowpass Filter (4 Pole)
ka1    =        1000/krez/kfco-1
ka2    =        100000/kfco/kfco
kb     =        1+ka1+ka2
ayn    nlfilt   axn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1

       outs     kamp*axn, kamp*asawrmp
       endin

;---------------------------------------------------------------------------------
; Delay
        instr   30

idur    =       p3
iamp    =       p4
idtime  =       p5
ifco    =       p6
ifeedbk =       p7
ixfdbk  =       p8
inchl   =       p9
inchr   =       p10
afsigl  init    0
afsigr  init    0
adsigl  init    0
adsigr  init    0

kdclick  linseg  0, .002, iamp, idur-.004, iamp, .002, 0

asigl   zar      inchl
asigr   zar      inchr

afdbkl  =        asigl+ifeedbk*(afsigl+adsigl)/2+ixfdbk*(afsigr+adsigr)/2
afdbkr  =        asigr+ifeedbk*(afsigr+adsigr)/2+ixfdbk*(afsigl+adsigl)/2

adsigl  delay    afdbkl, idtime
adsigr  delay    afdbkr, idtime

afsigl  butterlp adsigl, ifco
afsigr  butterlp adsigr, ifco

        outs     afdbkl*kdclick, afdbkr*kdclick
        zacl     0,30
        endin



</CsInstruments>

<CsScore>
;---------------------------------------------------------------------------------
; Temples of Tyria
;---------------------------------------------------------------------------------
f1 0 16384 10 1                               ; Sine

;---------------------------------------------------------------------------------
; Part 1 Deep Drone
;---------------------------------------------------------------------------------
f10 0 1024 -7 500 256 2000 256 500 512 1000   ; Fco Deep Drone
f11 0 1024 -7 6 1024 6                      ; Rez Deep Drone
f12 0 1024  7 .1 512 .05 512 .1               ; EnvFco
f13 0 1024  7 1  1024 1                       ; EnvRez
f14 0 1024  7 0  64   1 256 .9 640 .8  64 0   ; Amp

; LFO
;  Sta  Dur   Amp  Fqc  Wave  LFOCh
i1 0.0  41.6  0.5  .5   1     2      ; Low Fqc

; Envelope
;  Sta  Dur   Amp  Shape  OutKCh
i2 0.0  41.6  1    12     3
i2 0.0  41.6  1    13     4

; PWM
;   Sta   Dur  Amp    Pitch  AmpEnv  FcoEnv  RezEnv  FcoCh  RezCh  LFOCh  Pan
i10  0.0  4.8  5000   6.00   14      10      11      3      4      2      .7
i10  0.8  4.8  6000   5.00   .       .       .       3      4      2      .5
i10  3.2  4.8  8000   6.00   .       .       .       3      4      2      .3
i10  4.8  3.2  9000   5.00   .       .       .       3      4      2      .5
;
i10  6.4  4.8  10000  6.00   .       .       .       3      4      2      .7
i10  8.8  4.8  12000  5.00   .       .       .       3      4      2      .5
i10 11.2  4.8  13000  6.00   .       .       .       3      4      2      .3
i10 12.8  3.2  14000  5.00   .       .       .       3      4      2      .5
;
i10 14.4  4.8  10000  6.00   .       .       .       3      4      2      .7
i10 16.8  4.8  12000  5.00   .       .       .       3      4      2      .5
i10 19.2  4.8  13000  6.00   .       .       .       3      4      2      .3
i10 20.8  4.8  14000  5.00   .       .       .       3      4      2      .5
;
i10 22.4  4.8   8000  6.00   .       .       .       3      4      2      .7
i10 24.8  4.8  10000  5.00   .       .       .       3      4      2      .5
i10 27.2  4.8   9000  6.00   .       .       .       3      4      2      .3
i10 28.8  3.2  10000  5.00   .       .       .       3      4      2      .5
;
i10 30.4  4.8  8000   6.00   .       .       .       3      4      2      .7
i10 32.8  4.8  7000   5.00   .       .       .       3      4      2      .5
i10 35.2  4.8  6000   6.00   .       .       .       3      4      2      .3
i10 36.8  4.8  5000   5.00   .       .       .       3      4      2      .5

;---------------------------------------------------------------------------------
; Part 2 Bleep Beats
;---------------------------------------------------------------------------------
f20 0 1024 -7 20 256 80 256 40 256 200 256 30 ; Fco Bleep Beat
f21 0 1024 -7 10 1024 10                      ; Rez Bleep Beat
f22 0 1024  7 .1 512  1  512 .1               ; EnvFco
f23 0 1024  7 1  1024 1                       ; EnvRez
f24 0 1024  7 0 128   1 256 .7 512 .4 128 0   ; Amp

; Envelope
;  Sta  Dur  Amp  Shape  OutKCh
i2 3.2  6.4  1    22     5
i2 +    6.4  .    .      .
i2 .    6.4  .    .      .
i2 .    6.4  .    .      .
;
i2 3.2  6.4  1    23     6
i2 +    6.4  .    .      .
i2 .    6.4  .    .      .
i2 .    6.4  .    .      .

; Sawtooth
;   Sta Dur  Amp    Pitch  AmpEnv  FcoEnv  RezEnv  FcoCh  RezCh  Pan  OutCh1  OutCh2
i12 3.2 0.2  2000   8.00   24      20      21      5      6       .0  1       2
i12 +   0.2  <      8.03   .       .       .       .      .       .1  .       .
i12 .   0.2  <      8.05   .       .       .       .      .       .2  .       .
i12 .   0.2  <      8.07   .       .       .       .      .       .3  .       .
;                                                                 
i12 .   0.2  <      8.00   .       .       .       .      .       .4  .       .
i12 .   0.2  <      8.03   .       .       .       .      .       .5  .       .
i12 .   0.2  <      8.05   .       .       .       .      .       .6  .       .
i12 .   0.2  5000   8.07   .       .       .       .      .       .7  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .8  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .9  .       .
i12 .   0.2  .      8.05   .       .       .       .      .      1.0  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .9  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .1  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .8  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .2  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .7  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .3  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .6  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .4  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .5  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .4  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .6  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .3  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .7  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .2  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .8  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .1  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .9  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .0  .       .
i12 .   0.2  .      8.03   .       .       .       .      .      1.0  .       .
i12 .   0.2  .      8.05   .       .       .       .      .      1.0  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .1  .       .
;                                                                 
i12 .   0.2  .      8.00   .       .       .       .      .       .4  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .5  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .6  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .7  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .8  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .9  .       .
i12 .   0.2  .      8.05   .       .       .       .      .      1.0  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .9  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .1  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .8  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .2  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .7  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .3  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .6  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .4  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .5  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .4  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .6  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .3  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .7  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .2  .       .
i12 .   0.2  .      8.03   .       .       .       .      .       .8  .       .
i12 .   0.2  .      8.05   .       .       .       .      .       .1  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .9  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .0  .       .
i12 .   0.2  .      8.03   .       .       .       .      .      1.0  .       .
i12 .   0.2  .      8.05   .       .       .       .      .      1.0  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .1  .       .
;
i12 .   0.2  .      8.00   .       .       .       .      .       .0  .       .
i12 .   0.2  .      8.03   .       .       .       .      .      1.0  .       .
i12 .   0.2  .      8.05   .       .       .       .      .      1.0  .       .
i12 .   0.2  .      8.07   .       .       .       .      .       .1  .       .

;---------------------------------------------------------------------------------
; Part 3 Glimmer Glammer
;---------------------------------------------------------------------------------
f30 0 1024 -7 20 256 80 256 40 256 200 256 30 ; Fco Bleep Beat
f31 0 1024 -7 10 1024 10                      ; Rez Bleep Beat
f32 0 1024  7 .5 512 1 512 .5                 ; EnvFco
f33 0 1024  7 1  1024 1                       ; EnvRez
f34 0 1024  7 0  64   1 256 .9 640 .8  64 0   ; Amp

; Envelope
;  Sta   Dur  Amp  Shape  OutKCh
i2 9.6   4.8  1    32     7
i2 9.6   4.8  1    33     8

; Sawtooth Two Oscillator
;   Sta  Dur  Amp    Pitch  FRatio  ARatio  AmpEnv  FcoEnv  RezEnv  FcoCh  RezCh  Pan  OutCh1  OutCh2
i13 9.6  0.1  5000   10.00  1.5     1       34      30      31      7      8      1    1       2
i13 +    0.1  .       9.07  .       .       .       .       .       .      .      0    .       .
i13 .    0.1  .       9.10  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.06  .       .       .       .       .       .      .      0    .       .
;
i13 .    0.1  .      10.03  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.10  .       .       .       .       .       .      .      0    .       .
i13 .    0.1  .       9.05  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.10  .       .       .       .       .       .      .      0    .       .
;
i13 11.6 0.1  7000   10.00  1.5     .       .       .       .       .      .      1    .       .
i13 +    0.1  .       9.07  .       .       .       .       .       .      .      0    .       .
i13 .    0.1  .       9.10  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.06  .       .       .       .       .       .      .      0    .       .
;
i13 .    0.1  .      10.03  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.10  .       .       .       .       .       .      .      0    .       .
i13 .    0.1  .       9.05  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.10  .       .       .       .       .       .      .      0    .       .
;
i13 13.6 0.1  10000  10.00  1.5     .       .       .       .       .      .      1    .       .
i13 +    0.1  .       9.03  .       .       .       .       .       .      .      0    .       .
i13 .    0.1  .       9.07  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.10  .       .       .       .       .       .      .      0    .       .
;
i13 .    0.1  .      10.03  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.06  .       .       .       .       .       .      .      0    .       .
i13 .    0.1  .       9.05  .       .       .       .       .       .      .      1    .       .
i13 .    0.1  .       9.07  .       .       .       .       .       .      .      0    .       .


;---------------------------------------------------------------------------------
; Part 4 Fanfare
;---------------------------------------------------------------------------------
f40 0 1024  7 1   1024   1                           ; KnobFco
f41 0 1024  7 1   1024   1                           ; KnobRez
f42 0 1024 -7 300 64    350  256 250 704 300         ; EnvFco
f43 0 1024 -7 4   1024   2.5                         ; EnvRez
f44 0 1024  7 0   32     1    256 .8  672 .7  64  0  ; Amp
f45 0 1024  7 0   32     1    512 .8  256 .7  256 0  ; Amp

; Envelope
;  Sta    Dur  Amp  Shape  OutKCh
i2 16.0  26.4  1.0  40     9
i2 16.0  26.4  1.0  41     10

; Sawtooth
;   Sta  Dur  Amp    Pitch  FRatio  ARatio  AmpEnv  FcoEnv  RezEnv  FcoCh  RezCh  Pan  OutCh1  OutCh2
i13 16.0 0.4  20000  8.00   1.001   1       44      42      43      9      10     0.2  1       2
i13 +    3.2  25000  8.07   .       .       44      42      43      9      10     0.2  1       2
i13 19.2 0.4  25000  8.00   .       .       44      42      43      9      10     0.8  1       2
i13 +    0.4  30000  8.08   .       .       44      42      43      9      10     0.8  1       2
i13 .    2.4  25000  8.07   .       .       44      42      43      9      10     0.8  1       2
i13 .    0.4  20000  8.00   .       .       44      42      43      9      10     0.2  1       2
i13 .    3.2  25000  8.07   .       .       44      42      43      9      10     0.2  1       2
;
i13 29.2 0.4  20000  8.00   1.001   1       44      42      43      9      10     0.2  1       2
i13 +    3.2  25000  8.07   .       .       44      42      43      9      10     0.2  1       2
i13 .    0.2  25000  9.00   .       .       45      42      43      9      10     0.8  1       2
i13 .    0.2  30000  8.10   .       .       45      42      43      9      10     0.8  1       2
i13 .    2.4  25000  8.08   .       .       44      42      43      9      10     0.8  1       2
i13 .    0.4  20000  8.00   .       .       44      42      43      9      10     0.2  1       2
i13 .    3.2  25000  8.07   .       .       44      42      43      9      10     0.2  1       2
;
; Delay
;    Sta  Dur  Amp  DTime  Fco    FeedBk  XFeedBk  InChL  InChR
i30  0.0  42.4 .7   .8     5000   0.2     0.6      1      2

</CsScore>
</CsoundSynthesizer>
