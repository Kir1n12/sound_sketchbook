# Sound Sketchbook

A Flutter app that converts drawings to sound. This repository contains the first phase implementation: an interactive drawing canvas with smooth line drawing capabilities.

## Features

### Phase 1: Drawing Canvas (Current)
- **Interactive Drawing Canvas**: Draw with finger or mouse
- **Smooth Line Drawing**: Uses quadratic bezier curves for smooth strokes
- **Multiple Stroke Management**: Each drawing stroke is managed independently
- **Color Selection**: Choose from 4 preset colors (Black, Red, Blue, Green)
- **Brush Size Selection**: Select from 4 different brush sizes (1px, 3px, 5px, 8px)
- **Clear Canvas**: Reset the drawing canvas
- **Real-time Updates**: Drawing updates in real-time as you draw
- **High Performance**: Uses CustomPainter for optimized rendering

### Upcoming Features
- Sound conversion from drawing coordinates
- Save/load drawing functionality
- Audio playback controls
- Export functionality

## Technical Implementation

### Architecture
```
lib/
├── main.dart                 # Main application entry point
├── screens/
│   └── drawing_screen.dart   # Main drawing screen with UI controls
├── widgets/
│   └── drawing_canvas.dart   # Custom drawing canvas widget
└── models/
    └── drawing_point.dart    # Data models for drawing points and strokes
```

### Key Components

#### 1. DrawingPoint & DrawingStroke Models
- `DrawingPoint`: Represents a single point with coordinates, color, stroke width, and stroke ID
- `DrawingStroke`: Represents a complete drawing stroke containing multiple points

#### 2. DrawingCanvas Widget
- Custom widget with `CustomPainter` for high-performance drawing
- Handles touch/mouse input through `GestureDetector`
- Renders smooth curves using quadratic bezier paths

#### 3. DrawingScreen
- Main UI screen containing the drawing canvas and controls
- Manages drawing state and user interactions
- Provides color and brush size selection interfaces

### Performance Optimizations
- Uses `CustomPainter` for efficient canvas rendering
- Implements proper `shouldRepaint` logic to minimize unnecessary redraws
- Smooth curve interpolation for natural drawing feel
- Optimized state management with minimal rebuilds

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or later)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Kir1n12/sound_sketchbook.git
   cd sound_sketchbook
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Platform Support
- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Usage

1. **Drawing**: Touch/click and drag on the white canvas area to draw
2. **Color Selection**: Tap on any of the color circles to change drawing color
3. **Brush Size**: Tap on the brush size indicators to change stroke width
4. **Clear Canvas**: Press the "Clear Canvas" button to reset the drawing

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  just_audio: ^0.9.36        # For future audio functionality
  just_audio_web: ^0.4.8     # Web audio support
  path_provider: ^2.1.1      # For file operations
  share_plus: ^7.2.1         # For sharing functionality
  permission_handler: ^11.0.1 # For permissions

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## Roadmap

### Phase 2: Audio Integration
- Convert drawing coordinates to musical notes
- Real-time audio playback during drawing
- Sound synthesis and effects

### Phase 3: Advanced Features
- Save/load drawings with associated audio
- Export to various formats (audio, video, image)
- Social sharing capabilities
- Advanced drawing tools

## License

This project is licensed under the MIT License - see the LICENSE file for details.
