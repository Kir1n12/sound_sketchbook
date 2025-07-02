import 'package:flutter/material.dart';

class ColorSliderWidget extends StatelessWidget {
  final double hue;
  final double saturation;
  final double value;
  final Color currentColor;
  final ValueChanged<double> onHueChanged;
  final ValueChanged<double> onSaturationChanged;
  final ValueChanged<double> onValueChanged;

  const ColorSliderWidget({
    super.key,
    required this.hue,
    required this.saturation,
    required this.value,
    required this.currentColor,
    required this.onHueChanged,
    required this.onSaturationChanged,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Color preview and title
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: currentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Color',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Hue slider
          _buildSliderRow(
            'H',
            hue,
            0.0,
            360.0,
            onHueChanged,
            _buildHueGradient(),
          ),
          
          // Saturation slider
          _buildSliderRow(
            'S',
            saturation,
            0.0,
            1.0,
            onSaturationChanged,
            _buildSaturationGradient(),
          ),
          
          // Value/Brightness slider
          _buildSliderRow(
            'V',
            value,
            0.0,
            1.0,
            onValueChanged,
            _buildValueGradient(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    Gradient gradient,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 20,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
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
      ),
    );
  }

  LinearGradient _buildHueGradient() {
    return const LinearGradient(
      colors: [
        Color(0xFFFF0000), // Red
        Color(0xFFFFFF00), // Yellow
        Color(0xFF00FF00), // Green
        Color(0xFF00FFFF), // Cyan
        Color(0xFF0000FF), // Blue
        Color(0xFFFF00FF), // Magenta
        Color(0xFFFF0000), // Red again
      ],
    );
  }

  LinearGradient _buildSaturationGradient() {
    final baseColor = HSVColor.fromAHSV(1.0, hue, 1.0, value).toColor();
    return LinearGradient(
      colors: [
        Colors.white,
        baseColor,
      ],
    );
  }

  LinearGradient _buildValueGradient() {
    final baseColor = HSVColor.fromAHSV(1.0, hue, saturation, 1.0).toColor();
    return LinearGradient(
      colors: [
        Colors.black,
        baseColor,
      ],
    );
  }
}