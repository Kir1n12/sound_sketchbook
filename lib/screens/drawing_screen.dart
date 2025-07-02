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
  HSVColor _hsvColor = HSVColor.fromColor(Colors.black);
  double _selectedStrokeWidth = 3.0;
  
  // Get current color from HSV
  Color get _selectedColor => _hsvColor.toColor();

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

  void _onHueChanged(double hue) {
    setState(() {
      _hsvColor = _hsvColor.withHue(hue);
    });
  }

  void _onSaturationChanged(double saturation) {
    setState(() {
      _hsvColor = _hsvColor.withSaturation(saturation / 100.0);
    });
  }

  void _onValueChanged(double value) {
    setState(() {
      _hsvColor = _hsvColor.withValue(value / 100.0);
    });
  }

  void _setSelectedStrokeWidth(double width) {
    setState(() {
      _selectedStrokeWidth = width;
    });
  }

  Widget _buildColorSelector() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Hue slider
          Row(
            children: [
              const Text('🌈 Hue:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.yellow,
                        Colors.green,
                        Colors.cyan,
                        Colors.blue,
                        Colors.magenta,
                        Colors.red,
                      ],
                    ),
                  ),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 30,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                    ),
                    child: Slider(
                      value: _hsvColor.hue,
                      min: 0,
                      max: 360,
                      onChanged: _onHueChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Saturation slider
          Row(
            children: [
              const Text('🎨 Saturation:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        HSVColor.fromAHSV(1.0, _hsvColor.hue, 1.0, _hsvColor.value).toColor(),
                      ],
                    ),
                  ),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 30,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                    ),
                    child: Slider(
                      value: _hsvColor.saturation * 100,
                      min: 0,
                      max: 100,
                      onChanged: _onSaturationChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Value/Brightness slider
          Row(
            children: [
              const Text('💡 Brightness:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        HSVColor.fromAHSV(1.0, _hsvColor.hue, _hsvColor.saturation, 1.0).toColor(),
                      ],
                    ),
                  ),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 30,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                    ),
                    child: Slider(
                      value: _hsvColor.value * 100,
                      min: 0,
                      max: 100,
                      onChanged: _onValueChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Color preview and HSV values
          Row(
            children: [
              const Text('👁️ Preview:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'H:${_hsvColor.hue.round()}° S:${(_hsvColor.saturation * 100).round()}% V:${(_hsvColor.value * 100).round()}%',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStrokeWidthSelector() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Brush size slider
          Row(
            children: [
              const Text('📏 Size:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.grey[600],
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: Colors.grey[700],
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                  ),
                  child: Slider(
                    value: _selectedStrokeWidth,
                    min: 1.0,
                    max: 20.0,
                    divisions: 190, // 0.1 precision
                    onChanged: _setSelectedStrokeWidth,
                  ),
                ),
              ),
              Text(
                '${_selectedStrokeWidth.toStringAsFixed(1)}px',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Brush size preview
          Row(
            children: [
              const Text('🔴 Preview:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Container(
                    width: _selectedStrokeWidth * 2,
                    height: _selectedStrokeWidth * 2,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                'Color Controls',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildColorSelector(),
            
            // Stroke width selector
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Brush Size Controls',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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