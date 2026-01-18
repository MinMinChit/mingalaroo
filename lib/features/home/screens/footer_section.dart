import 'package:flutter/material.dart';
import 'package:wedding_v1/constants/color_style.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: KStyle.cWhite, 
        border: Border(
          top: BorderSide(
            color: KStyle.cStroke,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          '© Mingalaroo 2026',
          style: KStyle.tBodyS.copyWith(
            color: KStyle.cDisable,
          ),
        ),
      ),
    );
  }
}
