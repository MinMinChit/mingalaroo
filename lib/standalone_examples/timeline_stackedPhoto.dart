import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TimelineStackedPhotoDemo(),
  ));
}

/// A standalone demo screen for the Story Timeline Layout.
/// Demonstrates the precise alignment of text, timeline center, and staggered photo stacks.
class TimelineStackedPhotoDemo extends StatefulWidget {
  const TimelineStackedPhotoDemo({super.key});

  @override
  State<TimelineStackedPhotoDemo> createState() =>
      _TimelineStackedPhotoDemoState();
}

class _TimelineStackedPhotoDemoState extends State<TimelineStackedPhotoDemo> {
  // Simple toggle to replay animation
  bool _replay = true;

  void _triggerReplay() {
    setState(() => _replay = false);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _replay = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB), // Soft warm off-white
      floatingActionButton: FloatingActionButton(
        onPressed: _triggerReplay,
        child: const Icon(Icons.refresh),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: !_replay
                ? const SizedBox()
                : Column(
                    children: [
                      // ITEM 1: Text Left, Photos Right
                      const _TimelineRowItem(
                        year: "How We Met",
                        text:
                            "In the days of old, a boy met a girl. They exchanged glances, then messages, then dreams. From that small beginning, a story unfolded.",
                        isTextLeft: true,
                      ),

                      const SizedBox(height: 120),

                      // ITEM 2: Photos Left, Text Right
                      const _TimelineRowItem(
                        year: "How We Love",
                        text:
                            "Through every high and every low, we chose each other. Our love is a place of comfort, laughter, and understanding.",
                        // 🔑 FLIPPED LAYOUT
                        isTextLeft: false, 
                      ),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 📐 LAYOUT COMPONENT: TIMELINE ROW
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// 📐 LAYOUT COMPONENT: TIMELINE ROW (Pure Flutter Animation)
// -----------------------------------------------------------------------------

class _TimelineRowItem extends StatefulWidget {
  final String year;
  final String text;
  final bool isTextLeft;

  const _TimelineRowItem({
    required this.year,
    required this.text,
    required this.isTextLeft,
  });

  @override
  State<_TimelineRowItem> createState() => _TimelineRowItemState();
}

class _TimelineRowItemState extends State<_TimelineRowItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _heartScaleAnimation; // Added for the heart icon

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    // Heart scale with elastic effect, delayed slightly
    _heartScaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    );

    // Auto-start for demo purposes
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Text Widget Block
    final textWidget = Padding(
      padding: const EdgeInsets.only(top: 120, bottom: 40),
      child: Column(
        crossAxisAlignment:
            widget.isTextLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            widget.year,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB8860B),
              height: 1.0,
            ),
            textAlign: widget.isTextLeft ? TextAlign.right : TextAlign.left,
          ),
          const SizedBox(height: 16),
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.6,
            ),
            textAlign: widget.isTextLeft ? TextAlign.right : TextAlign.left,
          ),
        ],
      ),
    );

    // 2. Photo Stack Widget Block
    final photoWidget = _TiltedPhotoStack(
      isImageOnLeft: !widget.isTextLeft,
    );

    // 3. Main Row Layout
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT COLUMN (Flex 1)
          Expanded(
            child: widget.isTextLeft
                ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(-0.05, 0), end: Offset.zero)
                            .animate(_slideAnimation),
                        child: textWidget,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 40, top: 80),
                    child: photoWidget,
                  ),
          ),

          // MIDDLE COLUMN (Fixed 80px)
          SizedBox(
            width: 80,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // The Timeline Line
                Container(
                  width: 2,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE0E0E0), Color(0x00E0E0E0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.9],
                    ),
                  ),
                ),
                // The Heart Icon
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: ScaleTransition(
                    scale: _heartScaleAnimation,
                    child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 32),
                  ),
                ),
              ],
            ),
          ),

          // RIGHT COLUMN (Flex 1)
          Expanded(
            child: !widget.isTextLeft
                ? Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                            .animate(_slideAnimation),
                        child: textWidget,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 40, top: 80),
                    child: photoWidget,
                  ),
          ),
        ],
      ),
    );
  }
}


// -----------------------------------------------------------------------------
// 🖼️ COMPONENT: TILTED PHOTO STACK (Vector Replacement)
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// 🖼️ COMPONENT: TILTED PHOTO STACK (Vector Replacement)
// -----------------------------------------------------------------------------

class _TiltedPhotoStack extends StatefulWidget {
  final bool isImageOnLeft;

  const _TiltedPhotoStack({
    required this.isImageOnLeft,
  });

  @override
  State<_TiltedPhotoStack> createState() => _TiltedPhotoStackState();
}

class _TiltedPhotoStackState extends State<_TiltedPhotoStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));

    // Delayed start effect (cleaner than using .delay())
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double w = 280;
    const double h = 340;

    final double slideBegin = widget.isImageOnLeft ? -0.15 : 0.15;

    return SizedBox(
      height: 400,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // IMAGE B (BACK) - Darker Gray
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                // Back image slides in 80% distance
                begin: Offset(slideBegin * 0.8, 0),
                end: Offset.zero,
              ).animate(_slideAnimation),
              child: Transform.translate(
                offset: Offset(widget.isImageOnLeft ? 112 : -112, -45),
                child: Transform.rotate(
                  angle: 0.08, // Subtle tilt
                  child: Container(
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // IMAGE A (FRONT) - Lighter Gray
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                // Front image slides in 120% distance (faster visual)
                begin: Offset(slideBegin * 1.2, 0),
                end: Offset.zero,
              ).animate(_slideAnimation),
              child: Transform.translate(
                offset: Offset(widget.isImageOnLeft ? -112 : 112, 0),
                child: Transform.rotate(
                  angle: -0.12, // Stronger tilt
                  child: Container(
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(6, 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
