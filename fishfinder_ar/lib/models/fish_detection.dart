import 'dart:ui';

class FishDetection {
  final String speciesId;
  final String label;
  final double confidence;
  final Rect boundingBox;
  final DateTime timestamp;

  const FishDetection({
    required this.speciesId,
    required this.label,
    required this.confidence,
    required this.boundingBox,
    required this.timestamp,
  });

  bool get isHighConfidence => confidence > 0.7;
  bool get isMediumConfidence => confidence > 0.5;

  @override
  String toString() {
    return 'FishDetection{speciesId: $speciesId, label: $label, confidence: ${confidence.toStringAsFixed(2)}, boundingBox: $boundingBox}';
  }
}