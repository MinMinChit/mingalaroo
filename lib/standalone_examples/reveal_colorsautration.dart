import 'package:flutter/material.dart';
import 'dart:ui'; // For ImageFilter

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RevealColorSaturationDemo(),
  ));
}

/// A standalone demo screen for the Watercolor/Saturation Reveal effect.
class RevealColorSaturationDemo extends StatefulWidget {
  const RevealColorSaturationDemo({super.key});

  @override
  State<RevealColorSaturationDemo> createState() =>
      _RevealColorSaturationDemoState();
}

class _RevealColorSaturationDemoState extends State<RevealColorSaturationDemo> {
  // Toggle to restart animation
  int _key = 0;

  void _restart() {
    setState(() => _key++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        child: const Icon(Icons.refresh),
      ),
      body: Center(
        child: WatercolorRevealScene(
          key: ValueKey(_key),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🎨 PRESTO ANIMATION: WATERCOLOR REVEAL
// -----------------------------------------------------------------------------

/// Effect Sequence:
/// 1. Fade In (Opacity 0 -> 1)
/// 2. Deblur (Blur 10 -> 0) - Simulates focusing
/// 3. Saturate (Grayscale -> Full Color) - Simulates paint drying/appearing
class WatercolorRevealScene extends StatefulWidget {
  const WatercolorRevealScene({super.key});

  @override
  State<WatercolorRevealScene> createState() => _WatercolorRevealSceneState();
}

class _WatercolorRevealSceneState extends State<WatercolorRevealScene>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _blurAnim;
  late Animation<double> _saturationAnim;

  @override
  void initState() {
    super.initState();
    // ⚙️ CONFIG: Total Duration (3 seconds)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // 1. Fade: Happens quickly at start (0% - 30%)
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    // 2. Blur: Clears up from start to mid (0% - 60%)
    // Goes from 1.0 (max blur) to 0.0 (no blur)
    _blurAnim = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // 3. Saturation: Slowly bleeds in color (20% - 100%)
    // Goes from 0.0 (grayscale) to 1.0 (full color)
    _saturationAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    );

    // Auto Start
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Apply Saturation using ColorFilter matrix
        // Standard Grayscale Matrix interpolation
        final double sat = _saturationAnim.value;
        final ColorFilter colorFilter = ColorFilter.matrix(<double>[
          0.2126 + 0.7874 * sat, 0.7152 - 0.7152 * sat, 0.0722 - 0.0722 * sat, 0, 0,
          0.2126 - 0.2126 * sat, 0.7152 + 0.2848 * sat, 0.0722 - 0.0722 * sat, 0, 0,
          0.2126 - 0.2126 * sat, 0.7152 - 0.7152 * sat, 0.0722 + 0.9278 * sat, 0, 0,
          0,                     0,                     0,                     1, 0,
        ]);

        return FadeTransition(
          opacity: _fadeAnim,
          child: ImageFiltered(
            // Apply Blur
            imageFilter: ImageFilter.blur(
              sigmaX: _blurAnim.value,
              sigmaY: _blurAnim.value,
            ),
            // Apply Saturation (ColorFilter)
            child: ColorFiltered(
              colorFilter: colorFilter,
              child: child,
            ),
          ),
        );
      },
      child: const _VectorLandscape(), // The High-Saturation Scene
    );
  }
}

// -----------------------------------------------------------------------------
// 🌄 VECTOR ASSET: HIGH SATURATION LANDSCAPE
// -----------------------------------------------------------------------------

class _VectorLandscape extends StatelessWidget {
  const _VectorLandscape();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.blueAccent, // Deep Blue Sky
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0,10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // SUN
            Positioned(
              top: 30, 
              right: 30,
              child: Container(
                width: 60, height: 60,
                decoration: const BoxDecoration(
                  color: Colors.yellowAccent, // Bright Yellow
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.orangeAccent, blurRadius: 20, spreadRadius: 5)
                  ]
                ),
              ),
            ),

            // MOUNTAINS (Back)
            Positioned(
              bottom: 80,
              left: -50,
              right: -50,
              child: SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: _TriPainter(color: Colors.purpleAccent), // Deep Purple
                ),
              ),
            ),
            
            // MOUNTAINS (Front)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 150,
                child: CustomPaint(
                  painter: _TriPainter(color: Colors.deepPurple), // Darker Purple
                ),
              ),
            ),

            // GREEN FIELD
            Positioned(
              bottom: 0,
              left: 0, 
              right: 0, 
              height: 100,
              child: Container(
                color: Colors.greenAccent[700], // Vibrant Green
              ),
            ),

            // RIVER
            Positioned(
              bottom: 0,
              left: 150,
              child: Transform.rotate(
                angle: 0.2, // Tilted river path
                child: Container(
                  width: 80,
                  height: 120,
                  color: Colors.cyanAccent, // Bright Cyan Water
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TriPainter extends CustomPainter {
  final Color color;
  _TriPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width * 0.5, 0); // Top Peak
    path.lineTo(0, size.height);      // Bottom Left
    path.lineTo(size.width, size.height); // Bottom Right
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
