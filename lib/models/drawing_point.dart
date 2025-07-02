import 'package:flutter/material.dart';

/// Represents a single point in a drawing stroke
class DrawingPoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;
  final int strokeId;

  DrawingPoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
    required this.strokeId,
  });

  /// Creates a copy of this point with updated properties
  DrawingPoint copyWith({
    Offset? offset,
    Color? color,
    double? strokeWidth,
    int? strokeId,
  }) {
    return DrawingPoint(
      offset: offset ?? this.offset,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeId: strokeId ?? this.strokeId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrawingPoint &&
        other.offset == offset &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeId == strokeId;
  }

  @override
  int get hashCode {
    return offset.hashCode ^
        color.hashCode ^
        strokeWidth.hashCode ^
        strokeId.hashCode;
  }
}

/// Represents a complete stroke consisting of multiple drawing points
class DrawingStroke {
  final List<DrawingPoint> points;
  final Color color;
  final double strokeWidth;
  final int strokeId;

  DrawingStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
    required this.strokeId,
  });

  /// Adds a point to this stroke
  DrawingStroke addPoint(Offset offset) {
    final newPoint = DrawingPoint(
      offset: offset,
      color: color,
      strokeWidth: strokeWidth,
      strokeId: strokeId,
    );
    return DrawingStroke(
      points: [...points, newPoint],
      color: color,
      strokeWidth: strokeWidth,
      strokeId: strokeId,
    );
  }

  /// Returns true if this stroke has no points
  bool get isEmpty => points.isEmpty;

  /// Returns true if this stroke has points
  bool get isNotEmpty => points.isNotEmpty;
}