notes = [{'c':0,'c#':1,'d_':1, 'd':2, 'd#':3, 'e_':3,
    'e':4,'f':5, 'f#':6,'g_':6, 'g':7, 'g#':8,'a_':8,
    'a':9, 'a#':10, 'b_':10, 'b':11},
        {'C':0,'C#':1,'D_':1, 'D':2, 'D#':3, 'E_':3,
    'E':4,'F':5, 'F#':6,'G_':6, 'G':7, 'G#':8,'A_':8,
    'A':9, 'A#':10, 'B_':10, 'B':11}]

harmony_type = {'major':0, 'minor':1}

class Genner:
    def __init__(self, speed, octave):
        self.score = []
        self.time_unit = 60 / speed
        self.octave = octave
        self.octave_cur = octave
        self.cur_melody = -1
        self.default_divisor = 1
        self.inst = []
    
    def set_default_length(self, divisor):
        if divisor > 0 and divisor < 128:
            self.default_divisor = divisor
    
    def get_melody_from_string_list(self, mstr):
        last_note_num = -1
        melody = []
        for this_note_s in mstr:
            this_note = this_note_s[:1]
            this_len_div = int(this_note_s[1:]) if len(this_note_s) > 1 else self.default_divisor
            if this_len_div > 100:
                this_len_div = 1 / (this_len_div // 100)
            this_len = self.time_unit / (1 if this_len_div == 0 else this_len_div)
            near_note = True
            note_num = notes[0].get(this_note, -1)
            if note_num < 0:
                note_num = notes[1].get(this_note, -1)
                near_note = False
            if last_note_num > -1:
                if not note_num < last_note_num:
                    if note_num - last_note_num > 6:
                        self.octave_cur -= 1 if near_note else 0
                    else:
                        self.octave_cur -= 0 if near_note else 1
                else:
                    if last_note_num - note_num > 6:
                        self.octave_cur += 1 if near_note else 0
                    else:
                        self.octave_cur += 0 if near_note else 1
            melody.append({"note_num":note_num, "octave":self.octave_cur, "length": this_len})
        return melody
    
    def add_melody(self, melody_string_list, append=True):
        if len(self.score) == 0 or not append:
            self.score.append(self.get_melody_from_string_list(melody_string_list))
        else:
            self.score[self.cur_melody] += self.get_melody_from_string_list(melody_string_list)
    
    def add_stroke(self, start, type='major', dir='down', append=True):
        return
    
    def set_current_melody(self, mnum):
        if mnum < len(self.score):
            self.cur_melody = mnum
    
    def get_cs(self):
        with open("cs.txt", "a") as file:
            file.write("<CsScore>\n")
            for this_instr in self.inst:
                this_octave = str(this_instr // 100)
                this_note = str(this_instr)[-2:]
                if this_octave == '10':
                    this_octave = 'a'
                file.write("f "+str(this_instr // 100)+this_note+' 0 0 1 "'+this_octave+this_note+'.wav" 0 4 0\n')
            file.write('\n')
        for this_melody in self.score:
            start_time = 0.0
            for this_note in this_melody:
                cs_string, start_time = self.get_cs_line(this_note["octave"], this_note["note_num"], time=start_time, dur=this_note["length"])
                with open("cs.txt", "a") as file:
                    file.write(cs_string+'\n')
        with open("cs.txt", "a") as file:
            file.write("</CsScore>\n")
            file.write("</CsoundSynthesizer>")

    
    def get_cs_line(self, octave, note_num, time=0.0, dur=-1):
        if dur < 0:
            dur = self.default_length * self.time_unit
        return "i "+ str(octave) + format(note_num, '02d') + ' ' + str(time) + ' ' + str(dur * 1.1) + ' .7', time + dur
    
    def get_heading_lines(self, nch=1):
        with open("cs.txt", "w") as file: # Use file to refer to the file object
            file.write("<CsoundSynthesizer>\n")
            file.write("<CsOptions>\n")
            file.write("-odac -d\n")
            file.write("</CsOptions>\n")
            file.write("<CsInstruments>\n\n")
            file.write("sr = 44100\n")
            file.write("ksmps = 10\n")
            file.write("nchnls = "+str(nch)+'\n')
            file.write("0dbfs = 1\n\n")

    def get_instr(self, initial_instr, final_instr, rel=0.1):
        this_instr = initial_instr
        with open("cs.txt", "a") as file:
            while True:
                file.write('instr ' + str(this_instr) + '\n')
                file.write('iampp = p4\n')
                file.write('idur = p3\n')
                file.write('k1 linen p4, 0, idur - '+str(rel)+ ',' + str(rel)+'\n')
                file.write('a1 loscil iampp, 1, ' + str(this_instr) + ', 1, 0\n')
                file.write('\tout a1 * k1\n')
                file.write('endin\n\n')
                self.inst.append(this_instr)
                this_instr += 1
                if this_instr % 100 > 11:
                    this_instr = (this_instr // 100 + 1) * 100
                if this_instr > final_instr:
                    break
            file.write("</CsInstruments>\n\n")

if __name__ == "__main__":
    my_score = Genner(120, 8)
    my_score.get_heading_lines()
    my_score.get_instr(704, 1001, rel=.1)
    my_score.add_melody(['g200','g200','a','a','b','C','d'])
    my_score.set_default_length(.1)
    my_score.add_melody(['c'])
    my_score.get_cs()