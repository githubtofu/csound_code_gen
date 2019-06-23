<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 10
nchnls = 1
0dbfs = 1

instr  	101
a1   	oscil   .7, 311, 1
       	out      a1
		endin

	instr  	102
a1   	oscil   .7, 311, 2
       	out      a1
		endin
		
		instr  	103
a1   	oscil   .7, 311, 3
       	out      a1
		endin
		;ares foscil xamp, kcps, xcar, xmod, kndx, ifn
			instr   110
a1   	foscil 	.7, 2, 200, 1, 1, 2 ; simple 2 operator fm opcode
		out     a1
		endin
;xamp -- the amplitude of the output signal.
;kcps -- a common denominator, in cycles per second, for the carrier and modulating frequencies.
;xcar -- a factor that, when multiplied by the kcps parameter, gives the carrier frequency.
;xmod -- a factor that, when multiplied by the kcps parameter, gives the modulating frequency.
;kndx -- the modulation index. 

		instr   130
a1   	buzz   	.7, 440, 17, 2, .25  ; variable pulse train
        out     a1
		endin
		
				instr   140			
a1 		pluck 	.7, 440, 440, 2, 4, .9, 2   ;karplus-strong plucked string
		out 	a1
		endin
		
				instr 	150
a1 		grain 	.7, 440, 14, .7, 10, .2, 1, 3, 1  ; asynchronous granular synthesis
		out 	a1
		endin
		
				instr 	160
a1 		loscil  .7, 1, 4, 1, 2  ; sample-based looping oscillator
		out 	a1
		endin
		
		
		
		instr 807
		iampp = p4
		a1 loscil iampp, 1, 807, 1, 0
		   out a1
		endin
		
				instr 809
				iampp = p4
		a1 loscil iampp, 1, 809, 1, 0
		   out a1
		endin
		
				instr 804
				iampp = p4
		a1 loscil iampp, 1, 804, 1, 0
		   out a1
		endin
		
				instr 800
				iampp = p4
		a1 loscil iampp, 1, 800, 1, 0
		   out a1
		   endin
		
		instr 900
		iampp = p4
		a1 loscil iampp, 1, 900, 1, 0
		   out a1
		endin

</CsInstruments>
<CsScore>
;Function 1 uses the GEN10 subroutine to compute a sine wave
f 704 0 0 1 "704.wav" 0 4 0
f 705 0 0 1 "705.wav" 0 4 0
f 706 0 0 1 "706.wav" 0 4 0
f 707 0 0 1 "707.wav" 0 4 0
f 708 0 0 1 "708.wav" 0 4 0
f 709 0 0 1 "709.wav" 0 4 0
f 710 0 0 1 "710.wav" 0 4 0
f 711 0 0 1 "711.wav" 0 4 0
f 800 0 0 1 "800.wav" 0 4 0
f 801 0 0 1 "801.wav" 0 4 0
f 802 0 0 1 "802.wav" 0 4 0
f 803 0 0 1 "803.wav" 0 4 0
f 804 0 0 1 "804.wav" 0 4 0
f 805 0 0 1 "805.wav" 0 4 0
f 806 0 0 1 "806.wav" 0 4 0
f 807 0 0 1 "807.wav" 0 4 0
f 808 0 0 1 "808.wav" 0 4 0
f 809 0 0 1 "809.wav" 0 4 0
f 810 0 0 1 "810.wav" 0 4 0
f 811 0 0 1 "811.wav" 0 4 0
f 900 0 0 1 "900.wav" 0 4 0
f 901 0 0 1 "901.wav" 0 4 0
f 902 0 0 1 "902.wav" 0 4 0
f 903 0 0 1 "903.wav" 0 4 0
f 904 0 0 1 "904.wav" 0 4 0
f 905 0 0 1 "905.wav" 0 4 0
f 906 0 0 1 "906.wav" 0 4 0
f 907 0 0 1 "907.wav" 0 4 0
f 908 0 0 1 "908.wav" 0 4 0
f 909 0 0 1 "909.wav" 0 4 0
f 910 0 0 1 "910.wav" 0 4 0
f 911 0 0 1 "911.wav" 0 4 0
f 1000 0 0 1 "a00.wav" 0 4 0
f 1001 0 0 1 "a01.wav" 0 4 0

; inst	start	duration
;i 101		0		1
;i 110 1.5 1
i 807 0 1 .2
i 807 + 1 .7
i 809 2 1 .5
i 809 3 1 .6
i 807 4 1 .5
i 807 5 1 .7
i 804 6 4 .6
i 800 10 .6 .4
i 804 10.1 .6 .3
i 807 10.2 .6 .3
i 900 10.3 .6 .2
i 900 10.5 4 .4
i 807 10.6 4 .3
i 804 10.7 4 .3
i 800 10.8 4 .3


</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
