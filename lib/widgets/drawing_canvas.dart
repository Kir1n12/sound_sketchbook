import 'package:flutter/material.dart';
import '../models/drawing_point.dart';

/// Custom painter for drawing smooth lines and strokes
class DrawingCanvasPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;

  DrawingCanvasPainter({
    required this.strokes,
    this.currentStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }

    // Draw current stroke if it exists
    if (currentStroke != null && currentStroke!.isNotEmpty) {
      _drawStroke(canvas, currentStroke!);
    }
  }

  void _drawStroke(Canvas canvas, DrawingStroke stroke) {
    if (stroke.points.length < 2) {
      // Draw a single point as a circle
      if (stroke.points.isNotEmpty) {
        final paint = Paint()
          ..color = stroke.color
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(
          stroke.points.first.offset,
          stroke.strokeWidth / 2,
          paint,
        );
      }
      return;
    }

    final path = Path();
    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Start the path at the first point
    path.moveTo(stroke.points.first.offset.dx, stroke.points.first.offset.dy);

    // Create smooth curves between points using quadratic bezier curves
    for (int i = 1; i < stroke.points.length; i++) {
      final currentPoint = stroke.points[i].offset;
      final previousPoint = stroke.points[i - 1].offset;

      if (i == stroke.points.length - 1) {
        // Last point - draw a line to it
        path.lineTo(currentPoint.dx, currentPoint.dy);
      } else {
        // Create a smooth curve using the midpoint
        final nextPoint = stroke.points[i + 1].offset;
        final midPoint = Offset(
          (currentPoint.dx + nextPoint.dx) / 2,
          (currentPoint.dy + nextPoint.dy) / 2,
        );
        path.quadraticBezierTo(
          currentPoint.dx,
          currentPoint.dy,
          midPoint.dx,
          midPoint.dy,
        );
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! DrawingCanvasPainter ||
        oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke;
  }
}

/// Widget that provides a drawing canvas with touch/mouse input
class DrawingCanvas extends StatefulWidget {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;
  final Color selectedColor;
  final double selectedStrokeWidth;
  final Function(Offset) onPanStart;
  final Function(Offset) onPanUpdate;
  final Function() onPanEnd;

  const DrawingCanvas({
    super.key,
    required this.strokes,
    this.currentStroke,
    required this.selectedColor,
    required this.selectedStrokeWidth,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: GestureDetector(
        onPanStart: (details) {
          widget.onPanStart(details.localPosition);
        },
        onPanUpdate: (details) {
          widget.onPanUpdate(details.localPosition);
        },
        onPanEnd: (details) {
          widget.onPanEnd();
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingCanvasPainter(
            strokes: widget.strokes,
            currentStroke: widget.currentStroke,
          ),
        ),
      ),
    );
  }
}