import os

files = [
    "dataset/grave/grave_0.txt",
    "dataset/grave/grave_1.txt",
    "dataset/grave/grave_2.txt",
    "dataset/agudo/agudo_0.txt",
    "dataset/agudo/agudo_1.txt",
    "dataset/agudo/agudo_2.txt"
]

output_file = "samples.mif"

samples = []

for file in files:
    with open(file, "r") as f:
        samples.extend(
            int(line.strip())
            for line in f
            if line.strip()
        )

with open(output_file, "w") as f:

    f.write("WIDTH=8;\n")
    f.write(f"DEPTH={len(samples)};\n\n")

    f.write("ADDRESS_RADIX=UNS;\n")
    f.write("DATA_RADIX=DEC;\n\n")

    f.write("CONTENT BEGIN\n\n")

    for addr, value in enumerate(samples):
        f.write(f"{addr} : {value};\n")

    f.write("\nEND;\n")

print(f"Arquivo gerado: {output_file}")
print(f"Total de amostras: {len(samples)}")