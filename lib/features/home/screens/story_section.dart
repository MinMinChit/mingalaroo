import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wedding_v1/constants/color_style.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '10 years old story\nunfolding..\nto detest the time with\ncountless memories',
          style: KStyle.tTitleXL,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),

        const SizedBox(height: 50),
        Text(
          'Thanks to our friends & family for all\nwarming support.',
          style: KStyle.tTitleM,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 78),
        SvgPicture.asset('assets/icons/divider.svg'),
        const SizedBox(height: 160),
      ],
    );
  }
}
