"""
STEP 2 - Train the model.

Run:  python train_model.py
Needs: dataset.csv (from generate_dataset.py) and test_handwritten.csv
Output: service_model.json   <- this file goes into your VS Code project
        report.txt           <- accuracy numbers for your project report
        confusion_matrix.png <- picture for your project report (if matplotlib is installed)
        selftest.json        <- used to prove the TypeScript copy gives identical answers

The model: TF-IDF (turns text into numbers: words, word pairs and 3-5 letter
chunks so typos still work) + Logistic Regression (learns which numbers point to
which service). Trained from scratch on OUR data - no pretrained weights.
"""
import json, os
import numpy as np, pandas as pd
from scipy.sparse import hstack
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from sklearn.model_selection import train_test_split

data = pd.read_csv("dataset.csv")
exam = pd.read_csv("test_handwritten.csv")
labels = sorted(data.label.unique())
print(f"{len(data)} training rows, {len(labels)} classes, {len(exam)} hand-written exam sentences")

def make_vectorizers():
    word = TfidfVectorizer(analyzer="word", ngram_range=(1, 2), lowercase=True,
                           sublinear_tf=True, min_df=2, max_features=6000)
    char = TfidfVectorizer(analyzer="char_wb", ngram_range=(3, 5), lowercase=True,
                           sublinear_tf=True, min_df=3, max_features=12000)
    return word, char

def fit(texts, y):
    word, char = make_vectorizers()
    X = hstack([word.fit_transform(texts), char.fit_transform(texts)]).tocsr()
    clf = LogisticRegression(C=10, max_iter=2000)
    clf.fit(X, y)
    return word, char, clf

def predict(word, char, clf, texts):
    X = hstack([word.transform(texts), char.transform(texts)]).tocsr()
    return clf.predict(X), clf.predict_proba(X)

report = []
# --- Test 1: random 15% of our own generated data (easy; numbers will be very high)
tr, te = train_test_split(data, test_size=0.15, random_state=1, stratify=data.label)
w, c, m = fit(tr.text, tr.label)
p, _ = predict(w, c, m, te.text)
report.append(f"TEST 1 - held-out part of generated data: accuracy {accuracy_score(te.label, p):.3f}  (optimistic: same style as training)")

# --- Test 2: hand-written exam (the honest number)
p, _ = predict(w, c, m, exam.text)
acc = accuracy_score(exam.label, p)
report.append(f"TEST 2 - hand-written exam ({len(exam)} sentences): accuracy {acc:.3f}  <- the honest number")
report.append("\nPer-class results on the hand-written exam:\n" + classification_report(exam.label, p, labels=labels, zero_division=0))
wrong = exam[p != exam.label].copy(); wrong["predicted"] = p[p != exam.label]
report.append("Mistakes:\n" + (wrong.to_string(index=False) if len(wrong) else "none"))

try:
    import matplotlib; matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    cm = confusion_matrix(exam.label, p, labels=labels)
    fig, ax = plt.subplots(figsize=(9, 8)); ax.imshow(cm, cmap="Blues")
    ax.set_xticks(range(len(labels))); ax.set_yticks(range(len(labels)))
    ax.set_xticklabels(labels, rotation=90); ax.set_yticklabels(labels)
    for i in range(len(labels)):
        for j in range(len(labels)):
            if cm[i, j]: ax.text(j, i, cm[i, j], ha="center", va="center")
    ax.set_xlabel("Predicted"); ax.set_ylabel("Actual"); ax.set_title("Confusion matrix (hand-written exam)")
    plt.tight_layout(); plt.savefig("confusion_matrix.png", dpi=130)
except Exception as e:
    print("Skipping confusion matrix picture:", e)

# --- Final model: train on everything in dataset.csv, export for the website
word, char, clf = fit(data.text, data.label)
assert list(clf.classes_) == labels
D = 3
def export(vec):
    out = {}
    for term, idx in vec.vocabulary_.items():
        out[term] = [round(float(vec.idf_[idx]), D)]
    return out
W, C = export(word), export(char)
nw = len(word.vocabulary_)
coef = clf.coef_  # (classes, features)
for term, idx in word.vocabulary_.items():
    W[term] += [round(float(v), D) for v in coef[:, idx]]
for term, idx in char.vocabulary_.items():
    C[term] += [round(float(v), D) for v in coef[:, nw + idx]]
model = {"labels": labels, "intercept": [round(float(v), D) for v in clf.intercept_],
         "word": W, "char": C, "note": "Trained from scratch: TF-IDF + logistic regression"}
with open("service_model.json", "w") as f:
    json.dump(model, f, separators=(",", ":"))

# --- self-test file: lets us prove TypeScript == Python
tests = list(exam.text[:25]) + ["fix my geyser in Pretoria urgently", "braai catering for 40 people", "asdf qwer"]
_, probs = predict(word, char, clf, tests)
json.dump([{"text": t, "probs": [round(float(x), 5) for x in pr]} for t, pr in zip(tests, probs)], open("selftest.json", "w"))

import os
report.append(f"\nModel file service_model.json: {os.path.getsize('service_model.json')/1024:.0f} KB, "
              f"{len(W)} word features + {len(C)} character features, {len(labels)} classes")
open("report.txt", "w").write("\n".join(report))
print("\n".join(report))

# --- TypeScript copy of the model (this is the file the website imports)
target = "../src/server/serviceModel.ts" if os.path.isdir("../src/server") else "serviceModel.ts"
with open(target, "w", encoding="utf-8") as f:
    f.write("// AUTO-GENERATED by train_model.py - do not edit by hand. Re-run training to change it.\n")
    f.write("export const MODEL_JSON: string = " + json.dumps(open("service_model.json").read()) + ";\n")
print("Wrote", target)
