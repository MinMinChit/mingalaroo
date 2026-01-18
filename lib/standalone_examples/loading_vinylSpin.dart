import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VinylSplashDemo(),
  ));
}

/// A standalone demo screen for the Vinyl Splash Animation.
class VinylSplashDemo extends StatelessWidget {
  const VinylSplashDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinningVinylSplash(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 💿 PRESTO ANIMATION: VINYL SPIN & PULSE
// -----------------------------------------------------------------------------

/// A Spinning Vinyl Record animation with a gentle breathing/pulsing effect.
///
/// **Parameters (Business Logic):**
/// - `spinDuration`: 3000ms (Time for one full rotation)
/// - `pulseDuration`: 800ms (Time for one grow/shrink cycle)
/// - `pulseScale`: 0.1 (Max growth, i.e., 1.0 -> 1.1)
/// - `curve`: Curves.easeInOut (Smooth sine-wave breathing)
class SpinningVinylSplash extends StatefulWidget {
  const SpinningVinylSplash({super.key});

  @override
  State<SpinningVinylSplash> createState() => _SpinningVinylSplashState();
}

class _SpinningVinylSplashState extends State<SpinningVinylSplash>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // ⚙️ ENGINE 1: CONTINUOUS SPINNING
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // 3s per rotation
    )..repeat(); // Loop forever

    // ⚙️ ENGINE 2: PULSING / BREATHING
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Faster beat for pulse
    )..repeat(reverse: true); // Grow and Shrink

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut, // Smooth turn-around at max/min size
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ⚙️ CONFIG: Pulse Intensity
    const double pulseIntensity = 0.1; // Scales up to 1.1x

    return AnimatedBuilder(
      animation: Listenable.merge([_spinController, _pulseController]),
      builder: (context, child) {
        // Calculate Scale
        final double scale = 1.0 + (_pulseAnimation.value * pulseIntensity);

        // Calculate Rotation (Spin)
        final double angle = _spinController.value * 2 * math.pi;

        return Transform.scale(
          scale: scale, // Apply Pulse
          child: Transform.rotate(
            angle: angle, // Apply Spin
            child: child,
          ),
        );
      },
      child: const _VinylRecordVector(), // The Graphic
    );
  }
}

// -----------------------------------------------------------------------------
// 🎨 VECTOR ASSETS (CODE GENERATED)
// -----------------------------------------------------------------------------

/// Draws a Vinyl Record using Flutter Containers and Borders.
/// Repalces the original asset `smlogo.png`.
class _VinylRecordVector extends StatelessWidget {
  const _VinylRecordVector();

  @override
  Widget build(BuildContext context) {
    // ⚙️ CONFIG: Vinyl Size
    const double size = 180.0;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.black, // Vinyl Color
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Texture Grooves (Simulated with Gradient)
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.grey.shade900,
                  Colors.black,
                  Colors.grey.shade800,
                  Colors.black
                ],
                stops: const [0.4, 0.5, 0.9, 1.0],
              ),
            ),
          ),

          // Inner Label (Red)
          Container(
            width: size * 0.35,
            height: size * 0.35,
            decoration: BoxDecoration(
              color: Colors.redAccent.shade700,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: const Center(
              child: Text(
                "LOGO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Center Hole
          Container(
            width: size * 0.04,
            height: size * 0.04,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
