# csound_code_gen
generates simple snippets

## define score

`my_score = Genner(speed, starting_octave)'

## adding notes

`my_score.add_melody(list of note_definition)`

note definition is a combination of the note_symbol and note_length

note_symbol is one of c, d, e, f, g, a, b, C, D, E, F, G, A, B where lowercase letter represents the nearer note to the last note and uppercase the other

note_length is a divisor of time_unit if less than 100

if note_length is larger than 100 note_length // 100 is a multiplier

note_length defaults to 1

## adding notes (example)
`my_score = Genner(120, 8)`
`my_score.add_melody(['c2','d2','e2','f2', 'g2', 'a2', 'b2', 'c2'])`
the last 'C' is an octave higher than the first 'C' with the length of .25 second (since speed is 120 time unit is .5 sec)

wherein
`my_score.add_melody(['c2','d2','e2','f2', 'g2', 'a2', 'b2', 'C200'])`
the last 'C' is the same as the first 'C' with the length of 1 second