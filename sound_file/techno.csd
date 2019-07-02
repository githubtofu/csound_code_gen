<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr=44100
kr=22050
ksmps=2
nchnls=2
zakinit 50, 50
gareverb init 0

; Envelope
       instr    5

idur   =        p3
iamp   =        p4
irate  =        p5
itab1  =        p6
ioutch =        p7

kenv1  oscili   iamp, irate/idur, itab1
       zkw      kenv1, ioutch
       endin

; Drum Machine
instr 30

idur    =     p3
iamp    =     p4
idurtab =     p5
idrumtb =     p6
iacctab =     p7
iamptab =     p8
ispeed  =     p9
isteps  =     p10
ikinch  =     p11
ioutch  =     p12

kstep   init   isteps-1
kspeed  oscili 1, 1/p3, ispeed

loop1:
;     Read table values.
      kdur     table frac((kstep + 1)/isteps)*isteps, idurtab
      kdrnum   table kstep, idrumtb
      kaccnt   table kstep, iacctab
      kamp     table kstep, iamptab
      kaccnt1  table frac((kstep + 1)/isteps)*isteps, iacctab
      kdur1    =     kdur/kspeed          ; Make the step smaller.
      kdclick  linseg 0, .002, 1, i(kdur1)-.004, 1, .002, 0
      kaccin   zkr    ikinch
      kaccnt   =      kaccnt*kaccin
      kaccnt1  =      kaccnt1*kaccin

; Switch between the different drums
      if (kdrnum != 0) kgoto next1
  ;     Noise Blip
        kampenv0   linseg 0, .01/i(kaccnt1), iamp/2, .04/i(kaccnt1), 0, .01, 0
        asig0      rand   kampenv0
        aflt1      butterlp asig0, 400*kaccnt
        aflt2      butterbp asig0, 2000*kaccnt, 400*kaccnt
        aout       =        aflt1*4+aflt2*2
        kgoto  endswitch
next1:
      if (kdrnum != 1) kgoto next2
;       Dumb Drum
        kampenv1   expseg .0001, .01/i(kaccnt1), iamp, .08/i(kaccnt1), .01
        arnd1      rand kampenv1
        afilt      reson arnd1, 500*kaccnt, 50*kaccnt
        aout       balance afilt, arnd1
        kgoto endswitch
next2:
      if (kdrnum != 2) kgoto next3
;       Dumb Bass Drum
        kampenv2   linseg  0, .02, iamp*2,  .5/i(kaccnt1), 0
        kfreqenv   expseg  50,  .05, 200*i(kaccnt1)+.001,   .8, 10
        arnd2      rand    kampenv2
        afilt1     butterbp arnd2, kfreqenv, kfreqenv/32
        aosc1      oscil   kampenv2, kfreqenv, 1
;        afilt2     butterbp arnd2, kfreqenv*1.5, kfreqenv/32*1.5
;        aosc2      oscil   kampenv2, kfreqenv*1.5, 1
        aout       balance afilt+aosc1, arnd2*.5
        kgoto endswitch
next3:
      if (kdrnum != 3) kgoto next4
;       KS Snare
        kampenv3   linseg  0, .002, 1,  i(kdur1)-.022, 1, .02, 0
        kptchenv   linseg  100, .01, 300, .2, 200, .01, 200
        aplk3      pluck   iamp/2, kptchenv, 50, 2, 4, 1/(1+i(kaccnt)), 3
        aout       =        aplk3*kampenv3
        kgoto endswitch

next4:
      if (kdrnum != 4) kgoto next5
;       FM Boink
        kampenv41 expseg  .001, .01, iamp, i(kdur1)-.11, iamp/100, .1, .001
        kampenv42 linseg  1, .05, 1,  i(kdur1)/4-.11, 0, .01, 0
        klfo      oscil   1, 8, 1
        aout      foscil  kampenv41, 330*kaccnt, 1, 1.5+klfo, kampenv42*kaccnt, 1
        kgoto endswitch

next5:
      if (kdrnum != 5) kgoto next6
        ; Sorta Cool Knock Sweep Drum
        kfreqenv51 expseg  50,  .01, 200*i(kaccnt1)+.001,  .08, 50
        kfreqenv52 linseg  150, .01, 1000*i(kaccnt1), .08, 250, .01, 250
        kampenv5   linseg  0,   .01, iamp,        .08, 0,   .01, 0
        asig   rand    kampenv5
        afilt1 reson   asig, kfreqenv51, kfreqenv51/8
        afilt2 reson   asig, kfreqenv52, kfreqenv52/4
        aout1  balance afilt1, asig
        aout2  balance afilt2, asig
        aout   =       (aout1+aout2)/2
        kgoto endswitch

next6:
      if (kdrnum != 6) kgoto next7
        ; Ring Mod Drum 1
        kampenv6 linseg 0, .01/i(kaccnt1), iamp, .04/i(kaccnt1), 0, .001, 0
        kpchenv6 linseg 100, .01/i(kaccnt1), 400*i(kaccnt1), .04/i(kaccnt1), 100, .001, 100
        asig1  oscil   kampenv6, kpchenv6, 1
        asig2  oscil   kampenv6, kpchenv6*kaccnt, 1
        aout   balance asig1*asig2, asig1
        kgoto endswitch

next7:
      if (kdrnum != 7) kgoto endswitch
        ; Thunder Bomb
        aop4    init    0
        kae70   linseg  0, .002, iamp, i(kdur1)-.004, iamp, .002, 0
        kae71   linseg  0, .1*i(kaccnt1), 1, .2*i(kdur1)-.1*i(kaccnt1), .8, .8*i(kdur1), 0
        kae72   linseg  0, .1*i(kaccnt1), 1, .2*i(kdur1)-.1*i(kaccnt1), .8, .8*i(kdur1), 0
        kae73   linseg  0, .1*i(kaccnt1), 1, .2*i(kdur1)-.1*i(kaccnt1), .8, .8*i(kdur1), 0
        kae74   linseg  0, .1*i(kaccnt1), 1, .2*i(kdur1)-.1*i(kaccnt1), .8, .8*i(kdur1), 0
        krnfqc  randh   165*kaccnt1, 200

        aop4    oscil  10*kae74,   3*(1+.8*aop4)*krnfqc, 1
        aop3    oscil  20*kae73,     .5*(1+aop4)*krnfqc, 1
        aop2    oscil  16*kae72,            5.19*krnfqc, 1
        aop1    oscil  2* kae71,.5*(1+aop2+aop3)*krnfqc, 1
        aout   tone    aop1*kae70, 200*kaccnt1

endswitch:
;     When the time runs out go to the next step of the sequence and reinitialize the envelopes.
      timout 0, i(kdur1), cont1
        kstep   = frac((kstep + 1)/isteps)*isteps
        reinit loop1

  cont1:

     zaw    aout*kdclick*kamp, ioutch    ;, aout*kdclick*kamp

endin

;---------------------------------------------------------------------------
; Computer Controlled Metal Acid Bass
;---------------------------------------------------------------------------
        instr 40

idur    =     p3
iamp    =     p4
idurtab =     p5
ipchtb  =     p6
iacctab =     p7
iamptab =     p8
ispeed  =     p9
isteps  =     p10
ifcoch  =     p11
irezch  =     p12
ioutch  =     p13
idistab =     p14
ipwmrate =    1
iband    =    0
apwmdc1  init 0
apwmdc2  init 0
apwmdc3  init 0

kstep   init   isteps-1
kspeed  oscili 1, 1/p3, ispeed

loop1:
;     Read table values.
      kdur     table frac((kstep + 1)/isteps)*isteps, idurtab
      kpch1    table kstep, ipchtb
      kaccnt   table kstep, iacctab
      kamp1    table kstep, iamptab
      kamp2    table frac((kstep + 1)/isteps)*isteps, iamptab
      kaccnt1  table frac((kstep + 1)/isteps)*isteps, iacctab
      kdur1    =     kdur/kspeed          ; Make the step smaller.
      kdclick  linseg 0, .002, iamp, i(kdur1)-.004, iamp, .002, 0

; Play the current note
kamp   linseg   0, .004, i(kamp2), i(kdur1)-.024, i(kamp2)*.5, .02, 0
kfqc   =        cpspch(kpch1)

kfcoenv zkr      ifcoch
krezenv zkr      irezch

kfcoo  linseg   .3, .04, 1, .1, .6, i(kdur1)-.14, .3
kacct2 linseg   1/i(kaccnt1), .04, i(kaccnt1), .1, 1/i(kaccnt1), i(kdur1)-.14, 1/i(kaccnt1)
kfco   =        kfcoo*kfcoenv*kacct2
krez   =        krezenv*kacct2
ifqcadj =       .149659863*sr
klfo1  oscili   .1, ipwmrate, 1
klfo2  oscili   .1, ipwmrate*1.1, 1, .21
klfo3  oscili   .1, ipwmrate*.9, 1, .43

apulse1 buzz    1,kfqc, sr/2/kfqc, 1 ; Avoid aliasing
apulse3 buzz    1,kfqc, sr/2/kfqc, 1
apulse2 vdelay   apulse3, 1000/kfqc/(klfo1+1)/2, 1000/22
avpw1   =       apulse1 - apulse2         ; two inverted pulses at variable distance
apwmdc1    integ   avpw1

apulse4 buzz    1,kfqc*.995, sr/2/kfqc, 1 ; Avoid aliasing
apulse6 buzz    1,kfqc*.995, sr/2/kfqc, 1
apulse5 vdelay   apulse6, 1000/kfqc/(klfo2+1)/2*.995, 1000/22
avpw2   delay   apulse4 - apulse5, .05         ; two inverted pulses at variable distance
apwmdc2    integ   avpw2

apulse7 buzz    1,kfqc*.997, sr/2/kfqc, 1 ; Avoid aliasing
apulse9 buzz    1,kfqc*.997, sr/2/kfqc, 1
apulse8 vdelay   apulse6, 1000/kfqc/(klfo2+1)/2*.997, 1000/22
avpw3   delay  apulse7 - apulse8, .02         ; two inverted pulses at variable distance
apwmdc3    integ   avpw3

axn     =       apwmdc1+apwmdc2+apwmdc3

; Resonant Lowpass Filter (4 Pole)
kc     =        ifqcadj/kfco
krez2  =        krez/(1+exp(kfco/11000))
ka1    =        kc/krez2-(1+krez2*iband)
kasq    =       kc*kc
kb     =        1+ka1+kasq

ayn    nlfilt   axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

; Resonant Lowpass Filter (4 Pole)
kcl    =        ifqcadj/kfco
krez2l =        2.0/(1+exp(kfco/11000))
ka1l   =        kcl/krez2l-(1+krez2l*iband)
kasql  =        kcl*kcl
kbl    =        1+ka1l+kasql

aynl   nlfilt   axn/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1
ayn2l  nlfilt   aynl/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1

arez   =       (ayn2-ayn2l)*.5
aclip  tablei  arez, idistab, 1, .5
aout   =       aclip*.5+ayn2l

;     When the time runs out go to the next step of the sequence and reinitialize the envelopes.
      timout 0, i(kdur1), cont1
        kstep   = frac((kstep + 1)/isteps)*isteps
        reinit loop1

  cont1:


     zaw    aout*kdclick*kamp, ioutch

endin

;---------------------------------------------------------------------------
; Warbly Synth with Fifths Filter
;---------------------------------------------------------------------------
        instr 41

idur    =     p3
iamp    =     p4
idurtab =     p5
ipchtb  =     p6
iacctab =     p7
iamptab =     p8
ispeed  =     p9
isteps  =     p10
ifcoch  =     p11
irezch  =     p12
ioutch  =     p13
idistab =     p14
ipwmrate =    1
iband    =    0

kstep   init   isteps-1
kspeed  oscili 1, 1/p3, ispeed

loop1:
;     Read table values.
      kdur     table frac((kstep + 1)/isteps)*isteps, idurtab
      kpch1    table kstep, ipchtb
      kaccnt   table kstep, iacctab
      kamp1    table kstep, iamptab
      kamp2    table frac((kstep + 1)/isteps)*isteps, iamptab
      kaccnt1  table frac((kstep + 1)/isteps)*isteps, iacctab
      kdur1    =     kdur/kspeed          ; Make the step smaller.
      kdclick  linseg 0, .002, iamp, i(kdur1)-.004, iamp, .002, 0

; Play the current note
kamp   linseg   0, .004, i(kamp2), i(kdur1)-.024, i(kamp2)*.5, .02, 0
kfqc   =        cpspch(kpch1)

kfcoenv zkr      ifcoch
krezenv zkr      irezch

kfcoo  linseg   .3, .01, 1, .1, .6, i(kdur1)-.14, .3
kacct2 linseg   1/i(kaccnt1), .04, i(kaccnt1), .1, 1/i(kaccnt1), i(kdur1)-.14, 1/i(kaccnt1)
kfco   =        kfcoo*kfcoenv*kacct2
krez   =        krezenv*kacct2
ifqcadj =       .149659863*sr
klfo1  oscili   .1, ipwmrate, 1
klfo2  oscili   .1, ipwmrate*1.1, 1, .21
krtramp linseg  1, i(kdur1), 8
klfo3  oscili   .04, krtramp, 1, .21

apulse1 buzz    1,kfqc/(klfo3+1), sr/2/kfqc, 1 ; Avoid aliasing
apulse3 buzz    1,kfqc/(klfo3+1), sr/2/kfqc, 1
apulse2 vdelay  apulse3, 1000/kfqc/(klfo1+1)/2, 1000/22
avpw1   =       apulse1 - apulse2         ; two inverted pulses at variable distance
apwmdc1    integ   avpw1

apulse4 buzz    1,kfqc*1.5/(klfo3+1), sr/2/kfqc, 1 ; Avoid aliasing
apulse6 buzz    1,kfqc*1.5/(klfo3+1), sr/2/kfqc, 1
apulse5 vdelay  apulse6, 1000/kfqc/(klfo2+1)/2, 1000/22
avpw2   delay   apulse4 - apulse5, .05         ; two inverted pulses at variable distance
apwmdc2 integ   avpw2

axn     =       apwmdc1+apwmdc2

; Resonant Lowpass Filter (4 Pole)
kc     =        ifqcadj/kfco
krez2  =        krez/(1+exp(kfco/11000))
ka1    =        kc/krez2-(1+krez2*iband)
kasq    =       kc*kc
kb     =        1+ka1+kasq

ayn    nlfilt   axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

; Resonant Lowpass Filter (4 Pole) Fifth
kc5    =        ifqcadj/kfco/1.5
krez25 =        krez/(1+exp(kfco/1.5/11000))
ka15   =        kc5/krez2-(1+krez25*iband)
kasq5   =       kc5*kc5
kb5    =        1+ka15+kasq5

ayn5   nlfilt   axn/kb5, (ka15+2*kasq5)/kb5, -kasq5/kb5,  0, 0, 1
ayn25  nlfilt   ayn5/kb5, (ka15+2*kasq5)/kb5, -kasq5/kb5, 0, 0, 1

; Resonant Lowpass Filter (4 Pole)
kcl    =        ifqcadj/kfco
krez2l =        2.0/(1+exp(kfco/11000))
ka1l   =        kcl/krez2l-(1+krez2l*iband)
kasql  =        kcl*kcl
kbl    =        1+ka1l+kasql

aynl   nlfilt   axn/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1
ayn2l  nlfilt   aynl/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1

aout   =       ayn2-ayn2l+ayn25

;     When the time runs out go to the next step of the sequence and reinitialize the envelopes.
      timout 0, i(kdur1), cont1
        kstep   = frac((kstep + 1)/isteps)*isteps
        reinit loop1

  cont1:


     zaw    aout*kdclick*kamp, ioutch

endin

;---------------------------------------------------------------------------
; Synth with FM Filter Resonance
;---------------------------------------------------------------------------
         instr  42

idur     =      p3
iamp     =      p4
ifqc     =      cpspch(p5)
ifcoch   =      p6
irezch   =      p7
ibndtab  =      p8
ioutch   =      p9
ifmfqc   =      p10
ifmamp   =      p11
iband    =      0

kamp     linseg 0, .002, iamp, idur-.004, iamp, .002, 0

; Play the current note
kfcoenv  zkr    ifcoch
krezenv  zkr    irezch
kpbend   oscili 1, 1/idur, ibndtab
kfqc     =      ifqc*kpbend

klfo1    =      1 ; oscili 1, imodfqc, imodtab, .5
kfco     =      kfcoenv*(klfo1+1.5)+30
krez     =      krezenv
ifqcadj  =      .149659863*sr

apulse1 buzz    1,kfqc, sr/2/kfqc, 1 ; Avoid aliasing
asaw1   integ   apulse1

apulse2 buzz    1,kfqc*.505, sr/2/kfqc*.505, 1 ; Avoid aliasing
asaw2   integ   apulse2

axn     =       asaw1+asaw2-1

; Resonant Lowpass Filter (4 Pole)
kc     =        ifqcadj/kfco
krez2  =        krez/(1+exp(kfco/11000))
ka1    =        kc/krez2-(1+krez2*iband)
kasq    =       kc*kc
kb     =        1+ka1+kasq

ayn    nlfilt   axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

; Resonant Lowpass Filter (4 Pole)
kcl    =        ifqcadj/kfco
krez2l =        2.0/(1+exp(kfco/11000))
ka1l   =        kcl/krez2l-(1+krez2l*iband)
kasql  =        kcl*kcl
kbl    =        1+ka1l+kasql

aynl   nlfilt   axn/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1
ayn2l  nlfilt   aynl/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1

ares1  =       ayn2-ayn2l
krms   rms     ares1, 100
;              Amp   Fqc       Car  Mod     MAmp       Wave
ares2  foscil  krms, kfco,     1,   ifmfqc, ifmamp,    1
aout   butterhp      ayn2l+ares2/4, 20

       zaw      aout*kamp, ioutch

       endin

;---------------------------------------------------------------------------
; Sequenced Synth with FM Resonance Filter
;---------------------------------------------------------------------------
        instr 43

idur    =     p3
iamp    =     p4
idurtab =     p5
ipchtb  =     p6
iacctab =     p7
iamptab =     p8
ispeed  =     p9
isteps  =     p10
ifcoch  =     p11
irezch  =     p12
ioutch  =     p13
iband    =    0

kstep   init   isteps-1
kspeed  oscili 1, 1/p3, ispeed

loop1:
;     Read table values.
      kdur     table frac((kstep + 1)/isteps)*isteps, idurtab
      kpch1    table kstep, ipchtb
      kaccnt   table kstep, iacctab
      kamp1    table kstep, iamptab
      kamp2    table frac((kstep + 1)/isteps)*isteps, iamptab
      kaccnt1  table frac((kstep + 1)/isteps)*isteps, iacctab
      kdur1    =     kdur/kspeed          ; Make the step smaller.
      kdclick  linseg 0, .002, iamp, i(kdur1)-.004, iamp, .002, 0

; Play the current note
kamp   linseg   0, .004, i(kamp2), i(kdur1)-.024, i(kamp2)*.5, .02, 0
kfcoenv  zkr    ifcoch
krezenv  zkr    irezch
kfqc   =        cpspch(kpch1)

kfcoo  linseg   .6, .01, 1.5, .1, 1, i(kdur1)-.14, .6
kacct2 linseg   1/i(kaccnt1), .04, i(kaccnt1), .1, 1/i(kaccnt1), i(kdur1)-.14, 1/i(kaccnt1)
kfco   =        kfcoo*kfcoenv*kacct2
krez     =      krezenv
ifqcadj  =      .149659863*sr

apulse1 buzz    1,kfqc, sr/2/kfqc, 1 ; Avoid aliasing
asaw1   integ   apulse1

apulse2 buzz    1,kfqc*.505, sr/2/kfqc*.505, 1 ; Avoid aliasing
asaw2   integ   apulse2

axn     =       asaw1+asaw2-1

; Resonant Lowpass Filter (4 Pole)
kc     =        ifqcadj/kfco
krez2  =        krez/(1+exp(kfco/11000))
ka1    =        kc/krez2-(1+krez2*iband)
kasq    =       kc*kc
kb     =        1+ka1+kasq

ayn    nlfilt   axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

; Resonant Lowpass Filter (4 Pole)
kcl    =        ifqcadj/kfco
krez2l =        2.0/(1+exp(kfco/11000))
ka1l   =        kcl/krez2l-(1+krez2l*iband)
kasql  =        kcl*kcl
kbl    =        1+ka1l+kasql

aynl   nlfilt   axn/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1
ayn2l  nlfilt   aynl/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1

ares1  =       ayn2-ayn2l
krms   rms     ares1, 100
;              Amp   Fqc       Car  Mod      MAmp  Wave
ares2  foscil  krms, kfco,     1,   kaccnt1, 2,    1
aout   =       ayn2l+ares2/4

;     When the time runs out go to the next step of the sequence and reinitialize the envelopes.
      timout 0, i(kdur1), cont1
        kstep   = frac((kstep + 1)/isteps)*isteps
        reinit loop1

  cont1:


     zaw    aout*kdclick*kamp, ioutch

     endin

;---------------------------------------------------------------------------
; Synth with Noise Filter Resonance
;---------------------------------------------------------------------------
         instr  44

idur     =      p3
iamp     =      p4
ifqc     =      cpspch(p5)
ifcoch   =      p6
irezch   =      p7
ibndtab  =      p8
ioutch   =      p9
iband    =      0

kamp     linseg 0, .002, iamp, idur-.004, iamp, .002, 0

; Play the current note
kfcoenv  zkr    ifcoch
krezenv  zkr    irezch
kpbend   oscili 1, 1/idur, ibndtab
kfqc     =      ifqc*kpbend

klfo1    =      1 ; oscili 1, imodfqc, imodtab, .5
kfco     =      kfcoenv*(klfo1+1.5)+30
krez     =      krezenv
ifqcadj  =      .149659863*sr

apulse1 buzz    1,kfqc, sr/2/kfqc, 1 ; Avoid aliasing
asaw1   integ   apulse1

apulse2 buzz    1,kfqc*.505, sr/2/kfqc*.505, 1 ; Avoid aliasing
asaw2   integ   apulse2

axn     =       asaw1+asaw2-1

; Resonant Lowpass Filter (4 Pole)
kc     =        ifqcadj/kfco
krez2  =        krez/(1+exp(kfco/11000))
ka1    =        kc/krez2-(1+krez2*iband)
kasq    =       kc*kc
kb     =        1+ka1+kasq

ayn    nlfilt   axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

; Resonant Lowpass Filter (4 Pole)
kcl    =        ifqcadj/kfco
krez2l =        2.0/(1+exp(kfco/11000))
ka1l   =        kcl/krez2l-(1+krez2l*iband)
kasql  =        kcl*kcl
kbl    =        1+ka1l+kasql

aynl   nlfilt   axn/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1
ayn2l  nlfilt   aynl/kbl, (ka1l+2*kasql)/kbl, -kasql/kbl, 0, 0, 1

ares1  =       ayn2-ayn2l
krms   rms     ares1, 100

arand1 rand     krms
ares2  butterbp arand1, kfco, kfco/8
ares3  butterbp arand1, kfco*1.5, kfco/32*1.5
aout   =       ayn2l+(ares2+ares3)

       zaw      aout*kamp, ioutch

       endin


;---------------------------------------------------------------------------
; Spherical Lissajous Oscillators
;---------------------------------------------------------------------------
        instr 45

ifqc    init cpspch(p5)
iu      init p6
iv      init p7
irt2    init sqrt(2)
iradius init 1
ioutx   init p8
iouty   init p9
ioutz   init p10

kampenv linseg 0, .01, p4, p3-.03, p4*.5, .02, 0

; Cosines
acosu  oscil 1, iu*ifqc,   1, .25
acosv  oscil 1, iv*ifqc,   1, .25

; Sines
asinu  oscil 1, iu*ifqc,   1
asinv  oscil 1, iv*ifqc,   1

; Compute X and Y
ax = iradius*asinu*acosv
ay = iradius*asinu*asinv
az = iradius*acosu

   zaw kampenv*ax, ioutx
   zaw kampenv*ay, iouty
   zaw kampenv*az, ioutz

endin

;----------------------------------------------------------------------------------
; Granular Synthesis v. 2
;----------------------------------------------------------------------------------
         instr  46

idur     =      p3
iamp     =      p4
ifqc     =      cpspch(p5)
igrtab   =      p6
iwintab  =      p7
ifrngtab =      p8
idens    =      p9
iattk    =      p10
idecay   =      p11
ibndtab  =      p12
igdur    =      .2

kamp    linseg  0, iattk, 1, idur-iattk-idecay, 1, idecay, 0
kbend   oscil   1, 1/idur, ibndtab
kfrng   oscil   1, 1/idur, ifrngtab

;              Amp  Fqc         Dense  AmpOff PitchOff    GrDur  GrTable   WinTable  MaxGrDur
aoutl   grain  p4,  ifqc*kbend, idens, 100,   ifqc*kfrng, igdur, igrtab,   iwintab,  5
aoutr   grain  p4,  ifqc*kbend, idens, 100,   ifqc*kfrng, igdur, igrtab,   iwintab,  5

        outs   aoutl*kamp, aoutr*kamp

      endin

;---------------------------------------------------------------------------
; Planar Rotation in Three Dimensions
;---------------------------------------------------------------------------
        instr 50

ifqc    =    p4
iphase  =    p5
iplane  =    p6
iinx     =    p7
iny     =    p8
iinz     =    p9
ioutx   =    p10
iouty   =    p11
ioutz   =    p12

kcost  oscil 1, ifqc,   1, .25+iphase
ksint  oscil 1, ifqc,   1, iphase
kamp   linseg 0, .002, 1, p3-.004, 1, .002, 0

ax      zar  iinx
ay      zar  iny
az      zar  iinz

; Rotation in X-Y plane
  if (iplane!=1) goto next1
    axr = ax*kcost + ay*ksint
    ayr =-ax*ksint + ay*kcost
    azr = az
    goto next3

; Rotation in X-Z plane
next1:
  if (iplane!=2) goto next2
    axr = ax*kcost + az*ksint
    ayr = ay
    azr =-ax*ksint + az*kcost
    goto next3

; Rotation in Y-Z plane
next2:
    axr = ax
    ayr = ay*kcost + az*ksint
    azr =-ay*ksint + az*kcost

next3:
        zaw axr*kamp, ioutx
        zaw ayr*kamp, iouty
        zaw azr*kamp, ioutz

endin

;---------------------------------------------------------------------------
; Delay
;---------------------------------------------------------------------------
        instr  100

idtime  =      p4
ifdback =      p5
iinch   =      p6
ioutch  =      p7
aout    init   0

ain     zar    iinch
aout    delay  (aout+ain)*ifdback, idtime
        zaw    aout+ain, ioutch
        endin


;---------------------------------------------------------------------------
; Mixer Section
;---------------------------------------------------------------------------
          instr 190

idur      init  p3
iamp      init  p4
iinch      init  p5
ipan      init  p6
ifader    init  p7

asig1     zar    iinch           ; Read input channel 1

kfader    oscil  1, 1/idur, ifader
kpanner   oscil  1, 1/idur, ipan

kgl1      =      kfader*sqrt(kpanner)    ; Left gain
kgr1      =      kfader*sqrt(1-kpanner)  ; Right gain

kdclick   linseg  0, .002, iamp, p3-.004, iamp, .002, 0  ; Declick

asigl     =     asig1*kgl1       ; Scale and sum
asigr     =     asig1*kgr1

          outs  kdclick*asigl, kdclick*asigr   ; Output stereo pair

          endin

;----------------------------------------------------------------------------------
; Medium Room Reverb with controls
;----------------------------------------------------------------------------------
       instr    192

idur   =        p3
iamp   =        p4
iinch1 =        p5
iinch2 =        p6
iinch3 =        p7
iinch4 =        p8
iinch5 =        p9
iinch6 =        p10
idecay =        2.0
idense  =       .82
idense2 =       .9
ipreflt =       5000
ihpfqc  =       4100
ilpfqc  =       200

adel71 init     0
adel11 init     0
adel12 init     0
adel13 init     0
adel31 init     0
adel61 init     0
adel62 init     0

kdclick linseg  0, .002, iamp, idur-.004, iamp, .002, 0

; Initialize
ain1   zar      iinch1
ain2   zar      iinch2
ain3   zar      iinch3
ain4   zar      iinch4
ain5   zar      iinch5
ain6   zar      iinch6

asig0  =        ain1+ain2+ain3+ain4+ain5+ain6

aflt01 butterlp asig0, ipreflt                         ; Pre-Filter
aflt02 butterhp .4*adel71*idense2, ihpfqc              ; Feed-Back Filter
aflt03 butterlp .4*aflt02, ilpfqc                      ; Feed-Back Filter
asum01  =       aflt01+.5*aflt03                       ; Initial Mix

; Double Nested All-Pass
asum11  =       adel12-.35*adel11*idense               ; First  Inner Feedforward
asum12  =       adel13-.45*asum11*idense               ; Second Inner Feedforward
aout11  =       asum12-.25*asum01*idense               ; Outer Feedforward
adel11  delay   asum01+.25*aout11*idense, .0047*idecay ; Outer Feedback
adel12  delay   adel11+.35*asum11*idense, .0083*idecay ; First  Inner Feedback
adel13  delay   asum11+.45*asum12*idense, .0220*idecay ; Second Inner Feedback

adel21  delay   aout11, .005*idecay                    ; Delay 1

; All-Pass 1
asub31  =       adel31-.45*adel21*idense               ; Feedforward
adel31  delay   adel21+.45*asub31*idense, .030*idecay  ; Feedback

adel41  delay   asub31, .067*idecay                    ; Delay 2
adel51  delay   .4*adel41, .015*idecay                 ; Delay 3
aout51  =       aflt01+adel41

; Single Nested All-Pass
asum61  =       adel62-.35*adel61*idense               ; Inner Feedforward
aout61  =       asum61-.25*aout51*idense               ; Outer Feedforward
adel61  delay   aout51+.25*aout61*idense, .0292*idecay ; Outer Feedback
adel62  delay   adel61+.35*asum61*idense, .0098*idecay ; Inner Feedback

aout    =       .5*aout11+.5*adel41+.5*aout61 ; Combine Outputs

adel71  delay   aout61, .108*idecay                  ; Delay 4

        outs     aout*kdclick, -aout*kdclick

        endin

;---------------------------------------------------------------------------
; Zak Clear
;---------------------------------------------------------------------------
          instr 195

          zacl 0, 50
          zkcl 0, 50

          endin



</CsInstruments>

<CsScore>
;---------------------------------------------------------------------------
; TeknoBubble
; This song is based around drum machine and sequencer based sounds.
; Coded: February-May 1998 by Hans Mikelson
;---------------------------------------------------------------------------
;a0 0  64.5
;a0 78.5 125

f1  0 8193 10 1              ; Sine
f2  0 1025  7 1  1025 1      ; 1?
f3  0 1025 -7 8  1025 8      ; Speed
f3 64.5 1025 -7 8  1025 2      ; Speed
f4  0 1025 10 1  0  .333  0  .2  0  .143  0 .111  0   .0909  ; Square ?

f100 0 1025 -7 0  1025 1   ; Ramp, FadeIn, PanRL
f101 0 1025 -7 1  1025 0   ; Saw, FadeOut, PanLR
f102 0 1025 -7 1  1025 1   ; Const 1, PanL
f103 0 1025 -7 .5 1025 .5  ; Const .5, PanC
f104 0 1025 -7 0  1025 0   ; Const 0, PanR
f105 0 1025 -7 .8  513 .2 512 .8   ; PanRLR
f106 0 1025 -7 .2  513 .8 512 .2   ; PanLRL
f107 0 1025 -7 1   1025 .7         ; FadeDown
f108 0 1025 -7 .5  1025 1          ; FadeUp
f109 0 1025 -7 0  513 1 512 1      ; FadeIn & Hold

;---------------------------------------------------------------------------
; Drums
;---------------------------------------------------------------------------
; Envelope
f10  0 1025 -7 .4  256 3 256 .8 513 1.2  ; Accent Envelope
f10 48 1025 -7 3.5 256 2 256 .8 256 2 257 .4  ; Accent Envelope
;   Sta  Dur  Amp  Rate  Table  OutKCh
i5  2    38   1    1     10     1
i5  48.5 28   1    1     10     1
; Drums :  0=HiHat, 1=Tap, 2=Bass, 3=KS Snare, 4=FMBoink, 5=Sweep, 6=RingMod1
f21  0 16  -2  1     1     1     1     1     1     1     1        ; Duration
f22  0 16  -2  0     0     0     0     0     0     0     0        ; Drum
f23  0 16  -2  2     .5    1     1.5   2     2.5   .5    1        ; Accent
f24  0 16  -2  2     0     0     0     3     1     0     1        ; Amp
f25  0 16  -2  0     1.2   1     1     0     0     1     0        ; Amp
;   Sta  Dur  Amp  DurTab  DrumTab  Accent  AmpTab  Speed  Steps  InKCh  OutCh
i30 2    38   8000 21      22       23      24      3      8      1      1
i30 2    38   8000 21      22       23      25      3      8      1      2
i30 48.5 16   8000 21      22       23      24      3      8      1      1
i30 48.5 16   8000 21      22       23      25      3      8      1      2
i30 64.5 12   8000 21      22       23      24      3      8      1      1
i30 64.5 12   8000 21      22       23      25      3      8      1      2
; Mixer
;    Sta  Dur  Amp  Ch  Pan  Fader
i190 2    4    1    1   102  100
i190 2    4    1    2   104  100
i190 6    34   1    1   102  102
i190 6    34   1    2   104  102
;i190 48.5 28   1    1   102  102
;i190 48.5 28   1    2   104  102

; Drums :  0=HiHat, 1=Tap, 2=Bass, 3=KS Snare, 4=FMBoink, 5=Sweep, 6=RingMod1
f26  0 16  -2  2   1   1   2   1   1   2   1   1   2   2  ; Duration
f27  0 16  -2  2   1   1   2   1   1   2   1   1   2   2  ; Drum
f28  0 16  -2  5   .7  1   .8  1   .5  3   .7  1   1   8  ; Accent
f29  0 16  -2  1   0   1   1   0   0   1   0   0   1   1  ; Amp
f30  0 16  -2  1   1   0   0   1   1   1   1   1   1   0  ; Amp
;   Sta  Dur  Amp  DurTab  DrumTab  Accent  AmpTab  Speed  Steps  InKCh  OutCh
i30 8    32   8000 26      27       28      29      3      11     1      3
i30 8    32   8000 26      27       28      30      3      11     1      4
i30 48.5 24   8000 26      27       28      29      3      11     1      3
i30 48.5 24   8000 26      27       28      30      3      11     1      4
i30 64.5 12   8000 26      27       28      29      3      11     1      3
i30 64.5 12   8000 26      27       28      30      3      11     1      4
; Mixer
;    Sta  Dur  Amp  Ch  Pan  Fader
i190 8    32   1    3   102  102
i190 8    32   1    4   104  102
i190 48.5 28   1    3   102  102
i190 48.5 28   1    4   104  102

;---------------------------------------------------------------------------
; Metal Acid Bass Sequence
;---------------------------------------------------------------------------
;f10  0 1025 -7 .4 256 3 256 .8 513 1.2  ; Accent Envelope
f15  0 65537 8 1  8193 .99 8192 .96 8192 .9 4096 -.8 8192 -.8 4096 -.9 8192 -.96 8192 -.99 8192 -1
f60  0 1025 -7 500 256 800 256 2000 512 8000  ; Fco Envelope
f51  0 16  -2  1     2     1     1     2     1     1     2     1     1     1    1     1     ; Duration
f52  0 16  -2  6.04  6.04  6.04  6.07  6.09  7.04  6.11  6.04  6.04  6.07  6.09 6.11  7.02  ; Pitch
f52 48.5 16  -2  6.04  6.04  6.04  6.07  6.09  7.04  6.10  6.04  6.04  6.07  6.09 6.11  7.03  ; Pitch
f52 56.5 16  -2  6.02  6.02  6.02  6.07  6.11  7.07  5.11  6.04  6.04  6.07  6.06 6.10  5.07  ; Pitch
f52 64.5 16  -2  5.11  5.11  5.11  6.02  6.04  7.11  6.06  6.11  6.02  6.04  6.04 6.06  7.09  ; Pitch
f53  0 16  -2  .7    .8    .9    1     1.1   1.2   2     .8    1     1.3   1.6  1.8   2     ; Accent
f54  0 16  -2  1.2   1     1     1     1.5   1     1     1.1   1     1.1   1.2  1.3   1.5   ; Amp
f54 48.5 16  -2  1.2   1     1     1.4   1.2   1     0     0     0     0     0    0     0     ; Amp
; Envelope
;    Sta    Dur  Amp  Rate  Table  OutKCh
i5   12     28   1    1     60     2
i5   12     28   8    1     102    3
i5   48.5   28   1    1     60     2
i5   48.5   28   8    1     102    3
; Metal Acid Bass
;    Sta    Dur  Amp  DurTab  DrumTab  Accent  AmpTab  Speed  Steps  FcoKCh  RezKCh  OutCh  Distort
i40  12     28   8000 51      52       53      54      3      13     2       3       5      15
i40  48.5   16   8000 51      52       53      54      3      13     2       3       5      15
i40  64.5   12   8000 51      52       53      54      3      13     2       3       5      15
; Mixer
;    Sta  Dur  Amp  Ch  Pan  Fader
i190 12   4    1    5   103  100
i190 16   12   1    5   105  102
i190 28   4    1    5   105  107
i190 32   8    .7   5   105  102
i190 48.5   20   .8   5   105  102
i190 68.5   8    .8   5   105  101

;---------------------------------------------------------------------------
; Warble Fifths
;---------------------------------------------------------------------------
f62  0 1025 -7 1000 256 800 256 3000 256 700 256 2500 ; Fco Envelope
f62 48.5 1025 -7 2000 256 500 256 5000 256 200 256 1500 ; Fco Envelope
f56  0 16  -2  1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1    ; Duration
f57  0 16  -2  7.04  8.04  7.11  8.07  7.04  8.04  7.11  8.07  7.04  8.04  7.11  7.07  7.02  7.04  7.07  7.09 ; Pitch
f57 48.5 16  -2  7.11  7.04  8.02  8.07  7.04  7.04  7.11  8.07  7.04  8.04  7.11  8.09  7.02  7.04  7.07  7.09 ; Pitch
f57 60.5 16  -2  7.04  8.04  7.11  8.07  7.04  8.02  7.09  8.07  7.04  8.04  7.11  7.07  7.02  7.04  7.07  6.09 ; Pitch
f57 68.5 16  -2  8.02  8.11  8.02  9.02  7.11  7.09  8.06  9.02  7.11  8.11  8.04  9.02  8.06  7.11  7.09  7.11 ; Pitch
f58  0 16  -2  1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1    ; Accent
f58 48.5 16  -2  1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1    ; Accent
f59  0 16  -2  1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1    ; Amp
f59 48.4 16  -2  0     0     0     0     0     0     0     0     1.2   1     1     1     1.2   1     1     1    ; Amp
; Envelope
;    Sta  Dur  Amp  Rate  Table  OutKCh
i5   28   12   1    1     62     4
i5   28   12   8    1     102    5
i5   48.5   28   1    1     62     4
i5   48.5   28   8    1     102    5
; Warble Fifths
;    Sta    Dur  Amp  DurTab  DrumTab  Accent  AmpTab  Speed  Steps  FcoKCh  RezKCh  OutCh  Distort
i41  28     12  12000 56      57       58      59      3      16     4       5       6      15
i41  48.5   16  12000 56      57       58      59      3      16     4       5       6      15
i41  64.5   12  12000 56      57       58      59      3      16     4       5       6      15
; Mixer
;    Sta  Dur  Amp  Ch  Pan  Fader
i190 28   4    1    6   103  100
i190 32   8    1    6   106  102
i190 48.5   20   .8   6   106  102
i190 68.5   8    .8   6   106  101

;---------------------------------------------------------------------------
; Spherical Lissajous
;---------------------------------------------------------------------------
;    Sta  Dur   Amp    Frqc   U    V     OutX  OutY  OutZ
i45  0    1     4000   7.04   3    2     11    12    13
i45  +    .5    3000   5.11   5.6  .4    .     .     .
i45  .    .125  6000   8.07   2.3  8.5   .     .     .
i45  .    .425  4000   6.11   4.1  5.5   .     .     .
i45  .    .0625 5000   6.02   2    3     .     .     .
i45  .    .125  4700   8.11   4    7     .     .     .
i45  .    .0625 3500   7.04   2.2  4.3   .     .     .
;
i45  4    .75  2500   7.04   3.1  2.3   11    12    13
i45  +    .25  3000   6.06   5.6  1.4   .     .     .
i45  .    .5   6000   7.07   2.3  8.2   .     .     .
i45  .    .0625 .     7.03   5.3  8.2   .     .     .
i45  .    .0625 .     5.07   2.7  2.2   .     .     .
i45  .    .125  .     7.11   2.3  8.2   .     .     .
i45  .    .0625 .     7.02   4.3  1.2   .     .     .
i45  .    .0625 .     7.04   4.2  1.3   .     .     .
i45  .    .125 .      8.07   4.1  1.4   .     .     .
;
i45  10   .75  2500   7.11   3.1  2.3   11    12    13
i45  +    .5   3000   8.06   5.6  1.2   .     .     .
i45  .    .25  6000   6.07   2.3  4.2   .     .     .
i45  .    .3125 .     7.03   2.4  8.2   .     .     .
i45  .    .0625 .     5.07   2.5  2.1   .     .     .
i45  .    .895  .     7.11   2.6  6.2   .     .     .
i45  .    .125  .     7.02   2.7  1.2   .     .     .
i45  .    .0625 .     6.04   2.8  1.3   .     .     .
i45  .    .125 .      8.07   2.9  1.2   .     .     .
; Planar Rotation
; 1=X-Y Plane, 2=X-Z Plane, 3=Y-Z Plane
;    Sta  Dur  Fqc  Phase  Plane  InX  InY  InZ  OutX  OutY  OutZ
i50  0    16   1.5  0      1     11   12   13   14    15    16
i50  0    16   2.0  0      2     14   15   16   17    18    19
; Delay
;    Sta  Dur  Time  FeedBk  InCh OutCh
i100 0    16   .25   .5      17   20
i100 0    16   .25   .5      18   21
; Mixer
;    Sta  Dur  Amp  Ch  Pan  Fader
i190 0    4    1    20  102  100
i190 0    4    1    21  104  100
i190 4    12   1    20  102  102
i190 4    12   1    21  104  102

;---------------------------------------------------------------------------
; FM Resonance Filter with Sequencer
;---------------------------------------------------------------------------
f65 40.5 1024 -7 1 256 0 256 1 256 0 256 1 ; Pan 1
f67 40.5 1024 -7 400 256 250 256 800 256 160 156 1300 100 300 ; Fco Envelope
f58 40.5 16  -2  3     2     3     2     4     4     2     2     3     1     1     1     2     2     2     4    ; Accent
; Envelope
;    Sta    Dur  Amp  Rate  Table  OutKCh
i5   40.5   8    1    1     67     6       ; Fco
i5   40.5   8    12   1     102    7       ; Rez
; FM Reson
;    Sta    Dur  Amp  DurTab  PitchTab  Accent  AmpTab  Speed  Steps  FcoKCh  RezKCh  OutCh
i43  40.5   8   8000  56      57        58      59      3      16     6       7       7
; Mixer
;    Sta    Dur  Amp  Ch  Pan  Fader
i190 40.5   8    1.2  7   65   102

;---------------------------------------------------------------------------
; FM Resonance Filter
;---------------------------------------------------------------------------
f61 64.5 1024 -5 8 1024 .25   ; Pitch Bend
f65 64.5 1024 -7 1 256 0 256 1 256 0 256 1 ; Pan 1
f67 64.5 1024 -7 400 256 150 256 800 256 150 156 1300 100 300 ; Fco Envelope
; Envelope
;    Sta    Dur  Amp  Rate  Table  OutKCh
i5   64.5   12   1    1     67     6       ; Fco
i5   64.5   12   12   1     108    7       ; Rez
; FM Reson
;    Sta    Dur  Amp   Pitch  FcoKCh  RezKCh  PBend  OutCh  FMFqc  FMAmp
i42  64.5   12   8000  7.04   6       7       61     8      3      2
; Delay
;    Sta    Dur  Time  FeedBk  InCh OutCh
i100 64.5   18   .5    .6      8    9
; Mixer
;    Sta    Dur  Amp  Ch  Pan  Fader
i190 64.5   18   1    9   65   102

f61 80.7 1024 -5 .5 224 1 800 1   ; Pitch Bend
; Envelope
;    Sta    Dur  Amp  Rate  Table  OutKCh
i5   80.7   18   1    1     67     8       ; Fco
i5   80.7   18   12   1     108    9       ; Rez
;
i5   98.7   26   1    1     67     8       ; Fco
i5   98.7   26   12   1     108    9       ; Rez
; FM Reson
;    Sta    Dur  Amp   Pitch  FcoKCh  RezKCh  PBend  OutCh  FMFqc  FMAmp
i42  80.7   .25  6000  7.04   8       9       61     8      2      2
i42  +      .    .     7.09   .       .       .      .      .      .
i42  .      .    .     7.07   .       .       .      .      .      .
i42  .      .    .     7.07   .       .       .      .      .      .
;
i42  84.7   .25  6000  7.11   .       .       61     8      2      2
i42  +      .    .     8.02   .       .       .      .      .      .
i42  .      .    .     7.09   .       .       .      .      .      .
i42  .      .    .     9.06   .       .       .      .      .      .
;
i42  88.7   .25  6000  8.04   .       .       61     8      2      2
i42  +      .    .     8.02   .       .       .      .      .      .
i42  .      .    .     7.11   .       .       .      .      .      .
i42  .      .    .     7.09   .       .       .      .      .      .
; Part 1
i42  90.7   .25  6000  9.02   .       .       61     8      2      2
i42  +      .    .     8.02   .       .       .      .      .      .
i42  .      .    .     9.11   .       .       .      .      .      .
i42  .      .    .    10.09   .       .       .      .      .      .
i42  .      .    .     9.11   .       .       .      .      .      .
i42  .      .    .    10.09   .       .       .      .      .      .
;
i42  92.7   .25  4000  9.02   .       .       61     8      2      2
i42  +      .    .     9.04   .       .       .      .      .      .
i42  .      .    .     9.07   .       .       .      .      .      .
i42  .      .    .     9.09   .       .       .      .      .      .
i42  .      .    .     9.07   .       .       .      .      .      .
i42  .      .    .    10.04   .       .       .      .      .      .
;
i42  94.7   .25  6000  9.02   .       .       61     8      3      4
i42  +      .    .     8.04   .       .       .      .      .      .
i42  .      .    .     7.07   .       .       .      .      .      .
i42  .      .    .     8.11   .       .       .      .      .      .
i42  .      .    .     9.06   .       .       .      .      .      .
i42  .      .    .     9.04   .       .       .      .      .      .
;
i42  96.7   .25  6000 10.02   .       .       61     8      3      4
i42  +      .    .     8.11   .       .       .      .      .      .
i42  .      .    .    10.02   .       .       .      .      .      .
i42  .      .    .     8.11   .       .       .      .      .      .
i42  .      .    .     8.09   .       .       .      .      .      .
i42  .      .    .     8.07   .       .       .      .      .      .
i42  .      .    .     8.09   .       .       .      .      .      .
i42  .      .    .     8.04   .       .       .      .      .      .
; Part 2
i42  98.7   .25  6000  9.02   .       .       61     8      2      2
i42  +      .    .     8.02   .       .       .      .      .      .
i42  .      .    .     9.11   .       .       .      .      .      .
i42  .      .    .    10.09   .       .       .      .      .      .
i42  .      .    .     9.11   .       .       .      .      .      .
i42  .      .    .    10.09   .       .       .      .      .      .
;
i42  100.7  .25  4000  9.02   .       .       61     8      2      2
i42  +      .    .     9.04   .       .       .      .      .      .
i42  .      .    .     9.07   .       .       .      .      .      .
i42  .      .    .     9.09   .       .       .      .      .      .
i42  .      .    .     9.07   .       .       .      .      .      .
i42  .      .    .    10.04   .       .       .      .      .      .
;
i42  102.7  .25  6000  9.02   .       .       61     8      3      4
i42  +      .    .     8.04   .       .       .      .      .      .
i42  .      .    .     7.07   .       .       .      .      .      .
i42  .      .    .     8.11   .       .       .      .      .      .
i42  .      .    .     9.06   .       .       .      .      .      .
i42  .      .    .     9.04   .       .       .      .      .      .
;
i42  104.7  .25  6000 10.02   .       .       61     8      3      4
i42  +      .    .     8.11   .       .       .      .      .      .
i42  .      .    .    10.02   .       .       .      .      .      .
i42  .      .    .     8.11   .       .       .      .      .      .
i42  .      .    .     8.09   .       .       .      .      .      .
i42  .      .    .     8.07   .       .       .      .      .      .
i42  .      .    .     8.09   .       .       .      .      .      .
i42  .      .    .     8.04   .       .       .      .      .      .
; Part 3
i42 108.7   .25  6000  9.02   .       .       61     8      2      2
i42  +      .    .     8.02   .       .       .      .      .      .
i42  .      .    .     9.11   .       .       .      .      .      .
i42  .      .    .    10.09   .       .       .      .      .      .
i42  .      .    .     9.11   .       .       .      .      .      .
i42  .      .    .    10.09   .       .       .      .      .      .
;
i42  110.7  .25  4000  9.02   .       .       61     8      2      2
i42  +      .    .     9.04   .       .       .      .      .      .
i42  .      .    .     9.07   .       .       .      .      .      .
i42  .      .    .     9.09   .       .       .      .      .      .
i42  .      .    .     9.07   .       .       .      .      .      .
i42  .      .    .    10.04   .       .       .      .      .      .
;
i42  112.7  .25  6000  9.02   .       .       61     8      3      4
i42  +      .    .     8.04   .       .       .      .      .      .
i42  .      .    .     7.07   .       .       .      .      .      .
i42  .      .    .     8.11   .       .       .      .      .      .
i42  .      .    .     9.06   .       .       .      .      .      .
i42  .      .    .     9.04   .       .       .      .      .      .
;
i42  114.7  .25  6000 10.02   .       .       61     8      3      4
i42  +      .    .     8.11   .       .       .      .      .      .
i42  .      .    .    10.02   .       .       .      .      .      .
i42  .      .    .     8.11   .       .       .      .      .      .
i42  .      .    .     8.09   .       .       .      .      .      .
i42  .      .    .     8.07   .       .       .      .      .      .
i42  .      .    .     8.09   .       .       .      .      .      .
i42  .      .    .     8.04   .       .       .      .      .      .
; Delay
;    Sta    Dur  Time  FeedBk  InCh OutCh
i100 80.7   42   .5    .6      8    9
; Mixer
;    Sta    Dur  Amp  Ch  Pan  Fader
i190 80.7   42   1    9   65   102


;---------------------------------------------------------------------------
; Noise Resonance Filter
;---------------------------------------------------------------------------
;f68 68 1024 -7 .5 28 1 150 1 14 .5 50 .5 14 1.5 200 1.5 56 .75 100 .75 28 .5 100 .5 28 1 256 1 ; Pitch Bend
f68 68.1 1024 -7 1 1024 1 ; Pitch Bend
f65 68.1 1024 -7 1 256 0 256 1 256 0 256 1 ; Pan 1
f67 68.1 1024 -7 800 100 150 100 1000 56 300 256 1600 256 300 156 2600 100 300 ; Fco Envelope
; Envelope
;    Sta   Dur  Amp  Rate  Table  OutKCh
i5   78.7  10   1    1     67     6       ; Fco
i5   78.7  10   16   1     102    7       ; Rez
;
i5   98.7  20   1    1     67     6       ; Fco
i5   98.7  20   16   1     102    7       ; Rez
; Noise Reson
;    Sta   Dur  Amp   Pitch  FcoKCh  RezKCh  PBend  OutCh
i44  78.7  .5   8000  7.04   6       7       102    10
i44  +     .    8000  7.09   6       7       .      10
i44  .     .    8000  8.04   6       7       .      10
i44  .     .    8000  8.09   6       7       .      10
i44  82.7  .5   8000  8.07   6       7       102    10
i44  +     .    8000  8.11   6       7       .      10
i44  .     .    8000  8.09   6       7       .      10
i44  .     .    8000  8.06   6       7       .      10
i44  86.7  .5   8000  7.09   6       7       102    10
i44  +     .    8000  6.07   6       7       .      10
i44  .     .    8000  8.02   6       7       .      10
i44  .     .    8000  8.04   6       7       .      10
;
;    Sta   Dur  Amp   Pitch  FcoKCh  RezKCh  PBend  OutCh
i44  99.7  2    6000  8.04   6       7       102    10
i44 101.7  2    6000  8.11   6       7       102    10
i44 103.7  2    6000  8.09   6       7       102    10
i44 105.7  2    6000  8.04   6       7       102    10
;    Sta   Dur  Amp   Pitch  FcoKCh  RezKCh  PBend  OutCh
i44 109.7  2    6000  8.04   6       7       102    10
i44 111.7  2    6000  8.11   6       7       102    10
i44 113.7  2    6000  8.09   6       7       102    10
i44 115.7  2    6000  8.04   6       7       102    10
; Delay
;    Sta  Dur  Time  FeedBk  InCh OutCh
i100 78.7 46   .5    .6      10   11
; Mixer
;    Sta  Dur  Amp  Ch  Pan  Fader
i190 78.7 46   1.2  11  65   102

; Granular Synthesis tables
f31 0 1024 10 1 .3 .1 0 .2 .02 0 .1 .04
f32 0 1024  7 0 512 1 512 0
f33 0 1024 -5 .8 1024 .01
f34 0 1024 -5 4  1024 .125
; Granular
;  Start  Dur  Amp   Freq  GrTab  WinTab  FRngTab  Dens  Attk  Decay  BendTab
i46 64.5  12.0 1000  9.00  31     32      33       200   4     .5     34



;---------------------------------------------------------------------------
; Medium Room Reverb
;---------------------------------------------------------------------------
;     Sta  Dur  Amp  InCh1  InCh2  InCh3  InCh4  InCh5  InCh6
i192  0.0  122  .1   5      6      3      4      7      10

; Clear Zak
;     Sta  Dur
i195  0    122




</CsScore>
</CsoundSynthesizer>
