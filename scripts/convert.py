input_file = "dataset/agudo/agudo_0.txt"
output_file = "agudo_0.mif"

with open(input_file, "r") as f:
    samples = [int(line.strip()) for line in f if line.strip()]

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