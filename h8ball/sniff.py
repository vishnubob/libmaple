import sys
import serial
import struct
import time
port = "/dev/tty.usbmodem411"
mcu = serial.Serial(port, 115200)

cps = 1127
count = cps * 5
data = struct.pack("I", count)
mcu.write(data)

data = []
ts = time.time()
for x in range(count):
    datum = mcu.read(6)
    val = struct.unpack("hhh", datum)
    data.append(val)
print time.time() - ts

fn = "accel.txt"
f = open(fn, 'w')
f.write(str.join('\n', [str.join(',', map(str, row)) for row in data]))
