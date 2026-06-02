import os
import math
import random

os.makedirs("dataset/grave", exist_ok=True)
os.makedirs("dataset/agudo", exist_ok=True)

for i in range(50):
    f = random.uniform(1.0, 4.0)
    a = random.randint(40, 120)
    phase = random.uniform(0, 2 * math.pi)
    samples = []
    for t in range(128):
        val = int(a * math.sin(2 * math.pi * f * t / 128 + phase) + random.randint(-5, 5))
        val = max(-128, min(127, val))
        samples.append(str(val))
    with open(f"dataset/grave/grave_{i}.txt", "w") as f_out:
        f_out.write("\n".join(samples) + "\n")

for i in range(50):
    f = random.uniform(15.0, 30.0)
    a = random.randint(40, 120)
    phase = random.uniform(0, 2 * math.pi)
    samples = []
    for t in range(128):
        val = int(a * math.sin(2 * math.pi * f * t / 128 + phase) + random.randint(-5, 5))
        val = max(-128, min(127, val))
        samples.append(str(val))
    with open(f"dataset/agudo/agudo_{i}.txt", "w") as f_out:
        f_out.write("\n".join(samples) + "\n")
