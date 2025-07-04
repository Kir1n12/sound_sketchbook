import 'package:flutter/material.dart';
import 'drawing_point.dart';

/// 音符データを表すクラス
class Note {
  final double pitch; // 音の高さ
  final double duration; // 音の長さ（秒）
  final double velocity; // 音量（0.0〜1.0）
  final Color color; // 音色用
  final int strokeId; // 対応するストロークID

  Note({
    required this.pitch,
    required this.duration,
    required this.velocity,
    required this.color,
    required this.strokeId,
  });

  @override
  String toString() {
    return 'Note(pitch: ${pitch.toStringAsFixed(2)}, duration: ${duration.toStringAsFixed(2)}, velocity: ${velocity.toStringAsFixed(2)}, color: ${color.value.toRadixString(16)}, strokeId: ${strokeId})';
  }
}

/// DrawingStroke から Note へ変換する関数
Note strokeToNote(DrawingStroke stroke, double canvasHeight) {
  if (stroke.points.length < 2) {
    // 点だけなら無音
    return Note(
      pitch: 0,
      duration: 0,
      velocity: 0,
      color: stroke.color,
      strokeId: stroke.strokeId,
    );
  }
  // 線の始点・終点
  final start = stroke.points.first.offset;
  final end = stroke.points.last.offset;
  // 長さ
  final length = (end - start).distance;
  // 画面の高さを基準にY座標から音の高さを決定（上が高音、下が低音）
  final pitch = (1.0 - (start.dy / canvasHeight)) * 88 + 21; // MIDI 21~108
  // 長さを0.1px=0.01秒換算
  final duration = length * 0.01;
  // 太さを0.0〜1.0に正規化（1〜20px）
  final velocity = ((stroke.strokeWidth - 1) / 19).clamp(0.0, 1.0);
  return Note(
    pitch: pitch,
    duration: duration,
    velocity: velocity,
    color: stroke.color,
    strokeId: stroke.strokeId,
  );
}
