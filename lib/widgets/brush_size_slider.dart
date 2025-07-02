import 'package:flutter/material.dart';

class BrushSizeSlider extends StatelessWidget {
  final double brushSize;
  final ValueChanged<double> onBrushSizeChanged;

  const BrushSizeSlider({
    super.key,
    required this.brushSize,
    required this.onBrushSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brush size preview and title
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: (brushSize * 1.5).clamp(2.0, 24.0),
                    height: (brushSize * 1.5).clamp(2.0, 24.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Brush Size',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                '${brushSize.toStringAsFixed(1)}px',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Brush size slider
          Container(
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[500]!,
                  Colors.grey[700]!,
                ],
              ),
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
                value: brushSize,
                min: 1.0,
                max: 20.0,
                divisions: 190, // 0.1 increments
                onChanged: onBrushSizeChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}