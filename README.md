# csound_code_gen
generates simple snippets

## define score

`my_score = Genner(speed, starting_octave)`

## adding notes

`my_score.add_melody(list of note_definition)`

note definition is a combination of the note_symbol and note_length

note_symbol is one of c, c#, d_, d, d#, e_, e, f, f#, g_, g, g#, a_, a, a#, b_, b, C, C#, D_, D, D#, E_, E, F, F#, G_, G, G#, A_, A, A#, B_, B where lowercase letter represents the nearer note to the last note and uppercase the farther note

note_length is whole * 100 + frac format where frac is 0~63. the note length corresponds to time_unit * (whole + frac / 64) seconds

note_length defaults to 100

## adding notes (example)
`my_score = Genner(120, 8)`

`my_score.add_melody(['c','d','e','f', 'g', 'a', 'b', 'c2'])`

the last 'C' is an octave higher than the first 'C' with the length of .25 second (since speed is 120 time unit is .5 sec)

whereas in

`my_score.add_melody(['c2','d2','e2','f2', 'g2', 'a2', 'b2', 'C200'])`

the last 'C' is the same as the first 'C' with the length of 1 second

## adding strokes (example)
`my_score.add_stroke(0, type='minor', dur=400, step_div=16)`

minor C chord with duration of 4 * time_unit; gap between each note is 1/4(= 16/64) of time_unit

## waiting for silence (example)

`my_score.wait_finish()`

wait for all notes to be played
