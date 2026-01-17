import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';

class SpouseNameSection extends StatefulWidget {
  const SpouseNameSection({super.key});

  @override
  State<SpouseNameSection> createState() => _SpouseNameSectionState();
}

class _SpouseNameSectionState extends State<SpouseNameSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController; // For slow background panning

  bool _isVisible = false;
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Extremely slow speed
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return VisibilityDetector(
          key: const Key('spouse_name_section'),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.6 && !_isVisible) {
              setState(() {
                _isVisible = true;
              });
            }
          },
          child: MouseRegion(
            onHover: (event) {
              setState(() {
                _mousePos = event.localPosition;
              });
            },
            child: Stack(
              children: [
                // BACKGROUND LAYERS
                Positioned.fill(child: _buildAnimatedBackground()),

                // CONTENT
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 120),
                  width: double.infinity,
                  child: Column(
                    children: [
                      buildNameJob(
                            'Aung Kyaw Phyo',
                            '''B.C.Sc (Software Engineering) (UIT)\nson of U Maung Maung Lwin and Daw Khin San Yu''',
                          )
                          .animate(target: _isVisible ? 1 : 0)
                          .fadeIn(duration: 1200.ms, curve: Curves.easeOut),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: _buildTiltingHeart(context, constraints.maxWidth),
                      ),
                      buildNameJob(
                            'Cho Phoo Paing',
                            '''B.C.Sc (Software Engineering) (UCSY)\nonly daughter of U Soe Paing and Daw Yi Yi Cho''',
                          )
                          .animate(target: _isVisible ? 1 : 0)
                          .fadeIn(duration: 1200.ms, curve: Curves.easeOut),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTiltingHeart(BuildContext context, double maxWidth) {
    final double centerX = maxWidth / 2;
    // Approximate center Y
    const double centerY = 400; 

    final double dx = _mousePos.dx - centerX;
    final double dy = _mousePos.dy - centerY;
    
    // Max tilt
    const double maxTilt = 0.5; 

    // Reflection calculation
    final double reflectX = (_mousePos.dx / maxWidth).clamp(0, 1) * 2 - 1; 
    final double reflectY = (_mousePos.dy / 800).clamp(0, 1) * 2 - 1; 

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective
        ..rotateX(-dy * 0.001 * maxTilt) 
        ..rotateY(dx * 0.001 * maxTilt),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Drawn Heart Base
          CustomPaint(
            size: const Size(48, 48),
            painter: _HeartPainter(color: Colors.red),
          ),
          
          // Glossy Reflection Overlay (Clipped)
          ClipPath(
            clipper: const _HeartClipper(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-reflectX, -reflectY),
                  radius: 1.0, 
                  colors: [
                    Colors.white.withOpacity(0.5), 
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
  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Solid dark base
        Container(color: KStyle.cPrimary),

        // Layer 1: Base Background at 8% Opacity (Reverted to original subtle visibility)
        _buildMovingImage(opacity: 0.08),
      ],
    );
  }

  Widget _buildMovingImage({required double opacity}) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        // Panning from -5% to +5% of width to create movement without massive cropping
        final offset = (_bgController.value - 0.5) * 50; 
        
        return Transform.translate(
          offset: Offset(offset, 0),
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              'assets/images/name_bg.webp',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      },
    );
  }

  Column buildNameJob(String name, String job) {
    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: KStyle.tTitleXXL.copyWith(color: KStyle.cWhite),
        ),
        const SizedBox(height: 8),
        Text(
          job,
          textAlign: TextAlign.center,
          style: KStyle.tBodyS.copyWith(color: KStyle.cWhite.withOpacity(0.5), height: 1.5),
        ),
      ],
    );
  }
}

class _HeartPainter extends CustomPainter {
  final Color color;
  _HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = _HeartClipper.getHeartPath(size);
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
