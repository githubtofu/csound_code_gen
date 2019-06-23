# csound_code_gen
generates simple snippets

## define score

`my_score = Genner(speed, starting_octave)`

## adding notes

`my_score.add_melody(list of note_definition)`

note definition is a combination of the note_symbol and note_length

note_symbol is one of c, c#, d_, d, d#, e_, e, f, f#, g_, g, g#, a_, a, a#, b_, b, C, C#, D_, D, D#, E_, E, F, F#, G_, G, G#, A_, A, A#, B_, B where lowercase letter represents the nearer note to the last note and uppercase the other

note_length is a divisor of time_unit if less than 100

if note_length is larger than 100 note_length // 100 is a multiplier

note_length defaults to 1

## adding notes (example)
`my_score = Genner(120, 8)`

`my_score.add_melody(['c','d','e','f', 'g', 'a', 'b', 'c2'])`

the last 'C' is an octave higher than the first 'C' with the length of .25 second (since speed is 120 time unit is .5 sec)

whereas in

`my_score.add_melody(['c2','d2','e2','f2', 'g2', 'a2', 'b2', 'C200'])`

the last 'C' is the same as the first 'C' with the length of 1 second

## adding stroke (example)
`my_score.add_stroke(0, type='minor', dur=400, step_div=8)`

minor C chord with duration of 4 * time_unit; gap between each note is 1/8 of time_unit