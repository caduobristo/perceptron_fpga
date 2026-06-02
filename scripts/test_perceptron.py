import pandas as pd
import numpy as np

df = pd.read_csv("dataset/features.csv")
X = np.zeros((len(df), 2), dtype=int)
X[:, 0] = df["energy"].values >> 14
X[:, 1] = df["zcr"].values
y = (df["class"].values == "agudo").astype(int)

w1 = -63
w2 = 95
bias = -507

correct = 0
for i in range(len(y)):
    score = w1 * X[i, 0] + w2 * X[i, 1] + bias
    pred = 1 if score > 0 else 0
    if pred == y[i]:
        correct += 1

accuracy = (correct / len(y)) * 100
print(f"Total samples: {len(y)}")
print(f"Correct classifications: {correct}")
print(f"Accuracy: {accuracy:.2f}%")
