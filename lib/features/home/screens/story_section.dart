import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';
import 'package:wedding_v1/widgets/lazy_image.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCFB), // Soft warm off-white base
        image: DecorationImage(
          // Paper texture is small and used as background, keep it loaded
          image: const AssetImage('assets/images/paper_texture.webp'),
          repeat: ImageRepeat.repeat,
          opacity: 0.4,
          fit: BoxFit.none,
          scale: 3.5,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 60 : 100,
              horizontal: isMobile ? 20 : 0,
            ),
            child: Column(
              children: [
                Text(
                  'Our Story',
                  style: KStyle.tTitleXXL.copyWith(
                    fontSize: isMobile ? 32 : 42,
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 200.ms),

                SizedBox(height: isMobile ? 32 : 120),

                // WRAPPER FOR LINE AND ITEMS
                Stack(
                  key: const ValueKey('story_stack_v2'), // Force rebuild
                  alignment: isMobile ? Alignment.topLeft : Alignment.topCenter,
                  children: [
                    // FADING LINE
                    Positioned(
                      top: isMobile ? 80 : 120,
                      bottom: 0,
                      left: isMobile ? 16 : 0, // 16px from left on mobile
                      right: isMobile ? null : 0,
                      child: Center(
                        child: CustomPaint(
                          size: const Size(2, double.infinity),
                          painter: _FadingLinePainter(isCentered: !isMobile),
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        _StoryItem(
                          year: 'How We Met',
                          text:
                              'In the early days of Facebook, a boy noticed a girl at the university hostel and did what any curious heart would do—he searched for her online. With no flirting skills at all, “Peter Phyoe IsGood” sent a message to “Candy Cho Lay”: “Hi, စားပီးပီလား”.\n\nFrom that small and funny beginning, days turned into nights of endless chats, sharing stories and dreams. Somewhere between those conversations, love quietly found us—before we even realized it. When it came time to choose our anniversary, we smiled at how unsure we were of the exact moment we fell in love. So we chose 12/02, the day of our very first date, and made it ours forever.',
                          isTextLeft: true,
                          imageA: 'assets/images/howwemet_2.webp',
                          imageB: 'assets/images/howwemet_1.webp',
                        ),

                        SizedBox(height: isMobile ? 80 : 120),

                        // CARD 2: How We Love
                        _StoryItem(
                          year: 'How We Love',
                          text:
                              'Our love grew quietly and patiently. From sharing simple meals to sharing dreams, we learned to find happiness in the smallest moments. Through every low and every high, we chose each other—again and again. Today, our love is a place of comfort, laughter, and understanding, where even a single look says everything.',
                          isTextLeft: false,
                          imageA: 'assets/images/howwelove_2.webp',
                          imageB: 'assets/images/howwelove_1.webp',
                        ),

                        SizedBox(height: isMobile ? 80 : 120),

                        // CARD 3: How He Proposed
                        _StoryItem(
                          year: 'How He Proposed',
                          text:
                              'Like many grooms, he thought a proposal simply meant a diamond ring—until he realized he had no idea how gold weights or diamond carats worked. After weeks of quiet research and careful planning, he found the perfect ring. But he soon learned that a proposal is about more than a ring—it’s about the moment, the place, and the people who make it special. With the help of close friends and a heart full of love, he finally asked the question he had been holding onto for years. She smiled, said yes, and in that moment, forever began.',
                          isTextLeft: true,
                          imageA: 'assets/images/howheproposed_1.webp',
                          imageB: 'assets/images/howheproposed_2.webp',
                        ),

                        SizedBox(height: isMobile ? 80 : 120),

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
      ),
    );
  }
}

class _StoryItem extends StatefulWidget {
  final String year;
  final String text;
  final bool isTextLeft;
  final String? imageA;
  final String? imageB;

  const _StoryItem({
    required this.year,
    required this.text,
    required this.isTextLeft,
    this.imageA,
    this.imageB,
  });

  @override
  State<_StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<_StoryItem> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    if (isMobile) {
      return VisibilityDetector(
        key: Key('story_mobile_${widget.year}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.1 && !_isVisible) {
            setState(() => _isVisible = true);
          }
        },
        child: Padding(
          padding: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT COLUMN: Heart
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    const SizedBox(height: 80), // Align heart with title top
                    Image.asset(
                          'assets/icons/heart_fill.png',
                          width: 24,
                          height: 24,
                        )
                        .animate(target: _isVisible ? 1 : 0)
                        .scale(delay: 300.ms, curve: Curves.elasticOut),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // RIGHT COLUMN: Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child:
                      Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 80),
                              Text(
                                widget.year,
                                style: KStyle.tTitleXL.copyWith(
                                  color: KStyle.cPrimary,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.text,
                                style: KStyle.tBodyM.copyWith(
                                  color: KStyle.cSecondaryText,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 40),
                              if (widget.imageA != null ||
                                  widget.imageB != null)
                                SizedBox(
                                  height: 320,
                                  child: _TiltedPhotoStack(
                                    isImageOnLeft: true,
                                    isVisible: _isVisible,
                                    imageA: widget.imageA,
                                    imageB: widget.imageB,
                                    isMobile: true,
                                  ),
                                ),
                            ],
                          )
                          .animate(target: _isVisible ? 1 : 0)
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.05, end: 0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final textWidget = Padding(
      padding: const EdgeInsets.only(
        top: 120,
        bottom: 40,
      ), // Align with heart top, add bottom breathing room
      child: Column(
        crossAxisAlignment: widget.isTextLeft
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.year,
            style: KStyle.tTitleXL.copyWith(
              color: KStyle.cPrimary,
              height: 1.0,
            ),
            textAlign: widget.isTextLeft ? TextAlign.right : TextAlign.left,
          ),
          const SizedBox(height: 16),
          Text(
            widget.text,
            style: KStyle.tBodyM.copyWith(
              color: KStyle.cSecondaryText,
              height: 1.6,
            ),
            textAlign: widget.isTextLeft ? TextAlign.right : TextAlign.left,
          ),
        ],
      ),
    );

    // Photos: 400px fixed height
    final photoWidget = _TiltedPhotoStack(
      isImageOnLeft: !widget.isTextLeft,
      isVisible: _isVisible,
      imageA: widget.imageA,
      imageB: widget.imageB,
    );

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
        crossAxisAlignment: CrossAxisAlignment
            .start, // Align to top for precise heart positioning
        children: [
          // LEFT COLUMN
          Expanded(
            child: widget.isTextLeft
                ? Padding(
                        padding: const EdgeInsets.only(
                          left: 0,
                          right: 20,
                        ), // Reduced gap to 20
                        child: textWidget,
                      )
                      .animate(target: _isVisible ? 1 : 0)
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.05, end: 0, duration: 600.ms)
                : Padding(
                    padding: const EdgeInsets.only(
                      right: 40,
                      top: 80,
                    ), // Added top: 80
                    child: photoWidget,
                  ),
          ),

          // MIDDLE COLUMN (Heart Icon)
          Container(
            width: 80,
            alignment: Alignment.topCenter, // Align to top
            padding: const EdgeInsets.only(top: 120), // 30% down (120px)
            child:
                Image.asset(
                      'assets/icons/heart_fill.png',
                      width: 32,
                      height: 32,
                    )
                    .animate(target: _isVisible ? 1 : 0)
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
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 0,
                        ), // Reduced gap to 20
                        child: textWidget,
                      )
                      .animate(target: _isVisible ? 1 : 0)
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: 0.05, end: 0, duration: 600.ms)
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 40,
                      top: 80,
                    ), // Added top: 80
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
  final String? imageA;
  final String? imageB;
  final bool isMobile;

  const _TiltedPhotoStack({
    required this.isImageOnLeft,
    required this.isVisible,
    this.imageA,
    this.imageB,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    // Large dimensions
    // Responsive dimensions
    final double w = isMobile ? 160 : 280;
    final double h = isMobile ? 180 : 340;

    // Slide direction based on side
    final double slideBegin = isMobile
        ? (isImageOnLeft ? -0.08 : 0.08)
        : (isImageOnLeft ? -0.15 : 0.15);

    return SizedBox(
      height: isMobile ? 250 : 400, // Reduced from 320
      child: Stack(
        clipBehavior: Clip.none,
        alignment: isMobile ? Alignment.centerLeft : Alignment.center,
        children: [
          // Image B (Back)
          // Move further away from front image to reduce overlap to ~20%
          Transform.translate(
                offset: Offset(
                  isMobile
                      ? 128
                      : (isImageOnLeft
                            ? 112
                            : -112), // 128px separation for 20% overlap
                  isMobile ? -25 : -45,
                ),
                child: Transform.rotate(
                  angle: 0.08,
                  child: Container(
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: imageB != null
                          ? LazyImage(
                              imagePath: imageB!,
                              fit: BoxFit.cover,
                              width: w,
                              height: h,
                            )
                          : Container(color: const Color(0xFFD9D9D9)),
                    ),
                  ),
                ),
              )
              .animate(target: isVisible ? 1 : 0)
              .fadeIn(
                duration: isMobile ? 1200.ms : 800.ms,
                delay: isMobile ? 200.ms : 200.ms,
              )
              .slideX(
                begin: slideBegin * 0.8,
                end: 0,
                duration: isMobile ? 1200.ms : 800.ms,
                curve: Curves.easeOut,
                delay: isMobile ? 200.ms : 200.ms,
              ),

          // Image A (Front)
          // Move to the right (if on right side) or left (if on left side) to reduce overlap
          Transform.translate(
                offset: Offset(
                  isMobile
                      ? 0
                      : (isImageOnLeft
                            ? -112
                            : 112), // Front at 0 to stay to the right
                  0,
                ),
                child: Transform.rotate(
                  angle: -0.12, // More prominent tilt
                  child: Container(
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF757575),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(6, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: imageA != null
                          ? LazyImage(
                              imagePath: imageA!,
                              fit: BoxFit.cover,
                              width: w,
                              height: h,
                            )
                          : Container(color: const Color(0xFF757575)),
                    ),
                  ),
                ),
              )
              .animate(target: isVisible ? 1 : 0)
              .fadeIn(
                duration: isMobile ? 1200.ms : 800.ms,
                delay: isMobile ? 200.ms : 200.ms,
              )
              .slideX(
                begin: slideBegin * 1.2,
                end: 0,
                duration: isMobile ? 1200.ms : 800.ms,
                curve: Curves.easeOut,
                delay: isMobile ? 200.ms : 200.ms,
              ),
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
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return VisibilityDetector(
      key: const Key('story_finale'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Floral Decoration - Top Left
          Positioned(
            top: -40,
            left: isMobile ? -20 : -60,
            child: LazyImage(
              imagePath: 'assets/images/floral_corner.png',
              width: isMobile ? 120 : 180,
            ).animate(target: _isVisible ? 1 : 0).fadeIn(duration: 1500.ms),
          ),

          // Floral Decoration - Bottom Right (Rotated)
          Positioned(
            bottom: -40,
            right: isMobile ? -20 : -60,
            child: Transform.rotate(
              angle: 3.14, // 180 degrees
              child: LazyImage(
                imagePath: 'assets/images/floral_corner.png',
                width: isMobile ? 120 : 180,
              ),
            ).animate(target: _isVisible ? 1 : 0).fadeIn(duration: 1500.ms),
          ),

          // Main Content
          Column(
            children: [
              const SizedBox(height: 60),

              Text(
                    'Finally ...',
                    style: KStyle.tTitleXXL.copyWith(
                      color: KStyle.cPrimary,
                      fontSize: isMobile ? 32 : 42,
                    ),
                  )
                  .animate(target: _isVisible ? 1 : 0)
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(height: isMobile ? 32 : 48),

              // Heart Image with Glow
              Container(
                    width: isMobile ? 240 : 400,
                    height: isMobile ? 240 : 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.125),
                          blurRadius: isMobile ? 30 : 40,
                          spreadRadius: isMobile ? 6 : 8,
                        ),
                      ],
                    ),
                    child:
                        LazyImage(
                              imagePath: 'assets/images/engaged.webp',
                              fit: BoxFit.contain,
                              width: isMobile ? 150 : 272,
                              height: isMobile ? 150 : 272,
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .moveY(
                              begin: 0,
                              end: -10,
                              duration: 2000.ms,
                              curve: Curves.easeInOut,
                            ), // Bobbing effect
                  )
                  .animate(target: _isVisible ? 1 : 0)
                  .fadeIn(duration: 1200.ms)
                  .scale(
                    curve: Curves.easeInOutCubic,
                    duration: 1200.ms,
                    begin: const Offset(0.8, 0.8),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(
                    duration: 3000.ms,
                    color: Colors.yellow.withOpacity(0.2),
                  ), // Shimmering glow

              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }
}

class _FadingLinePainter extends CustomPainter {
  final bool isCentered;

  _FadingLinePainter({this.isCentered = true});

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

    final double x = isCentered ? size.width / 2 : 0;

    canvas.drawLine(
      Offset(x, 0),
      Offset(x, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
