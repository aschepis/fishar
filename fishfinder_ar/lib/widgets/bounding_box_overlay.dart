import 'package:flutter/material.dart';
import '../models/fish_detection.dart';

class BoundingBoxOverlay extends StatelessWidget {
  final List<FishDetection> detections;
  final Function(FishDetection) onFishTapped;
  final Size screenSize;

  const BoundingBoxOverlay({
    super.key,
    required this.detections,
    required this.onFishTapped,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: screenSize,
      painter: BoundingBoxPainter(
        detections: detections,
        onFishTapped: onFishTapped,
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<FishDetection> detections;
  final Function(FishDetection) onFishTapped;

  BoundingBoxPainter({
    required this.detections,
    required this.onFishTapped,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final detection in detections) {
      _drawBoundingBox(canvas, size, detection);
      _drawLabel(canvas, size, detection);
    }
  }

  void _drawBoundingBox(Canvas canvas, Size size, FishDetection detection) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = _getColorForConfidence(detection.confidence);

    final rect = Rect.fromLTWH(
      detection.boundingBox.left,
      detection.boundingBox.top,
      detection.boundingBox.width,
      detection.boundingBox.height,
    );

    // Draw rounded rectangle
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(rrect, paint);

    // Draw corner indicators for better visibility
    _drawCornerIndicators(canvas, rect, paint);
  }

  void _drawCornerIndicators(Canvas canvas, Rect rect, Paint paint) {
    final cornerLength = 15.0;
    final strokeWidth = paint.strokeWidth;

    // Top-left corner
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      paint..strokeWidth = strokeWidth + 1,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left, rect.top + cornerLength),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right - cornerLength, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + cornerLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left, rect.bottom - cornerLength),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right - cornerLength, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right, rect.bottom - cornerLength),
      paint,
    );
  }

  void _drawLabel(Canvas canvas, Size size, FishDetection detection) {
    final textSpan = TextSpan(
      text: '${_formatLabel(detection.label)}\n${(detection.confidence * 100).toInt()}%',
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: const Offset(1, 1),
            blurRadius: 2,
            color: Colors.black.withValues(alpha: 0.8),
          ),
        ],
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    // Position label above the bounding box
    final labelRect = Rect.fromLTWH(
      detection.boundingBox.left,
      detection.boundingBox.top - textPainter.height - 8,
      textPainter.width + 16,
      textPainter.height + 8,
    );

    // Draw background for label
    final backgroundPaint = Paint()
      ..color = _getColorForConfidence(detection.confidence).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
      backgroundPaint,
    );

    // Draw text
    textPainter.paint(
      canvas,
      Offset(
        labelRect.left + 8,
        labelRect.top + 4,
      ),
    );

    // Draw confidence indicator
    _drawConfidenceIndicator(canvas, detection);
  }

  void _drawConfidenceIndicator(Canvas canvas, FishDetection detection) {
    final indicatorSize = 8.0;
    final center = Offset(
      detection.boundingBox.right - indicatorSize,
      detection.boundingBox.top + indicatorSize,
    );

    final paint = Paint()
      ..color = _getColorForConfidence(detection.confidence)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, indicatorSize, paint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, indicatorSize, borderPaint);
  }

  Color _getColorForConfidence(double confidence) {
    if (confidence > 0.8) {
      return Colors.green;
    } else if (confidence > 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _formatLabel(String label) {
    // Capitalize first letter and replace underscores with spaces
    return label
        .split('_')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) {
    return detections != oldDelegate.detections;
  }
}

class InteractiveBoundingBoxOverlay extends StatelessWidget {
  final List<FishDetection> detections;
  final Function(FishDetection) onFishTapped;
  final Size screenSize;

  const InteractiveBoundingBoxOverlay({
    super.key,
    required this.detections,
    required this.onFishTapped,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Non-interactive overlay for drawing
        BoundingBoxOverlay(
          detections: detections,
          onFishTapped: onFishTapped,
          screenSize: screenSize,
        ),
        // Interactive overlay for tap handling
        ...detections.map((detection) => Positioned(
          left: detection.boundingBox.left,
          top: detection.boundingBox.top,
          width: detection.boundingBox.width,
          height: detection.boundingBox.height,
          child: GestureDetector(
            onTap: () => onFishTapped(detection),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        )),
      ],
    );
  }
}