import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';
import 'package:wedding_v1/widgets/divider.dart';
import 'package:wedding_v1/widgets/responsive.dart';

class TimelineImage extends StatefulWidget {
  const TimelineImage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<TimelineImage> createState() => _TimelineImageState();
}

class _TimelineImageState extends State<TimelineImage> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return VisibilityDetector(
      key: Key('timeline_${widget.title}'),
      onVisibilityChanged: (VisibilityInfo info) {
        // Trigger animation when widget becomes visible (with threshold)
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        width: 800,
        child: Column(
          children: [
            CustomDivider(
              child: Text(
                widget.title,
                style: KStyle.tTitleM,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 389,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: _isVisible
                          ? Image.asset(
                                  'assets/images/bg_hero.webp',
                                  fit: BoxFit.cover,
                                )
                                .animate(delay: 500.ms)
                                .fadeIn(
                                  duration: 600.ms,
                                  curve: Curves.easeOut,
                                )
                                .slideX(
                                  begin: -1.0, // Start from left (off-screen)
                                  end: 0.0,
                                  duration: 1200.ms,
                                  curve: Curves.easeOut,
                                )
                          : null,
                    ),
                  ),
                  SizedBox(width: isMobile ? 16 : 20),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox.expand(
                            child: _isVisible
                                ? Image.asset(
                                        'assets/images/bg_hero.webp',
                                        fit: BoxFit.cover,
                                      )
                                      .animate(delay: 500.ms)
                                      .fadeIn(
                                        duration: 600.ms,
                                        curve: Curves.easeOut,
                                      )
                                      .slideX(
                                        begin: 1.0, // Start from right
                                        end: 0.0,
                                        duration: 1200.ms,
                                        curve: Curves.easeOut,
                                      )
                                      .slideY(
                                        begin: -1.0, // Start from top
                                        end: 0.0,
                                        duration: 1200.ms,
                                        curve: Curves.easeOut,
                                      )
                                : null,
                          ),
                        ),
                        SizedBox(height: isMobile ? 16 : 20),
                        Expanded(
                          child: SizedBox.expand(
                            child: _isVisible
                                ? Image.asset(
                                        'assets/images/bg_hero.webp',
                                        fit: BoxFit.cover,
                                      )
                                      .animate(delay: 500.ms)
                                      .fadeIn(
                                        duration: 600.ms,
                                        curve: Curves.easeOut,
                                      )
                                      .slideX(
                                        begin: 1.0, // Start from right
                                        end: 0.0,
                                        duration: 1200.ms,
                                        curve: Curves.easeOut,
                                      )
                                      .slideY(
                                        begin: 1.0, // Start from bottom
                                        end: 0.0,
                                        duration: 1200.ms,
                                        curve: Curves.easeOut,
                                      )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'First met on one hot summer train ride...',
              style: KStyle.tBodyL.copyWith(
                color: KStyle.cSecondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
