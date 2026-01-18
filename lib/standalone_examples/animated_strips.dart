import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnimatedStripsDemo(),
  ));
}

/// A standalone demo screen for the Animated Hazard/Warning Strips texture.
class AnimatedStripsDemo extends StatelessWidget {
  const AnimatedStripsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Long Rectangle - Disabled Style
            AnimatedStripTexture(
              width: 300,
              height: 60,
              color1: Color(0xFFEEEEEE), // Very light gray (Background)
              color2: Color(0xFFE0E0E0), // Slightly darker gray (Stripe)
              stripeWidth: 10,           // Thinner
            ),
            SizedBox(height: 40),
            // 2. Short Tall Rectangle - Disabled Style
            AnimatedStripTexture(
              width: 100,
              height: 200, 
              color1: Color(0xFFF5F5F5),
              color2: Color(0xFFDDDDDD), 
              stripeWidth: 8
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🚧 PRESTO ANIMATION: MOVING STRIPS TEXTURE
// -----------------------------------------------------------------------------

class AnimatedStripTexture extends StatefulWidget {
  final double width;
  final double height;
  final Color color1;
  final Color color2;
  final double stripeWidth;

  const AnimatedStripTexture({
    super.key,
    required this.width,
    required this.height,
    required this.color1,
    required this.color2,
    this.stripeWidth = 10.0, // Default to thinner
  });

  @override
  State<AnimatedStripTexture> createState() => _AnimatedStripTextureState();
}

class _AnimatedStripTextureState extends State<AnimatedStripTexture>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // ⚙️ ENGINE: Slow scrolling for "Disabled" feel
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Much slower (was 1s)
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      clipBehavior: Clip.antiAlias, // Clean edges
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _StripesPainter(
              scrollOffset: _controller.value,
              color1: widget.color1,
              color2: widget.color2,
              stripeWidth: widget.stripeWidth,
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🖌️ VECTOR PAINTER: DIAGONAL STRIPES
// -----------------------------------------------------------------------------

class _StripesPainter extends CustomPainter {
  final double scrollOffset; // 0.0 to 1.0
  final Color color1;
  final Color color2;
  final double stripeWidth;

  _StripesPainter({
    required this.scrollOffset,
    required this.color1,
    required this.color2,
    required this.stripeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // We need to draw diagonal lines covering the entire rect.
    // The pattern repeats every (2 * stripeWidth) projected on the axis.
    
    // 📐 Geometry:
    // A diagonal stripe of width W at 45 degrees.
    // The "period" (horizontal repeat distance) is W / sin(45) * 2?
    // Let's simplify: checking pixels.
    
    // We will draw many polygons.
    // Effective projection width on X axis for a 45 degree line:
    // final double period = stripeWidth * 2; 
    
    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = color1);

    paint.color = color2;
    
    
    // --- ROBUST ROTATION METHOD ---
    canvas.save();
    
    // 1. Center the logic for rotation? No, just rotate around 0,0 is fine if we cover enough area.
    // We want 45 degrees.
    canvas.rotate(3.14159 / 4); // 45 degrees
    
    // Now we draw vertical bars along the new X axis.
    // The area to cover is now larger (Hypotenuse of the rect).
    final double diagDist = size.width + size.height; // Rough overestimate
    final double offsetPx = (stripeWidth * 2) * scrollOffset; // Movement
    
    // Start far negative to cover rotation
    for (double x = -diagDist; x < diagDist; x += (stripeWidth * 2)) {
      // Draw the "Color 2" stripe
      // The x position moves with time
      double drawX = x + offsetPx;
      
      canvas.drawRect(
        Rect.fromLTWH(drawX, -diagDist, stripeWidth, diagDist * 2), // Infinite height rect
        paint
      );
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StripesPainter old) => 
    old.scrollOffset != scrollOffset || old.color1 != color1;
}
