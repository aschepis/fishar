# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**FishFinder AR** is a cross-platform Flutter mobile app for iOS and Android that identifies fish species in real-time at aquariums using AR and machine learning. The app uses the device camera to detect fish, displays bounding boxes with species labels, and provides detailed information when users tap on identified fish.

## Architecture

This project is currently in the planning/requirements phase with only documentation present. The intended architecture includes:

### Core Components
- **AR Camera View**: Live camera feed with AR overlay using `ar_flutter_plugin`
- **ML Pipeline**: Two-stage detection system:
  - Stage 1: Object detection (SSD MobileNet V2 or EfficientDet Lite) to identify fish bounding boxes
  - Stage 2: Fish classification using TensorFlow Lite models (e.g., iNaturalist) to identify species
- **Fish Info System**: Database/service for species information (common name, scientific name, habitat, description)
- **Platform Integration**: Native camera and AR features via Flutter plugins

### Technology Stack
- **Framework**: Flutter (cross-platform)
- **AR**: `ar_flutter_plugin` with ARKit/ARCore integration
- **ML**: TensorFlow Lite for on-device inference
- **State Management**: Provider, Riverpod, or Bloc pattern (TBD)
- **Optional Backend**: Firebase for analytics or cloud fish database updates

## Development Workflow

Since this is a Flutter project that hasn't been initialized yet, typical commands will be:

```bash
# Initialize Flutter project
flutter create fishfinder_ar

# Get dependencies
flutter pub get

# Run on connected device/simulator
flutter run

# Build for release
flutter build apk        # Android
flutter build ios       # iOS

# Run tests
flutter test

# Analyze code
flutter analyze
```

## ML Model Integration

The app uses a two-stage ML pipeline:

1. **Fish Detection Model**: Identifies bounding boxes of fish in camera frames
2. **Fish Classification Model**: Classifies cropped fish images into species

Models should be converted to TensorFlow Lite format for optimal mobile performance. The detection pipeline follows this pattern:

```dart
final detections = fishDetector.predict(frame); // Stage 1: Object detection
for (final box in detections) {
  final crop = cropImage(frame, box);           // Crop detected fish
  final label = fishClassifier.predict(crop);   // Stage 2: Species classification
  drawBoxWithLabel(box, label);                 // Display AR overlay
}
```

## Key Implementation Notes

- Target 1-5 fps for real-time inference to balance performance and battery life
- Use confidence thresholds (e.g., >0.7) to avoid false positives
- Implement offline-first approach with locally cached fish information
- Handle low-light conditions and fast-moving fish scenarios
- Ensure bounding box alignment with AR overlay through proper camera calibration

## Development Phases

### Phase 1 MVP
- AR camera view with live feed
- TensorFlow Lite model integration
- Bounding box overlays with labels
- Basic fish info modal on tap

### Phase 2 Enhancements  
- Model accuracy and performance improvements
- Expanded fish database
- UI polish and animations
- Local detection logging

Start with 5-10 common aquarium fish species before expanding the model's capabilities.