import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'coordinates_translator.dart';

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(
    this._objects,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<DetectedObject> _objects;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;
    final Paint background = Paint()..color = Color(0xCCFFFFFF);

    // Draw a container at the bottom for displaying all detected objects
    final Paint containerPaint = Paint()..color = Color(0xCC000000);
    final Rect containerRect =
        Rect.fromLTWH(0, size.height - 100, size.width, 100);
    canvas.drawRect(containerRect, containerPaint);

    // Create a list to store all detected labels
    List<String> allLabels = [];

    for (final DetectedObject detectedObject in _objects) {
      if (detectedObject.labels.isEmpty) continue;

      final label = detectedObject.labels
          .reduce((a, b) => a.confidence > b.confidence ? a : b);

      // Add label to the list with confidence
      final labelText =
          '${label.text} ${(label.confidence * 100).toStringAsFixed(0)}%';
      allLabels.add(labelText);

      final left = translateX(
        detectedObject.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      final top = translateY(
        detectedObject.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      final right = translateX(
        detectedObject.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      final bottom = translateY(
        detectedObject.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      // Draw bounding box
      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );

      // Draw label on the bounding box (similar to the repository implementation)
      final labelBackground = Rect.fromLTRB(left, top, left + 150, top + 20);

      canvas.drawRect(labelBackground, background);

      final labelBuilder = ParagraphBuilder(
        ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 14,
          textDirection: TextDirection.ltr,
        ),
      );

      labelBuilder.pushStyle(ui.TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ));

      labelBuilder.addText(labelText);
      labelBuilder.pop();

      final labelParagraph = labelBuilder.build()
        ..layout(ParagraphConstraints(width: 150));

      canvas.drawParagraph(
        labelParagraph,
        Offset(left + 5, top),
      );
    }

    // Display all labels in the container at the bottom
    if (allLabels.isNotEmpty) {
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(ui.TextStyle(color: Colors.white));
      builder.addText('Detected Objects: ${allLabels.join(', ')}');
      builder.pop();

      final paragraph = builder.build()
        ..layout(ParagraphConstraints(width: size.width - 20));

      canvas.drawParagraph(
        paragraph,
        Offset(10, size.height - 90),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
