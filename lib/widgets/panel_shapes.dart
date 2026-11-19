import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/fx.dart';
import '../theme/palette.dart';

/// Importanța unui panou: forma urmează rolul.
enum PanelLevel { primary, secondary, tertiary }

/// Dreptunghi cu colțuri teșite la 45° (unghiul unic al prezentării).
Path chamferPath(Rect r, {double tl = 0, double tr = 0, double br = 0, double bl = 0}) {
  final Path p = Path()..moveTo(r.left + tl, r.top);
  p.lineTo(r.right - tr, r.top);
  if (tr > 0) p.lineTo(r.right, r.top + tr);
  p.lineTo(r.right, r.bottom - br);
  if (br > 0) p.lineTo(r.right - br, r.bottom);
  p.lineTo(r.left + bl, r.bottom);
  if (bl > 0) p.lineTo(r.left, r.bottom - bl);
  p.lineTo(r.left, r.top + tl);
  if (tl > 0) p.lineTo(r.left + tl, r.top);
  p.close();
  return p;
}

/// Principal: 2 colțuri de 28 px · secundar: 1 colț de 16 px · terțiar: niciunul.
Path panelPath(PanelLevel level, Size size) {
  final Rect r = Offset.zero & size;
  final double cap = math.min(size.width, size.height) / 3;
  if (level == PanelLevel.primary) {
    final double c = math.min(Fx.chamferL, cap);
    return chamferPath(r, tl: c, br: c);
  }
  if (level == PanelLevel.secondary) {
    return chamferPath(r, tr: math.min(Fx.chamferM, cap));
  }
  return chamferPath(r);
}

/// Desenează panoul de sticlă holografică. [progress] (0..1) vine din `.enter()`:
/// în primele ~56% marginea se „desenează”, apoi apar reperele; fără progres,
/// panoul e complet.
class PanelPainter extends CustomPainter {
  PanelPainter({
    required this.level,
    required this.accent,
    required this.fill,
    required this.border,
    this.progress,
  }) : super(repaint: progress);

  final PanelLevel level;
  final Color accent;
  final double fill;
  final double border;
  final Animation<double>? progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double p = progress?.value ?? 1.0;
    final double e = Fx.out.transform((p / 0.56).clamp(0.0, 1.0).toDouble());
    if (e <= 0.0 || size.isEmpty) return;

    final Rect r = Offset.zero & size;
    final Path path = panelPath(level, size);
    final bool pri = level == PanelLevel.primary;
    final bool ter = level == PanelLevel.tertiary;
    final double d = ((e - 0.9) / 0.1).clamp(0.0, 1.0).toDouble(); // repere, după margine

    // 1) Halou (doar principal): trepte de contur lat, fără blur.
    if (pri && kFxHigh) {
      for (int i = 0; i < 3; i++) {
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 18.0 - i * 6.0
            ..color = accent.o((0.025 + i * 0.02) * e),
        );
      }
    }

    // 2) Sticla: degrade din „Punte” + un văl în culoarea etapei.
    final double a0 = pri ? 0.88 : (ter ? 0.26 : 0.76);
    final double a1 = pri ? 0.76 : (ter ? 0.14 : 0.64);
    final Color tint = Color.lerp(Palette.punte, accent, 0.10)!;
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(
          r.topLeft,
          r.bottomRight,
          <Color>[tint.o(a0 * e), Palette.punte.o(a1 * e)],
        ),
    );
    canvas.drawPath(path, Paint()..color = accent.o(fill * 0.55 * e));

    // 3) Marginea.
    final Paint edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.miter;
    if (pri) {
      edge
        ..strokeWidth = Fx.line
        ..shader = ui.Gradient.linear(
          r.topLeft,
          r.bottomRight,
          <Color>[accent.o(0.95), accent.o(0.30), accent.o(0.75)],
          <double>[0.0, 0.55, 1.0],
        );
    } else if (ter) {
      edge
        ..strokeWidth = Fx.hair
        ..color = accent.o(0.22);
    } else {
      edge
        ..strokeWidth = Fx.hair
        ..color = accent.o(border);
    }
    _stroke(canvas, path, edge, e);

    // 4) Repere, după ce marginea s-a desenat.
    if (d <= 0.0) return;
    if (pri) {
      final double c = math.min(Fx.chamferL, math.min(size.width, size.height) / 3);
      final Paint hi = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = Fx.heavy
        ..color = Color.lerp(accent, Palette.gheata, 0.55)!.o(0.9 * d);
      canvas.drawLine(Offset(0, c), Offset(c, 0), hi);
      canvas.drawLine(Offset(size.width, size.height - c), Offset(size.width - c, size.height), hi);
    } else if (ter) {
      canvas.drawRect(Rect.fromLTWH(0, 0, 2.5, size.height), Paint()..color = accent.o(0.85 * d));
    } else {
      const double o = 5;
      const double l = 9;
      final Paint tick = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = Fx.line
        ..color = accent.o(0.85 * d);
      canvas.drawPath(Path()..moveTo(o, o + l)..lineTo(o, o)..lineTo(o + l, o), tick);
      canvas.drawPath(
        Path()
          ..moveTo(size.width - o, size.height - o - l)
          ..lineTo(size.width - o, size.height - o)
          ..lineTo(size.width - o - l, size.height - o),
        tick,
      );
    }
  }

  void _stroke(Canvas canvas, Path path, Paint paint, double t) {
    if (t >= 1.0) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final ui.PathMetric m in path.computeMetrics()) {
      canvas.drawPath(m.extractPath(0, m.length * t), paint);
    }
  }

  @override
  bool shouldRepaint(PanelPainter old) =>
      old.level != level ||
      old.accent != accent ||
      old.fill != fill ||
      old.border != border ||
      old.progress != progress;
}

/// Formă mică teșită (insigne, chip-uri, taste, segmente): fundal + contur + halou opțional.
class ChamferPainter extends CustomPainter {
  const ChamferPainter({
    required this.color,
    this.cut = Fx.chamferS,
    this.fillAlpha = 0.14,
    this.strokeAlpha = 0.6,
    this.strokeWidth = 1.4,
    this.glow = 0.0,
    this.cutTL = true,
    this.cutTR = false,
    this.cutBR = true,
    this.cutBL = false,
  });

  final Color color;
  final double cut;
  final double fillAlpha;
  final double strokeAlpha;
  final double strokeWidth;
  final double glow; // 0..1
  final bool cutTL;
  final bool cutTR;
  final bool cutBR;
  final bool cutBL;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final double c = math.min(cut, math.min(size.width, size.height) / 2.5);
    final Path path = chamferPath(
      (Offset.zero & size).deflate(strokeWidth / 2),
      tl: cutTL ? c : 0,
      tr: cutTR ? c : 0,
      br: cutBR ? c : 0,
      bl: cutBL ? c : 0,
    );
    if (glow > 0.0) {
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 8
          ..color = color.o(0.16 * glow),
      );
    }
    canvas.drawPath(path, Paint()..color = color.o(fillAlpha));
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.miter
        ..strokeWidth = strokeWidth
        ..color = color.o(strokeAlpha),
    );
  }

  @override
  bool shouldRepaint(ChamferPainter old) =>
      old.color != color ||
      old.cut != cut ||
      old.fillAlpha != fillAlpha ||
      old.strokeAlpha != strokeAlpha ||
      old.strokeWidth != strokeWidth ||
      old.glow != glow ||
      old.cutTL != cutTL ||
      old.cutTR != cutTR ||
      old.cutBR != cutBR ||
      old.cutBL != cutBL;
}
