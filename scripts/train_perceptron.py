import pandas as pd
import numpy as np

df = pd.read_csv("dataset/features.csv")
X = np.zeros((len(df), 2), dtype=int)
X[:, 0] = df["energy"].values >> 14
X[:, 1] = df["zcr"].values
y = (df["class"].values == "agudo").astype(int)

w = np.zeros(2, dtype=int)
b = 0
epochs = 1000

for epoch in range(epochs):
    errors = 0
    for i in range(len(y)):
        activation = w[0] * X[i, 0] + w[1] * X[i, 1] + b
        prediction = 1 if activation > 0 else 0
        if prediction != y[i]:
            error = y[i] - prediction
            w[0] += error * X[i, 0]
            w[1] += error * X[i, 1]
            b += error
            errors += 1
    if errors == 0:
        break

print(f"w1 = {w[0]}")
print(f"w2 = {w[1]}")
print(f"bias = {b}")
