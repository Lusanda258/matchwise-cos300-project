# MatchWise – our own trained matching model

## What we built
| Piece | File | What it does |
|---|---|---|
| Data builder | `generate_dataset.py` | Creates `dataset.csv` (~6,000 labelled sentences) from our own building blocks + `my_examples.csv` |
| Trainer | `train_model.py` | Trains the model from scratch, writes accuracy report, exports the model |
| The model | `serviceModel.ts` (auto-made) | The trained weights, imported by the website |
| Engine | `matchModel.ts` | Classifies a request and ranks providers (category fit, text similarity, location, rating) |
| Wiring | `src/server/match.functions.ts` | Server function that calls our engine |
| Exam | `test_handwritten.csv` | Sentences the model never trains on – used to measure real accuracy |

**Model type:** TF-IDF + Logistic Regression (classical machine learning), trained from scratch on our data.
No pretrained weights, no external API, no API key, runs inside the Cloudflare Worker.
16 classes: 15 services + "other" (so off-topic requests give "no match", REQ-18).

---
## PART A – Train it (do this once, ~10 minutes)

### Option 1: on your own PC (Windows)
1. Install Python from python.org (tick **"Add Python to PATH"**).
2. Open the `ml` folder in VS Code → **Terminal → New Terminal**.
3. Install the libraries (once):
   `py -m pip install scikit-learn pandas scipy matplotlib`
4. Build the data: `py generate_dataset.py`
5. Train: `py train_model.py`
6. Read `report.txt` and look at `confusion_matrix.png` (both go in your project report).

### Option 2: Google Colab (no installs)
1. Go to colab.research.google.com → New notebook.
2. Click the folder icon on the left → upload `generate_dataset.py`, `train_model.py`, `test_handwritten.csv`, `my_examples.csv`.
3. In a cell run: `!python generate_dataset.py` then in the next cell `!python train_model.py`
4. Download `serviceModel.ts`, `report.txt` and `confusion_matrix.png` from the folder panel.

---
## PART B – Already done in this project
`train_model.py` writes the model straight into `src/server/serviceModel.ts`, and `src/server/match.functions.ts` already calls the engine.
To test: `npm run dev`, log in as a client, submit *"my geyser is leaking in Pretoria"* → plumbing providers with reasons such as "100% fit for Plumbing, rated 4.8/5…". An off-topic request ("what is the weather today") returns "no match".
After retraining, just run `npm run dev` again (or `npm run build` + `npx wrangler deploy`).

How providers are read: the model reads each provider's **category + business name + bio**, so free-text categories like "Pipe fitting" still work. A good bio helps. Location matches when the provider's location (e.g. "Pretoria") appears in the client's location box or in the request text.

---
## PART C – Make it better and prove it (important for marks)
1. **Add our own data.** Each member writes 20+ real sentences per category into `my_examples.csv` (format: `text,label`; labels: plumbing, electrical, cleaning, gardening, painting, carpentry, tutoring, moving, appliance_repair, car_mechanic, hair_beauty, it_support, photography, security, catering, other). Ask friends/family too. Re-run Part A steps 4–5 (the website picks up the new model automatically).
2. **Write a fresh exam.** The current `test_handwritten.csv` was used while we fixed weaknesses, so its score (≈95%) is slightly optimistic. Each member should write 5 NEW sentences per category into a separate file *before* looking at the model's answers; score the model on those and report that number. State it honestly in the report: "accuracy on unseen hand-written requests".
3. **Add a new service category:** add its name to `DATA` and `KEYWORDS` in `generate_dataset.py`, add its display name in `LABEL_NAMES` in `matchModel.ts`, regenerate, retrain.
4. **Document in the SRS/report:** model type, data sources (templates + group-written), 80/20 style evaluation, accuracy, confusion matrix, limitations (English only, 16 classes, needs retraining to learn new services).

## Limitations to be honest about
- It recognises the service type from words it has seen; very unusual wording may fail → "no match" message.
- Mostly English with some South African terms (bakkie, braai, matric). Add other languages via `my_examples.csv`.
- It does not write free-form explanations; reasons are built from scores (category fit, rating, location).
- Document OCR/authenticity (REQ-24/25) is a separate feature and is NOT part of this model.

## Security reminder
`.env` contains real database keys (including the service-role key). Never put it on GitHub or send the project zip around; regenerate keys in Supabase if it was shared.
