import 'package:flutter/material.dart';
import 'package:wedding_v1/features/home/screens/spouse_name_section.dart';
import 'package:wedding_v1/features/home/screens/hero_section.dart';

import '../../../services/curtain_animation.dart';

// Deferred imports for non-critical sections - loaded on demand
import 'invite_section.dart' deferred as invite_section;
import 'poem_section.dart' deferred as poem_section;
import 'rsvp_section.dart' deferred as rsvp_section;
import 'story_section.dart' deferred as story_section;
import 'thank_you_section.dart' deferred as thank_you_section;
import 'payment_section.dart' deferred as payment_section;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _paymentKey = GlobalKey();
  bool openCurtain = false;
  bool _sectionsLoaded = false;

  @override
  void initState() {
    super.initState();
    // Load deferred sections after initial render
    _loadDeferredSections();
  }

  Future<void> _loadDeferredSections() async {
    try {
      await Future.wait([
        story_section.loadLibrary(),
        poem_section.loadLibrary(),
        invite_section.loadLibrary(),
        rsvp_section.loadLibrary(),
        thank_you_section.loadLibrary(),
        payment_section.loadLibrary(),
      ]);
      if (mounted) {
        setState(() {
          _sectionsLoaded = true;
        });
      }
    } catch (e) {
      // Handle error gracefully
      if (mounted) {
        setState(() {
          _sectionsLoaded = true; // Still show sections even if loading fails
        });
      }
    }
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
                if (_sectionsLoaded) ...[
                  story_section.StorySection(),
                  poem_section.PoemSection(),
                  invite_section.InviteSection(),
                  rsvp_section.RSVPSection(
                    onCelebrateFromAfar: _scrollToPayment,
                  ),
                  payment_section.PaymentSection(key: _paymentKey),
                  thank_you_section.ThankYouSection(),
                ] else ...[
                  // Placeholder while loading deferred sections
                  const SizedBox(height: 100),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 100),
                ],
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
