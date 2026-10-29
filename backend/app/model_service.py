import pickle
from pathlib import Path

# sentiment.pkl diasumsikan berupa sklearn Pipeline (TF-IDF + classifier),
# sehingga bisa langsung menerima teks mentah tanpa preprocessing manual.
MODEL_PATH = Path(__file__).resolve().parent.parent / "models" / "sentiment.pkl"

with MODEL_PATH.open("rb") as f:
    model = pickle.load(f)


def predict_text(text: str) -> dict:
    label = model.predict([text])[0]
    probabilities = model.predict_proba([text])[0]
    score = float(max(probabilities))
    return {
        "label": str(label),
        "score": score,
    }
