import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remixicon/remixicon.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';
import 'package:wedding_v1/widgets/lazy_image.dart';

class InviteSection extends StatefulWidget {
  const InviteSection({super.key});

  @override
  State<InviteSection> createState() => _InviteSectionState();
}

class _InviteSectionState extends State<InviteSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('invite_section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: SizedBox(
        height: 800,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: KStyle.cBlack,
              ),
            ),
            Positioned.fill(
              child: LazyImage(
                imagePath: 'assets/images/couple_kiss.webp',
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildDetails(
                    iconData: RemixIcons.hotel_fill,
                    title: 'Inya Lake Hotel (Lake side)',
                    content: 'Wedding Venue',
                    delay: 200.ms,
                  ),
                  const SizedBox(height: 80),
                  buildDetails(
                    iconData: RemixIcons.time_fill,
                    title: '12 Feb, 2026\n8am - 10am',
                    content: 'Wedding Time',
                    delay: 400.ms,
                  ),
                  const SizedBox(height: 80),
                  Text(
                        'We cordially invite to join our\nwedding ceremony.',
                        style: KStyle.tTitleXL.copyWith(
                          color: KStyle.cWhite,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate(target: _isVisible ? 1 : 0)
                      .fadeIn(duration: 800.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 800.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetails({
    required IconData iconData,
    required String title,
    required String content,
    required Duration delay,
  }) {
    return Column(
          children: [
            Icon(
              iconData,
              color: KStyle.cBrand,
              size: 32,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: KStyle.tTitleXL.copyWith(
                color: KStyle.cWhite,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: KStyle.tBodyM.copyWith(
                color: KStyle.cDisable,
              ),
            ),
          ],
        )
        .animate(target: _isVisible ? 1 : 0)
        .fadeIn(delay: delay, duration: 800.ms)
        .slideY(
          begin: 0.2,
          end: 0,
          delay: delay,
          duration: 800.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
