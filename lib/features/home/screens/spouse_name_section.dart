import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';

class SpouseNameSection extends StatefulWidget {
  const SpouseNameSection({super.key});

  @override
  State<SpouseNameSection> createState() => _SpouseNameSectionState();
}

class _SpouseNameSectionState extends State<SpouseNameSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('spouse_name_section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.6 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
          _controller.repeat(reverse: true);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 120),
        color: KStyle.cPrimary,
        width: double.infinity,
        child: Column(
          children: [
            if (_isVisible)
              buildNameJob(
                    'Aung Kyaw Phyo',
                    'Senior Engineer, Yoma Company Ltd',
                  )
                  .animate()
                  .slideY(
                    begin: -0.6,
                    end: 0,
                    curve: Curves.easeOutCubic,
                    duration: 700.ms,
                  )
                  .fadeIn(duration: 600.ms),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/icons/heart_fill.png',
                  width: 48,
                ),
              ),
            ),
            if (_isVisible)
              buildNameJob(
                    'Payinn Yaung',
                    'Senior Engineer, Yoma Company Ltd',
                  )
                  .animate()
                  .slideY(
                    begin: 0.6,
                    end: 0,
                    curve: Curves.easeOutCubic,
                    duration: 700.ms,
                  )
                  .fadeIn(duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Column buildNameJob(String name, String job) {
    return Column(
      children: [
        Text(
          name,
          style: KStyle.tTitleXXL.copyWith(color: KStyle.cWhite),
        ),
        Text(
          job,
          style: KStyle.tBodyM.copyWith(color: KStyle.cWhite),
        ),
      ],
    );
  }
}
