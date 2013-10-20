import sys
import serial
import struct
import time
import math
import operator
import pickle

def average(data):
    return sum(data) / float(len(data))

def quantize(val):
    val = val - 512
    if val == 0:
        return 0
    gstep = 1024 / 6.0
    g = int(val / gstep)
    posneg = [-1, 1][val > 0]
    if abs(g) == 0:
        return (abs(int(val / gstep * 9)) + 1) * posneg
    if abs(g) == 1:
        return (abs(int(val / (gstep * 2) * 4) + 11) * posneg)
    return 16 * posneg

class DynamicTimeWarp(object):
    def __init__(self, seq1, seq2):
        self.seq1 = seq1
        self.seq2 = seq2
        self.table = []
        for s1 in range(len(seq1)):
            row = [0] * len(seq2)
            self.table.append(row)
        for s1 in range(len(seq1)):
            self.set(s1, 0, 1000000)
        for s2 in range(len(seq2)):
            self.set(0, s2, 1000000)
        self.set(0, 0, 0)

    def metric(self, pt1, pt2):
        return math.sqrt(sum([(pt1[idx] - pt2[idx]) ** 2 for idx in range(3)]))

    def get(self, s1, s2):
        return self.table[s1][s2]

    def set(self, s1, s2, val):
        self.table[s1][s2] = val

    def __call__(self):
        for s1 in range(1, len(self.seq1)):
            for s2 in range(1, len(self.seq2)):
                cost = self.metric(self.seq1[s1], self.seq2[s2])
                vals = [self.get(s1 - 1, s2), self.get(s1, s2 - 1), self.get(s1 - 1, s2 - 1)]
                self.set(s1, s2, cost + min(vals))
        #print self.table
        return self.get(s1, s2)

class MovingAverage(list):
    def get_points(self, window, step):
        steps = (len(self) - window) / step
        res = []
        _pts = [self[widx * step:widx * step + window] for widx in range(steps)]
        #return [quantize(average(data)) for data in _pts]
        return [average(data) for data in _pts]

    def append(self, val):
        super(MovingAverage, self).append(val)
        if len(self) > 1000:
            del self[0]

class GestureSystem(object):
    def __init__(self, port):
        self.port = port
        self.templates = {}
        self.data = [MovingAverage(), MovingAverage(), MovingAverage()]
        self.window = 2
        self.step = 1

    def get_next_frame(self):
        data = struct.pack("I", 1)
        self.port.write(data)
        datum = self.port.read(6)
        vals = struct.unpack("hhh", datum)
        for (idx, val) in enumerate(vals):
            self.data[idx].append(val)

    def get_path(self, length):
        path = []
        for x in range(3):
            pts = self.data[x].get_points(self.window, self.step)
            path.append(pts)
        return path

    def record(self, count):
        self.data = [MovingAverage(), MovingAverage(), MovingAverage()]
        for x in range(count):
            self.get_next_frame()
        path = self.get_path(self.get_path(self.data[0]))
        return zip(*path)

    def interact(self):
        command = raw_input("> ")
        parts = command.split(' ')
        cmd = parts[0]
        if cmd in ('record', 'rec'):
            try:
                frames = int(parts[1])
            except:
                print "You need to provide a frame count!"
                return
            for delay in range(3):
                print 3 - delay, "..."
                time.sleep(1)
            print "Go!"
            self.path = self.record(frames)
            print "Done!"
        elif cmd in ('set', 'store'):
            try:
                name = parts[1]
                assert name
            except:
                print "You need to provide a name!"
                return
            self.templates[name] = self.path
        elif cmd == 'call':
            scores = []
            for name in self.templates:
                dtw = DynamicTimeWarp(self.templates[name], self.path)
                score = dtw()
                scores.append((score, name))
                msg = "%s: %f" % (name, score)
                print msg
            scores.sort(key=operator.itemgetter(0))
            print "Gesture: ", scores[0][-1]
        elif cmd == 'clear':
            self.templates = {}
        elif cmd in ('show', "print", "p"):
            print "step: ", self.step
            print "window: ", self.window
            for name in self.templates:
                print name, self.templates[name]
        elif cmd == 'step':
            self.step = int(parts[1])
        elif cmd in ('win', "window"):
            self.window = int(parts[1])
        elif cmd == 'save':
            try:
                fn = cmd[1]
            except:
                print "I name a filename, yo."
                return
            f = open(fn, 'w')
            pickle.dump(f, self.templates)
        elif cmd == 'load':
            try:
                fn = cmd[1]
            except:
                print "I name a filename, yo."
                return
            f = open(fn)
            self.template = pickle.load(f)
        else:
            print "huh?", cmd

    def loop(self):
        while 1:
            try:
                self.interact()
            except KeyboardInterrupt:
                return
            except EOFError:
                return
            except:
                import traceback
                traceback.print_exc()

try:
    dev = sys.argv[1]
except:
    dev = "/dev/tty.usbmodem411"
mcu = serial.Serial(dev, 115200)
gs = GestureSystem(mcu)
gs.loop()
