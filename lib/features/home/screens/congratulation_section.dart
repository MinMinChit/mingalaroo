import 'package:flutter/material.dart';
import 'package:wedding_v1/constants/color_style.dart';

import '../widgets/magic_btn.dart';

class CongratulationSection extends StatelessWidget {
  const CongratulationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Congratulate',
          style: KStyle.tTitleM.copyWith(
            color: KStyle.cSecondaryText,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Phyo & Payinn',
          style: KStyle.tTitleXL,
        ),
        const SizedBox(height: 40),
        // ElevatedButton(
        //   // style: ,
        //   onPressed: () {},
        //   child: Text(
        //     'Tap & Hold Here',
        //   ),
        // ),
        MagicButtonPage(),
      ],
    );
  }
}
