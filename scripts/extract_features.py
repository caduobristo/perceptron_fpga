import os

def calculate_energy(samples):
    return sum(x ** 2 for x in samples)

def calculate_zcr(samples):
    crossings = 0
    for i in range(1, len(samples)):
        if (samples[i] < 0) != (samples[i-1] < 0):
            crossings += 1
    return crossings

features = []

grave_dir = "dataset/grave"
for filename in sorted(os.listdir(grave_dir)):
    if filename.endswith(".txt"):
        path = os.path.join(grave_dir, filename)
        with open(path, "r") as f:
            samples = [int(line.strip()) for line in f if line.strip()]
        energy = calculate_energy(samples)
        zcr = calculate_zcr(samples)
        features.append(("grave", filename, energy, zcr))

agudo_dir = "dataset/agudo"
for filename in sorted(os.listdir(agudo_dir)):
    if filename.endswith(".txt"):
        path = os.path.join(agudo_dir, filename)
        with open(path, "r") as f:
            samples = [int(line.strip()) for line in f if line.strip()]
        energy = calculate_energy(samples)
        zcr = calculate_zcr(samples)
        features.append(("agudo", filename, energy, zcr))

with open("dataset/features.csv", "w") as f:
    f.write("class,filename,energy,zcr\n")
    for item in features:
        f.write(f"{item[0]},{item[1]},{item[2]},{item[3]}\n")

print("| Classe | Arquivo | Energia | ZCR |")
print("| --- | --- | --- | --- |")
for item in features:
    print(f"| {item[0]} | {item[1]} | {item[2]} | {item[3]} |")
