import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';
import 'package:wedding_v1/features/home/screens/footer_section.dart';

class ThankYouSection extends StatefulWidget {
  const ThankYouSection({super.key});

  @override
  State<ThankYouSection> createState() => _ThankYouSectionState();
}

class _ThankYouSectionState extends State<ThankYouSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('thank_you_section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Column(
        children: [
          // Thank You Content
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFDFCFB),
              image: DecorationImage(
                image: const AssetImage('assets/images/paper_texture.webp'),
                repeat: ImageRepeat.repeat,
                opacity: 0.4,
                fit: BoxFit.none,
                scale: 3.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 120),
            child: Column(
              children: [
                // Circular Image
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/thankyou.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ).animate(target: _isVisible ? 1 : 0)
                .scale(duration: 1200.ms, curve: Curves.easeOutCubic, begin: const Offset(0.5, 0.5))
                .fadeIn(duration: 800.ms),

                const SizedBox(height: 56),

                // Thanks Text
                Text(
                  'Thanks to our friends & family for all\nwarming support.',
                  textAlign: TextAlign.center,
                  style: KStyle.tTitleL.copyWith(
                    height: 1.5,
                  ),
                ).animate(target: _isVisible ? 1 : 0)
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 800.ms, curve: Curves.easeOutCubic),

                const SizedBox(height: 48),

                // Decor SVG
                SvgPicture.asset(
                  'assets/icons/endDecor.svg',
                  width: 200,
                  colorFilter: ColorFilter.mode(
                    KStyle.cDisable, // Using cDisable or similar grey
                    BlendMode.srcIn,
                  ),
                ).animate(target: _isVisible ? 1 : 0)
                .fadeIn(delay: 800.ms, duration: 1000.ms)
                .scaleX(begin: 0, end: 1, delay: 800.ms, duration: 1000.ms, curve: Curves.easeOutCubic),
              ],
            ),
          ),

          // Simple Footer
          const FooterSection(),
        ],
      ),
    );
  }
}
