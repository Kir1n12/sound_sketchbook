// This is a basic Flutter widget test for the Sound Sketchbook app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sound_sketchbook/main.dart';

void main() {
  testWidgets('Drawing screen loads with compact UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Verify that the compact drawing UI is present with new section titles
    expect(find.text('🎨 Color'), findsOneWidget);
    expect(find.text('📏 Brush Size'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);

    // Verify that the clear button is present
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });

  testWidgets('HSV color sliders are present in compact format', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Find HSV sliders (should have 4 sliders total: 3 HSV + 1 brush size)
    final sliders = find.byType(Slider);
    expect(sliders, findsNWidgets(4));
    
    // Check for HSV emoji indicators in compact sliders
    expect(find.text('🌈'), findsOneWidget);
    expect(find.text('🎨'), findsWidgets); // This appears twice (title and slider)
    expect(find.text('💡'), findsOneWidget);
    expect(find.text('📏'), findsOneWidget);
  });

  testWidgets('Compact color and brush size previews are present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Check for preview labels in compact format
    expect(find.textContaining('🔴 Preview:'), findsOneWidget);
    
    // Check for compact HSV values display (H:180 S:65 V:80 format)
    expect(find.textContaining('H:'), findsOneWidget);
    expect(find.textContaining('S:'), findsOneWidget);
    expect(find.textContaining('V:'), findsOneWidget);
    
    // Check for brush size value display
    expect(find.textContaining('px'), findsOneWidget);
  });

  testWidgets('Clear button works in compact UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Tap the clear button
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    // Verify the button still exists (canvas should be cleared)
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });

  testWidgets('UI layout is responsive', (WidgetTester tester) async {
    // Test desktop layout
    await tester.binding.setSurfaceSize(const Size(800, 600));
    await tester.pumpWidget(const SoundSketchbookApp());

    // Should find Row layout with color and brush controls side by side
    expect(find.text('🎨 Color'), findsOneWidget);
    expect(find.text('📏 Brush Size'), findsOneWidget);

    // Test mobile layout  
    await tester.binding.setSurfaceSize(const Size(400, 600));
    await tester.pumpWidget(const SoundSketchbookApp());
    await tester.pump();

    // Should still find both controls but in vertical layout
    expect(find.text('🎨 Color'), findsOneWidget);
    expect(find.text('📏 Brush Size'), findsOneWidget);

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });
}
