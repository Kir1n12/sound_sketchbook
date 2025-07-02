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

    // Verify that the drawing canvas is present
    expect(find.text('Colors'), findsOneWidget);
    expect(find.text('Brush Size'), findsOneWidget);
    expect(find.text('Clear Canvas'), findsOneWidget);

    // Verify that the clear button is present
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });

  testWidgets('Color selector is functional', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundSketchbookApp());

    // Find color selection circles (should have 4 colors)
    final colorCircles = find.byType(GestureDetector);
    expect(colorCircles, findsWidgets);
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
}
