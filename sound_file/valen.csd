<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

;---------------------------------------------------------------------------
; Song 1
;---------------------------------------------------------------------------

sr=44100
kr=22050
ksmps=2
nchnls=2
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
       zawm     aplk*kamp, ioutch                 ; Write to output
       endin

;---------------------------------------------------------------------------
; LFO
;---------------------------------------------------------------------------
          instr   7
iamp      init    p4
ifqc      init    p5
itab1     init    p6
iphase    init    p7
ioffset   init    p8
iout      init    p9

koscil    oscil   iamp, ifqc, itab1, iphase  ;Table oscillator
kout      =       koscil+ioffset

          zkw     kout, iout           ;Send to output channel

          endin


;---------------------------------------------------------------------------------
; Bass Synth
;---------------------------------------------------------------------------------
        instr   20

idur    =       p3
iamp    =       p4/10
ifqc    =       cpspch(p5)
ifco    =       p6
irez    =       p7
iband   =       p8
ioutch  =       p9
ifqcadj =       .149659863*sr

kamp   linseg   0,       .005, iamp, .1, .6*iamp, idur-.13, .5*iamp, .02, 0
kfco   linseg   .2*ifco, .005, ifco, .1, .3*ifco, idur-.13, .2*ifco, .02, .2*ifco
krez   linseg   irez/2, .8*idur, irez, .2*idur, irez/2

apulse1 buzz    1,ifqc, sr/2/ifqc, 1    ; Avoid aliasing
apulse3 buzz    1,ifqc, sr/2/ifqc, 1
apulse2 delay   apulse3, 1/ifqc/2
avpw    =        apulse1 - apulse2      ; two inverted pulses at variable distance
apwmdc  integ    avpw
atri    integ    apwmdc
axn     butterhp atri, 10               ; remove DC offset caused by integ

; Resonant Lowpass Filter (4 Pole)
kc     =        ifqcadj/kfco
krez2  =        krez/(1+exp(kfco/11000))
ka1    =        kc/krez2-(1+krez2*iband)
kasq    =       kc*kc
kb     =        1+ka1+kasq

ayn    nlfilt   axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   nlfilt   ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

       zaw     kamp*ayn, ioutch
       endin

;---------------------------------------------------------------------------------
; Female Ahh
;---------------------------------------------------------------------------------
       instr   30
idur   =       p3
ifq    =       cpspch(p4)
ioutch =       p6
ibendtab =     p7

k1     oscil   2, 3, 1                    ; vibrato
kbend  oscili  1, 1/idur, ibendtab
k2     linseg  .5, .02, 0, idur-.04, 0, .02, .5  ; octaviation coefficient
kamp   linseg  0, .14, 1, .5*p3-.12, .6, .5*p3-.12, 1, .1, 0
kfqc   =       ifq*kbend+k1

;                           koct                      iolaps  ifnb
;          xamp  xfund  xform    kband kris  kdur  kdec    ifna    idur
;  Base amplitude of 20000

a1 fof  371, kfqc,  564, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a2 fof  186, kfqc, 1156, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a3 fof  113, kfqc, 1748, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a4 fof  117, kfqc, 3552, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a5 fof  103, kfqc, 4116, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a6 fof   51, kfqc, 2340, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a7 fof   58, kfqc, 2932, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a8 fof   53, kfqc, 7641, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a9 fof   56, kfqc, 8205, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1

abal1  =       p5*500

a10    balance (a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8/2 + a9/2), abal1

anoise rand    1000*kamp
a12    reson   anoise, 1156, 150
a13    reson   anoise, 3778, 175
a14    reson   anoise, 8177, 390
a15    reson   anoise, 10000, 250

a20    balance (a12 + a13 + a14 + a15/2), a10/8

aout   =       (a10+a20)*kamp
       zaw     aout, ioutch

       endin

;---------------------------------------------------------------------------------
; Male Ahh
;---------------------------------------------------------------------------------
       instr   31
idur   =       p3
ifq    =       cpspch(p4)
ioutch =       p6
ibendtab =     p7

k1     oscil   2, 3, 1                    ; vibrato
kbend  oscili  1, 1/idur, ibendtab
k2     linseg  .5, .02, 0, idur-.04, 0, .02, .5  ; octaviation coefficient
kamp   linseg  0, .14, 1, .5*p3-.12, .6, .5*p3-.12, 1, .1, 0
kfqc   =       ifq*kbend+k1

;                           koct                      iolaps  ifnb
;          xamp  xfund  xform    kband kris  kdur  kdec    ifna    idur
;  Base amplitude of 20000

a1 fof  303, kfqc,  630, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a2 fof  220, kfqc, 1145, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a3 fof  129, kfqc, 2462, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a4 fof  129, kfqc, 3121, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1
a5 fof  107, kfqc, 3608, k2, 200, .003, .017, .005, 50, 1,19, idur, 0, 1

abal1  =       p5*500

a10    balance a1 + a2 + a3 + a4 + a5, abal1

anoise rand    1000*kamp
a12    reson   anoise, 658, 150
a13    reson   anoise, 3264, 175
a14    reson   anoise, 5641, 390

a20    balance a12 + a13 + a14, abal1*.05

aout   =       (a10+a20)*kamp
       zaw     aout, ioutch

       endin

;---------------------------------------------------------------------------
;Lorenz Attractor
;---------------------------------------------------------------------------
        instr  8

iamp    init   p4/40
kx      init   p5
ky      init   p6
kz      init   p7
is      init   p8
ir      init   p9
ib      init   p10
ih      init   p11/kr*1.2
ioutch  init   p12
ioffset init   p13

kxnew   =      kx+ih*is*(ky-kx)
kynew   =      ky+ih*(-kx*kz+ir*kx-ky)
kznew   =      kz+ih*(kx*ky-ib*kz)

kx      =      kxnew
ky      =      kynew
kz      =      kznew

;printk   .5, kx
;printk   .5, ky
;printk   .5, kz

        zkw    kx*iamp+ioffset, ioutch
        endin

;---------------------------------------------------------------------------
; Chorus
;---------------------------------------------------------------------------
         instr   35

imixch   =       p4             ; Mix of chorused signal
imix     =       1-imixch       ; Mix of direct signal
izin     =       p5            ; Input channel
izout    =       p6            ; Output channel
ikin     =       p7            ; Input K Channel

asig     zar     izin           ; Read input channel
kinsig   zkr     ikin           ; Read K Input

adel1    vdelay  asig, kinsig, 100      ; Variable delay tap
aout     =       adel1*imixch+asig*imix ; Mix direct and chorused signals

;aout     =       kinsig*500
         zaw     aout, izout                    ; Write to output channel

         endin

;---------------------------------------------------------------------------
; Breath
;---------------------------------------------------------------------------
       instr 41

idur   =      p3
iamp   =      p4
irate  =      p5
iwave1 =      p6
iwave2 =      p7
iamptab =     p8

adel1   init  0
adel2   init  0

krate  oscili 1, 1/idur, irate
kamp1  oscili 1, krate, iwave1
kamp2  oscili 1, krate, iwave2
kamp3  oscili 1, 1/idur, iamptab

kosc1  oscil  20, .5, 1
kosc2  oscil  20, .5, 1, .25

kdel1  =      kosc1+21
kdel2  =      kosc2+21

anoise rand   iamp/10

a1     reson  anoise, 747, 200
a2     reson  anoise, 1403, 500
a3     reson  anoise, 3221, 500
a4     reson  anoise, 5526, 600

a5     reson  anoise, 300, 50
a6     reson  anoise, 730, 100
a7     reson  anoise, 1360, 150
a8     reson  anoise, 3135, 300

aout1   =     kamp1*(5*a1+4*a2+2*a3+a4)*kamp3
aout2   =     kamp2*(a5+2*a6+4*a7+4*a8)*kamp3

adel1   delay aout1, .15
adel2   delay aout2, .15

       outs  adel1-.5*adel2, adel2-.5*adel1

       endin

;---------------------------------------------------------------------------
; Heartbeat
;---------------------------------------------------------------------------
       instr 42

idur   =      p3
iamp   =      p4
irate  =      p5
ishape =      p6
iwave1 =      p7
iwave2 =      p8
iamptab =     p9

adel1   init  0
adel2   init  0

krate  oscili 1, 1/idur, irate
kamp1  oscili 1, krate, iwave1
kamp2  oscili 1, krate, iwave2
kamp3  oscili 1, 1/idur, iamptab

asig   oscil  1, 78, ishape

afilt1  butterlp   asig*kamp1*kamp3, 200
afilt2  butterlp   asig*kamp2*kamp3, 150
aout1   butterhp   afilt1, 100
aout2   butterhp   afilt2, 75

       outs  aout1*7000, aout2*9000

       endin

;---------------------------------------------------------------------------------
; String Pad (Band Limited Impulse Train)
;---------------------------------------------------------------------------------
        instr   50

p3      =       p3+.2
idur    =       p3
iamp    =       p4
ifqc    =       cpspch(p5)
iampenv =       p6
ifcotab =       p7
ireztab =       p8
ioutch  =       p9
iband   =       0

kamp   linseg   0, .5, iamp, idur-.7, iamp, .2, 0
kfco   oscili   1, 1/(p3), ifcotab
krez   oscili   1, 1/(p3), ireztab
ifqcadj =       .149659863*sr
klfo1  oscili   .1, 1.5, 1
klfo2  oscili   .1, 1.5, 1, .21
klfo3  oscili   .1, 1.5, 1, .43

kfco   oscil    1, 1/idur, ifcotab
krez   oscil    1, 1/idur, ireztab

apulse1 buzz    1,ifqc, sr/2/ifqc, 1 ; Avoid aliasing
apulse3 buzz    1,ifqc, sr/2/ifqc, 1
apulse2 vdelay   apulse3, 1000/ifqc/(klfo1+1)/2, 1000/ifqc           ;
avpw1   =       apulse1 - apulse2         ; two inverted pulses at variable distance
apwmdc1    integ   avpw1

apulse4 buzz    1,ifqc*.995, sr/2/ifqc, 1 ; Avoid aliasing
apulse6 buzz    1,ifqc*.995, sr/2/ifqc, 1
apulse5 vdelay   apulse6, 1000/ifqc/(klfo2+1)/2*.995, 1000/ifqc           ;
avpw2   delay   apulse4 - apulse5, .05         ; two inverted pulses at variable distance
apwmdc2    integ   avpw2

apulse7 buzz    1,ifqc*.997, sr/2/ifqc, 1 ; Avoid aliasing
apulse9 buzz    1,ifqc*.997, sr/2/ifqc, 1
apulse8 vdelay   apulse6, 1000/ifqc/(klfo2+1)/2*.997, 1000/ifqc           ;
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

       zawm    kamp*ayn2, ioutch
       endin
;-------------------------------------------------------------
;Flute Instrument based on Perry Cook's Slide Flute
;-------------------------------------------------------------
         instr  60

aflute1  init   0
ifqc     =      cpspch(p5)
ipress   =      .9    ;p6
ibreath  =      .01  ;p7
ifeedbk1 =      .4    ;p8
ifeedbk2 =      .4    ;p9
ibendtab =      p6
ioutch   =      p7
iaccnt   =      p8
kbreath  linseg 0, .005, .4*iaccnt, .2, 0, p3-.205, 0

;-------------------------------------------------------------
kenv1    linseg 0,.01,iaccnt*1.4*ipress,.1,ipress,p3-.17,ipress,.06,0
;Flow setup
kenv2    linseg 0,.01,1,p3-.02,1,.01,0     ;Flow must be about 1 or it will blow up
kenvibr  linseg 0,.5,0,.5,1,p3-1,1         ; Vibrato envelope
kvbrate  oscil  1, 1, 1
kvibr    oscil  .02*kenvibr,5+kvbrate,1    ;Low frequency vibrato
kbend    oscil  1, 1/p3, ibendtab

;-------------------------------------------------------------
arnd0    rand   p4
arnd1    reson  arnd0, 1230, 200
arnd2    reson  arnd0, 3202, 1000
arnd3    reson  arnd0, 6402, 2000

abal1    =      kenv1
aflow1   balance arnd1+arnd2+arnd3,  abal1+kvibr  ;Noise is used to simulate breath sound.
asum1    =      ibreath*aflow1+kenv1+kvibr  ;Add flow, noise and vibrato.
asum2    =      asum1+aflute1*ifeedbk1      ;Add above to scaled feedback.
afqc     =      1/ifqc/kbend-asum1/20000-4/sr+ifqc/kbend/5000000 ;Find delay length.

;-------------------------------------------------------------
atemp1   delayr   1/ifqc/2                  ;The embouchoure delay should
ax       deltapi  afqc/2                    ;be about 1/2 the bore delay.
         delayw   asum2

;-------------------------------------------------------------
apoly    =        ax-ax*ax*ax               ;A polynomial is used to adjust
asum3    =        apoly+aflute1*ifeedbk2    ;the feedback.

kfco     linseg   4000, .1, 1000, .1, 2400, p3-.2, 2000
avalue   tone     asum3, kfco

; Bore, the bore length determines pitch.  Shorter is higher pitch.
;-------------------------------------------------------------
atemp2   delayr   1/ifqc
aflute1  deltapi  afqc
         delayw   avalue

khpenv   linseg   600, .3, 20, p3-.3, 20
aout     butterhp avalue, khpenv

         zaw     (aout+kbreath*(arnd2+arnd3)/400000)*p4*kenv2, ioutch

         endin

;---------------------------------------------------------------------------
; Mixer
;---------------------------------------------------------------------------
          instr 100

idur      init  p3
iamp      init  p4
iinch      init  p5
ipan      init  p6
ifader    init  p7
ioutch    init  p8

asig1     zar   iinch             ; Read input channel 1

kfader    oscil  1, 1/idur, ifader
kpanner   oscil  1, 1/idur, ipan

kgl1      =     kfader*sqrt(kpanner)    ; Left gain
kgr1      =     kfader*sqrt(1-kpanner)  ; Right gain

kdclick   linseg  0, .002, iamp, idur-.002, iamp, .002, 0  ; Declick

asigl     =     asig1*kgl1       ; Scale and sum
asigr     =     asig1*kgr1

          outs  kdclick*asigl, kdclick*asigr   ; Output stereo pair
          zaw   kdclick*kfader*asig1, ioutch   ; Output postfader

          endin

;----------------------------------------------------------------------------------
; Large Room Reverb
;----------------------------------------------------------------------------------
       instr  105

idur   =        p3
iamp   =        p4
iinch1 =        p5
igain1 =        p6
iinch2 =        p7
igain2 =        p8
iinch3 =        p9
igain3 =        p10

aout91 init     0
adel01 init     0
adel11 init     0
adel51 init     0
adel52 init     0
adel91 init     0
adel92 init     0
adel93 init     0

kdclick linseg  0, .002, iamp, idur-.004, iamp, .002, 0

ain1  zar       iinch1
ain2  zar       iinch2
ain3  zar       iinch3
asig0  =        igain1*ain1+igain2*ain2+igain3*ain3

aflt01 butterlp asig0, 4000            ; Pre-Filter
aflt02 butterbp .8*aout91, 1000, 500       ; Feed-Back Filter
asum01  =       aflt01+.5*aflt02       ; Initial Mix

; All-Pass 1
asub01  =       adel01-.3*asum01
adel01  delay   asum01+.3*asub01,.008

; All-Pass 2
asub11  =       adel11-.3*asub01
adel11  delay   asub01+.3*asub11,.012

; Delay 1
adel21  delay   asub11, .004

; Out 1
aout31  =       1.5*adel21

; Delay 2
adel41  delay   adel21, .017

; Single Nested All-Pass
asum51  =       adel52-.25*adel51
aout51  =       asum51-.5*adel41
adel51  delay   adel41+.5*aout51, .025
adel52  delay   adel51+.25*asum51, .062

; Delay 3
adel61  delay   aout51,.031

; Out 2
aout71  =       .8*adel61

; Delay 4
adel81  delay   adel61, .003

; Double Nested All-Pass
asum91  =       adel92-.25*adel91
asum92  =       adel93-.25*asum91
aout91  =       asum92-.5*adel81
adel91  delay   adel81+.5*aout91, .120
adel92  delay   adel91+.25*asum91, .076
adel93  delay   asum91+.25*asum92, .030

aout    =       .8*aout91+aout71+aout31

        outs      aout*kdclick, -aout*kdclick

        endin


;---------------------------------------------------------------------------
; Clear audio & control channels
;---------------------------------------------------------------------------
          instr 110

          zacl  0, 30          ; Clear audio channels 0 to 30
          zkcl  0, 30          ; Clear control channels 0 to 30

          endin



</CsInstruments>

<CsScore>
;---------------------------------------------------------------------------
; Valentine's Day
; by Hans Mikelson 1998
;---------------------------------------------------------------------------
;  Sta   Dur
;a0 0     132.8  ; advance
;a0 86.8  140    ; advance
;a0 106.0  140    ; advance

; Sine Wave
f1  0 16384  10 1
f19 0 1024  19 .5 .5 270 .5
f2 0 8192 7  -1  4096 1 4096 -1 ; Triangle Wave 1

; Mixer Tables
; 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5
f3  0 1024 -7 0  1024 1           ; UpSaw/FadeIn/PanRL
f4  0 1024 -7 0  512 1 512 0      ; Tri/Pan RLR/Fade In&Out
f5  0 1024 -7 1  1024 0           ; DnSaw/FadeOut/PanLR
f6  0 1024 -7 1  1024 1           ; Const1/PanL
f7  0 1024 -7 .5 1024 .5          ; Const.5/PanC
f8  0 1024 -7 0  1024 0           ; Const0/PanR
f9  0 1024 -7 0  256 1 768 1      ; Voice Amp
f10 0 1024 -7 .5 256 .2 768 .8    ; Voice Pan CRL
f11 0 1024 -7 .5 256 .8 768 .2    ; Voice Pan CLR

;---------------------------------------------------------------------------
; Em Arpeggio Intro (10.0-29.2)
;---------------------------------------------------------------------------
;    Sta  Dur  Amp    Fqc   Func  Meth  OutCh  Sus
i2  10.0  0.2  16000  7.04   0     1    1      1.4
i2  +     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; C
i2  .     .    16000  7.00   0     1    1      1.4
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.00   .     .    .      <
i2  .     .    12000  7.07   .     .    .      0.0
; C
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  7.04   .     .    .      0.0
; Verse 1
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; C
i2  .     .    16000  7.00   0     1    1      1.4
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.00   .     .    .      <
i2  .     .    12000  7.07   .     .    .      0.0
; C
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  7.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Verse 2
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; C
i2  .     .    16000  7.00   0     1    1      1.4
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.00   .     .    .      <
i2  .     .    12000  7.07   .     .    .      0.0
; C
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  7.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Chorus
; D
i2  80.4  .025 12000  7.09   0     1    1      3.175
i2  +     .    12000  7.06   .     .    .      <
i2  .     .    10400  6.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    10400  8.02   .     .    .      3.05
; Em
i2  83.6  .    12000  7.04   0     1    1      3.175
i2  +     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .     8400  6.11   .     .    .      3.05
; D
i2  86.8  .025 12000  7.09   0     1    1      3.175
i2  +     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .     8000  6.09   .     .    .      <
i2  .     .    10400  8.02   .     .    .      3.05
; Em
i2  90.0  .    12000  7.04   0     1    1      3.175
i2  +     .    10000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      3.05
; D
i2  93.2  .025 12000  7.09   0     1    1      3.175
i2  +     .    10000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    10000  7.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .     8400  8.02   .     .    .      3.05
; Em
i2  96.4  .    12000  7.04   0     1    1      3.175
i2  +     .    10000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    10000  7.09   .     .    .      <
i2  .     .     8400  8.11   .     .    .      3.05
; Em
i2  99.6  .    12000  7.04   0     1    1      1.575
i2  +     .    10000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .     8000  8.04   .     .    .      1.45
; D
i2 101.2  .025 12000  7.09   0     1    1      0.775
i2  +     .    10000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    10000  7.02   .     .    .      <
i2  .     .    12000  8.06   .     .    .      <
i2  .     .     8400  6.09   .     .    .      0.65
; C
i2 102.0  .025 12000  7.07   0     1    1      0.775
i2  +     .    10000  7.04   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    10000  7.00   .     .    .      <
i2  .     .    10400  8.00   .     .    .      <
i2  .     .     8000  6.07   .     .    .      0.65
; B7
i2 102.8  .    12000  7.03   0     1    1      3.175
i2  +     .    10000  6.11   .     .    .      <
i2  .     .    10400  8.06   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    10000  8.03   .     .    .      3.05
; Verse 3
; Em
i2  106   .2   16000  7.04   0     1    1      1.4
i2  +     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; C
i2  .     .    16000  7.00   0     1    1      1.4
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.00   .     .    .      <
i2  .     .    12000  7.07   .     .    .      0.0
; C
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  7.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
;
; Verse 4 Fade Out
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.11   0     1    1      1.4
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; C
i2  .     .    16000  7.00   0     1    1      1.4
i2  .     .    12000  7.04   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.00   .     .    .      <
i2  .     .    12000  7.07   .     .    .      0.0
; C
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.07   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  7.04   .     .    .      0.0
; D
i2  .     .    16000  7.09   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.02   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.09   .     .    .      0.0
; D
i2  .     .    16000  7.02   0     1    1      1.4
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.09   .     .    .      <
i2  .     .    12000  7.00   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.06   .     .    .      <
i2  .     .    10400  8.02   .     .    .      <
i2  .     .    12000  7.02   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      <
i2  .     .    16000  7.04   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.04   .     .    .      <
i2  .     .    12000  8.09   .     .    .      0.0
; Em
i2  .     .    16000  7.04   0     1    1      1.4
i2  .     .    12000  7.11   .     .    .      <
i2  .     .    10400  8.07   .     .    .      <
i2  .     .    12000  8.04   .     .    .      <
i2  .     .    16000  7.09   .     .    .      <
i2  .     .    12000  7.09   .     .    .      <
i2  .     .    10400  8.11   .     .    .      <
i2  .     .    12000  8.04   .     .    .      0.0

; Lorenz Oscillator for Chorus
;   Sta  Dur    Amp   X    Y    Z     S    R   B      h(rate)  OutKCh Offset
i8  10   157.4  2.5   7.8  1.1  33.4  10   28  2.667  1        1      25
i8  10   157.4  2.5  14.1 20.7  26.6  10   28  2.667  1        2      26
; Guitar Chorus
;   Sta  Dur   Mix  InCh  OutCh  InKCh
i35 10   157.4 .5   1     2      1
i35 10   157.4 .5   1     3      2
; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0
;    Sta    Dur  Amp  Ch  Pan  Fader  OutCh
i100 10     6.4  .5   2   6    3      20
i100 10     6.4  .5   3   8    3      .
i100 16.4  64.0  .5   2   6    6      .
i100 16.4  64.0  .5   3   8    6      .
i100 80.4  25.6  .5   2   6    6      .
i100 80.4  25.6  .5   3   8    6      .
i100 106   25.6  .5   2   6    6      .
i100 106   25.6  .5   3   8    6      .
i100 131.6 25.6  .5   2   6    5      .
i100 131.6 25.6  .5   3   8    5      .

;---------------------------------------------------------------------------
; Bass
;---------------------------------------------------------------------------
;    Sta   Dur  Amp    Pitch  Fco   Rez  Band  OutCh
i20  29.2  2.8  7000   6.04   400   3    0     4
i20  +     0.4  9000   6.07   600   .    .     .
i20  .     3.2  7000   6.04   400   .    .     .
i20  .     2.8  9000   6.04   400   .    .     .
i20  .     0.4  9000   6.07   600   .    .     .
i20  .     3.2  7000   6.04   400   .    .     .
i20  .     2.4  7000   6.02   400   .    .     .
i20  .     0.4  7000   6.07   600   3.5  .1    .
i20  .     0.4  9000   6.09   700   3    0     .
i20  .     2.4  7000   6.00   400   3    0     .
i20  .     0.4  9500   7.00   800   3.5  .1    .
i20  .     0.4  7000   6.00   700   3    0     .
i20  .     2.4  7000   6.02   400   .    .     .
i20  .     0.4  7000   6.07   600   3.5  .1    .
i20  .     0.4  9000   6.09   700   3    0     .
i20  .     3.2  7000   6.04   400   .    .     .
;    Sta   Dur  Amp    Pitch  Fco   Rez  Band  OutCh
i20  54.8  2.8  7000   6.04   400   3    0     4
i20  +     0.4  9000   6.07   600   .    .     .
i20  .     3.2  7000   6.04   400   .    .     .
i20  .     2.8  9000   6.04   400   .    .     .
i20  .     0.4  9000   6.07   600   .    .     .
i20  .     3.2  7000   6.04   400   .    .     .
i20  .     2.4  7000   6.02   400   .    .     .
i20  .     0.4  7000   6.07   600   3.5  .1    .
i20  .     0.4  9000   6.09   700   3    0     .
i20  .     2.4  7000   6.00   400   3    0     .
i20  .     0.4  9500   7.00   800   3.5  .1    .
i20  .     0.4  7000   6.00   700   3    0     .
i20  .     2.4  7000   6.02   400   .    .     .
i20  .     0.4  7000   6.07   600   3.5  .1    .
i20  .     0.4  9000   6.09   700   3    0     .
i20  .     3.2  7000   6.04   400   .    .     .
;    Sta   Dur  Amp    Pitch  Fco   Rez  Band  OutCh
i20  80.4  0.8  7000   6.02   400   3    0     4
i20  +     0.8  9000   6.09   400   .    .     .
i20  .     0.8  7000   6.02   400   .    .     .
i20  .     0.4  8000   6.06   400   .    .     .
i20  .     0.4  9000   6.09   600   .    .     .
i20  .     0.8  7000   6.04   400   .    .     .
i20  .     0.8  9000   6.11   400   .    .     .
i20  .     0.8  7000   6.04   400   .    .     .
i20  .     0.4  9000   6.11   400   .    .     .
i20  .     0.4  7000   6.04   400   .    .     .
;
i20  .     0.8  7000   6.02   400   .    .     .
i20  .     0.8  9000   6.09   400   .    .     .
i20  .     0.8  7000   6.02   400   .    .     .
i20  .     0.4  8000   6.06   400   .    .     .
i20  .     0.4  9000   6.09   600   .    .     .
i20  .     0.8  7000   6.04   400   .    .     .
i20  .     0.8  9000   6.11   400   .    .     .
i20  .     0.8  7000   6.04   400   .    .     .
i20  .     0.4  8000   6.07   400   .    .     .
i20  .     0.4  7000   6.04   400   .    .     .
;
i20  .     0.8  7000   6.02   400   3    0     4
i20  .     0.8  9000   6.09   400   .    .     .
i20  .     0.8  7000   6.02   400   .    .     .
i20  .     0.4  8000   6.06   400   .    .     .
i20  .     0.4  9000   6.09   600   .    .     .
i20  .     0.8  7000   6.04   400   .    .     .
i20  .     0.8  9000   6.11   400   .    .     .
i20  .     0.8  7000   6.04   400   .    .     .
i20  .     0.4  9000   6.11   400   .    .     .
i20  .     0.4  7000   6.04   400   .    .     .
;
i20  .     0.8  7000   6.04   400   .    .     .
i20  .     0.8  7000   6.11   400   .    .     .
i20  .     0.8  7000   6.02   400   .    .     .
i20  .     0.8  7000   6.00   600   .    .     .
i20  .     3.2  7000   5.11   400   .    .     .
;    Sta   Dur  Amp    Pitch  Fco   Rez  Band  OutCh
i20  106   2.8  7000   6.04   400   3    0     4
i20  +     0.4  9000   6.07   600   .    .     .
i20  .     3.2  7000   6.04   400   .    .     .
i20  .     2.8  9000   6.04   400   .    .     .
i20  .     0.4  9000   6.07   600   .    .     .
i20  .     3.2  7000   6.04   400   .    .     .
i20  .     2.4  7000   6.02   400   .    .     .
i20  .     0.4  7000   6.07   600   3.5  .1    .
i20  .     0.4  9000   6.09   700   3    0     .
i20  .     2.4  7000   6.00   400   3    0     .
i20  .     0.4  9500   7.00   800   3.5  .1    .
i20  .     0.4  7000   6.00   700   3    0     .
i20  .     2.4  7000   6.02   400   .    .     .
i20  .     0.4  7000   6.07   600   3.5  .1    .
i20  .     0.4  9000   6.09   700   3    0     .
i20  .     3.2  7000   6.04   400   .    .     .
;    Sta   Dur  Amp    Pitch  Fco   Rez  Band  OutCh
i20  131.6 2.8  7000   6.04   400   3    0     4
i20  +     0.4  9000   6.07   600   .    .     .
i20  .     3.2  7000   6.04   400   .    .     .
i20  .     2.8  9000   6.04   400   .    .     .
i20  .     0.4  9000   6.07   600   .    .     .
i20  .     3.2  7000   6.04   400   .    .     .
i20  .     2.4  7000   6.02   400   .    .     .
i20  .     0.4  7000   6.07   600   3.5  .1    .
i20  .     0.4  9000   6.09   700   3    0     .
i20  .     2.4  7000   6.00   400   3    0     .
i20  .     0.4  9500   7.00   800   3.5  .1    .
i20  .     0.4  7000   6.00   700   3    0     .
i20  .     2.4  7000   6.02   400   .    .     .
i20  .     0.4  7000   6.07   600   3.5  .1    .
i20  .     0.4  9000   6.09   700   3    0     .
i20  .     3.2  7000   6.04   400   .    .     .

; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0
;    Sta   Dur   Amp  Ch  Pan  Fader  OutCh
i100 29.2  102.4 .6   4   7    6      21    ; Bass
i100 131.6 25.6  .6   4   7    5      21    ; Bass

;---------------------------------------------------------------------------
; Female Voice 
;---------------------------------------------------------------------------
; Verse 1
f30  29.2 1024 -7 1     508 1     4 1.335 124 1.335 4 1.189 60  1.189 4 1.122 60  1.122 4 1 256 1
f31  35.6 1024 -7 1     508 1     4 1.335 124 1.335 4 1.189 60  1.189 4 1.335 60  1.335 4 1.498 256 1.498
f32  42.0 1024 -7 1     380 1     4 .9438  60 .9438 4 .8408 60  .8408 4 .9438 252 .9438 4 .6300 256 .6300
f33  48.4 1024 -7 1.335 380 1.335 4 1.189  60 1.189 4 1.122 60  1.122 4 1     512 1
;    Sta   Dur  Fqc     Amp  OutCh  PitchTable
i30  29.2  6.4  8.04    8    5      30
i30  +     6.4  8.04    8    5      31
i30  .     6.4  9.00    8    5      32
i30  .     6.4  8.04    8    5      33

; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0, 9=VocalFadeIn
;    Sta  Dur   Amp  Ch  Pan  Fader
i100 29.2 6.4   .5   5   10   9
i100 +    6.4   .5   5   11   6
i100 .    6.4   .5   5   10   6
i100 .    6.4   .5   5   11   6

; Verse 2
;    Sta   Dur  Fqc     Amp  OutCh  PitchTable
i30  54.8  6.4  8.04    8    5      30
i30  +     6.4  8.04    8    5      31
i30  .     6.4  9.00    8    5      32
i30  .     6.4  8.04    8    5      33
; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0
;    Sta  Dur   Amp  Ch  Pan  Fader  OutCh
i100 54.8 6.4   .5   5   10   6      22
i100 +    .     .    .   11   .      .
i100 .    .     .    .   10   .      .
i100 .    .     .    .   11   .      .

; Verse 3
;    Sta   Dur  Fqc     Amp  OutCh  PitchTable
i30  106   6.4  8.04    6    5      30
i30  +     6.4  8.04    6    5      31
i30  .     6.4  9.00    6    5      32
i30  .     6.4  8.04    6    5      33
; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0
;    Sta  Dur   Amp  Ch  Pan  Fader  OutCh
i100 106  6.4   .5   5   10   6      22
i100 +    6.4   .5   5   11   .      .
i100 .    6.4   .5   5   10   .      .
i100 .    6.4   .5   5   11   .      .

; Fade Out
;    Sta    Dur  Fqc     Amp  OutCh  PitchTable
i30  131.6  6.4  8.04    6    5      30
i30  +      6.4  8.04    6    5      30
i30  .      6.4  8.04    6    5      30
i30  .      6.4  8.04    6    5      30

; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0
;    Sta    Dur    Amp  Ch  Pan  Fader  OutCh
i100 131.6  25.6   .5   5   10    5     22

;---------------------------------------------------------------------------
; Male Voice 
;---------------------------------------------------------------------------
; Verse 2
f34  56.0 1024 -7 1.122 73  1.122 5  1.189 153 1.189 5  1     153 1     5  .8909 310 .8909 5 1 315 1
f35  62.4 1024 -7 1.122 73  1.122 5  1.189 153 1.189 5  1     153 1     5  1.335 310 1.335 5 1.189 315 1.189
f36  68.4 1024 -7 1.587 161 1.587 10 1.498 161 1.498 10 1.335 331 1.335 10 1.587 341 1.587
f37  71.6 1024 -7 1.498 161 1.498 10 1.335 161 1.335 10 1.189 331 1.189 10 1.498 341 1.498
f38  74.8 1024 -7 1.335 73  1.335  4 1.189  73 1.189  4 1.122 146 1.122  4 1.189 146 1.189 4 1 570 1
;    Sta   Dur  Fqc     Amp  OutCh  PitchTable
i31  56.0  5.2  7.04    8    6      34
i31  62.4  5.2  7.04    .    .      35
i31  68.4  2.4  7.04    .    .      36
i31  71.6  2.4  7.04    .    .      37
i31  74.8  5.6  7.04    .    .      38
;
; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0, 9=Voice FadeIn
;    Sta  Dur   Amp  Ch  Pan  Fader  OutCh
i100 56.0 5.2   .5   6   10   9      23
i100 62.4 5.2   .5   6   11   6      .
i100 68.4 2.4   .5   6   10   .      .
i100 71.6 2.4   .5   6   11   .      .
i100 74.8 5.6   .5   6   10   .      .
;
; Verse 3
;    Sta    Dur  Fqc     Amp  OutCh  PitchTable
i31  107.2  5.2  7.04    8    6      34
i31  113.6  5.2  7.04    .    .      35
i31  119.6  2.4  7.04    .    .      36
i31  122.8  2.4  7.04    .    .      37
i31  126.0  5.6  7.04    .    .      38
;
;    Sta    Dur   Amp  Ch  Pan  Fader  OutCh
i100 107.2  5.2   .5   6   10   6      23
i100 113.6  5.2   .5   6   11   6      .
i100 119.6  2.4   .5   6   10   .      .
i100 122.8  2.4   .5   6   11   .      .
i100 126.0  5.6   .5   6   10   .      .

;---------------------------------------------------------------------------
; Heartbeat/Breathing
;---------------------------------------------------------------------------
f40 0   1024   -7 0 512 0 256 1 256 0
f41 0   1024   -7 0 128 1 384 0 512 0
f42 0   1024   -7 0 256 1.5  256 1.5  512 0
f42 144 1024   -7 0    256 1.5  768 2.5
f43 0   1024   -7 .3125 256 .3125  256 .625 512 .625
f43 144 1024   -7 10 256 10 256 10 256 .625 128 .3125 128 .3125
f46 0   1024   -7 .9375 256 .9375  256 1.875 512 1.875
f46 144 1024   -7 10 256 10 256 10 256 .9375 128 .625 128 .625
f44 0   1024   -7 0 356 0 64  1  64  0 604 0
f45 0   1024   -7 0 64  1 80 .7  64 0 816 0
f47 0   1024   -7 0 256 1 256 1 512 0
f47 144 1024   -7 0  256 4 768 1.5
f48 0   16384  10 1 .3  .1  0  .05 0 .1

; Breathing
;   Sta   Dur  Amp  RateTable  Wave1  Wave2  AmpTable  
i41 0     24   100  43         40     41     47
i41 144   24   100  43         40     41     47

; Heartbeat
;   Sta   Dur  Amp  RateTable  Shape  Wave1  Wave2  AmpTable  
i42 0     24   100  46         48     44     45     42
i42 144   24   100  46         48     44     45     42

;---------------------------------------------------------------------------------
; Verse 3 String Pad
;---------------------------------------------------------------------------------
f50 0 1024 -7 4000 341 2000 341 4000 342 2000  ; Fco
f51 0 1024 -7 1000 341 3000 341 1000 342 3000  ; Fco
f52 0 1024 -7 2 1024 2                  ; Rez
f53 0 1024  7 0  128   1 224 .9 640 .9  64 0  ; Amp
;    Sta   Dur  Amp    Pitch  AmpEnv  FcoEnv  RezEnv  OutCh
i50  131.6 6.4  10000  7.04   53      51      52      7
i50  .     .    .      7.11   .       50      .       .
i50  .     .    .      8.04   .       50      .       .
i50  .     .    .      6.04   .       51      .       .
i50  .     .    .      8.07   .       50      .       .
;
i50  138   6.4  10000  7.02   53      51      52      7
i50  .     .    .      7.09   .       50      .       .
i50  .     .    .      8.02   .       50      .       .
i50  .     .    .      6.02   .       51      .       .
i50  .     .    .      8.06   .       50      .       .
;
i50  144.4 6.4  10000  7.04   53      51      52      7
i50  .     .    .      7.11   .       50      .       .
i50  .     .    .      8.04   .       50      .       .
i50  .     .    .      6.04   .       51      .       .
i50  .     .    .      8.07   .       50      .       .
;
i50  150.8 6.4  10000  7.02   53      51      52      7
i50  .     .    .      7.09   .       50      .       .
i50  .     .    .      8.02   .       50      .       .
i50  .     .    .      6.02   .       51      .       .
i50  .     .    .      8.06   .       50      .       .

; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0
;    Sta    Dur   Amp  Ch  Pan  Fader  OutCh
i100 131.6  6.4   .5   7   7    3      24
i100 138.0  6.4   .5   7   7    6      .
i100 144.4  6.4   .5   7   7    6      .
i100 150.8  6.4   .5   7   7    5      .

; Flute
f60 80.4 1024 -7 1.122 384 1.122 12 1.189 116 1.189 12 1.335 244 1.335 12  1.189 116 1.189 12  1.122 128 1.122
f61 80.4 1024 -7 1.189 500 1.189 12 1     512 1
f62 80.4 1024 -7 1.122 186 1.122  6 1.189 58  1.189 6  1.335 122 1.335 6   1.189 58  1.189 6   1.122 58  1.122 6 1.189 122 1.189 6 1.335 122 1.335 6 1.498 256 1.498
f63 80.4 1024 -7 1.498 186 1.498  3 1.335 3   1.498 58 1.498 6   1.335 122 1.335 6   1.189 122 1.189 6   1.122 512 1.122
;    Sta  Dur  Amp    Pitch  Bend  OutCh Accent
i60  80.4 3.2  10000  8.04   60    8     1.02
i60  +    3.2  10000  8.04   61    8     1.02
i60  .    6.4  10000  8.04   62    8     1.00
i60  .    3.2  10000  8.04   60    8     1.02
i60  .    3.2  10000  8.04   61    8     1.00
i60  .    6.4  10000  8.04   63    8     0.96
; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0
;    Sta    Dur   Amp  Ch  Pan  Fader  OutCh
i100 80.4   25.6  .7   8   7    6      25

; Large Room Reverb
;    Sta   Dur    Amp  InCh1 Gain1 InCh2 Gain2 InCh3 Gain3  
i105 29.2  129.0  0.2  22    1     23    1     25    1

;---------------------------------------------------------------------------
; Clear ZAK
;---------------------------------------------------------------------------
; Clear Channels
i110 0  157.4

</CsScore>
</CsoundSynthesizer>
