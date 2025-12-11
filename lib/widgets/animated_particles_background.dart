import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

class AnimatedParticlesBackground extends StatefulWidget {
  final int particleCount;
  final List<Color> colors;
  final double minSize;
  final double maxSize;
  final Duration duration;
  const AnimatedParticlesBackground({
    super.key,
    this.particleCount = 40,
    this.colors = const [
      Color(0xFF00F0FF),
      Color(0xFFFF00E0),
      Color(0xFF39FF14),
      Color(0xFF9D00FF),
    ],
    this.minSize = 4,
    this.maxSize = 16,
    this.duration = const Duration(seconds: 18),
  });

  @override
  State<AnimatedParticlesBackground> createState() => _AnimatedParticlesBackgroundState();
}

class _AnimatedParticlesBackgroundState extends State<AnimatedParticlesBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _particles = List.generate(widget.particleCount, (i) => _Particle.random(widget.colors, widget.minSize, widget.maxSize));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlesPainter(_particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  Offset start;
  Offset end;
  double size;
  Color color;
  double speed;
  double delay;

  _Particle({required this.start, required this.end, required this.size, required this.color, required this.speed, required this.delay});

  factory _Particle.random(List<Color> colors, double minSize, double maxSize) {
    final rand = Random();
    return _Particle(
      start: Offset(rand.nextDouble(), rand.nextDouble()),
      end: Offset(rand.nextDouble(), rand.nextDouble()),
      size: minSize + rand.nextDouble() * (maxSize - minSize),
      color: colors[rand.nextInt(colors.length)].withOpacity(0.18 + rand.nextDouble() * 0.38),
      speed: 0.5 + rand.nextDouble() * 1.2,
      delay: rand.nextDouble(),
    );
  }

  Offset position(double t) {
    final tt = ((t * speed + delay) % 1.0).clamp(0.0, 1.0);
    return Offset(
      lerpDouble(start.dx, end.dx, tt)!,
      lerpDouble(start.dy, end.dy, tt)!,
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  _ParticlesPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final pos = p.position(t);
      final offset = Offset(pos.dx * size.width, pos.dy * size.height);
      final paint = Paint()
        ..color = p.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(offset, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
