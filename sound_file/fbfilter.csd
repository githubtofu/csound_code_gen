<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr=44100
kr=22050
ksmps=2
nchnls=2
zakinit 30,30

; Feedback Filter 1
instr 1

  idur    = p3
  iamp    = p4
  ifqc    = cpspch(p5)
  itab    = p6
  itabc   = p7
  ifeedbk = p8

  kdclick  linseg   0, .002, 1, idur-.004, 1, .002, 0
  kfco     linseg   500, .1*idur, 5000, .4*idur, 1000, .4*idur, 500, .1*idur, 500

  asig  oscil kdclick, ifqc, itab
  afilt tone asig, kfco

  afdbk    =        afilt/10                    ; Reduce original signal
  adeli    delayr   .2                          ; Feed back delay
  adel1    deltapi  1/kfco
  afilt2    butterbp    adel1, kfco, kfco/4     ; Filter the delayed signal
  kamprms  rms      afilt2                      ; Find rms level
  kampn    =        kamprms/6                   ; Normalize rms level 0-1.
  kcomp    tablei   kampn,itabc,1,0             ; Look up compression value in table
           delayw   afdbk+kcomp*ifeedbk*afilt2  ; Add limited feedback
  aout     =        adel1*10*kdclick*iamp

  outs  aout, aout

endin

; Feedback Filter 2
instr 2

  idur    = p3
  iamp    = p4
  ifqc    = cpspch(p5)
  itab    = p6
  itabc   = p7
  ifeedbk = p8/2

  kdclick  linseg   0, .002, iamp, idur-.004, iamp, .002, 0
  kfco     linseg   500, .1*idur, 5000, .4*idur, 1000, .4*idur, 500, .1*idur, 500

  asig     oscil    1, ifqc, itab
  afilt    tone     asig, kfco

  afdbk    =        afilt/10              ; Reduce original signal
  adeli    delayr   .2                    ; Feed back delay
  adel1    deltapi  1/kfco
  afilt3   reson    adel1, kfco, kfco/4   ; Filter the delayed signal
  afilt2   balance  afilt3, adel1         ;
  kamprms  rms      afilt2                ; Find rms level
  kampn    =        kamprms/6             ; Normalize rms level 0-1.
  kcomp    tablei   kampn,itabc,1,0       ; Look up compression value in table
           delayw   afdbk+kcomp*ifeedbk*afilt2       ; Add limited feedback
  aout     =        adel1*10*kdclick

  outs  aout, aout

endin

; Standard tone/butterbp Combo Filter
instr 3

  idur    = p3
  iamp    = p4
  ifqc    = cpspch(p5)
  itab    = p6
  itabc   = p7
  ifeedbk = p8

  kdclick  linseg   0, .002, 1, idur-.004, 1, .002, 0
  kfco     linseg   500, .1*idur, 5000, .4*idur, 1000, .4*idur, 500, .1*idur, 500

  asig     oscil    kdclick, ifqc, itab
  afilt    tone     asig, kfco
  afilt2   butterbp afilt, kfco, kfco/8/ifeedbk        ; Filter the delayed signal
  aout    =         (afilt/2+afilt2*ifeedbk*6)*kdclick*iamp

  outs  aout, aout

endin

; Oscillator Module
instr 10

  idur    =      p3
  iamp    =      p4
  ifqc    =      cpspch(p5)
  itab    =      p6
  ioutch  =      p7

  kdclick linseg 0, .002, iamp, idur-.004, iamp, .002, 0
  asig    oscil  kdclick, ifqc, itab
          zaw    asig, ioutch

endin


; Feedback Filter Module
          instr    20

  idur    =        p3
  ifco    =        p4
  imodtab =        p5
  ifeedbk =        p6
  icmptab =        p7
  iinch   =        p8
  ioutch  =        p9

  kfco    oscil    ifco, 1/idur, imodtab

  asig    zar      iinch
  afilt   tone     asig, kfco

  afdbk   =        afilt/10                   ; Reduce original signal
  adeli   delayr   .2                         ; Feed back delay
  adel1   deltapi  1/kfco
  afilt2  butterbp adel1, kfco, kfco/4        ; Filter the delayed signal
  kamprms rms      afilt2                     ; Find rms level
  kampn   =        kamprms/6                  ; Normalize rms level 0-1.
  kcomp   tablei   kampn,icmptab,1,0          ; Look up compression value in table
          delayw   afdbk+kcomp*ifeedbk*afilt2 ; Add limited feedback
          zaw      adel1*10, ioutch

          endin

; Output Amplifier Module
instr 99

  idur    =      p3
  iamp    =      p4
  iamptab =      p5
  ipantab =      p6
  iinch   =      p7

  kamp    oscil  iamp, 1/idur, iamptab
  kpan    oscil  1, 1/idur, ipantab

  asig    zar    iinch 
          outs   asig*kamp*sqrt(kpan), asig*kamp*sqrt(1-kpan)

endin

; Clear the Zaks
instr 100
zacl 0,30
endin

</CsInstruments>

<CsScore>
; Waveforms
f1 0 8192 10 1                     ; Sine
f2 0 1024 7  1 512 1 0 -1 512 -1   ; Square
f3 0 1024 7  1 1024 -1             ; Triangle

; Compression Curve
f6 0 1025 7 1 128 .2 128 .15 256 .04 256 .02 257 .001

; Audio Oscillator
i10 0    .15   2     7.00   2         1
i10 +    .15   1     7.05   .         .
i10 .    .15   .     6.07   .         .
i10 .    .15   1.5    7.10   .         .
i10 .    .15   1     8.05   .         .
i10 .    .15   .     7.07   .         .
;
i10 .    .15   2     7.00   3         1
i10 .    .15   1     7.05   .         .
i10 .    .15   .     6.07   .         .
i10 .    .15   1.5   7.10   .         .
i10 .    .15   1     8.05   .         .
i10 .    .15   .     7.07   .         .
;
i10 .    .15   2     7.00   2         1
i10 .    .15   1     7.05   .         .
i10 .    .15   .     6.07   .         .
i10 .    .15   1.5   7.10   .         .
i10 .    .15   1     8.05   .         .
i10 .    .15   .     7.07   .         .
;
i10 .    .15   2     7.00   3         1
i10 .    .15   1     7.05   .         .
i10 .    .15   .     6.07   .         .
i10 .    .15   1.5   7.10   .         .
i10 .    .15   1     8.05   .         .
i10 .    .15   .     7.07   .         .
;
;i10 .    .15   2     7.00   2         1
;i10 .    .15   1     7.05   .         .
;i10 .    .15   .     6.07   .         .
;i10 .    .15   1.5   7.10   .         .
;i10 .    .15   1     8.05   .         .
;i10 .    .15   .     7.07   .         .
;
;i10 .    .15   2     7.00   3         1
;i10 .    .15   1     7.05   .         .
;i10 .    .15   .     6.07   .         .
;i10 .    .15   1.5   7.10   .         .
;i10 .    .15   1     8.05   .         .
;i10 .    .15   .     7.07   .         .
;
;i10 .    .15   2     7.00   2         1
;i10 .    .15   1     7.05   .         .
;i10 .    .15   .     6.07   .         .
;i10 .    .15   1.5   7.10   .         .
;i10 .    .15   1     8.05   .         .
;i10 .    .15   .     7.07   .         .
;
;i10 .    .15   2     7.00   3         1
;i10 .    .15   1     7.05   .         .
;i10 .    .15   .     6.07   .         .
;i10 .    .15   1.5   7.10   .         .
;i10 .    .15   1     8.05   .         .
;i10 .    .15   .     7.07   .         .

;Filter Module
f10 0 1024 7  .2 256 1  256 .6 512 .2
f11 0 1024 7  .5 256 .2 256 1  512 .6
f12 0 1024 7  .8 256 .5 256 .2 512 1
;   Sta  Dur  Fco   ModTab  FeedBk  CompTab InCh  OutCh
i20 0    3.6  1000  10      1.20    6       1     2
i20 0    3.6  3000  11      1.20    6       1     3
i20 0    3.6  6000  12      1.20    6       1     4

;Output Module
f15 0 1024 7  0 64 1 896 1 64 0
f16 0 1024 7  1 512 0 512 1
;   Sta  Dur  Amp   AmpTab  PanTab  InCh
i99 0    3.6  2000  15      16       2
i99 0    3.6  2000  15      16       3
i99 0    3.6  2000  15      16       4

; Clear the Zaks
i100 0 3.6

</CsScore>
</CsoundSynthesizer>
