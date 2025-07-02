import 'package:flutter/material.dart';
import '../models/drawing_point.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/color_slider_widget.dart';
import '../widgets/brush_size_slider.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawingStroke> _strokes = [];
  DrawingStroke? _currentStroke;
  int _currentStrokeId = 0;
  
  // HSV color settings
  double _hue = 0.0; // 0-360
  double _saturation = 0.0; // 0-1
  double _value = 0.0; // 0-1
  Color _selectedColor = Colors.black;
  
  // Brush size setting
  double _selectedStrokeWidth = 3.0;

  void _onPanStart(Offset position) {
    setState(() {
      _currentStroke = DrawingStroke(
        points: [
          DrawingPoint(
            offset: position,
            color: _selectedColor,
            strokeWidth: _selectedStrokeWidth,
            strokeId: _currentStrokeId,
          )
        ],
        color: _selectedColor,
        strokeWidth: _selectedStrokeWidth,
        strokeId: _currentStrokeId,
      );
    });
  }

  void _onPanUpdate(Offset position) {
    if (_currentStroke != null) {
      setState(() {
        _currentStroke = _currentStroke!.addPoint(position);
      });
    }
  }

  void _onPanEnd() {
    if (_currentStroke != null) {
      setState(() {
        _strokes.add(_currentStroke!);
        _currentStroke = null;
        _currentStrokeId++;
      });
    }
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke = null;
      _currentStrokeId = 0;
    });
  }

  void _setSelectedColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _updateColorFromHSV() {
    setState(() {
      _selectedColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();
    });
  }

  void _setHue(double hue) {
    _hue = hue;
    _updateColorFromHSV();
  }

  void _setSaturation(double saturation) {
    _saturation = saturation;
    _updateColorFromHSV();
  }

  void _setValue(double value) {
    _value = value;
    _updateColorFromHSV();
  }

  void _setSelectedStrokeWidth(double width) {
    setState(() {
      _selectedStrokeWidth = width;
    });
  }

  Widget _buildToolbar() {
    return Container(
      color: Colors.grey[100],
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color slider widget
            ColorSliderWidget(
              hue: _hue,
              saturation: _saturation,
              value: _value,
              currentColor: _selectedColor,
              onHueChanged: _setHue,
              onSaturationChanged: _setSaturation,
              onValueChanged: _setValue,
            ),
            
            const Divider(height: 1),
            
            // Brush size slider
            BrushSizeSlider(
              brushSize: _selectedStrokeWidth,
              onBrushSizeChanged: _setSelectedStrokeWidth,
            ),
            
            const Divider(height: 1),
            
            // Clear button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _clearCanvas,
                icon: const Icon(Icons.clear),
                label: const Text('Clear Canvas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Toolbar at the top
          _buildToolbar(),
          
          // Drawing canvas - takes most of the screen
          Expanded(
            child: DrawingCanvas(
              strokes: _strokes,
              currentStroke: _currentStroke,
              selectedColor: _selectedColor,
              selectedStrokeWidth: _selectedStrokeWidth,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
            ),
          ),
        ],
      ),
    );
  }
}