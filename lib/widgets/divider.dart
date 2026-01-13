import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    required this.child,
    this.lineWidth = 197,
  });

  final Widget child;
  final double lineWidth;

  Widget _line({required bool reverse}) {
    return Container(
      width: lineWidth,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: reverse ? Alignment.centerLeft : Alignment.centerRight,
          end: reverse ? Alignment.centerRight : Alignment.centerLeft,
          colors: const [
            Color(0xFFE6E6E6), // solid #E6E6E6
            Color(0x00E6E6E6), // transparent #E6E6E6
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _line(reverse: false),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: child,
        ),

        _line(reverse: true),
      ],
    );
  }
}
