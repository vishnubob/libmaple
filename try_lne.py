import math
k = -0.08
shake_factor = 50
cnt = 0
decay = 1.0
while decay > 0.1:
    decay = shake_factor * math.e ** (cnt * k)
    print decay
    cnt += 1
