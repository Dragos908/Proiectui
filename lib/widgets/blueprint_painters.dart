import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/palette.dart';

// Numele fișierului e păstrat doar ca importurile din slide-uri (coperta, finalul)
// să compileze; se redenumește în Faza 2, când refac aceste două slide-uri.

/// Colțurile HUD au dispărut din limbaj (clișeu de „ecran futurist”): painter gol,
/// păstrat temporar pentru compatibilitate cu `slide_00_cover.dart`.
class HudCornersPainter extends CustomPainter {
  const HudCornersPainter({
    required this.color,
    this.inset = 26,
    this.len = 70,
    this.stroke = 3,
  });

  final Color color;
  final double inset;
  final double len;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(HudCornersPainter old) => false;
}

/// Particule lente, în formă de romb (45°). Cel mult 25; vitezele sunt întregi,
/// deci bucla `t` 0..1 se închide fără salt.
class ParticlesPainter extends CustomPainter {
  const ParticlesPainter({
    required this.t,
    required this.color,
    this.count = 20,
    this.seed = 7,
  });

  final double t;
  final Color color;
  final int count;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final math.Random rng = math.Random(seed);
    final int n = count > 25 ? 25 : count;
    final Paint paint = Paint();
    for (int i = 0; i < n; i++) {
      final double x0 = rng.nextDouble();
      final double y0 = rng.nextDouble();
      final int laps = 1 + rng.nextInt(2);
      final double r = 2.2 + rng.nextDouble() * 2.6;
      final double ph = rng.nextDouble();
      final double y = (y0 - t * laps) % 1.0;
      final double x = x0 + 0.015 * math.sin((t + ph) * 2 * math.pi);
      final double a = 0.12 + 0.30 * (0.5 + 0.5 * math.sin((t * 2 + ph) * 2 * math.pi));
      final double cx = x * size.width;
      final double cy = y * size.height;
      paint.color = color.o(a);
      canvas.drawPath(
        Path()
          ..moveTo(cx, cy - r)
          ..lineTo(cx + r, cy)
          ..lineTo(cx, cy + r)
          ..lineTo(cx - r, cy)
          ..close(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter old) => old.t != t || old.color != color;
}
