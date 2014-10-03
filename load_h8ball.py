#!/usr/bin/env python

import sys
import serial
import time
import struct

def get_ok(chk=''):
    thing = ball.read(1)
    while ball.inWaiting():
        thing += ball.read(1)
    print len(thing), thing
    assert thing.endswith("OK"), thing

def send(line):
    for ch in line:
        ball.write(ch)
        _ch = ball.read(1)
        assert ch == _ch

port = "/dev/tty.usbmodem621"
ball = serial.Serial(port)
ball.write('R')
get_ok()

fn = sys.argv[1]
f = open(fn)
idx = 0
for line in f:
    if len(line) > 64:
        continue
    content = line.strip()
    print content
    line = 'L' + struct.pack("I", len(content)) + content
    ball.write(line)
    get_ok(content)
    idx += 1
print "Loaded", idx, "phrases"
