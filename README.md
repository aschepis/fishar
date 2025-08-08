# 🐠 FishFinder AR – Requirements Document

## 📋 Overview

**FishFinder AR** is a cross-platform mobile app for iOS and Android that allows users to identify fish in real-time at an aquarium using their phone’s camera. Leveraging AR and on-device machine learning, the app detects and labels fish species in the camera view with bounding boxes and species names. Users can tap on a fish for more information.

---

## 🎯 Goals

* Detect fish in real-time using the device camera.
* Display bounding boxes and labels over identified fish.
* Provide an info overlay when a fish is selected (common name, scientific name, habitat, etc.).
* Deliver a smooth AR experience on both iOS and Android using Flutter.
* Run on-device for fast, offline-friendly performance.

---

## 🧩 Core Features

### 1. **Camera + AR View**

* Live camera feed with AR overlay using `ar_flutter_plugin`.
* Bounding boxes appear around fish in real-time.
* Flutter UI overlays for box labels.

### 2. **Fish Detection (ML)**

* Use TensorFlow Lite model trained to detect fish species.
* Real-time inference on camera frames (approx. 1–5 fps).
* Return bounding box + class name.

### 3. **Fish Info Overlay**

* Tap a bounding box to bring up a modal or side panel with:

  * Common & scientific name
  * Description
  * Region/habitat
  * Image and size range (optional)

### 4. **Platform Support**

* iOS and Android supported via single Flutter codebase.
* Native features (camera, ARKit/ARCore) accessed via plugins or platform channels.

---

## 📱 UI Design (Minimal)

| Screen              | Elements                                        |
| ------------------- | ----------------------------------------------- |
| Camera/AR View      | Live feed, bounding boxes, label tags           |
| Fish Info Modal     | Image, name, description, facts                 |
| Settings (optional) | Toggle bounding boxes, accuracy vs. performance |

---

## 🛠️ Tech Stack

| Component        | Technology                                                                                           |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| UI Framework     | **Flutter**                                                                                          |
| AR Support       | [`ar_flutter_plugin`](https://pub.dev/packages/ar_flutter_plugin), possibly custom platform channels |
| ML Inference     | **TensorFlow Lite** + pre-trained or custom fish detection model                                     |
| State Management | Provider, Riverpod, or Bloc (your choice)                                                            |
| Optional Backend | Firebase (for analytics or cloud updates to fish database)                                           |

---

## 🧪 ML Model Details

### Model Type

* Object Detection (bounding boxes + labels)
* Format: TensorFlow Lite `.tflite` model

### Input

* Real-time camera frames (preprocessed to 224x224 or 300x300 pixels)

### Output

* Bounding boxes, class index, confidence score

---

## 🔍 Existing Pre-trained Models (No Custom Training Required)

### ✅ **Wildlife/Marine Identification**

| Model                                      | Description                                                              | Format                                                  | Source                                                                            |
| ------------------------------------------ | ------------------------------------------------------------------------ | ------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **iNaturalist Species Classifier**         | Trained on thousands of species including fish, reptiles, mammals, birds | TFLite                                                  | [TensorFlow Hub](https://tfhub.dev/google/aiy/vision/classifier/inaturalist_V1/1) |
| **iNaturalist 2021 Dataset Models**        | Includes fish; no bounding boxes, but good for classification            | TF / TFLite                                             | \[Kaggle + TF Hub]                                                                |
| **Fish4Knowledge Dataset + Sample Models** | Fish detection from underwater footage                                   | Not directly available as TFLite, but dataset is public | [F4K Dataset](http://groups.inf.ed.ac.uk/f4k/)                                    |
| **Wildlife Insights Models**               | Animal detection and classification, sometimes includes fish             | TFLite / ONNX                                           | [Wildlife Insights](https://www.wildlifeinsights.org/ai-models)                   |

### 🟡 Caveats:

* Most pre-trained models are **classification-only**, not object detection (i.e., they recognize a species from a cropped image, not detect multiple fish in a frame).
* For bounding boxes, you may need to pair a **generic object detector** (e.g., SSD or YOLOv5) with a fish classifier for two-stage inference.
* **Transfer learning** with a small custom dataset may still be necessary for bounding box detection unless you find a ready fish detection model.

---

## 🚧 Development Phases

### Phase 1: MVP

* [ ] AR camera view with live feed
* [ ] Integrate TF Lite model and detect objects
* [ ] Overlay bounding boxes with labels
* [ ] Display static fish info modal on tap

### Phase 2: Enhancements

* [ ] Improve model accuracy and latency
* [ ] Expand fish info from dataset or backend
* [ ] UI polish (animations, haptics, dark mode)
* [ ] Optional: Log detections locally for later review

## 🧠 Two-Stage Detection Pipeline: Detector + Classifier

Since most public fish ML models are **classifiers** (i.e., they recognize the fish type from an image) rather than **object detectors** (i.e., they find and label multiple fish in an image), you can combine two models in a **pipeline**:

---

### ⚙️ Stage 1: Object Detection

**Goal:** Identify bounding boxes of fish in the camera frame.

#### Use:

* **SSD MobileNet V2** or **EfficientDet Lite** pre-trained on general objects.
* Train or fine-tune on fish detection data (can start with general marine datasets).
* Converts easily to **TFLite**.

#### Tools:

* [TensorFlow Lite Model Maker (Object Detection)](https://www.tensorflow.org/lite/models/modify/model_maker/object_detection)
* [Google Colab TF Lite Object Detection Notebook](https://colab.research.google.com/github/tensorflow/examples/blob/master/tensorflow_examples/lite/model_maker/demo/object_detection.ipynb)

---

### ⚙️ Stage 2: Fish Classification

**Goal:** Classify the cropped fish image into a species.

#### Use:

* Pretrained classifier (e.g., iNaturalist TFLite model)
* OR train a custom classifier on aquarium-focused dataset using transfer learning

#### Steps:

1. Crop each detected fish from the frame using bounding boxes.
2. Resize crop to classifier input size (e.g., 224x224).
3. Run classification model on each cropped image.
4. Overlay class name back on bounding box in original frame.

---

### 🧪 Example Pipeline Code (Pseudocode)

```dart
final detections = fishDetector.predict(frame); // Stage 1

for (final box in detections) {
  final crop = cropImage(frame, box);           // Crop fish
  final label = fishClassifier.predict(crop);   // Stage 2
  drawBoxWithLabel(box, label);                 // AR overlay
}
```

---

## 🔄 Converting Pretrained Models to TensorFlow Lite

### ✅ Supported (easy conversion):

| Framework  | Convert Tool                      | Notes                      |
| ---------- | --------------------------------- | -------------------------- |
| TensorFlow | `tf.lite.TFLiteConverter`         | Most supported             |
| PyTorch    | Convert to ONNX → TFLite (via TF) | Requires intermediary step |
| Keras      | `model.save()` → TFLite           | Simple path                |

#### Example (from Keras):

```python
import tensorflow as tf
model = tf.keras.models.load_model('fish_classifier.h5')
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
with open('fish_classifier.tflite', 'wb') as f:
    f.write(tflite_model)
```

---

## 🔍 Notes and Recommendations

* **iNaturalist models** work well for Stage 2 if you can isolate the fish via detection.
* You may use **Google’s AutoML Vision Object Detection** to train a model without coding, using labeled fish photos.
* You only need **5–10 fish types** common in aquariums to start with — training your own lightweight detector on a small dataset is very doable.
* Add confidence thresholds to avoid mislabeling (e.g., only show label if `confidence > 0.7`).

---

## 📝 Notes

* Bounding boxes may not align perfectly without custom calibration — test thoroughly.
* Low light or fast-moving fish may degrade accuracy — model must be robust.
* Info overlays should be cached locally or embedded for offline use.
