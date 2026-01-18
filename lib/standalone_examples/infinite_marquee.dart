import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InfiniteMarqueeDemo(),
  ));
}

/// A standalone demo screen for the Infinite Marquee Effect.
class InfiniteMarqueeDemo extends StatelessWidget {
  const InfiniteMarqueeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row 1: Left to Right
            _InfiniteMarqueeRow(
              isMovingRight: true,
              speedDuration: Duration(seconds: 20),
            ),
            SizedBox(height: 20),
            // Row 2: Right to Left
            _InfiniteMarqueeRow(
              isMovingRight: false,
              speedDuration: Duration(seconds: 25),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🎞️ PRESTO ANIMATION: INFINITE MARQUEE (Pure Flutter)
// -----------------------------------------------------------------------------

class _InfiniteMarqueeRow extends StatefulWidget {
  final bool isMovingRight;
  final Duration speedDuration;

  const _InfiniteMarqueeRow({
    required this.isMovingRight,
    required this.speedDuration,
  });

  @override
  State<_InfiniteMarqueeRow> createState() => _InfiniteMarqueeRowState();
}

class _InfiniteMarqueeRowState extends State<_InfiniteMarqueeRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // ⚙️ ENGINE: Constant Linear Motion
    _controller = AnimationController(
      vsync: this,
      duration: widget.speedDuration,
    )..repeat(); // Loop forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ⚙️ PALETTE: Soft Muted Colors
    final List<Color> colors = [
      const Color(0xFFE6E6FA), // Lavender
      const Color(0xFFF5DEB3), // Wheat
      const Color(0xFFADD8E6), // Light Blue
      const Color(0xFFFFB7C5), // Cherry Blossom
      const Color(0xFF98FB98), // Pale Green
      const Color(0xFFFFDAB9), // Peach Puff
      const Color(0xFFE0FFFF), // Light Cyan
      const Color(0xFFD8BFD8), // Thistle
    ];

    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate Slide Value (-0.0 to -1.0 implies moving one full 'segment' length)
          // Since we repeat the list 2 times in the row, one full segment = 50% of content width.
          // Wait, 'slideX' logic usually is relative to child size.
          
          // Let's implement exact percentage sliding manually.
          // If moving right: We start at x = -0.25 (hidden left part) and move to 0.0
          // If moving left: We start at x = 0.0 and move to -0.25
          
          // Actually, standard tactic:
          // We have a row of width W.
          // We want to scroll W/2 distance, then reset seamlessly.
          // So we build content [A][A].
          // We scroll from 0 to -Size(A).
          
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate Slide Value
          double t = _controller.value;
          double slidePercent;
          
          if (widget.isMovingRight) {
             // -0.5 to 0.0
             slidePercent = -0.5 + (0.5 * t);
          } else {
             // 0.0 to -0.5
             slidePercent = -0.5 * t;
          }

          // 🔑 FIX: Wrap in SingleChildScrollView with horizontal scrolling DISABLED visually
          // but enabled logically to allow the Row to exist beyond the screen bounds.
          // Actually, 'OverflowBox' or 'SingleChildScrollView' is needed because 'Row' tries to respect constraints.
          
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(), // Prevent manual scroll
            child: FractionalTranslation(
              translation: Offset(slidePercent, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Hug content
                children: [
                  // SEGMENT 1
                  ...colors.map((c) => _ColorTile(color: c)),
                  // SEGMENT 2 (Duplicate for seamless loop)
                  ...colors.map((c) => _ColorTile(color: c)),
                ],
              ),
            ),
          );
        },
      ),
    );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🎨 COMPONENT: COLOR TILE (Replaces Photo)
// -----------------------------------------------------------------------------

class _ColorTile extends StatelessWidget {
  final Color color;
  const _ColorTile({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8), // Gap
      width: 250, // Aspect ratio similar to photos
      height: 350,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        // Subtle inset gloss
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: Text(
          "#${color.value.toRadixString(16).substring(2).toUpperCase()}",
          style: TextStyle(
            color: Colors.black.withOpacity(0.3),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
