import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PremiumPaperStatsDemo(),
  ));
}

/// A standalone demo screen for "Premium Paper" texture and sorting.
class PremiumPaperStatsDemo extends StatelessWidget {
  const PremiumPaperStatsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFE5E5E0), // Concrete/Desk background
      body: PremiumPaperDisplay(), // Use the new Split Screen widget
    );
  }
}

// -----------------------------------------------------------------------------
// 🃏 PRESTO ANIMATION: SORTING CARD DECK
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// 📜 PRESTO ANIMATION: PREMIUM PAPER TEXTURE
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// 📜 PRESTO ANIMATION: SPLIT SCREEN COMPARISON
// -----------------------------------------------------------------------------

class PremiumPaperDisplay extends StatelessWidget {
  const PremiumPaperDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // -----------------------------------------------------------
        // LEFT HALF: Asset Based (Actual Image)
        // -----------------------------------------------------------
        // -----------------------------------------------------------
        // LEFT HALF: Asset Based (Actual Story Section Logic)
        // -----------------------------------------------------------
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            // 1. REPLICATING STORY SECTION BACKGROUND LOGIC EXACTLY
            decoration: const BoxDecoration(
              color: Color(0xFFFDFCFB), // Soft warm off-white base
              image: DecorationImage(
                image: AssetImage('assets/images/paper_texture.webp'),
                repeat: ImageRepeat.repeat,
                opacity: 0.4,
                fit: BoxFit.none,
                scale: 3.5,
              ),
            ),
            child: const Center(
              child: Text(
                "Paper Image\n(Tiled Background)",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ),

        // DIVIDER
        Container(width: 1, color: Colors.grey.shade400),

        // -----------------------------------------------------------
        // MIDDLE: Control (Solid Color Only)
        // -----------------------------------------------------------
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFFDFCFB), // Soft warm off-white base (Same as others)
            child: const Center(
              child: Text(
                "Control\n(Solid Color)",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ),

        // DIVIDER
        Container(width: 1, color: Colors.grey.shade400),
        
        // -----------------------------------------------------------
        // RIGHT HALF: Vector Paper Background (Generated Texture)
        // -----------------------------------------------------------
        Expanded(
                  // We wrap the PaperSheet logic into a full container here
          child: ClipRect( 
            child: CustomPaint(
              painter: _PaperGrainPainter(), // Now draws background color + texture
              foregroundPainter: _PaperEdgeDimmer(),
              child: const SizedBox( // Container no longer needs color
                 width: double.infinity,
                 height: double.infinity,
                 child: Center(
                  child: Text(
                    "Code Generated\n(Vector Texture)",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ... (PaperSheet class remains if used elsewhere, but we are fixing the Split Screen directly above) ...

/// Draws a complex "Heavy Linen" style grain texture.
class _PaperGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 0. DRAW BACKGROUND COLOR FIRST
    final paint = Paint()..color = const Color(0xFFFDFCFB); // Soft warm off-white
    canvas.drawRect(Offset.zero & size, paint);

    final Random rng = Random(1337); 

    // 1. LINEN WEAVE (Structure) - Denser
    paint.strokeWidth = 1.0;
    
    // Horizontal Lines (Step 2.0)
    for (double y = 0; y < size.height; y += 2) {
      if (rng.nextDouble() > 0.6) continue; // More frequent lines

      paint.color = Colors.black.withOpacity(0.01); // 1% USER Request
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertical Lines (Step 2.0)
    for (double x = 0; x < size.width; x += 2) {
      if (rng.nextDouble() > 0.6) continue; 

      paint.color = Colors.black.withOpacity(0.01);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // 2. DIAGONAL FABRIC GRAIN (New Layer)
    // Simulates the twist of the fiber
    for (int i = 0; i < 400; i++) {
        double startX = rng.nextDouble() * size.width;
        double startY = rng.nextDouble() * size.height;
        // Draw short diagonal scratch
        paint.color = Colors.black.withOpacity(0.008); // 0.8% USER Request
        paint.strokeWidth = 1.5;
        canvas.drawLine(Offset(startX, startY), Offset(startX + 5, startY + 5), paint);
    }

    // 3. ORGANIC NOISE (Texture)
    
    // Dark Fibers
    for (int i = 0; i < 8000; i++) {
      double x = rng.nextDouble() * size.width;
      double y = rng.nextDouble() * size.height;
      
      paint.color = Colors.black.withOpacity(0.02); // 2% USER Correction
      // Use small circles for grit
      canvas.drawCircle(Offset(x, y), rng.nextDouble() * 0.9 + 0.2, paint);
    }
    
    // Light Fibers (Highlights)
    for (int i = 0; i < 4000; i++) {
       double x = rng.nextDouble() * size.width;
       double y = rng.nextDouble() * size.height;
       
       paint.color = Colors.white.withOpacity(0.06); // 6% USER Request
       canvas.drawCircle(Offset(x, y), rng.nextDouble() * 1.2 + 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Adds a subtle gradient vignette.
class _PaperEdgeDimmer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.08), // Increased to 0.08
        ],
        stops: const [0.6, 1.0], // Start earlier for more pronounced depth
        radius: 1.2,
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
