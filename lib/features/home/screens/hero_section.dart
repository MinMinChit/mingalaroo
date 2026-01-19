import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wedding_v1/constants/color_style.dart';
import 'package:wedding_v1/widgets/divider.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.scrollController,
    required this.startAnimate,
  });

  final ScrollController scrollController;
  final bool startAnimate;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _imagesCached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_imagesCached) {
      precacheImage(
        const AssetImage('assets/images/bg_hero.webp'),
        context,
      );
      precacheImage(
        const AssetImage('assets/images/couple_hero.webp'),
        context,
      );
      _imagesCached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = MediaQuery.sizeOf(context);
        final double width = constraints.maxWidth;
        final bool isMobile = width < 600;

        return SizedBox(
          width: width,
          height: size.height, // Full screen height
          child: Stack(
            children: [
              // BACKGROUND IMAGE PARALLAX - Full screen cover
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: widget.scrollController,
                  builder: (context, child) {
                    final double scrollOffset =
                        widget.scrollController.hasClients
                        ? widget.scrollController.offset
                        : 0.0;

                    final double t = (scrollOffset / 300).clamp(0.0, 1.0);
                    final double bgScale = 1.4 - 0.25 * t;

                    return Transform.scale(
                      scale: bgScale,
                      child: child,
                    );
                  },
                  child: widget.startAnimate
                      ? Image.asset(
                              'assets/images/bg_hero.webp',
                              fit: BoxFit.cover,
                              width: width,
                              height: size.height,
                            )
                            .animate(delay: 2000.ms)
                            .fadeIn(
                              duration: 1600.ms,
                              curve: Curves.easeOut,
                            )
                            .saturate(
                              begin: 0,
                              end: 1,
                              duration: 3000.ms,
                              curve: Curves.easeInOut,
                            )
                            .blur(
                              begin: const Offset(2, 2),
                              end: Offset.zero,
                              duration: 3000.ms,
                              curve: Curves.easeInOut,
                            )
                      : Container(
                          width: width,
                          height: size.height,
                          color: Colors.white,
                        ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 450,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withAlpha(0),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.35],
                    ),
                  ),
                ),
              ),

              // BIG NAME (BEHIND COUPLE)
              Align(
                alignment: Alignment(
                  0,
                  isMobile ? -0.15 : -0.2,
                ), // Slightly above center
                child: widget.startAnimate
                    ? Transform.translate(
                        offset: const Offset(0, -40),
                        child:
                            Text(
                                  'Aung & Cho',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.greatVibes(
                                    fontSize: isMobile
                                        ? 140
                                        : 300, // Super mega big
                                    height: 1.0,
                                    color: const Color(0xFFFFB832),
                                    letterSpacing: isMobile ? 5.0 : 15.0,
                                  ),
                                )
                                .animate(delay: 500.ms)
                                .fadeIn(
                                  duration: 1200.ms,
                                  curve: Curves.easeOut,
                                )
                                .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1.0, 1.0),
                                  duration: 1500.ms,
                                  curve: Curves.easeOut,
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .moveY(
                                  begin: 0,
                                  end: 15,
                                  duration: 3000.ms,
                                  curve: Curves.easeInOut,
                                ),
                      )
                    : const SizedBox(),
              ),

              // COUPLE IMAGE PARALLAX - Stuck to bottom of cover image
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: widget.scrollController,
                  builder: (context, child) {
                    final double scrollOffset =
                        widget.scrollController.hasClients
                        ? widget.scrollController.offset
                        : 0.0;

                    final double t = (scrollOffset / 300).clamp(0.0, 1.0);
                    final double coupleScale = 1.1 + 0.2 * t;

                    return Transform.scale(
                      scale: coupleScale,
                      alignment: Alignment.bottomCenter,
                      child: child,
                    );
                  },
                  child: widget.startAnimate
                      ? Image.asset(
                              'assets/images/couple_hero.webp',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                              height: size.height * (isMobile ? 0.55 : 0.66),
                              width: width,
                            )
                            .animate(delay: 500.ms)
                            .scale(
                              begin: const Offset(0.95, 0.95),
                              end: const Offset(1.0, 1.0),
                              duration: 1500.ms,
                              curve: Curves.easeOut,
                            )
                      : SizedBox(
                          height: size.height * (isMobile ? 0.55 : 0.66),
                          width: width,
                        ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // PRE-TITLE
                    widget.startAnimate
                        ? Text(
                                "We’re Getting Married!",
                                style: KStyle.tTitleL.copyWith(
                                  fontSize: isMobile ? 20 : 28,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                              .animate(delay: 600.ms)
                              .fadeIn(duration: 800.ms)
                              .slideY(begin: 0.2, end: 0)
                        : const SizedBox(height: 40),

                    const SizedBox(height: 20),

                    // Wait, if name is in background, date might be better at bottom?
                    // User said "keep same font for We're getting married and date".
                    // Assuming layout is still top-centered.

                    // DATE SECTION (Moved closer to top or kept?)
                    // With a huge image and huge name in middle, top text needs to be minimal.
                    // The "Aung & Cho" used to be here. Now it's gone.
                    widget.startAnimate
                        ? Column(
                                children: [
                                  CustomDivider(
                                    lineWidth: isMobile
                                        ? 80
                                        : 120, // Smaller divider
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: KStyle.cStroke,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 6 : 12),
                                  Text(
                                        '12.2.2026',
                                        style: KStyle.tTitleL,
                                      )
                                      .animate(delay: 1400.ms)
                                      .custom(
                                        duration: 2000.ms,
                                        curve: Curves.easeOutCubic,
                                        begin: 0,
                                        end: 5.0,
                                        builder: (context, value, child) =>
                                            Text(
                                              '12.2.2026',
                                              style: KStyle.tTitleL.copyWith(
                                                letterSpacing: value,
                                              ),
                                            ),
                                      )
                                      .slideY(
                                        begin: 0.2,
                                        end: 0,
                                        duration: 800.ms,
                                        curve: Curves.easeOutCubic,
                                      ),
                                ],
                              )
                              .animate(delay: 1400.ms)
                              .fadeIn(
                                duration: 800.ms,
                                curve: Curves.easeOut,
                              )
                              .slideY(
                                begin: 0.2,
                                end: 0,
                                duration: 800.ms,
                                curve: Curves.easeOutCubic,
                              )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
