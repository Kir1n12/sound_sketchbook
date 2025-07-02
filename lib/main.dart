import 'package:flutter/material.dart';
import 'screens/drawing_screen.dart';

void main() {
  runApp(const SoundSketchbookApp());
}

class SoundSketchbookApp extends StatelessWidget {
  const SoundSketchbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Sketchbook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DrawingScreen(),
    );
  }
}

