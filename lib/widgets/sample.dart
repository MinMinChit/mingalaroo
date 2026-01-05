import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MagicButtonPage(),
    ),
  );
}

class MagicButtonPage extends StatefulWidget {
  const MagicButtonPage({super.key});

  @override
  State<MagicButtonPage> createState() => _MagicButtonPageState();
}

class _MagicButtonPageState extends State<MagicButtonPage>
    with TickerProviderStateMixin {
  late AnimationController _holdController;
  late Ticker _ticker;

  final List<Particle> _particles = [];
  final Random _random = Random();

  static const int _confettiCount = 60;
  static const int _flowerCount = 20;
  static const List<String> _flowerEmojis = [
    '🌸',
    '🌺',
    '🌻',
    '🌹',
    '🌷',
    '🌼',
    '💐',
  ];
  static const List<Color> _confettiColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    // 1500ms duration
    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _ticker = createTicker(_updateParticles);
  }

  @override
  void dispose() {
    _holdController.dispose();
    _ticker.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _holdController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (_holdController.isCompleted) {
      _triggerCelebration();
    }
    _holdController.reset();
  }

  void _onTapCancel() {
    _holdController.reset();
  }

  void _triggerCelebration() {
    _particles.clear();
    final size = MediaQuery.of(context).size;

    // 1. Confetti (Slow Motion)
    for (int i = 0; i < _confettiCount; i++) {
      double angle = _random.nextDouble() * 2 * pi;
      double speed = _random.nextDouble() * 10 + 5;

      _particles.add(
        ConfettiParticle(
          color: _confettiColors[_random.nextInt(_confettiColors.length)],
          x: size.width / 2,
          y: size.height / 2,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
        ),
      );
    }

    // 2. Flowers (Feather-like falling)
    for (int i = 0; i < _flowerCount; i++) {
      _particles.add(
        FlowerParticle(
          emoji: _flowerEmojis[_random.nextInt(_flowerEmojis.length)],
          x: _random.nextDouble() * size.width,
          y: -(_random.nextDouble() * 400),
          vy: _random.nextDouble() * 0.5,
          oscillationSpeed: _random.nextDouble() * 0.02 + 0.01,
        ),
      );
    }

    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  void _updateParticles(Duration elapsed) {
    if (_particles.isEmpty) {
      _ticker.stop();
      return;
    }

    final size = MediaQuery.of(context).size;
    bool activeParticles = false;

    setState(() {
      for (var p in _particles) {
        p.update();
        if (p.y < size.height + 200 &&
            (p is! ConfettiParticle || p.opacity > 0)) {
          activeParticles = true;
        }
      }
    });

    if (!activeParticles) {
      _particles.clear();
      _ticker.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: AnimatedBuilder(
                animation: _holdController,
                builder: (context, child) {
                  // --- ANIMATION LOGIC ---

                  Widget centerContent;
                  double progress = _holdController.value;

                  if (_holdController.isCompleted) {
                    // Done state
                    centerContent = const Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.white,
                    );
                  } else if (progress > 0) {
                    // Calculate which number (3, 2, or 1) we are on
                    // rawStep goes from 0.0 to 3.0
                    double rawStep = progress * 3;
                    int index = rawStep.floor(); // 0, 1, or 2
                    int count = 3 - index;

                    // localT goes from 0.0 to 1.0 for EACH number repeatedly
                    // This drives the "Pop" effect every time the number changes
                    double localT = rawStep - index;

                    // Visual Curves
                    // Scale: Overshoots slightly (0.5 -> 1.2 -> 1.0)
                    double scaleValue = Curves.easeOutBack.transform(localT);
                    // Opacity: Fades in quickly
                    double opacityValue = Curves.easeIn
                        .transform(localT)
                        .clamp(0.0, 1.0);

                    centerContent = Transform.scale(
                      scale:
                          0.5 +
                          (scaleValue * 1.0), // Start at 0.5x, end around 1.5x
                      child: Opacity(
                        opacity: opacityValue,
                        child: Text(
                          "$count",
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Idle state
                    centerContent = const Icon(
                      Icons.touch_app,
                      size: 40,
                      color: Colors.blue,
                    );
                  }

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress Ring
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: _holdController.value,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      // The Circle Container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _holdController.isCompleted
                              ? Colors.greenAccent
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (!_holdController.isCompleted)
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                              ),
                          ],
                        ),
                        child: Center(child: centerContent),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              "Hold for 1.5 seconds!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),

          IgnorePointer(
            child: CustomPaint(
              painter: ParticlePainter(_particles),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Particle Logic (Slow Motion + Feather) ---

abstract class Particle {
  double x, y;
  Particle({required this.x, required this.y});
  void update();
}

class ConfettiParticle extends Particle {
  double vx, vy;
  Color color;
  double opacity = 1.0;
  double size = 8.0;

  ConfettiParticle({
    required this.color,
    required double x,
    required double y,
    required this.vx,
    required this.vy,
  }) : super(x: x, y: y);

  @override
  void update() {
    x += vx;
    y += vy;

    // Low Gravity & Friction for "Slow Mo"
    vy += 0.05;
    vx *= 0.99;

    opacity -= 0.005;
    if (opacity < 0) opacity = 0;
  }
}

class FlowerParticle extends Particle {
  double vy;
  String emoji;
  double oscillationSpeed;
  double time = 0;

  FlowerParticle({
    required this.emoji,
    required double x,
    required double y,
    required this.vy,
    required this.oscillationSpeed,
  }) : super(x: x, y: y);

  @override
  void update() {
    // Feather-light Gravity
    vy += 0.005;
    y += vy;

    time += oscillationSpeed;
    x += sin(time) * 3.0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      if (p is ConfettiParticle) {
        if (p.opacity > 0) {
          final paint = Paint()..color = p.color.withOpacity(p.opacity);
          canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
        }
      } else if (p is FlowerParticle) {
        final textSpan = TextSpan(
          text: p.emoji,
          style: const TextStyle(fontSize: 38),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(p.x - textPainter.width / 2, p.y - textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
