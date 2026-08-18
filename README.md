# Machine Learning-Based Intrusion Detection for Wi-Fi 7 Networks

## Overview

This project presents a simulation-based machine learning framework for detecting malicious network behavior in IEEE 802.11be (Wi-Fi 7) wireless networks.

The project combines:

- Wi-Fi 7 network simulation using ns-3.44
- Normal and malicious traffic generation
- DoS and channel occupancy attack scenarios
- Automated network performance data collection
- Machine learning-based attack classification
- Feature importance analysis
- Explainable AI analysis
- A prediction dashboard for demonstrating attack classification

The objective is to investigate whether network-level performance metrics generated from a Wi-Fi 7 simulation can be used to distinguish normal traffic from different attack types and attack severity levels.

---

# Project Architecture

The complete workflow is:

Wi-Fi 7 Simulation
        |
        v
     ns-3.44
        |
        v
Normal / DoS / Occupancy Scenarios
        |
        v
Network Performance Metrics
        |
        v
Wi-Fi 7 Dataset
        |
        v
Data Preprocessing
        |
        v
Machine Learning Models
        |
        +------------------+
        |        |         |
        v        v         v
       RF     XGBoost   LightGBM
        |        |         |
        +--------+---------+
                 |
                 v
          Model Comparison
                 |
                 v
          Best Model: LightGBM
                 |
                 v
          Attack Prediction
                 |
                 v
             Dashboard

---

# Research Objective

The main objective of this project is to develop and evaluate a machine learning-based intrusion detection framework for simulated Wi-Fi 7 networks.

The framework attempts to classify network scenarios into nine classes:

1. Normal
2. DoS Low
3. DoS Medium
4. DoS High
5. DoS Extreme
6. Occupancy Low
7. Occupancy Medium
8. Occupancy High
9. Occupancy Extreme

---

# Technologies Used

## Network Simulation

- ns-3.44
- IEEE 802.11be / Wi-Fi 7
- FlowMonitor
- C++

## Machine Learning

- Python
- Pandas
- NumPy
- Scikit-learn
- Random Forest
- XGBoost
- LightGBM
- CatBoost

## Explainability

- SHAP
- LightGBM feature importance

## Development Environment

- Ubuntu Linux
- Visual Studio Code
- Google Colab
- Jupyter Notebook

---

# Wi-Fi 7 Simulation

The network simulation was developed using ns-3.44.

The simulation consists of a Wi-Fi 7 Access Point and multiple wireless stations. Different network configurations are used to generate a diverse set of network conditions.

The simulation parameters include:

| Parameter | Values |
|-----------|--------|
| Number of Stations | 2, 10, 20 |
| Distance | 1 m, 10 m, 20 m |
| MCS | 3, 7, 11 |
| Channel Width | 20 MHz, 80 MHz, 160 MHz |
| Guard Interval | 800 ns, 3200 ns |
| Payload Size | 700 bytes |
| Load Factor | 1 |

---

# Attack Scenarios

The simulation currently considers two attack categories.

## 1. Denial-of-Service (DoS)

The DoS scenarios represent malicious traffic intended to disrupt network communication by generating excessive traffic and causing network degradation.

Four severity levels are considered:

- Low
- Medium
- High
- Extreme

## 2. Channel Occupancy

Occupancy scenarios represent attacks that consume wireless channel resources and affect legitimate network communication.

Four severity levels are considered:

- Low
- Medium
- High
- Extreme

## 3. Normal Traffic

Normal traffic is used as the baseline class and represents network operation without an injected attack.

---

# Dataset Generation

The dataset is generated automatically from the ns-3.44 simulation environment.

For every simulation scenario, network-level performance metrics are collected and stored in a CSV file.

The resulting dataset contains:

- 972 scenarios
- 9 classes
- 108 samples per class
- 12 machine learning input features

The dataset is balanced across all nine classes.

---

# Dataset Features

The final machine learning dataset contains the following 12 input features:

| Feature | Description |
|---------|-------------|
| Distance | Distance between wireless nodes |
| Stations | Number of stations |
| MCS | Modulation and Coding Scheme |
| ChannelWidth | Wireless channel width |
| GI | Guard Interval |
| Throughput | Network throughput |
| TxPackets | Number of transmitted packets |
| RxPackets | Number of received packets |
| LostPackets | Number of lost packets |
| PacketLossRate | Packet loss percentage |
| Delay | Network packet delay |
| Jitter | Variation in packet delay |

Two original fields were removed before machine learning:

- PayloadSize
- LoadFactor

These fields were constant in the generated dataset and therefore provided no useful information for classification.

---

# Machine Learning

Four ensemble machine learning algorithms were evaluated:

1. Random Forest
2. XGBoost
3. LightGBM
4. CatBoost

All models were evaluated using the same dataset and the same Stratified 5-Fold Cross-Validation procedure.

This provides a fair comparison between the algorithms.

---

# Model Evaluation

The experimental results obtained from the current dataset are:

| Model | Accuracy | Precision | Recall | F1 Score |
|-------|----------|-----------|--------|----------|
| Random Forest | 70.78% | 72.70% | 70.76% | 71.06% |
| XGBoost | 87.45% | 88.22% | 87.47% | 87.44% |
| CatBoost | 78.08% | 79.21% | 78.11% | 77.86% |
| LightGBM | 93.41% | 93.88% | 93.42% | 93.37% |

LightGBM achieved the highest performance among the evaluated models.

Therefore, LightGBM is used as the primary model for the prediction dashboard.

---

# Cross Validation

Stratified 5-Fold Cross-Validation is used for model evaluation.

The dataset is divided into five folds while preserving the class distribution.

Example:

    Fold 1 -> Test
    Fold 2 -> Train
    Fold 3 -> Train
    Fold 4 -> Train
    Fold 5 -> Train

    Fold 1 -> Train
    Fold 2 -> Test
    Fold 3 -> Train
    Fold 4 -> Train
    Fold 5 -> Train

This process continues until every sample has been used for testing.

The final reported performance is calculated from the five folds.

---

# Feature Importance

Feature importance analysis was performed using the trained LightGBM model.

The most influential features in the current experiment include:

1. TxPackets
2. PacketLossRate
3. Throughput
4. LostPackets
5. Delay
6. Stations
7. ChannelWidth
8. MCS
9. GI
10. Jitter
11. Distance
12. RxPackets

The results indicate that network traffic behavior is particularly important for distinguishing between normal and malicious scenarios.

---

# Explainable AI

SHAP was investigated to improve the interpretability of the machine learning model.

SHAP can be used to analyze how individual features contribute to model predictions.

This helps answer questions such as:

- Which network feature influenced the prediction?
- Which features are most important globally?
- Why was a particular scenario classified as an attack?
- Which features contribute toward distinguishing different attack classes?

SHAP results should be interpreted together with the LightGBM feature importance analysis.

---

# Prediction Dashboard

A prediction dashboard was developed to demonstrate the trained LightGBM model.

The dashboard accepts the 12 network-level input features:

- Distance
- Stations
- MCS
- Channel Width
- GI
- Throughput
- TxPackets
- RxPackets
- LostPackets
- Packet Loss Rate
- Delay
- Jitter

The values are passed to the trained LightGBM model.

The model then produces a prediction among the nine classes.

Example:

    Input Network Metrics
            |
            v
       LightGBM Model
            |
            v
      Predicted Class
            |
            v
       DoS Extreme

The dashboard also displays the probability distribution across the nine classes.

---

# Example Prediction

An example input may contain network statistics such as:

    Distance       = 1
    Stations       = 2
    MCS            = 3
    ChannelWidth   = 80
    GI             = 800
    Throughput     = 134.91
    TxPackets      = 75900004
    RxPackets      = 531499
    LostPackets    = 4394919
    PacketLossRate = 83.07
    Delay          = 43
    Jitter         = 2

The trained model can then classify the network scenario into one of the nine classes.

The prediction probability displayed by the dashboard represents the model's predicted probability distribution and should not be interpreted as absolute certainty.

---

# Project Directory Structure

A recommended repository structure is:

    WiFi7-IDS/
    |
    ├── ns-3.44/
    │   └── scratch/
    │       └── wifi7_mlo/
    │           ├── wifi_security_attack.cc
    │           └── ...
    |
    ├── results/
    │   └── wifi7_dataset.csv
    |
    ├── ml/
    │   ├── notebooks/
    │   ├── models/
    │   └── analysis/
    |
    ├── dashboard/
    │   └── ...
    |
    ├── figures/
    │   ├── confusion_matrix.png
    │   ├── feature_importance.png
    │   └── ...
    |
    ├── README.md
    └── requirements.txt

The exact directory structure may vary depending on how the project is organized.

---

# Running the Wi-Fi 7 Simulation

## 1. Enter the ns-3 directory

    cd ~/ns-allinone-3.44/ns-3.44

## 2. Build ns-3

    ./ns3 build

## 3. Run the Wi-Fi 7 simulation

Example:

    ./ns3 run scratch/wifi7_mlo/wifi_security_attack

Additional command-line parameters can be provided for individual scenarios.

Example:

    ./ns3 run "scratch/wifi7_mlo/wifi_security_attack --attack=normal --attackIntensity=none --nStations=2 --distance=10 --mcs=7 --channelWidth=80 --guardInterval=3200"

---

# Generating the Dataset

The simulation program can be configured to execute multiple scenarios.

Each completed scenario generates network performance statistics that are appended to:

    results/wifi7_dataset.csv

The resulting CSV contains the network configuration, attack information, and measured performance metrics.

Example columns:

    Attack
    AttackIntensity
    Distance
    Stations
    PayloadSize
    LoadFactor
    MCS
    ChannelWidth
    GI
    Throughput
    TxPackets
    RxPackets
    LostPackets
    PacketLossRate
    Delay
    Jitter

---

# Machine Learning Workflow

The machine learning workflow is performed separately from the ns-3 simulation.

The general workflow is:

    Load Dataset
        |
        v
    Data Cleaning
        |
        v
    Remove Constant Features
        |
        v
    Create Target Classes
        |
        v
    Feature Preparation
        |
        v
    Stratified 5-Fold CV
        |
        v
    Train Models
        |
        v
    Compare Models
        |
        v
    Select LightGBM
        |
        v
    Feature Importance
        |
        v
    Explainability Analysis
        |
        v
    Save Trained Model
        |
        v
    Dashboard Prediction

---

# Requirements

The simulation environment requires ns-3.44 and its required dependencies.

The machine learning environment requires Python and the following packages:

    pandas
    numpy
    scikit-learn
    xgboost
    lightgbm
    catboost
    shap
    matplotlib

Install the Python dependencies using:

    pip install pandas numpy scikit-learn xgboost lightgbm catboost shap matplotlib

Depending on the environment, additional packages may be required by the dashboard.

---

# Reproducibility

The project is designed to provide a reproducible workflow:

1. Configure the Wi-Fi 7 simulation.
2. Execute the simulation scenarios.
3. Collect FlowMonitor statistics.
4. Generate the CSV dataset.
5. Perform preprocessing.
6. Train machine learning models.
7. Evaluate using Stratified 5-Fold Cross-Validation.
8. Select the best-performing model.
9. Save the trained model.
10. Use the model in the prediction dashboard.

---

# Results Summary

The current experimental evaluation produced the following main result:

    Best Model: LightGBM

    Accuracy: 93.41%

    Macro Precision: 93.88%

    Macro Recall: 93.42%

    Macro F1 Score: 93.37%

LightGBM outperformed Random Forest, XGBoost, and CatBoost on the current simulation-generated dataset.

---

# Limitations

The current study has several limitations.

1. The dataset is generated using simulation rather than physical Wi-Fi 7 hardware.
2. Only DoS and occupancy attack categories are currently considered.
3. The dataset contains 972 scenarios.
4. Real-world wireless interference and environmental effects may differ from the simulation.
5. The current system should not be interpreted as a complete real-time Wi-Fi 7 intrusion prevention system.
6. Additional Wi-Fi 7 capabilities and attack types can be investigated in future work.

---

# Future Work

Future extensions include:

- Validation using real Wi-Fi 7 hardware
- Larger simulation datasets
- Additional attack types
- Evil Twin attack scenarios
- Spoofing attacks
- Deauthentication attacks
- Authentication attacks
- Multi-Link Operation (MLO) scenarios
- Temporal network traffic analysis
- Real-time intrusion detection
- Deep learning models
- Graph Neural Networks
- Federated learning
- Edge-based deployment

---

# Research Contribution

The main contribution of this project is a reproducible simulation-to-machine-learning pipeline for investigating intrusion detection in Wi-Fi 7 environments.

The project combines:

    Wi-Fi 7 Simulation
            +
    Attack Scenario Generation
            +
    Dataset Generation
            +
    Machine Learning
            +
    Explainable AI
            +
    Attack Prediction Dashboard

The current evaluation demonstrates the potential of ensemble machine learning, particularly LightGBM, for classifying the simulated Wi-Fi 7 traffic scenarios represented in the dataset.

---

# Authors

Add your project members here.

    Name 1
    Name 2
    Name 3
    Name 4

Department of Computer Science and Engineering

Add your college/university name here.

---

# Acknowledgements

We acknowledge the developers and contributors of the ns-3 network simulator and the open-source machine learning libraries used in this project.

---

# Disclaimer

This project is intended for academic and research purposes.

The reported machine learning performance is based on a simulation-generated dataset and should not be interpreted as real-world Wi-Fi 7 intrusion detection accuracy without further validation using physical Wi-Fi 7 deployments.

---

# License

Add the license selected for this repository.

For example:

    MIT License

or use another license appropriate for your project.
