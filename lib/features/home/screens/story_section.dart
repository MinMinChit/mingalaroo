import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              Text(
                'Our Story',
                style: KStyle.tTitleXXL.copyWith(fontSize: 42),
              ).animate().fadeIn(duration: 800.ms, delay: 200.ms),

              const SizedBox(height: 120),

              // WRAPPER FOR LINE AND ITEMS
              Stack(
                key: const ValueKey('story_stack_v2'), // Force rebuild
                alignment: Alignment.topCenter,
                children: [
                  // CENTER FADING LINE
                  // Starts from top: 120 (matching the first heart position)
                  Positioned(
                    top: 120, 
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CustomPaint(
                        size: const Size(2, double.infinity),
                        painter: _FadingLinePainter(),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      // CARD 1: 2015 (Text Left, Images Right)
                      _StoryItem(
                        year: '2015',
                        text: 'First met on one hot summer train ride. Who would have thought we would be spending next years together.',
                        isTextLeft: true,
                      ),

                      const SizedBox(height: 120),

                      // CARD 2: 2017 (Text Right, Images Left)
                      _StoryItem(
                        year: '2017',
                        text: 'From strangers sharing a seat to soulmates sharing a life. Every laugh brought us closer, every moment became a memory.',
                        isTextLeft: false,
                      ),

                      const SizedBox(height: 120),

                      // CARD 3: 2019 (Text Left, Images Right)
                      _StoryItem(
                        year: '2019',
                        text: 'Growing together through seasons of change, finding home in each other’s presence and strength in our shared dreams.',
                        isTextLeft: true,
                      ),

                      const SizedBox(height: 120),

                      // FINALE CARD
                      const _FinaleItem(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryItem extends StatefulWidget {
  final String year;
  final String text;
  final bool isTextLeft;

  const _StoryItem({
    required this.year,
    required this.text,
    required this.isTextLeft,
  });

  @override
  State<_StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<_StoryItem> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    // Calculated alignment to match heart position:
    // Container Height: 400. Center: 200.
    // Heart Top: 120. Heart Center: ~136.
    // Offset: 136 - 200 = -64px.
    // Alignment Y: -64 / 200 = -0.32.
    final textWidget = Container(
      height: 400,
      alignment: Alignment(widget.isTextLeft ? 1.0 : -1.0, -0.32),
      child: Column(
        crossAxisAlignment: widget.isTextLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.year,
            style: KStyle.tTitleXL.copyWith(color: KStyle.cPrimary),
            textAlign: widget.isTextLeft ? TextAlign.right : TextAlign.left,
          ),
          const SizedBox(height: 16),
          Text(
            widget.text,
            style: KStyle.tBodyL.copyWith(color: KStyle.cSecondaryText, height: 1.6),
            textAlign: widget.isTextLeft ? TextAlign.right : TextAlign.left,
          ),
        ],
      ),
    );

    // Photos: 400px fixed height
    final photoWidget = _TiltedPhotoStack(isImageOnLeft: !widget.isTextLeft, isVisible: _isVisible);

    return VisibilityDetector(
      key: Key('story_${widget.year}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top for precise heart positioning
        children: [
          // LEFT COLUMN
          Expanded(
            child: widget.isTextLeft 
              ? Padding(
                  padding: const EdgeInsets.only(left: 0, right: 100), // Increased Gap to 100
                  child: textWidget,
                )
                .animate(target: _isVisible ? 1 : 0)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.05, end: 0, duration: 600.ms)
              : Padding(
                  padding: const EdgeInsets.only(right: 40), // Photo on Left, gap on Right (towards center)
                  child: photoWidget,
                ),
          ),

          // MIDDLE COLUMN (Heart Icon)
          Container(
            width: 80, 
            height: 400, 
            alignment: Alignment.topCenter, // Align to top
            padding: const EdgeInsets.only(top: 120), // 30% down (120px)
            child: Image.asset(
              'assets/icons/heart_fill.png',
              width: 32, 
              height: 32,
            ).animate(target: _isVisible ? 1 : 0)
            .scale(
              delay: 300.ms,
              duration: 1500.ms, // Slow speed
              curve: Curves.elasticOut, // Jump out effect
              begin: const Offset(0.0, 0.0), 
              end: const Offset(1.0, 1.0),
            ),
          ),

          // RIGHT COLUMN
          Expanded(
             child: !widget.isTextLeft 
              ? Padding(
                  padding: const EdgeInsets.only(left: 100, right: 0), // Increased Gap
                  child: textWidget,
                )
                .animate(target: _isVisible ? 1 : 0)
                .fadeIn(duration: 600.ms)
                .slideX(begin: 0.05, end: 0, duration: 600.ms)
              : Padding(
                  padding: const EdgeInsets.only(left: 40), // Photo on Right, gap on Left (towards center)
                  child: photoWidget,
                ),
          ),
        ],
      ),
    );
  }
}

class _TiltedPhotoStack extends StatelessWidget {
  final bool isImageOnLeft;
  final bool isVisible;

  const _TiltedPhotoStack({
    required this.isImageOnLeft,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    // Large dimensions
    const double w = 280;
    const double h = 340;
    
    // Slide direction based on side
    final double slideBegin = isImageOnLeft ? -0.15 : 0.15;

    return SizedBox(
      height: 400, // Enough height for the tilt and offsets
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Image B (Back)
          // Extruded Top (38px) and Left/Right (48px towards center)
          Positioned(
            top: (400 - h) / 2 - 38, // Centered base minus 38 extrusion up
            // Align relative to center
            left: isImageOnLeft 
                ? (MediaQuery.sizeOf(context).width > 0 ? null : null)
                : null,
            // Simply use transform translate for easier offset from center
            child: Transform.translate(
              offset: Offset(
                isImageOnLeft ? 48 : -48, // Increased extrusion towards center
                -38, // Towards top
              ),
              child: Transform.rotate(
                angle: 0.05, // +3 deg (tilted downwards to right)
                child: Container(
                  width: w,
                  height: h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9), // Lighter grey
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .animate(target: isVisible ? 1 : 0)
          .fadeIn(duration: 600.ms, delay: 200.ms) // 2nd
          .slideX(begin: slideBegin, end: 0, duration: 600.ms, curve: Curves.easeOutBack, delay: 200.ms),

          // Image A (Front)
          // Tilted downwards to left (-6 deg)
          // More prominent tilt
          Transform.rotate(
            angle: -0.10, // -6 deg
            child: Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: const Color(0xFF757575), // Darker grey
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
            ),
          )
          .animate(target: isVisible ? 1 : 0)
          .fadeIn(duration: 600.ms, delay: 100.ms) // 1st
          .slideX(begin: slideBegin, end: 0, duration: 600.ms, curve: Curves.easeOutBack, delay: 100.ms),
        ],
      ),
    );
  }
}

class _FinaleItem extends StatefulWidget {
  const _FinaleItem();

  @override
  State<_FinaleItem> createState() => _FinaleItemState();
}

class _FinaleItemState extends State<_FinaleItem> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('story_finale'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Column(
        children: [
          // Removed heart icon

          const SizedBox(height: 60),

          Text(
            'Finally ...',
            style: KStyle.tTitleXXL.copyWith(color: KStyle.cPrimary),
          ).animate(target: _isVisible ? 1 : 0).fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 48),

          // Heart Image with Glow (Reduced to 400)
          Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Using circle for glow distribution
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.125), // Reduced by 50%
                  blurRadius: 40, // Reduced by 20%
                  spreadRadius: 8, // Reduced by 20%
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/engaged.webp',
              fit: BoxFit.contain,
              width: 272,
              height: 272,
              alignment: Alignment.center,
            ),
          ).animate(target: _isVisible ? 1 : 0).fadeIn(duration: 1200.ms).scale(
            curve: Curves.easeInOutCubic, // Even more graceful
            duration: 1200.ms,
            begin: const Offset(0.8, 0.8),
          ),
        ],
      ),
    );
  }
}

class _FadingLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
           Color(0xFFE0E0E0), // Visible grey at top
           Color(0x00E0E0E0), // Transparent at bottom
        ],
        stops: [0.0, 0.9],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
