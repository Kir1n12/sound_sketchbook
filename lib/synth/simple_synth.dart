import 'dart:async';
import 'dart:math';
import 'dart:html' as html;

/// Web Audio APIを使ったサイン波シンセ（Web専用）
Future<void> playSineWave({required double frequency, required double duration, double volume = 0.5}) async {
  final ctx = html.AudioContext();
  final oscillator = ctx.createOscillator();
  final gain = ctx.createGain();
  oscillator.type = 'sine';
  oscillator.frequency.value = frequency;
  gain.gain.value = volume;
  oscillator.connectNode(gain);
  gain.connectNode(ctx.destination!);
  oscillator.start();
  oscillator.stop(ctx.currentTime + duration);
  await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));
  ctx.close();
}
