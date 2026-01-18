import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ThreeDTiltMouseDemo(),
  ));
}

/// A standalone demo screen for the 3D Interactive Tilt effect.
class ThreeDTiltMouseDemo extends StatelessWidget {
  const ThreeDTiltMouseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: InteractiveTiltHeart(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🖱️ PRESTO ANIMATION: 3D MOUSE TILT
// -----------------------------------------------------------------------------

/// A Heart that tilts in 3D space following the mouse cursor.
/// Includes a dynamic glossy reflection that moves oppositely to the tilt.
///
/// **Parameters (Business Logic):**
/// - `maxTilt`: 0.5 (Radians of rotation at max edge)
/// - `perspective`: 0.001 (Lens intensity. 0.005 = FishEye, 0.0005 = Isometric)
/// - `glossOpacity`: 0.5 (Strength of the shiny reflection)
class InteractiveTiltHeart extends StatefulWidget {
  const InteractiveTiltHeart({super.key});

  @override
  State<InteractiveTiltHeart> createState() => _InteractiveTiltHeartState();
}

class _InteractiveTiltHeartState extends State<InteractiveTiltHeart> {
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use full constraint space to track mouse, or a specific region
        // Here we track the mouse over the 'Center' area for demonstration.
        return MouseRegion(
          onHover: (event) {
            setState(() {
              _mousePos = event.localPosition;
            });
          },
          // Container ensures the MouseRegion covers a large hit area
          child: Container(
            color: Colors.transparent, // Hit test enabled
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: _buildTiltingHeart(context, constraints.maxWidth, constraints.maxHeight),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTiltingHeart(BuildContext context, double areaWidth, double areaHeight) {
    // ⚙️ CONFIG: Physics
    const double maxTilt = 0.5;
    const double perspective = 0.001;

    // Calculate center of the active area
    final double centerX = areaWidth / 2;
    final double centerY = areaHeight / 2;

    // Distance of mouse from center
    final double dx = _mousePos.dx - centerX;
    final double dy = _mousePos.dy - centerY;

    // Reflection Logic:
    // This value moves from -1 to 1 based on mouse position relative to the WHOLE screen/area.
    // It drives the center of the RadialGradient.
    final double reflectX = (_mousePos.dx / areaWidth).clamp(0.0, 1.0) * 2 - 1;
    final double reflectY = (_mousePos.dy / areaHeight).clamp(0.0, 1.0) * 2 - 1;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, perspective) // Apply Perspective depth
        ..rotateX(-dy * 0.001 * maxTilt) // Tilt Vertically (inverse mouse Y)
        ..rotateY(dx * 0.001 * maxTilt), // Tilt Horizontally (follows mouse X)
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. The Heart Shape (Base Color)
          CustomPaint(
            size: const Size(180, 180), // Size of the heart
            painter: _HeartPainter(color: Colors.redAccent),
          ),

          // 2. Glossy Reflection Overlay
          // Clipped to the exact heart shape so gloss doesn't spill out.
          ClipPath(
            clipper: const _HeartClipper(),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  // The glare moves opposite to the mouse/tilt
                  center: Alignment(-reflectX, -reflectY),
                  radius: 1.0,
                  colors: [
                    Colors.white.withOpacity(0.5), // Typical glare color
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🎨 VECTOR ASSETS (CODE GENERATED)
// -----------------------------------------------------------------------------

class _HeartPainter extends CustomPainter {
  final Color color;
  _HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color, color.withRed(150)], // Subtle gradient
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = _HeartClipper.getHeartPath(size);
    
    // Add a shadow for depth
    canvas.drawShadow(path, Colors.black.withOpacity(0.5), 10, true);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeartClipper extends CustomClipper<Path> {
  const _HeartClipper();

  @override
  Path getClip(Size size) {
    return getHeartPath(size);
  }

  /// Pure math to draw a heart shape
  static Path getHeartPath(Size size) {
    final double width = size.width;
    final double height = size.height;

    final path = Path();
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6,
        0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6,
        0.5 * width, height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
