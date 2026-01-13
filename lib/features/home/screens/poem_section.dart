import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';

class PoemSection extends StatelessWidget {
  const PoemSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PART 1: Text Container
        Container(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The Text Block with Padding
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 120),
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: const _TypewriterText(),
                ),
              ),

              // Top Left Decor (Flipped)
              Positioned(
                top: 32,
                left: 32,
                child: Transform.rotate(
                  angle: math.pi, // Flip 180 degrees
                  child: SvgPicture.asset(
                    'assets/icons/lowerRightDecor.svg',
                    width: 96,
                    height: 96,
                  ),
                ),
              ),

              // Lower Right Decor
              Positioned(
                bottom: 32,
                right: 32,
                child: SvgPicture.asset(
                  'assets/icons/lowerRightDecor.svg',
                  width: 120,
                  height: 120,
                ),
              ),
            ],
          ),
        ),

        // PART 2: Moving Image 1
        _ScrollingImageRow(
          imagePaths: const [
            'assets/images/poen_line1.webp',
            'assets/images/poem_line2.webp',
          ],
          speedDuration: 50.seconds,
          isMovingRight: true,
        ),

        const SizedBox(height: 16),

        // PART 3: Moving Image 2
        _ScrollingImageRow(
          imagePaths: const [
            'assets/images/poem_line2.webp',
            'assets/images/poen_line1.webp',
          ],
          speedDuration: 63.seconds, 
          isMovingRight: false, // Move Left
        ),

        // 16px sized box
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ScrollingImageRow extends StatelessWidget {
  final List<String> imagePaths;
  final Duration speedDuration;
  final bool isMovingRight;

  const _ScrollingImageRow({
    required this.imagePaths,
    required this.speedDuration,
    required this.isMovingRight,
  });

  @override
  Widget build(BuildContext context) {
    // Height 320
    const double height = 320;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity, // Allow infinite width for the row
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Repeat list 4x to ensure infinite scroll coverage even on wide screens
              ...imagePaths.map((p) => _buildImageSegment(p, height)),
              ...imagePaths.map((p) => _buildImageSegment(p, height)),
              ...imagePaths.map((p) => _buildImageSegment(p, height)),
              ...imagePaths.map((p) => _buildImageSegment(p, height)),
            ], 
          )
          .animate(onPlay: (c) => c.repeat())
          .slideX(
            // Slide by 25% of total width (which equals 1 full set of images out of 4)
            begin: isMovingRight ? -0.25 : 0, 
            end: isMovingRight ? 0 : -0.25,
            duration: speedDuration,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSegment(String path, double height) {
    return Image.asset(
      path,
      height: height,
      fit: BoxFit.fitHeight,
    );
  }
}

class _TypewriterText extends StatefulWidget {
  const _TypewriterText();

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  bool _isVisible = false;
  static const String _text = '10 years old story unfolding..\nto detest the time with \ncountless memories';

  @override
  Widget build(BuildContext context) {
    // Style
    final style = KStyle.tTitleXXL.copyWith(height: 1.5);

    return VisibilityDetector(
      key: const Key('poem_text_typewriter'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Text(
        _text,
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.transparent), // Placeholder for layout
      )
      .animate(target: _isVisible ? 1 : 0)
      .custom(
        duration: 4000.ms, // 4 seconds total typing
        builder: (context, value, child) {
          final int count = (value * _text.length).clamp(0, _text.length).toInt();
          return Stack(
            alignment: Alignment.center,
            children: [
              child!, // Keeps the layout size fixed
              Text(
                _text.substring(0, count),
                textAlign: TextAlign.center,
                style: style,
              ),
            ],
          );
        },
      ),
    );
  }
}
