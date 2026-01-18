import 'package:flutter/material.dart';
import 'package:wedding_v1/features/home/screens/invite_section.dart';
import 'package:wedding_v1/features/home/screens/spouse_name_section.dart';
import 'package:wedding_v1/features/home/screens/poem_section.dart';
import 'package:wedding_v1/features/home/screens/rsvp_section.dart';
import 'package:wedding_v1/features/home/screens/story_section.dart';
import 'package:wedding_v1/features/home/screens/payment_section.dart';
import 'package:wedding_v1/features/home/screens/thank_you_section.dart';

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
  final GlobalKey _paymentKey = GlobalKey();
  bool openCurtain = false;
  @override
  void initState() {
    super.initState();
    // No listener needed for setState anymore
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPayment() {
    if (_paymentKey.currentContext != null) {
      Scrollable.ensureVisible(
        _paymentKey.currentContext!,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
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
                  scrollController: _scrollController,
                  startAnimate: openCurtain,
                ),
                SpouseNameSection(),
                StorySection(),
                PoemSection(),
                InviteSection(),
                RSVPSection(onCelebrateFromAfar: _scrollToPayment),
                PaymentSection(key: _paymentKey),
                ThankYouSection(),
              ],
            ),
          ),
          // if (safeOffset >= size.height * 0.45) LiquidCapsuleBar(),
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
