
from flask import Flask, render_template, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

MODEL_PATH = "LightGBM_WiFi7_Model.pkl"
model = joblib.load(MODEL_PATH)

FEATURES = [
    "Distance", "Stations", "MCS", "ChannelWidth", "GI",
    "Throughput", "TxPackets", "RxPackets", "LostPackets",
    "PacketLossRate", "Delay", "Jitter"
]

# This order is taken from the notebook's LabelEncoder classes:
# ['dos_extreme', 'dos_high', 'dos_low', 'dos_medium', 'normal',
#  'occupancy_extreme', 'occupancy_high', 'occupancy_low', 'occupancy_medium']
LABELS = [
    "dos_extreme", "dos_high", "dos_low", "dos_medium", "normal",
    "occupancy_extreme", "occupancy_high", "occupancy_low", "occupancy_medium"
]

def make_input(data):
    return np.array([[float(data[f]) for f in FEATURES]], dtype=float)

@app.route("/")
def home():
    return render_template("index.html", features=FEATURES)

@app.post("/predict")
def predict():
    try:
        data = request.get_json(force=True)
        X = make_input(data)

        pred = int(model.predict(X)[0])
        probs = model.predict_proba(X)[0]

        # Map numeric model class -> human-readable label.
        classes = getattr(model, "classes_", np.arange(len(probs)))
        probability = {
            LABELS[int(cls)] if int(cls) < len(LABELS) else str(cls): round(float(p) * 100, 3)
            for cls, p in zip(classes, probs)
        }

        ordered = sorted(probability.items(), key=lambda x: x[1], reverse=True)
        result_label = LABELS[pred] if 0 <= pred < len(LABELS) else str(pred)

        # Simple dashboard-friendly explanation, not a causal explanation.
        top_features = []
        for name, value in zip(FEATURES, X[0]):
            top_features.append({"feature": name, "value": float(value)})

        return jsonify({
            "prediction": result_label,
            "prediction_id": pred,
            "probabilities": ordered,
            "inputs": dict(zip(FEATURES, X[0].tolist())),
            "note": "Probabilities show the model's class confidence distribution. They are not proof of causation."
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
