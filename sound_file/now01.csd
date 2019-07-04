<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr=44100
kr=22050
ksmps=2
nchnls=1


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
;display krate, 1
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

instr 1041
idur = p3
iamp = p4
irate  =      p5
iwave1 =      p6
iwave2 =      p7
iamptab =     p8

adel1   init  0
adel2   init  0

krate  oscili 1, 1/idur, irate
;display krate, 1
kamp1  oscili 1, krate, iwave1
kamp2  oscili 1, krate, iwave2
kamp3  oscili 1, 1/idur, iamptab

kosc1  oscil  20, .5, 1
kosc2  oscil  20, .5, 1, .25

kdel1  =      kosc1+21
kdel2  =      kosc2+21
anoise rand iamp/10
a1 reson anoise, 747, 200
a2 reson anoise, 1403, 500
a3     reson  anoise, 3221, 500
a4     reson  anoise, 5526, 600

a5     reson  anoise, 300, 50
a6     reson  anoise, 730, 100
a7     reson  anoise, 1360, 150
a8     reson  anoise, 3135, 300
display kamp1, 24
display kamp2, 24
display kamp3, 24
outs kamp1 * a1
endin

</CsInstruments>

<CsScore>

; Sine Wave
f1  0 16384  10 1

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
i1041 0     24   100  43         40     41     47

</CsScore>
</CsoundSynthesizer>
