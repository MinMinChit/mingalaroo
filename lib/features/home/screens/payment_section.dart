import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wedding_v1/constants/color_style.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  bool _isVisible = false;
  int _selectedIndex = 0;

  final List<PaymentOption> _options = [
    PaymentOption(
      id: 'kpay',
      name: 'KBZ Pay',
      accountName: 'Aung Kyaw Phyo',
      iconPath: 'assets/images/kpay.png',
      qrPath: 'assets/images/kpayQR_akp.webp',
    ),
    PaymentOption(
      id: 'wave_akp',
      name: 'Wave Pay',
      accountName: 'Aung Kyaw Phyo',
      iconPath: 'assets/images/wave_akp.png',
      qrPath: 'assets/images/waveQR_akp.webp',
    ),
    PaymentOption(
      id: 'wave_cpp',
      name: 'Wave Pay',
      accountName: 'Cho Phone Pyae',
      iconPath:
          'assets/images/wave_cpp.png', // Assuming this exists based on pattern
      qrPath: 'assets/images/waveQR_cpp.webp',
    ),
    PaymentOption(
      id: 'aya',
      name: 'AYA Pay',
      accountName: 'Aung Kyaw Phyo',
      iconPath: 'assets/images/aya.png',
      qrPath: 'assets/images/ayaQR_akp.webp',
    ),
    PaymentOption(
      id: 'yoma',
      name: 'Yoma Bank',
      accountName: 'Aung Kyaw Phyo',
      iconPath: 'assets/images/yoma.png',
      qrPath: 'assets/images/yomaQR_akp.webp',
    ),
    PaymentOption(
      id: 'prompt',
      name: 'PromptPay',
      accountName: 'Ma Thaw Ka',
      iconPath: 'assets/images/promptpay.png',
      qrPath: 'assets/images/promptQR_mtk.webp',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedOption = _options[_selectedIndex];

    return VisibilityDetector(
      key: const Key('payment_section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFCFB), // Soft warm off-white base
          image: DecorationImage(
            image: const AssetImage('assets/images/paper_texture.webp'),
            repeat: ImageRepeat.repeat,
            opacity: 0.4,
            fit: BoxFit.none,
            scale: 3.5,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            if (isMobile) {
              return _buildMobileLayout();
            }

            return Column(
              children: [
                // Title
                Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            Text(
                              'For your convenience, we have provided a QR code for those who wish to send a wedding gift (လက်ဖွဲ့) digitally.',
                              textAlign: TextAlign.center,
                              style: KStyle.tTitleXL.copyWith(
                                height: 1.6,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Text(
                                "Please notify the recipient directly after sending. Website does not handle payments and is not responsible for any transaction errors.",
                                textAlign: TextAlign.center,
                                style: KStyle.tBodyS.copyWith(
                                  color: KStyle.cSecondaryText,
                                  height: 1.5,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 48),

                // Toggle Row
                SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_options.length, (index) {
                          final isSelected = _selectedIndex == index;
                          final option = _options[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedContainer(
                                      duration: 300.ms,
                                      width: isSelected ? 64 : 56,
                                      height: isSelected ? 64 : 56,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? KStyle.cBrand
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        option.iconPath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    // Arrow Indicator
                                    AnimatedOpacity(
                                      opacity: isSelected ? 1.0 : 0.0,
                                      duration: 300.ms,
                                      child: Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: KStyle.cBrand,
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(delay: 200.ms, duration: 800.ms),

                // Envelope & QR Card
                Transform.translate(
                      offset: const Offset(0, -180),
                      child: SizedBox(
                        height:
                            640, // Cropped visible height, reduced to 640 to crop bottom 1/5
                        width: 764,
                        child: OverflowBox(
                          maxHeight: 942,
                          minHeight: 942,
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 942, // Full internal height
                            width: 764,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // 0. The Back Flap (Inside of envelope)
                                Positioned(
                                  bottom: 0,
                                  child: CustomPaint(
                                    size: const Size(719, 422),
                                    painter: EnvelopeBackPainter(),
                                  ),
                                ),

                                // 1. The Card (Sliding out)
                                Positioned(
                                  top: 20,
                                  child: AnimatedSwitcher(
                                    duration: 500.ms,
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.2),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _buildQRCard(selectedOption),
                                  ),
                                ),

                                // 2. The Envelope Body (Front Pocket)
                                Positioned(
                                  bottom: 0,
                                  child: _buildEnvelopePocket(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideY(begin: 0.1, end: 0),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final selectedOption = _options[_selectedIndex];

    Widget buildOptionCircle(int index) {
      final option = _options[index];
      final isSelected = _selectedIndex == index;
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: 300.ms,
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? KStyle.cBrand : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Image.asset(
            option.iconPath,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Title
        ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Text(
                    'For your convenience, we have provided a QR code for those who wish to send a wedding gift (လက်ဖွဲ့) digitally.',
                    textAlign: TextAlign.center,
                    style: KStyle.tTitleXL.copyWith(
                      height: 1.6,
                      fontWeight: FontWeight.normal,
                      fontSize: 18, // Slightly smaller for mobile
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Please notify the recipient directly after sending. Website does not handle payments and is not responsible for any transaction errors.",
                    textAlign: TextAlign.center,
                    style: KStyle.tBodyS.copyWith(
                      color: KStyle.cSecondaryText,
                      height: 1.5,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 32),

        // Manual 3x2 Layout
        Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildOptionCircle(0),
                    const SizedBox(width: 12),
                    buildOptionCircle(1),
                    const SizedBox(width: 12),
                    buildOptionCircle(2),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildOptionCircle(3),
                    const SizedBox(width: 12),
                    buildOptionCircle(4),
                    const SizedBox(width: 12),
                    buildOptionCircle(5),
                  ],
                ),
              ],
            )
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(delay: 200.ms, duration: 800.ms),

        const SizedBox(height: 16),

        // Framed QR Card
        AnimatedSwitcher(
              duration: 500.ms,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: GestureDetector(
                key: ValueKey(selectedOption.id),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.all(16),
                      child: InteractiveViewer(
                        maxScale: 4.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(selectedOption.qrPath),
                        ),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    selectedOption.qrPath,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(delay: 400.ms, duration: 800.ms)
            .slideY(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildQRCard(PaymentOption option) {
    return Container(
      key: ValueKey(option.id),
      width: 585, // Increased width (+25%)
      height: 780, // Increased height (+25%)
      decoration: BoxDecoration(
        color: Colors.transparent, // No background
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          option.qrPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildEnvelopePocket() {
    return SizedBox(
      width: 719, // Increased width (+25%)
      height: 422, // Increased height (+25%)
      child: Stack(
        children: [
          // White Envelope Shape
          CustomPaint(
            size: const Size(719, 422),
            painter: EnvelopePainter(),
          ),

          // Floral Decoration Left
          Positioned(
            bottom: -20,
            left: -20,
            child: Transform.rotate(
              angle: -0.5,
              child: Image.asset(
                'assets/images/floral_corner.png',
                width: 252, // +25%
                color: KStyle.cBrand.withOpacity(0.2),
                colorBlendMode: BlendMode.srcATop,
              ),
            ),
          ),

          // Floral Decoration Right
          Positioned(
            bottom: -20,
            right: -20,
            child: Transform.flip(
              flipX: true,
              child: Transform.rotate(
                angle: 0.5,
                child: Image.asset(
                  'assets/images/floral_corner.png',
                  width: 252, // +25%
                  color: KStyle.cBrand.withOpacity(0.2),
                  colorBlendMode: BlendMode.srcATop,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnvelopeBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFFF2F2F2) // Slightly darker than front to show depth
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = KStyle.cStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    // Simple rectangular back, but we can make it slightly tapered or just a rect
    // Since it's behind the pocket, a rect is fine, but let's shape the top triangle
    // to look like the open flap.

    // Draw the open flap triangle at the top
    // path.moveTo(0, size.height);
    // path.lineTo(0, size.height * 0.4); // Left side meets pocket top
    // path.lineTo(size.width / 2, 0); // Top peak of open flap
    // path.lineTo(size.width, size.height * 0.4); // Right side
    // path.lineTo(size.width, size.height);
    // path.close();

    // Actually, simpler: A rectangle for the main body + a triangle on top for the open flap
    // The pocket covers the bottom half, so we just need the top triangle sticking up
    // behind the card, or the "inside" rectangle.

    // Let's just draw a large rect that fills the space.
    final rectPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(rectPath, paint);
    canvas.drawPath(rectPath, borderPaint);

    // Draw an "open flap" triangle line for visual detail?
    // Maybe not needed if the card is in front vertically.
    // Let's just keep it simple: A backing plate.
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFAFAFA),
          const Color(0xFFF0F0F0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();
    // V-shape pocket
    path.moveTo(0, 0); // Top Left
    path.lineTo(size.width / 2, size.height * 0.4); // Center Dip
    path.lineTo(size.width, 0); // Top Right
    path.lineTo(size.width, size.height); // Bottom Right
    path.lineTo(0, size.height); // Bottom Left
    path.close();

    // Draw shadow
    canvas.drawPath(path.shift(const Offset(0, 4)), shadowPaint);
    // Draw body
    canvas.drawPath(path, paint);

    // Draw borders for definition
    final borderPaint = Paint()
      ..color = KStyle.cStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, borderPaint);

    // Draw a center line to simulate fold
    final foldPath = Path();
    foldPath.moveTo(size.width / 2, size.height * 0.4);
    foldPath.lineTo(size.width / 2, size.height);

    canvas.drawPath(
      foldPath,
      borderPaint..color = KStyle.cStroke.withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PaymentOption {
  final String id;
  final String name;
  final String accountName;
  final String iconPath;
  final String qrPath;

  PaymentOption({
    required this.id,
    required this.name,
    required this.accountName,
    required this.iconPath,
    required this.qrPath,
  });
}
