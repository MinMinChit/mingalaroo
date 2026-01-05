import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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

  bool _isCelebrationActive = false; // Controls the final "✨" state
  bool _confettiFired = false; // Ensures confetti triggers only once per hold

  // Particle Settings
  static const int _confettiCount = 200;
  static const int _flowerCount = 30;
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
    _holdController = AnimationController(
      vsync: this,
      // 2800ms total (4 beats x 700ms)
      duration: const Duration(milliseconds: 3000),
    );

    // Listener to trigger confetti EXACTLY at the start of Beat 4
    _holdController.addListener(() {
      // 0.75 is the 3/4 mark (Start of the 4th beat)
      if (_holdController.value >= 0.75 && !_confettiFired) {
        _confettiFired = true; // Lock so it doesn't re-fire in the same press
        _fireConfetti();
      }
    });

    // Listener to handle the "Finish" state after the pop animation is done
    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showFinishedState();
      }
    });

    _ticker = createTicker(_updateParticles);
  }

  @override
  void dispose() {
    _holdController.dispose();
    _ticker.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (_isCelebrationActive) return;

    // Reset trigger flags for a new attempt
    _confettiFired = false;

    if (_holdController.isCompleted) _holdController.reset();
    _holdController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (_isCelebrationActive) return;
    if (!_holdController.isCompleted) _holdController.reverse();
  }

  void _onTapCancel() {
    if (_isCelebrationActive) return;
    _holdController.reset();
  }

  // Called immediately when hitting Beat 4
  void _fireConfetti() {
    _spawnParticles();
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  // Called when the entire 2.8s animation finishes
  void _showFinishedState() {
    setState(() {
      _isCelebrationActive = true;
    });

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCelebrationActive = false;
          _holdController.reset();
        });
      }
    });
  }

  void _spawnParticles() {
    _particles.clear();
    final size = MediaQuery.of(context).size;

    // 1. Confetti
    for (int i = 0; i < _confettiCount; i++) {
      double angle = _random.nextDouble() * 2 * pi;
      double speed = _random.nextDouble() * 15 + 7;

      _particles.add(
        ConfettiParticle(
          color: _confettiColors[_random.nextInt(_confettiColors.length)],
          x: size.width / 2,
          y: size.height / 2,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          gravity: _random.nextDouble() * 0.2 + 0.1,
          drag: _random.nextDouble() * 0.05 + 0.93,
          size: _random.nextDouble() * 4 + 4,
        ),
      );
    }

    // 2. Flowers
    for (int i = 0; i < _flowerCount; i++) {
      _particles.add(
        FlowerParticle(
          emoji: _flowerEmojis[_random.nextInt(_flowerEmojis.length)],
          x: (_random.nextDouble() * size.width * 1.2) - (size.width * 0.1),
          y: -(_random.nextDouble() * 800),
          vy: _random.nextDouble() * 10 + 10,
          oscillationSpeed: _random.nextDouble() * 0.02 + 0.01,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.05,
          pulsePhase: _random.nextDouble() * pi * 2,
        ),
      );
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
    return Stack(
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

        IgnorePointer(
          child: CustomPaint(
            painter: ParticlePainter(_particles),
            child: Container(),
          ),
        ),
      ],
    );
  }
}

// --- Particle Logic (Unchanged) ---

abstract class Particle {
  double x, y;
  Particle({required this.x, required this.y});
  void update();
}

class ConfettiParticle extends Particle {
  double vx, vy;
  Color color;
  double opacity = 1.0;
  double size;
  double gravity;
  double drag;

  ConfettiParticle({
    required this.color,
    required super.x,
    required super.y,
    required this.vx,
    required this.vy,
    required this.gravity,
    required this.drag,
    required this.size,
  });

  @override
  void update() {
    x += vx;
    y += vy;
    vy += gravity;
    vx *= drag;
    opacity -= 0.002;
    if (opacity < 0) opacity = 0;
  }
}

class FlowerParticle extends Particle {
  double vy;
  String emoji;
  double oscillationSpeed;
  double time = 0;
  double rotation = 0;
  double rotationSpeed;
  double pulsePhase;

  FlowerParticle({
    required this.emoji,
    required super.x,
    required super.y,
    required this.vy,
    required this.oscillationSpeed,
    required this.rotationSpeed,
    required this.pulsePhase,
  });

  @override
  void update() {
    if (vy > 2.0) {
      vy *= 0.92;
    } else {
      vy += 0.005;
    }
    y += vy;
    time += oscillationSpeed;
    rotation += rotationSpeed;
    x += sin(time) * 2.0;
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
        canvas.save();
        canvas.translate(p.x, p.y);
        canvas.rotate(p.rotation);

        double scale = 1.0 + sin(p.time * 2 + p.pulsePhase) * 0.1;
        canvas.scale(scale, scale);

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
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
