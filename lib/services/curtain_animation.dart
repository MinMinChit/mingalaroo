import 'package:flutter/material.dart';

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

    return GestureDetector(
      onTap: _toggleAnimation,
      child: Stack(
        children: [
          // 2. LEFT CURTAIN PANEL
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: halfWidth,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  // Draws the shadow/trim on the edge
                  foregroundPainter: CurtainEdgePainter(
                    progress: _animation.value,
                    isLeft: true,
                  ),
                  child: ClipPath(
                    clipper: SideCurtainClipper(
                      progress: _animation.value,
                      isLeft: true,
                    ),
                    child: const VelvetFabric(), // The Red Texture
                  ),
                );
              },
            ),
          ),

          // 3. RIGHT CURTAIN PANEL
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: halfWidth,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  foregroundPainter: CurtainEdgePainter(
                    progress: _animation.value,
                    isLeft: false,
                  ),
                  child: ClipPath(
                    clipper: SideCurtainClipper(
                      progress: _animation.value,
                      isLeft: false,
                    ),
                    child: const VelvetFabric(),
                  ),
                );
              },
            ),
          ),

          if (showTap) ...[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Image.asset(
                  'assets/icons/tap_here.gif',
                  cacheHeight: 50,
                  cacheWidth: 50,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Text(
                  "Tap to Start Show",
                  style: TextStyle(color: Colors.white70, letterSpacing: 1.5),
                ),
              ),
            ),
          ],
        ],
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

// --- LOGIC: The Path Math (Shared by Clipper and Painter) ---
// We extracted the math here so both the Clipper (which cuts)
// and the Painter (which draws the shadow line) can use the EXACT same curve.
Path getCurtainPath(Size size, double progress, bool isLeft) {
  final Path path = Path();
  final w = size.width;
  final h = size.height;

  final double bottomOpenValue = Interval(
    0.0,
    0.8,
    curve: Curves.easeIn,
  ).transform(progress);
  final double topOpenValue = Interval(
    0.4,
    1.0,
    curve: Curves.easeIn,
  ).transform(progress);

  if (isLeft) {
    double currentRightEdgeTop = w - (w * topOpenValue);
    double currentRightEdgeBottom = w - (w * bottomOpenValue * 1.5);

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
    return oldClipper.progress != progress;
  }
}

// --- PAINTER: Draws the shadow/edge on the curve ---
class CurtainEdgePainter extends CustomPainter {
  final double progress;
  final bool isLeft;

  CurtainEdgePainter({required this.progress, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Get the exact same path used for clipping
    final Path path = getCurtainPath(size, progress, isLeft);

    // 2. Define a paint for the shadow/edge
    final Paint paint = Paint()
      ..color = Colors.black
          .withOpacity(0.5) // Dark shadow color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0); // Blur it

    // 3. Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurtainEdgePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
