import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ParallaxDemo(),
  ));
}

/// A standalone demo screen for the Scroll Parallax effect.
class ParallaxDemo extends StatefulWidget {
  const ParallaxDemo({super.key});

  @override
  State<ParallaxDemo> createState() => _ParallaxDemoState();
}

class _ParallaxDemoState extends State<ParallaxDemo> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // THE HERO SECTION
            SizedBox(
              height: size.height * 0.85, // 85% Viewport height
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                   // 1. BACKGROUND PARALLAX (Mountains & Sky)
                  _ParallaxLayer(
                    scrollController: _scrollController,
                    // ⚙️ CONFIG: Physics (Background moves slower/recedes)
                    // Scale starts higher (1.6) and shrinks rapidly (0.6 per unit)
                    // This creates a "Zoom Out" feeling as if mountains are far away.
                    scaleBuilder: (t) => 1.6 - 0.6 * t, 
                    child: const _VectorBackground(),
                  ),

                  // 2. FOREGROUND PARALLAX (The Couple)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _ParallaxLayer(
                      scrollController: _scrollController,
                      // ⚙️ CONFIG: Physics (Foreground moves closer/zooms)
                      // Scale starts at 1.0 and Grows rapidly (0.5 per unit)
                      // This creates a "Zoom In" feeling as if we are walking past them.
                      scaleBuilder: (t) => 1.0 + 0.5 * t,
                      child: const FractionallySizedBox(
                        heightFactor: 0.6, // Couple takes 60% of hero height
                        child: _VectorCouple(),
                      ),
                    ),
                  ),
                  
                  // 3. STATIC OVERLAY (Gradient fade at bottom)
                  // Matches hero_section.dart lines 103-118 logic but flipped/adjusted as needed.
                   Align(
                    alignment: Alignment.topCenter,
                     child: Container(
                       height: 150,
                       decoration: BoxDecoration(
                         gradient: LinearGradient(
                           begin: Alignment.topCenter,
                           end: Alignment.bottomCenter,
                           colors: [
                             Colors.white.withOpacity(0.5),
                             Colors.transparent,
                           ],
                         ),
                       ),
                     ),
                   ),
                ],
              ),
            ),

            // SCROLLABLE CONTENT BELOW
            Container(
              height: 1000, // Long scroll area
              color: Colors.white,
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Text(
                    "Keep Scrolling...",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Notice how the mountains and the couple move at different speeds?",
                     style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const Divider(height: 100),
                  // Mock content blocks
                  for (int i = 0; i < 5; i++)
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      height: 100,
                      color: Colors.grey[100],
                      alignment: Alignment.center,
                      child: Text("Content Block ${i+1}"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 📐 MATH: PARALLAX CALCULATOR
// -----------------------------------------------------------------------------

class _ParallaxLayer extends StatelessWidget {
  final ScrollController scrollController;
  final Widget child;
  final double Function(double t) scaleBuilder;

  const _ParallaxLayer({
    required this.scrollController,
    required this.scaleBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final double scrollOffset =
            scrollController.hasClients ? scrollController.offset : 0.0;

        // Normalize scroll: 0.0 at top, 1.0 after 300px of scrolling
        final double t = (scrollOffset / 300).clamp(0.0, 1.0);
        
        // Calculate physics
        final double scale = scaleBuilder(t);

        return Transform.scale(
          scale: scale,
          alignment: Alignment.bottomCenter, // Anchor at bottom usually
          child: child,
        );
      },
      child: child, // Pass the static graphic to prevent rebuilds
    );
  }
}

// -----------------------------------------------------------------------------
// 🎨 VECTOR ASSETS (CODE GENERATED)
// -----------------------------------------------------------------------------

/// Replaces `bg_hero.webp`
class _VectorBackground extends StatelessWidget {
  const _VectorBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.lightBlue[50], // Sky Base
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Sun
          Positioned(
            top: 50,
            right: 50,
            child: Container(
              width: 100, 
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber[100],
                boxShadow: [
                  BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 40, spreadRadius: 20),
                ]
              ),
            ),
          ),
          
          // Back Mountains
          Positioned(
            bottom: 100,
            left: -100,
            right: -100,
            height: 400,
            child: CustomPaint(painter: _MountainPainter(color: Colors.blueGrey[100]!)),
          ),
          
          // Front Mountains
          Positioned(
            bottom: 0,
            left: -50,
            right: -50,
            height: 250,
            child: CustomPaint(painter: _MountainPainter(color: Colors.blueGrey[300]!, offset: 150)),
          ),
        ],
      ),
    );
  }
}

/// Simple triangular painter for mountains
class _MountainPainter extends CustomPainter {
  final Color color;
  final double offset;

  _MountainPainter({required this.color, this.offset = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    
    // Draw 3 peaks
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.3 + offset, size.height * 0.2); // Peak 1
    path.lineTo(size.width * 0.6 + offset, size.height * 0.8); // Valley
    path.lineTo(size.width * 0.8 + offset, size.height * 0.1); // Peak 2
    path.lineTo(size.width + 100, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Replaces `couple_hero.webp`
class _VectorCouple extends StatelessWidget {
  const _VectorCouple();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Just to be safe with constraints, though usually not needed here
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // GROOM (Mannequin)
          _buildMannequin(isGroom: true),
          const SizedBox(width: 20),
          // BRIDE (Mannequin)
          _buildMannequin(isGroom: false),
        ],
      ),
    );
  }

  Widget _buildMannequin({required bool isGroom}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Head
        Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE0B2), // Skin tone
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        const SizedBox(height: 5),
        // Body
        Container(
          width: 80,
          height: 200, // Adjusted height
          decoration: BoxDecoration(
            color: isGroom ? Colors.black87 : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              if (!isGroom) 
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0,5)),
            ],
          ),
          child: isGroom 
            ? Column( // Tuxedo details
                children: [
                  Container(width: 20, height: 60, color: Colors.white), // Shirt
                ],
              )
            :  null, // Minimalist bride dress
        ),
      ],
    );
  }
}
