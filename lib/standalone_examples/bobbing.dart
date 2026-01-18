import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BobbingDemo(),
  ));
}

/// A standalone demo screen for the Bobbing Text and Interactive Clouds.
class BobbingDemo extends StatelessWidget {
  const BobbingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100], // Darker Blue to see white clouds
      body: const Center(
        child: InteractiveBobbingScene(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ☁️ PRESTO ANIMATION: BOBBING TEXT & REACTIVE CLOUDS
// -----------------------------------------------------------------------------

class InteractiveBobbingScene extends StatefulWidget {
  const InteractiveBobbingScene({super.key});

  @override
  State<InteractiveBobbingScene> createState() => _InteractiveBobbingSceneState();
}

class _InteractiveBobbingSceneState extends State<InteractiveBobbingScene>
    with TickerProviderStateMixin {
  late AnimationController _bobController;
  late Animation<double> _bobAnimation;

  @override
  void initState() {
    super.initState();

    // ⚙️ ENGINE 1: VERTICAL BOBBING (Infinite Loop)
    _bobController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    
    _bobAnimation = CurvedAnimation(
      parent: _bobController,
      curve: Curves.easeInOut,
    );

    _bobController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ⚙️ CONFIG: Bob Physics
    const double bobDistance = 15.0;

    // Use a fixed frame to simulate the "Hero Section" area.
    // This ensures Positioned widgets have a definite boundary to be placed against.
    return SizedBox(
      width: 600,
      height: 600, 
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, // 🔑 Prevent text from being cut off if it bobs outside
        children: [
          // 1. CLOUD TOP (Reactive) - Positioned relative to the 600x600 box
          const Positioned(
            top: 50,
            left: 50, // Added left to ensure it's not centered and blocked
            child: _ReactiveCloud(
              width: 140, 
              color: Colors.white,
            ),
          ),

          // 2. BOBBING TEXT (The Main Character)
          AnimatedBuilder(
            animation: _bobAnimation,
            builder: (context, child) {
              final double dy = _bobAnimation.value * bobDistance;
              return Transform.translate(
                offset: Offset(0, dy), 
                child: child,
              );
            },
            child: Container(
              // Add padding to ensure the font's large loops aren't clipped by its own bounding box
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Text(
                'Floating',
                textAlign: TextAlign.center,
                style: GoogleFonts.greatVibes(
                  fontSize: 120, // Larger size
                  height: 1.2, // Increased line height to prevent vertical clipping
                  color: const Color(0xFFFFB832),
                  letterSpacing: 2.0,
                  shadows: [
                    const Shadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. CLOUD BOTTOM (Reactive)
          const Positioned(
            bottom: 80,
            right: 50, // Put on right side
            child: _ReactiveCloud(
              width: 180,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}


// -----------------------------------------------------------------------------
// 🌤️ COMPONENT: REACTIVE MOUSE CLOUD
// -----------------------------------------------------------------------------

/// A cloud shape that reacts dramatically (tilts, shrinks, moves) when hovered.
class _ReactiveCloud extends StatefulWidget {
  final double width;
  final Color color;
  final Offset baseOffset;

  const _ReactiveCloud({
    required this.width,
    required this.color,
    this.baseOffset = Offset.zero,
  });

  @override
  State<_ReactiveCloud> createState() => _ReactiveCloudState();
}

class _ReactiveCloudState extends State<_ReactiveCloud> {
  bool _isHovering = false;
  
  // Random Reactivity State
  double _randomScale = 1.0;
  double _randomRotate = 0.0;
  Offset _randomOffset = Offset.zero;
  final Random _rng = Random();

  void _triggerRandomReaction() {
    setState(() {
      _isHovering = true;
      // 🎲 RANDOM BEHAVIOR GENERATOR
      // 1. Scale: Either shrink (0.8) or grow (1.2)
      _randomScale = _rng.nextBool() ? 1.2 : 0.8;
      
      // 2. Rotate: Tilt left or right (-0.2 to 0.2 rads)
      _randomRotate = (_rng.nextDouble() - 0.5) * 0.4;
      
      // 3. Slide: Move vertically or horizontally 20px
      _randomOffset = Offset(
        (_rng.nextDouble() - 0.5) * 40,
        (_rng.nextDouble() - 0.5) * 40,
      );
    });
  }

  void _resetReaction() {
    setState(() {
      _isHovering = false;
      // Reset logic handled by implicit animation to 1.0/0.0
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _triggerRandomReaction(),
      onExit: (_) => _resetReaction(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut, // Bouncy reaction
        transform: Matrix4.identity()
          ..translate(
            widget.baseOffset.dx + (_isHovering ? _randomOffset.dx : 0),
            widget.baseOffset.dy + (_isHovering ? _randomOffset.dy : 0),
          )
          ..scale(_isHovering ? _randomScale : 1.0)
          ..rotateZ(_isHovering ? _randomRotate : 0.0),
        
        child: CustomPaint(
          size: Size(widget.width, widget.width * 0.6),
          painter: _CloudPainter(color: widget.color),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🎨 VECTOR ASSETS
// -----------------------------------------------------------------------------

class _CloudPainter extends CustomPainter {
  final Color color;
  _CloudPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    
    // Simple 3-Circle Cloud
    final Path path = Path();
    
    // Left Bump
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.25, size.height * 0.6), 
      radius: size.width * 0.25,
    ));
    
    // Center Bump (Larger)
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.55, size.height * 0.45), 
      radius: size.width * 0.35,
    ));
    
    // Right Bump
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.8, size.height * 0.65), 
      radius: size.width * 0.2,
    ));
    
    // Flat Bottom Fill
    path.addRect(Rect.fromLTWH(
      size.width * 0.2, 
      size.height * 0.6, 
      size.width * 0.6, 
      size.height * 0.25
    ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
