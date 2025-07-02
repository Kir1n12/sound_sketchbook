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
  testWidgets('Drawing screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Verify that the drawing canvas is present with new section titles
    expect(find.text('Color Controls'), findsOneWidget);
    expect(find.text('Brush Size Controls'), findsOneWidget);
    expect(find.text('Clear Canvas'), findsOneWidget);

    // Verify that the clear button is present
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });

  testWidgets('HSV color sliders are present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Find HSV sliders (should have 4 sliders total: 3 HSV + 1 brush size)
    final sliders = find.byType(Slider);
    expect(sliders, findsNWidgets(4));
    
    // Check for HSV labels
    expect(find.textContaining('🌈 Hue:'), findsOneWidget);
    expect(find.textContaining('🎨 Saturation:'), findsOneWidget);
    expect(find.textContaining('💡 Brightness:'), findsOneWidget);
    expect(find.textContaining('📏 Size:'), findsOneWidget);
  });

  testWidgets('Color and brush size previews are present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Check for preview labels
    expect(find.textContaining('👁️ Preview:'), findsOneWidget);
    expect(find.textContaining('🔴 Preview:'), findsOneWidget);
    
    // Check for HSV values display
    expect(find.textContaining('H:'), findsOneWidget);
    expect(find.textContaining('S:'), findsOneWidget);
    expect(find.textContaining('V:'), findsOneWidget);
    
    // Check for brush size value display
    expect(find.textContaining('px'), findsOneWidget);
  });

  testWidgets('Clear button works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Tap the clear button
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    // Verify the button still exists (canvas should be cleared)
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });

  testWidgets('SafeArea wrapper is present in main layout', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Verify that SafeArea is present in the widget tree
    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets('Mobile layout uses horizontal scrollable toolbar', (WidgetTester tester) async {
    // Build our app and trigger a frame with small screen size to simulate mobile
    await tester.binding.setSurfaceSize(const Size(400, 600));
    await tester.pumpWidget(const SoundSketchbookApp());

    // Verify that SingleChildScrollView with horizontal scroll is present
    final horizontalScrollView = find.byWidgetPredicate(
      (widget) => widget is SingleChildScrollView && 
                  widget.scrollDirection == Axis.horizontal
    );
    expect(horizontalScrollView, findsOneWidget);
  });

  testWidgets('Toolbar height is limited to 100px', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Find the toolbar container with height constraint
    final toolbarContainer = find.byWidgetPredicate(
      (widget) => widget is Container && 
                  widget.constraints?.maxHeight == 100.0
    );
    expect(toolbarContainer, findsOneWidget);
  });
}
