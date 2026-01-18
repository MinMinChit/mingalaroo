import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PrestoCurtainDemo(),
  ));
}

/// A standalone demo screen to visualize the animation.
class PrestoCurtainDemo extends StatefulWidget {
  const PrestoCurtainDemo({super.key});

  @override
  State<PrestoCurtainDemo> createState() => _PrestoCurtainDemoState();
}

class _PrestoCurtainDemoState extends State<PrestoCurtainDemo> {
  bool _isOpen = false;

  void _reset() {
    setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content Behind the Curtain
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 80, color: Colors.amber),
                const SizedBox(height: 20),
                const Text(
                  "Content Revealed!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text("Reset Curtain"),
                ),
              ],
            ),
          ),

          // The Curtain Overlay
          // Pass a key to force rebuild if strictly needed, or just let state handle it.
          if (!_isOpen)
            Positioned.fill(
              child: PrestoVelvetCurtain(
                onFinished: () {
                  setState(() => _isOpen = true);
                },
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🎭 PRESTO ANIMATION: VELVET CURTAIN REVEAL
// -----------------------------------------------------------------------------

/// A full-screen velvet curtain that opens with a realistic fabric curve.
///
/// **Parameters:**
/// - `duration`: 2500ms (Adjust for speed)
/// - `curve`: Curves.easeInOutCubic (Adjust for "heaviness" of fabric)
class PrestoVelvetCurtain extends StatefulWidget {
  const PrestoVelvetCurtain({
    super.key,
    required this.onFinished,
  });

  final VoidCallback onFinished;

  @override
  State<PrestoVelvetCurtain> createState() => _PrestoVelvetCurtainState();
}

class _PrestoVelvetCurtainState extends State<PrestoVelvetCurtain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showLabel = true;

  @override
  void initState() {
    super.initState();
    // ⚙️ CONFIG: Animation Duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // ⚙️ CONFIG: Animation Curve
    // easeInOutCubic gives a slow start, fast middle, and slow settle (heavy feel).
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerOpen() {
    setState(() => _showLabel = false);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double halfWidth = constraints.maxWidth / 2;
        // Extra width ensures no gap during potential bounce/elastic effects
        const double overlap = 20.0;

        return GestureDetector(
          onTap: _triggerOpen,
          child: Stack(
            children: [
              // -------------------------------------------
              // LEFT PANEL
              // -------------------------------------------
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: halfWidth + overlap,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      foregroundPainter: _CurtainEdgePainter(
                        progress: _animation.value,
                        isLeft: true,
                      ),
                      child: ClipPath(
                        clipper: _SideCurtainClipper(
                          progress: _animation.value,
                          isLeft: true,
                        ),
                        child: const _VelvetFabric(),
                      ),
                    );
                  },
                ),
              ),

              // -------------------------------------------
              // RIGHT PANEL
              // -------------------------------------------
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: halfWidth + overlap,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      foregroundPainter: _CurtainEdgePainter(
                        progress: _animation.value,
                        isLeft: false,
                      ),
                      child: ClipPath(
                        clipper: _SideCurtainClipper(
                          progress: _animation.value,
                          isLeft: false,
                        ),
                        child: const _VelvetFabric(),
                      ),
                    );
                  },
                ),
              ),

              // -------------------------------------------
              // TAP LABEL
              // -------------------------------------------
              if (_showLabel)
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Text(
                      "Tap to Open",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        letterSpacing: 1.5,
                        decoration: TextDecoration.none,
                         fontFamily: 'System', // use default
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// 🎨 VISUAL ASSETS (CODE GENERATED)
// -----------------------------------------------------------------------------

class _VelvetFabric extends StatelessWidget {
  const _VelvetFabric();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          // ⚙️ CONFIG: Fabric Texture & Folds
          // This gradient simulates light hitting heavy folds of cloth.
          colors: [
            Colors.red.shade900,
            Colors.red.shade700, // Highlight (Fold Peak)
            Colors.red.shade900, // Shadow (Fold Valley)
            Colors.red.shade800,
            Colors.red.shade600, // Highlight
            Colors.red.shade900,
          ],
          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 📐 MATH & PHYSICS: BEZIER CURVES
// -----------------------------------------------------------------------------

/// Calculates the path for the curtain edge at a specific progress point.
///
/// **Logic:**
/// The curtain doesn't slide linearly. It "swings" open.
/// - The bottom moves faster initially (opening the gap).
/// - The top follows later (gravity/hanging effect).
Path _getCurtainPath(Size size, double progress, bool isLeft) {
  final Path path = Path();
  final w = size.width;
  final h = size.height;

  // ⚙️ CONFIG: Opening Timing
  // 'Interval' maps the 0.0-1.0 total progress to specific sub-timings.
  final double bottomOpenValue = Interval(
    0.0,
    0.8, // Bottom finishes opening at 80% of total time
    curve: Curves.easeIn,
  ).transform(progress);

  final double topOpenValue = Interval(
    0.4, // Top starts opening at 40% of total time (lag)
    1.0,
    curve: Curves.easeIn,
  ).transform(progress);

  if (isLeft) {
    // Left Panel Logic
    double currentRightEdgeTop = w - (w * topOpenValue);
    double currentRightEdgeBottom = w - (w * bottomOpenValue * 1.5);

    path.moveTo(0, 0);
    path.lineTo(currentRightEdgeTop, 0); // Top Right point
    
    // The Curve
    path.quadraticBezierTo(
      currentRightEdgeTop, // Control Point X (Straight down from top)
      h * 0.6,             // Control Point Y (60% down screen)
      currentRightEdgeBottom, // End Point X
      h,                      // End Point Y (Bottom of screen)
    );
    
    path.lineTo(0, h); // Bottom Left
    path.close();
  } else {
    // Right Panel Logic (Mirrored)
    double currentLeftEdgeTop = 0 + (w * topOpenValue);
    double currentLeftEdgeBottom = 0 + (w * bottomOpenValue * 1.5);

    path.moveTo(w, 0);
    path.lineTo(currentLeftEdgeTop, 0);
    path.quadraticBezierTo(
      currentLeftEdgeTop,
      h * 0.6,
      currentLeftEdgeBottom,
      h,
    );
    path.lineTo(w, h);
    path.close();
  }
  return path;
}

class _SideCurtainClipper extends CustomClipper<Path> {
  final double progress;
  final bool isLeft;

  const _SideCurtainClipper({required this.progress, required this.isLeft});

  @override
  Path getClip(Size size) {
    return _getCurtainPath(size, progress, isLeft);
  }

  @override
  bool shouldReclip(_SideCurtainClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class _CurtainEdgePainter extends CustomPainter {
  final double progress;
  final bool isLeft;

  _CurtainEdgePainter({required this.progress, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _getCurtainPath(size, progress, isLeft);

    // ⚙️ CONFIG: Shadow Line
    // Draws a blurry dark line along the cut edge to simulate thickness.
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CurtainEdgePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
