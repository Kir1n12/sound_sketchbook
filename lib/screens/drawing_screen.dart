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

  Widget _buildCompactSlider(String emoji, double value, double min, double max, Function(double) onChanged, bool isHue) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: isHue 
                ? const LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.yellow,
                      Colors.green,
                      Colors.cyan,
                      Colors.blue,
                      Colors.magenta,
                      Colors.red,
                    ],
                  )
                : emoji == '🎨'
                  ? LinearGradient(
                      colors: [
                        Colors.white,
                        HSVColor.fromAHSV(1.0, _hsvColor.hue, 1.0, _hsvColor.value).toColor(),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.black,
                        HSVColor.fromAHSV(1.0, _hsvColor.hue, _hsvColor.saturation, 1.0).toColor(),
                      ],
                    ),
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 24,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactColorSelector() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and preview in same row
          Row(
            children: [
              const Text('🎨 Color', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!, width: 1),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'H:${_hsvColor.hue.round()} S:${(_hsvColor.saturation * 100).round()} V:${(_hsvColor.value * 100).round()}',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          
          // Compact HSV sliders
          _buildCompactSlider('🌈', _hsvColor.hue, 0, 360, _onHueChanged, true),
          const SizedBox(height: 2),
          _buildCompactSlider('🎨', _hsvColor.saturation * 100, 0, 100, _onSaturationChanged, false),
          const SizedBox(height: 2),
          _buildCompactSlider('💡', _hsvColor.value * 100, 0, 100, _onValueChanged, false),
          
          // Clear button
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _clearCanvas,
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear', style: TextStyle(fontSize: 10)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red[600],
                minimumSize: const Size(60, 24),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStrokeSelector() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and size display
          Row(
            children: [
              const Text('📏 Brush Size', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${_selectedStrokeWidth.toStringAsFixed(1)}px',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 4),
          
          // Brush size slider
          SizedBox(
            height: 24,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.grey[600],
                inactiveTrackColor: Colors.grey[300],
                thumbColor: Colors.grey[700],
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                trackHeight: 4,
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
          const SizedBox(height: 4),
          
          // Brush size preview
          Row(
            children: [
              const Text('🔴 Preview:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Container(
                    width: (_selectedStrokeWidth * 1.5).clamp(2.0, 20.0),
                    height: (_selectedStrokeWidth * 1.5).clamp(2.0, 20.0),
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
      constraints: const BoxConstraints(maxHeight: 120),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 600;
              
              if (isDesktop) {
                return Row(
                  children: [
                    // Color Controls (60% width)
                    Expanded(
                      flex: 3,
                      child: _buildCompactColorSelector(),
                    ),
                    const SizedBox(width: 8),
                    // Brush Size Controls (40% width)
                    Expanded(
                      flex: 2,
                      child: _buildCompactStrokeSelector(),
                    ),
                  ],
                );
              } else {
                // Mobile layout - keep vertical but more compact
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCompactColorSelector(),
                    const SizedBox(height: 4),
                    _buildCompactStrokeSelector(),
                  ],
                );
              }
            },
          ),
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