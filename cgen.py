notes = [{'c':0,'c#':1,'d_':1, 'd':2, 'd#':3, 'e_':3,
    'e':4,'f':5, 'f#':6,'g_':6, 'g':7, 'g#':8,'a_':8,
    'a':9, 'a#':10, 'b_':10, 'b':11},
        {'C':0,'C#':1,'D_':1, 'D':2, 'D#':3, 'E_':3,
    'E':4,'F':5, 'F#':6,'G_':6, 'G':7, 'G#':8,'A_':8,
    'A':9, 'A#':10, 'B_':10, 'B':11}]

class Genner:
    def __init__(self, speed, octave):
        self.score = []
        self.time_unit = 60 / speed
        self.octave = octave
    
    def add_melody(self, melody, append=True):
        if len(self.score) == 0 or append:
            self.score.append(melody)
        else:
            pass
    
    def get_cs(self):
        for this_melody in self.score:
            start_time = 0.0
            for this_note in this_melody:
                note_num = notes[0][this_note]
                o = self.octave
                cs_string, start_time = self.get_cs_line(o, note_num, time=start_time)
                print(cs_string)

    
    def get_cs_line(self, octave, note_num, time=0.0):
        return "i "+ str(octave) + format(note_num, '02d') + ' ' + str(time) + ' ' + str(self.time_unit) + ' .7', time + self.time_unit

if __name__ == "__main__":
    my_score = Genner(120, 8)
    my_score.add_melody(['g','g','a','a','g','g','e'])
    my_score.get_cs()