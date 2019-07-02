<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
;************************************************************
; An assortment of chaotic, fractal and related instruments
; Coded by Hans Mikelson  March 9, 1997
;************************************************************

; 1. The Lorenz Attractor
; 2. Duffings System or Cubic Oscillator
; 3. Planet Orbiting in a Binary Star System
; 4. The Rossler Attractor
; 5. K A Oscillator
; 6. Feather Fractals
; 7. Simple Chaos 1
; 8. Simple Chaos 2
; 9. Simple Chaos 3
;10. Simple Chaos 4
;11. Simple Chaos 5

sr=44100
kr=44100
ksmps=1
nchnls=2

;Lorenz Attractor

        instr  1

;--------------------------------------------------------------------
ax      init   p5
ay      init   p6
az      init   p7
as      init   p8
ar      init   p9
ab      init   p10
ah      init   p11

;--------------------------------------------------------------------
kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0

axnew   =      ax+ah*as*(ay-ax)
aynew   =      ay+ah*(-ax*az+ar*ax-ay)
aznew   =      az+ah*(ax*ay-ab*az)

;--------------------------------------------------------------------
ax      =      axnew
ay      =      aynew
az      =      aznew

;--------------------------------------------------------------------
        outs   ax*kampenv,ay*kampenv
        endin

instr 2  ; Duffings System or cubic oscillator
         ; I can't seem to get this one to work
         ; dx = y
         ; dy = Ax^3-By+C cos(t) or dy=Ccos(t)-x^3-x-By

  ifqc = cpspch(p5)

  ax  init 0
  ay  init 0

  ka  init p6
  kb  init p7
  kc  init p8
  kh  init p9

  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0

  adx = ay
  acos1 oscil kc, ifqc, 1, .25
;  ay = ay + kh*(-ka*ax*ax*ax+kb*ay+acos1)
;  ay = ay + kh*(ka*ax*ax*ax-kb*ay+acos1)
  ay = ay + kh*(-ka*ax*ax*ax-ax-kb*ay+acos1)
  ax = ax + kh*adx

  outs kampenv*ax, kampenv*ay

endin


instr 3
; This simulates a planet orbiting in a multiple star system.

  kampenv linseg 0, .1, p4, p3-.2, p4, .1, 0

; Planet Position (X, Y, Z) & Velocity (VX, VY, VZ)
  kx  init 0
  ky  init .1
  kz  init 0
  kvx init .5
  kvy init .6
  kvz init -.1
  ih  init p5

; Star 1 Mass & X, Y, Z
  imass1 init p6
  is1x   init 0
  is1y   init 0
  is1z   init p8

; Star 2 Mass & X, Y, Z
  imass2 init p7
  is2x   init 0
  is2y   init 0
  is2z   init -p8

; Calculate distance to Star 1
  kdx=is1x-kx
  kdy=is1y-ky
  kdz=is1z-kz
  ksqradius=kdx*kdx+kdy*kdy+kdz*kdz+1
  kradius=sqrt(ksqradius)

; Determine acceleration due to Star 1 (AX, AY, AZ)
  kax=imass1/ksqradius*kdx/kradius
  kay=imass1/ksqradius*kdy/kradius
  kaz=imass1/ksqradius*kdz/kradius

; Calculate distance to Star 2
  kdx=is2x-kx
  kdy=is2y-ky
  kdz=is2z-kz
  ksqradius=kdx*kdx+kdy*kdy+kdz*kdz+1
  kradius=sqrt(ksqradius)

; Determine acceleration due to Star 2 (AX, AY, AZ)
  kax=kax+imass2/ksqradius*kdx/kradius
  kay=kay+imass2/ksqradius*kdy/kradius
  kaz=kaz+imass2/ksqradius*kdz/kradius

; Update the velocity
  kvx=kvx+ih*kax
  kvy=kvy+ih*kay
  kvz=kvz+ih*kaz

; Update the position
  kx=kx+ih*kvx
  ky=ky+ih*kvy
  kz=kz+ih*kvz

  aoutx = kx*kampenv
  aouty = ky*kampenv
  outs aoutx, aouty

endin


instr 4 ; Rossler's Attractor

  ax init 0
  ay init 0
  az init 0
  ih init p5

  aa init .375
  ib init p6
  ic init p7

; Amplitude envelope
  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0

  aa oscil 1/7, .5, 1
  aa = .3 + aa

  axnew = ax + ih*(-ay - az)
  aynew = ay + ih*(ax + aa*ay)
  aznew = az + ih*(ib + ax*az - ic*az)

  ax = axnew
  ay = aynew
  az = aznew

  outs kampenv*ax, kampenv*ay

endin

instr 5 ; K A Oscillator

  ifqc init cpspch(p5)
  ax init p6
  ib init p7

; Amplitude envelope
  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0

start:
  timout 0,1/ifqc,continue
  axold = ax
  ax = ax * ib*(1 - ax)
  reinit start

continue:
  aout tone ax,ifqc*4
  outs kampenv*(aout-.5), kampenv*(aout-.5)

endin

instr 6  ; Feather Fractal

  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0

  ih init p5
  ia init -.48
  ic init 2-2*ia
  ib init .93
  ax init 3
  ay init 0
  aw init ia*3+ic*9/10

  az = ax
  ax = ib*ay+aw
  au = ax*ax
  aw = ia*ax+ic*au/(1+au)
  ay = aw-az

  outs ax*kampenv, ay*kampenv

endin

;***************************************************************
instr 7 ; Simple chaos

  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0
  ax init .5
  ay init .6
  az init .3
  ah init cpspch(p5)/5500

  klfsinth oscil 1,1,1
  klfsinph oscil 1,.5,1
  klfcosth oscil 1,1,1,.25
  klfcosph oscil 1,4,1,.25

  adx=ay
  ady=-ax+ay*az
  adz=1-ay*ay

  ax=ax+ah*adx
  ay=ay+ah*ady
  az=az+ah*adz

  aox=-ax*klfsinth+ay*klfcosth
  aoy=-ax*klfsinth*klfcosph-ay*klfsinth*klfcosph+az*klfsinph

  outs aox*kampenv, aoy*kampenv
endin

instr 8 ; Simple chaos 2

  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0
  ax init .5
  ay init .3
  az init .6
  ah init cpspch(p5)/6550

  klfsinth oscil 1,1,1
  klfsinph oscil 1,.5,1
  klfcosth oscil 1,1,1,.25
  klfcosph oscil 1,.5,1,.25

  adx=ay*az
  ady=ax*ax-ay
  adz=1-4*ax

  ax=ax+ah*adx
  ay=ay+ah*ady
  az=az+ah*adz

  aox=-ax*klfsinth+ay*klfcosth
  aoy=-ax*klfsinth*klfcosph-ay*klfsinth*klfcosph+az*klfsinph

  outs aox*kampenv, aoy*kampenv
endin


instr 9 ; Simple chaos 3

  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0
  ax init .5
  ay init .3
  az init .6
  ah init cpspch(p5)/6550
  kloops init p6

  klfsinth oscil 1,1,1
  klfsinph oscil 1,.5,1
  klfcosth oscil 1,1,1,.25
  klfcosph oscil 1,.5,1,.25

kcount = 0
loop:

  adx=ay+az
  ady=-ax+.5*ay
  adz=ax*ax-az

  ax=ax+ah*adx
  ay=ay+ah*ady
  az=az+ah*adz

kcount = kcount + 1
if (kcount<kloops) goto loop

  aox=-ax*klfsinth+ay*klfcosth
  aoy=-ax*klfsinth*klfcosph-ay*klfsinth*klfcosph+az*klfsinph

  outs aox*kampenv, aoy*kampenv
endin

instr 10 ; Simple chaos 4. These are all from Sprott's Fractal Gallery Simple Chaotic Flow GIF Animations

  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0
  ax init .5
  ay init .3
  az init .6
  ah init cpspch(p5)/6550
  kloops init p6

  klfsinth oscil 1,1,1
  klfsinph oscil 1,.5,1
  klfcosth oscil 1,1,1,.25
  klfcosph oscil 1,.5,1,.25

kcount = 0
loop:

  adx=.4*ax+az
  ady=ax*az-ay
  adz=-ax+ay

  ax=ax+ah*adx
  ay=ay+ah*ady
  az=az+ah*adz

kcount = kcount + 1
if (kcount<kloops) goto loop

  aox=-ax*klfsinth+ay*klfcosth
  aoy=-ax*klfsinth*klfcosph-ay*klfsinth*klfcosph+az*klfsinph

  outs aox*kampenv, aoy*kampenv
endin

instr 11 ; Simple chaos 5. These are all from Sprott's Fractal Gallery Simple Chaotic Flow GIF Animations

  kampenv linseg 0, .01, p4, p3-.02, p4, .01, 0
  ax init .5
  ay init .3
  az init .6
  ah init cpspch(p5)/6550
  kloops init p6

  klfsinth oscil 1,1,1
  klfsinph oscil 1,.5,1
  klfcosth oscil 1,1,1,.25
  klfcosph oscil 1,.5,1,.25

kcount = 0
loop:

  adx=-ay+az*az
  ady=ax+.5*ay
  adz=ax-az

  ax=ax+ah*adx
  ay=ay+ah*ady
  az=az+ah*adz

kcount = kcount + 1
if (kcount<kloops) goto loop

  aox=-ax*klfsinth+ay*klfcosth
  aoy=-ax*klfsinth*klfcosph-ay*klfsinth*klfcosph+az*klfsinph

  outs aox*kampenv, aoy*kampenv
endin

</CsInstruments>

<CsScore>
;************************************************************
; An assortment of chaotic, fractal and related instruments
; Coded by Hans Mikelson  March 9, 1997
;************************************************************
; 1. The Lorenz Attractor
; 2. Duffings System or Cubic Oscillator
; 3. Planet Orbiting in a Binary Star System
; 4. The Rossler Attractor
; 5. K A Oscillator
; 6. Feather Fractals
; 7. Simple Chaos 1
; 8. Simple Chaos 2



f1 0 8192 10 1

t 0 400

;  Start  Dur Amp  X   Y   Z    S    R   B      h
;i1  0     8   600  .6  .6  .6  10   28  2.667  .01
;i1  +     .   600  .6  .6  .6  22   28  2.667  .01
;i1  .     .   600  .6  .6  .6  32   28  2.667  .01

; Planetary orbit in a binary star system
;  Start  Dur  Amp    Freq Mass1 Mass2 Separation
;i3  0      8   6000    .5   .4    .34     1.1
;i3  +      .   5000    .4   .5    .6      2    
;i3  .      .   6000    .3   .5    .5      1

; Rossler Attractor
;  Start  Dur  Amp   Freq  B  C
;i4  0     4   3000   .1   2  4
;i4  +      .   4000   .1   3  4
;i4  .      .   8000   .04  4  4

; K A Oscillator
;  Start  Dur  Amp   Freq    X    B
;i5  0      8  30000  7.00   .5   3.5
;i5  +      8  30000  8.00   .4   3.6
;i5  .      8  30000  7.05   .3   3.7

; Feather Fractal
;i6 0  8  1000  .1

; Duffings System or Cubic Oscillator
;   Start  Dur  Amp   Freq  A     B    C   h
;i2   0      1  100  6.00  1    .2   40  .01
;i2   +      1  100  5.08  1    .2    .  .01
;i2   .      1  100  5.04  1    .2    .  .01
;i2   .      1  100  5.00  1    .2    .  .01
;i2   .      1  100  4.08  1    .2    .  .01

; Simple Attractor
;  Start  Dur  Amp   Freq
;i7  0     16   6000  8.00
;i7  +      2   .     8.02
;i7  .      .   .     8.04
;i7  .      .   .     8.05
;i7  .      .   .     8.07
;i7  .      .   .     8.09
;i7  .      .   .     8.11
;i7  .     12   .     9.00

; Simple Attractor
;  Start  Dur  Amp   Freq
;i8  0     8   4000  8.00
;i8  +      2   .     7.00
;i8  .      .   .     7.07
;i8  .      .   .     7.07
;i8  .      .   .     7.09
;i8  .      .   .     7.09
;i8  .      4   .     7.07
;i8  .      2   .     7.05
;i8  .      2   .     7.05
;i8  .      2   .     7.04
;i8  .      2   .     7.04
;i8  .      2   .     7.02
;i8  .      2   .     7.02
;i8  .      4   .     7.00

; Simple Attractor
;  Start  Dur  Amp   Freq  Loops
;i9  0     4   3000   6.05  20
;i9  +     2   .      5.00  .
;i9  .     .   .      5.07  .

; Simple Attractor
;   Start  Dur  Amp   Freq  Loops
;i10  0     4   3000   6.05  4
;i10  +     2   .      7.00  .
;i10  .     .   .      7.07  .

; Simple Attractor
;   Start  Dur  Amp   Freq  Loops
;i11  0     4   3000   6.05  20
;i11  +     2   .      5.00  .
;i11  .     .   .      5.07  .
</CsScore>
</CsoundSynthesizer>
