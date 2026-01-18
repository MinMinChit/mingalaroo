import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ParticlesDemo(),
  ));
}

/// A standalone demo screen for the Magic Button Particle Celebration.
class ParticlesDemo extends StatelessWidget {
  const ParticlesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tap to Celebrate!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            // THE MAGIC BUTTON
            CelebrationButton(
              onPressed: () {
                debugPrint("Celebration Button Pressed!");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purpleAccent, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26, 
                      blurRadius: 10, 
                      offset: Offset(0, 4)
                    ),
                  ],
                ),
                child: const Text(
                  "Party Time 🎉",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// -----------------------------------------------------------------------------
// 🎊 PRESTO ANIMATION: CELEBRATION PARTICLES
// -----------------------------------------------------------------------------

class CelebrationButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const CelebrationButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  State<CelebrationButton> createState() => _CelebrationButtonState();
}

class _CelebrationButtonState extends State<CelebrationButton> {
  bool _isCooldown = false;

  void _handleTap() {
    if (_isCooldown) return;

    widget.onPressed?.call();

    // Trigger Particle Overlay
    _showParticles();

    // Cooldown 2s to prevent crazy spamming
    setState(() {
      _isCooldown = true;
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCooldown = false;
        });
      }
    });
  }

  void _showParticles() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Calculate center of the button in global coordinates
    final Offset buttonCenter =
        offset + Offset(size.width / 2, size.height / 2);

    final overlay = Overlay.of(context);
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) => ParticleOverlay(
        buttonCenter: buttonCenter,
        onFinished: () {
          entry?.remove();
          entry = null;
        },
      ),
    );

    overlay.insert(entry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      // Visual feedback when pressed
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isCooldown ? 0.7 : 1.0,
        child: widget.child,
      ),
    );
  }
}

// --- Overlay Widget to manage animation ---

class ParticleOverlay extends StatefulWidget {
  final Offset buttonCenter;
  final VoidCallback onFinished;

  const ParticleOverlay({
    super.key,
    required this.buttonCenter,
    required this.onFinished,
  });

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<Particle> _particles = [];
  final Random _random = Random();

  // Particle Settings
  static const int _confettiCount = 200;
  static const int _flowerCount = 30;
  static const List<String> _flowerEmojis = [
    '🌸', '🌺', '🌻', '🌹', '🌷', '🌼', '💐',
  ];
  static const List<Color> _confettiColors = [
    Colors.red, Colors.blue, Colors.green, Colors.orange,
    Colors.purple, Colors.pink, Colors.cyan, Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_updateParticles);
    // Don't spawn yet, wait for dependencies to get size? 
    // Actually we can get size instantly via MediaQuery since we are in Overlay.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_particles.isEmpty) {
      final size = MediaQuery.of(context).size;
      _spawnInitialParticles(size);
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _spawnInitialParticles(Size screenSize) {
    _particles.clear();

    // 1. Confetti (Shoots from Button Center)
    for (int i = 0; i < _confettiCount; i++) {
      double angle = _random.nextDouble() * 2 * pi;
      double speed = _random.nextDouble() * 15 + 7;

      _particles.add(
        ConfettiParticle(
          color: _confettiColors[_random.nextInt(_confettiColors.length)],
          x: widget.buttonCenter.dx,
          y: widget.buttonCenter.dy,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          gravity: _random.nextDouble() * 0.2 + 0.1,
          drag: _random.nextDouble() * 0.05 + 0.93,
          size: _random.nextDouble() * 4 + 4,
        ),
      );
    }

    // 2. Flowers (Drop from Top of Screen)
    // IMPORTANT: Spawns across entire screen width, starting ABOVE the viewport (-50)
    for (int i = 0; i < _flowerCount; i++) {
      _particles.add(
        FlowerParticle(
          emoji: _flowerEmojis[_random.nextInt(_flowerEmojis.length)],
          x: _random.nextDouble() * screenSize.width, // Random X across screen
          y: -(_random.nextDouble() * 400) - 50,      // Start well above screen
          vy: _random.nextDouble() * 5 + 5,           // Initial fall speed
          oscillationSpeed: _random.nextDouble() * 0.02 + 0.01,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.05,
          pulsePhase: _random.nextDouble() * pi * 2,
        ),
      );
    }
  }

  void _updateParticles(Duration elapsed) {
    if (_particles.isEmpty) return;

    // Use a large height to kill particles
    final size = MediaQuery.of(context).size;
    final killY = size.height + 200; 
    
    bool activeParticles = false;

    setState(() {
      for (var p in _particles) {
        p.update();
        // Keep active if onscreen or fading
        if (p.y < killY && (p is! ConfettiParticle || p.opacity > 0)) {
          activeParticles = true;
        }
      }
    });

    if (!activeParticles) {
      _ticker.stop();
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: ParticlePainter(_particles),
      ),
    );
  }
}

// --- Particle Logic ---

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
    // Air resistance terminal velocity logic
    if (vy > 2.0) {
      vy *= 0.92;
    } else {
      vy += 0.005;
    }
    y += vy;
    time += oscillationSpeed;
    rotation += rotationSpeed;
    x += sin(time) * 2.0; // Horizontal sway
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
