import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wedding_v1/constants/color_style.dart';
import 'package:wedding_v1/widgets/divider.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.scrollOffset,
    required this.startAnimate,
  });

  final double scrollOffset;
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

    // Normalize scroll to 0..1 for smooth scaling.
    final double t = (widget.scrollOffset / 300).clamp(
      0.0,
      1.0,
    ); // 300px of scroll range

    // Background image shrinks slightly when scrolling down.
    final double bgScale = 1.3 - 0.1 * t; // 1.3 -> 1.2

    // Couple image grows slightly when scrolling down.
    final double coupleScale = 1.2 + 0.1 * t; // 1.2 -> 1.3

    return SizedBox(
      width: size.width,
      height: size.height * 0.85,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedScale(
              scale: bgScale,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              // Keep scroll-based scale, start fade-in only after [startAnimate] is true.
              child: widget.startAnimate
                  ? Image.asset(
                          'assets/images/bg_hero.webp',
                          fit: BoxFit.cover,
                          height: size.height * 0.6,
                          width: size.width,
                        )
                        .animate(delay: 500.ms)
                        .fadeIn(
                          duration: 1600.ms,
                          curve: Curves.easeOut,
                        )
                  : SizedBox(
                      height: size.height * 0.6,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedScale(
              scale: coupleScale,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              // Keep scroll-based scale, start zoom-in only after [startAnimate] is true.
              child: widget.startAnimate
                  ? Image.asset(
                          'assets/images/couple_hero.webp',
                          fit: BoxFit.contain,
                          height: size.height * 0.6,
                        )
                        .animate(delay: 500.ms)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.0, 1.0),
                          duration: 1500.ms,
                          curve: Curves.easeOut,
                        )
                  : SizedBox(
                      height: size.height * 0.6,
                    ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 50),
                // Per-letter falling animation for the title.
                widget.startAnimate
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: 'Phyo & Payinn'
                            .split('')
                            .map(
                              (char) => Text(
                                char,
                                style: KStyle.tTitleL.copyWith(
                                  fontSize: 48,
                                ),
                              ),
                            )
                            .toList()
                            .animate(interval: 150.ms)
                            .fadeIn(
                              duration: 200.ms,
                              curve: Curves.easeOut,
                            )
                            .slideY(
                              begin: -0.8,
                              end: 0.0,
                              curve: Curves.easeOut,
                              duration: 400.ms,
                            ),
                      )
                    : Text(
                        '',
                        style: KStyle.tTitleL.copyWith(
                          fontSize: 48,
                        ),
                      ),
                const SizedBox(height: 16),
                widget.startAnimate
                    ? Column(
                            children: [
                              CustomDivider(
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: KStyle.cPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '25.12.2025',
                                style: KStyle.tTitleM,
                              ),
                            ],
                          )
                          .animate(delay: 1000.ms)
                          .fadeIn(
                            duration: 1000.ms,
                            curve: Curves.easeOut,
                            begin: 0,
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
