# WiFi-7 LightGBM Model Web App

A simple visual web interface for the uploaded `LightGBM_WiFi7_Model.pkl`.

## What it does

1. Takes the same 12 numeric features used by the trained model.
2. Sends them to a Flask `/predict` endpoint.
3. Runs the real LightGBM model.
4. Displays:
   - predicted class
   - numeric class ID
   - probability for all 9 classes
   - interactive probability bar chart
   - input snapshot

The feature set is based on the supplied notebook: Distance, Stations, MCS, ChannelWidth,
GI, Throughput, TxPackets, RxPackets, LostPackets, PacketLossRate, Delay, Jitter.

The notebook's class order is:
0 dos_extreme
1 dos_high
2 dos_low
3 dos_medium
4 normal
5 occupancy_extreme
6 occupancy_high
7 occupancy_low
8 occupancy_medium

## Run locally

```bash
cd wifi7_model_webapp
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Open http://127.0.0.1:5000

## Important

This app uses the actual uploaded model file. It does not retrain the model.

The notebook reports the direct 9-class LightGBM model at about 93.41% overall accuracy, and
the hierarchical Stage-1 experiment at about 94.85%. The final model selected in the notebook
was the direct 9-class LightGBM model.
