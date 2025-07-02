import 'package:flutter/material.dart';
import '../models/drawing_point.dart';
import '../widgets/drawing_canvas.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawingStroke> _strokes = [];
  DrawingStroke? _currentStroke;
  int _currentStrokeId = 0;
  
  // Drawing settings
  Color _selectedColor = Colors.black;
  double _selectedStrokeWidth = 3.0;
  
  // Available colors
  final List<Color> _availableColors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
  ];
  
  // Available stroke widths
  final List<double> _availableStrokeWidths = [1.0, 3.0, 5.0, 8.0];

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

  void _setSelectedStrokeWidth(double width) {
    setState(() {
      _selectedStrokeWidth = width;
    });
  }

  Widget _buildColorSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _availableColors.map((color) {
          return GestureDetector(
            onTap: () => _setSelectedColor(color),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedColor == color ? Colors.grey[800]! : Colors.grey[300]!,
                  width: _selectedColor == color ? 3.0 : 1.0,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStrokeWidthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _availableStrokeWidths.map((width) {
          return GestureDetector(
            onTap: () => _setSelectedStrokeWidth(width),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedStrokeWidth == width ? Colors.grey[300] : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Container(
                  width: width * 2,
                  height: width * 2,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      color: Colors.grey[100],
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color selector
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Colors',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildColorSelector(),
            
            // Stroke width selector
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Brush Size',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildStrokeWidthSelector(),
            
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
          
          // Toolbar at the bottom
          _buildToolbar(),
        ],
      ),
    );
  }
}