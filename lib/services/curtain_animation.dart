import 'package:flutter/material.dart';

// Cache Interval objects to avoid recreating on every frame
final _bottomInterval = Interval(0.0, 0.8, curve: Curves.easeIn);
final _topInterval = Interval(0.4, 1.0, curve: Curves.easeIn);

class VelvetCurtainScreen extends StatefulWidget {
  const VelvetCurtainScreen({super.key, required this.onChanged});
  final VoidCallback onChanged;

  @override
  State<VelvetCurtainScreen> createState() => _VelvetCurtainScreenState();
}

class _VelvetCurtainScreenState extends State<VelvetCurtainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool showTap = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    widget.onChanged();
    showTap = false;
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double halfWidth = MediaQuery.of(context).size.width / 2;

    // Cache the fabric widget to avoid rebuilding it
    final leftFabric = const VelvetFabric();
    final rightFabric = const VelvetFabric();

    return GestureDetector(
      onTap: _toggleAnimation,
      child: Stack(
        children: [
          // LEFT CURTAIN PANEL - Isolated with RepaintBoundary
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: halfWidth,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return _CurtainPanel(
                    progress: _animation.value,
                    isLeft: true,
                    fabric: leftFabric,
                  );
                },
                child: leftFabric, // Pass as child to avoid rebuilding
              ),
            ),
          ),

          // RIGHT CURTAIN PANEL - Isolated with RepaintBoundary
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: halfWidth,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return _CurtainPanel(
                    progress: _animation.value,
                    isLeft: false,
                    fabric: rightFabric,
                  );
                },
                child: rightFabric, // Pass as child to avoid rebuilding
              ),
            ),
          ),

          if (showTap) ...[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Image.asset(
                  'assets/icons/tap_here.gif',
                  cacheHeight: 50,
                  cacheWidth: 50,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Tap to Start Show",
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1.5,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Extracted curtain panel widget for better performance
class _CurtainPanel extends StatelessWidget {
  final double progress;
  final bool isLeft;
  final Widget fabric;

  const _CurtainPanel({
    required this.progress,
    required this.isLeft,
    required this.fabric,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CurtainEdgePainter(
        progress: progress,
        isLeft: isLeft,
      ),
      child: ClipPath(
        clipper: SideCurtainClipper(
          progress: progress,
          isLeft: isLeft,
        ),
        child: fabric,
      ),
    );
  }
}

// --- WIDGET: The Fabric Texture ---
class VelvetFabric extends StatelessWidget {
  const VelvetFabric({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          // Repeating pattern of Dark -> Light -> Dark to simulate folds
          colors: [
            Colors.red.shade900,
            Colors.red.shade700, // Highlight (Fold top)
            Colors.red.shade900, // Shadow (Fold bottom)
            Colors.red.shade800,
            Colors.red.shade600, // Highlight
            Colors.red.shade900,
          ],
          // These stops dictate the width of the folds
          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
        ),
        // Removed boxShadow for better performance - shadows are expensive
        // The edge painter provides sufficient visual depth
      ),
    );
  }
}

// --- LOGIC: The Path Math (Shared by Clipper and Painter) ---
// We extracted the math here so both the Clipper (which cuts)
// and the Painter (which draws the shadow line) can use the EXACT same curve.
// Using cached Interval objects from the state class
Path getCurtainPath(Size size, double progress, bool isLeft) {
  final Path path = Path();
  final w = size.width;
  final h = size.height;

  // Use cached intervals to avoid object creation on every frame
  final double bottomOpenValue = _bottomInterval.transform(progress);
  final double topOpenValue = _topInterval.transform(progress);

  if (isLeft) {
    final double currentRightEdgeTop = w - (w * topOpenValue);
    final double currentRightEdgeBottom = w - (w * bottomOpenValue * 1.5);

    path.moveTo(0, 0);
    path.lineTo(currentRightEdgeTop, 0);
    path.quadraticBezierTo(
      currentRightEdgeTop,
      h * 0.6,
      currentRightEdgeBottom,
      h,
    );
    path.lineTo(0, h);
    path.close();
  } else {
    final double currentLeftEdgeTop = w * topOpenValue;
    final double currentLeftEdgeBottom = w * bottomOpenValue * 1.5;

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

class SideCurtainClipper extends CustomClipper<Path> {
  final double progress;
  final bool isLeft;

  SideCurtainClipper({required this.progress, required this.isLeft});

  @override
  Path getClip(Size size) {
    return getCurtainPath(size, progress, isLeft);
  }

  @override
  bool shouldReclip(SideCurtainClipper oldClipper) {
    // Only reclip if progress changed significantly (avoid micro-reclips)
    return (oldClipper.progress - progress).abs() > 0.001;
  }
}

// --- PAINTER: Draws the shadow/edge on the curve ---
class CurtainEdgePainter extends CustomPainter {
  final double progress;
  final bool isLeft;

  // Cache paint object to avoid recreating on every frame
  static final _paint = Paint()
    ..color = Colors.black.withOpacity(0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

  CurtainEdgePainter({required this.progress, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Get the exact same path used for clipping
    final Path path = getCurtainPath(size, progress, isLeft);

    // 2. Draw the path with cached paint
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CurtainEdgePainter oldDelegate) {
    // Only repaint if progress changed significantly (avoid micro-repaints)
    return (oldDelegate.progress - progress).abs() > 0.001;
  }
}
