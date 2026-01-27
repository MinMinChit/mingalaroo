import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';
import 'package:wedding_v1/features/home/widgets/magic_btn.dart';
import 'package:wedding_v1/services/supabase_service.dart';
import 'package:wedding_v1/services/url_service.dart';
import 'package:wedding_v1/widgets/lazy_image.dart';

class RSVPSection extends StatefulWidget {
  final VoidCallback? onCelebrateFromAfar;

  const RSVPSection({
    super.key,
    this.onCelebrateFromAfar,
  });

  @override
  State<RSVPSection> createState() => _RSVPSectionState();
}

class _RSVPSectionState extends State<RSVPSection> {
  bool _isVisible = false;
  String? _invitedUserName;
  String? _originalName;
  String? _weddingId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Get URL data when widget initializes
    final urlData = UrlService.getUrlData();
    _weddingId = urlData['weddingId'];
    _invitedUserName = urlData['invitedUserName'];
    _originalName = urlData['originalName'];
  }

  /// Get the wedding ID from URL (available for API calls or data fetching)
  String? get weddingId => _weddingId;

  /// Update RSVP attendance state
  Future<void> _updateRSVP(String attendanceState) async {
    if (_invitedUserName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing required information. Please check the URL.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await SupabaseService.updateRSVP(
        guestName: _originalName!,
        attendanceState: attendanceState,
        guestCount: '0',
      );

      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(
      //         attendanceState == 'attending'
      //             ? 'Thank you! We look forward to seeing you!'
      //             : 'Thank you for letting us know. We will miss you!',
      //       ),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
      // }
    } catch (e) {
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Failed to update RSVP: ${e.toString()}'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('rsvp_section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFDFCFB),
          image: DecorationImage(
            image: const AssetImage('assets/images/paper_texture.webp'),
            repeat: ImageRepeat.repeat,
            opacity: 0.4,
            fit: BoxFit.none,
            scale: 3.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flower GIF
            LazyImage(
                  imagePath: 'assets/icons/bouquet.gif',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                )
                .animate(target: _isVisible ? 1 : 0)
                .scale(
                  duration: 800.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.8, 0.8),
                )
                .fadeIn(duration: 800.ms),

            const SizedBox(height: 24),

            // "Dear [Name]" - Dynamic from URL
            Text(
                  _invitedUserName != null
                      ? 'Dear ${_invitedUserName},'
                      : 'Dear Guest,',
                  style: KStyle.tTitleXL,
                  textAlign: TextAlign.center,
                )
                .animate(target: _isVisible ? 1 : 0)
                .fadeIn(delay: 200.ms, duration: 800.ms),

            const SizedBox(height: 12),

            // Subtitle
            Text(
                  'Let us know, if you could attend our wedding ceremony.',
                  style: KStyle.tTitleL.copyWith(
                    color: KStyle.cSecondaryText,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate(target: _isVisible ? 1 : 0)
                .fadeIn(delay: 400.ms, duration: 800.ms),

            const SizedBox(height: 40),

            // Buttons
            ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Column(
                    children: [
                      // "I will be there" Button (Dark)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: CelebrationButton(
                          onPressed: _isSubmitting || _invitedUserName == null
                              ? null
                              : () => _updateRSVP('attending'),
                          child: ElevatedButton(
                            onPressed: _isSubmitting || _invitedUserName == null
                                ? null
                                : () {}, // Handled by CelebrationButton
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF18272C,
                              ), // Dark almost black
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 0,
                              disabledBackgroundColor: const Color(
                                0xFF18272C,
                              ).withOpacity(0.6),
                            ),
                            child: Text(
                              'I will be there',
                              style: KStyle.tTitleM.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // "So sorry, I couldn't attend" Button (Outline)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () {
                                  if (_invitedUserName != null) {
                                    _updateRSVP('not_attending');
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      padding: EdgeInsets.zero,
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      content: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            border: Border.all(
                                              color: Colors.black12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.05,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "We'll miss you! 🥺",
                                            textAlign: TextAlign.center,
                                            style: KStyle.tBodyM.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height -
                                            120, // Adjusted top position
                                      ),
                                    ),
                                  );
                                  widget.onCelebrateFromAfar?.call();
                                },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: KStyle.cSecondaryText.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'So Sorry, I will celebrate from afar',
                            style: KStyle.tTitleM.copyWith(
                              color: KStyle.cSecondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate(target: _isVisible ? 1 : 0)
                .fadeIn(delay: 600.ms, duration: 800.ms, curve: Curves.easeOut)
                .slideY(
                  begin: 0.1,
                  end: 0,
                  delay: 600.ms,
                  duration: 800.ms,
                  curve: Curves.easeOutCubic,
                ),
          ],
        ),
      ),
    );
  }
}
