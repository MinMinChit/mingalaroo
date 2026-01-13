import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final Size size = MediaQuery.sizeOf(context);

    final bool isMobile = size.width < 600;

    return SizedBox(
      width: size.width,
      height: size.height * 0.85,
      child: Stack(
        children: [
          // BACKGROUND IMAGE PARALLAX
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: widget.scrollController,
              builder: (context, child) {
                // Calculation on every frame (cheap)
                final double scrollOffset = widget.scrollController.hasClients
                    ? widget.scrollController.offset
                    : 0.0;
                
                final double t = (scrollOffset / 300).clamp(0.0, 1.0);
                // Increased intensity: 1.4 -> 1.15 (Delta 0.25)
                final double bgScale = 1.4 - 0.25 * t;  

                // Use Transform.scale for instant update (no duration lag)
                return Transform.scale(
                  scale: bgScale,
                  child: child,
                );
              },
              child: widget.startAnimate
                  ? Image.asset(
                          'assets/images/bg_hero.webp',
                          fit: BoxFit.cover,
                          height: size.height * (isMobile ? 0.5 : 0.6),
                          width: size.width,
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
                  : SizedBox(
                      height: size.height * (isMobile ? 0.5 : 0.6),
                      width: size.width,
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
                  stops: [0.0, 0.35], // adjust fade height
                ),
              ),
            ),
          ),
          
          // COUPLE IMAGE PARALLAX
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: widget.scrollController,
              builder: (context, child) {
                 final double scrollOffset = widget.scrollController.hasClients
                    ? widget.scrollController.offset
                    : 0.0;
                 
                 final double t = (scrollOffset / 300).clamp(0.0, 1.0);
                 // Increased intensity: 1.1 -> 1.3 (Delta 0.2)
                 final double coupleScale = 1.1 + 0.2 * t;

                 return Transform.scale(
                   scale: coupleScale,
                   child: child,
                 );
              },
              child: widget.startAnimate
                  ? Image.asset(
                          'assets/images/couple_hero.webp',
                          fit: BoxFit.contain,
                          height: size.height * (isMobile ? 0.5 : 0.6),
                        )
                        .animate(delay: 500.ms)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.0, 1.0),
                          duration: 1500.ms,
                          curve: Curves.easeOut,
                        )
                  : SizedBox(
                      height: size.height * (isMobile ? 0.5 : 0.6),
                    ),
            ),
          ),
          
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 74),
                // Per-letter falling animation for the title.
                widget.startAnimate
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: 'Phyo & Cho'
                              .split('')
                              .map(
                                (char) => Text(
                                  char,
                                  style: KStyle.tTitleL.copyWith(
                                    fontSize: isMobile ? 30 : 38,
                                  ),
                                ),
                              )
                              .toList()
                              .animate(
                                delay: 1000.ms,
                                interval: 150.ms,
                              )
                              .fadeIn(
                                duration: 500.ms,
                                curve: Curves.easeOut,
                              )
                              .slideY(
                                begin: -0.4, // Reduced distance for subtlety
                                end: 0.0,
                                curve: Curves.easeOutCubic, // More graceful deceleration
                                duration: 800.ms, // Slower individual fall
                              ),
                        ),
                      )
                    : Text(
                        '',
                        style: KStyle.tTitleL.copyWith(
                          fontSize: 44, // Keep placeholder consistent
                        ),
                      ),
                const SizedBox(height: 12),
                widget.startAnimate
                    ? Column(
                            children: [
                              CustomDivider(
                                lineWidth: isMobile ? 120 : 197,
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: KStyle.cStroke,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
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
                                builder: (context, value, child) => Text(
                                  '25.12.2025',
                                  style: KStyle.tTitleL.copyWith(
                                    letterSpacing: value,
                                  ),
                                ),
                              )
                              .slideY(
                                begin: 0.2, // Subtle rise from below
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
                            begin: 0.2, // Subtle rise from below
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
  }
}
