import 'package:flutter/material.dart';
import 'package:wedding_v1/features/home/screens/congratulation_section.dart';
import 'package:wedding_v1/features/home/screens/invitation_letter_section.dart';
import 'package:wedding_v1/features/home/screens/spouse_name_section.dart';
import 'package:wedding_v1/features/home/screens/story_section.dart';
import 'package:wedding_v1/features/home/widgets/timeline_image.dart';

import '../../../services/curtain_animation.dart';
import '../widgets/custom_app_bar.dart';
import 'hero_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool openCurtain = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {}); // rebuild to update scrollOffset
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // When the widget is first built, the ScrollController may not yet be
    // attached to the SingleChildScrollView. In that case, use 0.0 to avoid
    // the "ScrollController not attached to any scroll views" assertion.
    final double safeOffset = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  scrollOffset: safeOffset,
                  startAnimate: openCurtain,
                ),
                SpouseNameSection(),
                const SizedBox(height: 120),
                TimelineImage(
                  title: '2015',
                ),
                const SizedBox(height: 120),
                TimelineImage(
                  title: '2016',
                ),
                const SizedBox(height: 120),
                TimelineImage(
                  title: '2017',
                ),
                const SizedBox(height: 150),
                InvitationLetterSection(),
                const SizedBox(height: 150),
                StorySection(),
                const SizedBox(height: 150),
                CongratulationSection(),
                const SizedBox(height: 150),
              ],
            ),
          ),
          if (safeOffset >= size.height * 0.45) LiquidCapsuleBar(),
          _buildLoadingScreen(),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Positioned.fill(
      child: VelvetCurtainScreen(
        onChanged: () {
          setState(() {
            openCurtain = true;
          });
        },
      ),
    );
  }
}
