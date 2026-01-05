import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:wedding_v1/constants/color_style.dart';

class InvitationLetterSection extends StatelessWidget {
  const InvitationLetterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 673,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: KStyle.cBlack,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/couple_kiss.png',
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 96),
              child: Column(
                children: [
                  buildDetails(
                    iconData: RemixIcons.school_fill,
                    title: 'Yangon City Hall',
                    content: 'Venue',
                  ),
                  const SizedBox(height: 80),
                  buildDetails(
                    iconData: RemixIcons.time_fill,
                    title: 'Sunday\nDec 24 2025',
                    content: 'Time',
                  ),
                  const SizedBox(height: 80),
                  Text(
                    'We cordially invite to join our\nwedding ceremony.',
                    style: KStyle.tTitleXXL.copyWith(
                      color: KStyle.cWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column buildDetails({
    required IconData iconData,
    required String title,
    required String content,
  }) {
    return Column(
      children: [
        Icon(
          iconData,
          color: KStyle.cBrand,
        ),
        SizedBox(height: 44),
        Text(
          title,
          style: KStyle.tTitleXL.copyWith(
            color: KStyle.cWhite,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: KStyle.tBodyM.copyWith(
            color: KStyle.cDisable,
          ),
        ),
      ],
    );
  }
}
