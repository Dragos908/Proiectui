import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/fx.dart';
import '../theme/palette.dart';
import '../theme/text_styles.dart';
import 'auto_fit.dart';
import 'enter_choreo.dart';
import 'panel_shapes.dart';

/// Panou de sticlă holografică, în trei trepte (forma urmează rolul):
/// principal (`glow: true`) · secundar (implicit) · terțiar (`fill` ≤ 0,06 sau `level`).
/// Decorurile se desenează în afara conținutului: `padding` rămâne spațiul real
/// al textului, deci `AutoFit` nu micșorează literele din cauza lor.
class GlassCard extends StatelessWidget implements SelfEntering {
  const GlassCard({
    super.key,
    required this.accent,
    required this.child,
    this.padding = const EdgeInsets.all(26),
    this.radius = 20, // păstrat pentru compatibilitate; panourile au colțuri teșite
    this.fill = 0.07,
    this.border = 0.40,
    this.glow = false,
    this.fit = true,
    this.alignment = Alignment.topLeft,
    this.level,
    this.blur = false,
  });

  final Color accent;
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final double fill;
  final double border;
  final bool glow;
  final bool fit;
  final Alignment alignment;

  /// Treapta panoului; dacă lipsește, se deduce din `glow` și `fill`.
  final PanelLevel? level;

  /// BackdropFilter real (doar cu `kFxHigh`); de folosit pe cel mult 2–3 panouri pe slide.
  final bool blur;

  PanelLevel get _level =>
      level ??
      (glow
          ? PanelLevel.primary
          : (fill < 0.065 ? PanelLevel.tertiary : PanelLevel.secondary));

  @override
  Widget build(BuildContext context) {
    final EnterProgress? scope = EnterProgress.maybeOf(context);
    Widget content = fit ? AutoFit(alignment: alignment, child: child) : child;
    if (scope != null && !scope.generic) {
      final Animation<double> a = scope.animation;
      content = AnimatedBuilder(
        animation: a,
        child: content,
        builder: (BuildContext context, Widget? ch) {
          final double t = Fx.out.transform(((a.value - 0.42) / 0.58).clamp(0.0, 1.0).toDouble());
          return Opacity(
            opacity: t,
            child: Transform.translate(offset: Offset(0, (1 - t) * 8), child: ch),
          );
        },
      );
    }
    final PanelLevel lv = _level;
    Widget panel = RepaintBoundary(
      child: CustomPaint(
        painter: PanelPainter(
          level: lv,
          accent: accent,
          fill: fill,
          border: border,
          progress: scope?.animation,
        ),
        child: Padding(padding: padding, child: content),
      ),
    );
    if (blur && kFxHigh) {
      panel = ClipPath(
        clipper: _PanelClipper(lv),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: panel,
        ),
      );
    }
    return panel;
  }
}

class _PanelClipper extends CustomClipper<Path> {
  const _PanelClipper(this.level);
  final PanelLevel level;

  @override
  Path getClip(Size size) => panelPath(level, size);

  @override
  bool shouldReclip(_PanelClipper old) => old.level != level;
}

/// Insignă teșită cu o pictogramă în culoarea etapei.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 64,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ChamferPainter(
          color: color,
          cut: size * 0.26,
          fillAlpha: 0.14,
          strokeAlpha: 0.70,
          strokeWidth: 1.4,
        ),
        child: Center(child: Icon(icon, color: color, size: size * 0.56)),
      ),
    );
  }
}

/// Rând cu marcaj (pictogramă sau romb de 45°) și text; [lead] apare evidențiat.
class BulletRow extends StatelessWidget {
  const BulletRow({
    super.key,
    required this.text,
    required this.color,
    this.lead,
    this.icon,
    this.size = 24,
    this.gap = 16,
  });

  final String text;
  final String? lead;
  final Color color;
  final IconData? icon;
  final double size;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final Widget marker = icon != null
        ? Padding(
            padding: EdgeInsets.only(top: size * 0.17),
            child: Icon(icon, color: color, size: size),
          )
        : Padding(
            padding: EdgeInsets.only(top: size * 0.47 + 1),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(width: 8, height: 8, color: color),
            ),
          );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        marker,
        SizedBox(width: gap),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: Txt.body(size: size),
              children: <InlineSpan>[
                if (lead != null)
                  TextSpan(
                    text: '$lead ',
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Antet de coloană / secțiune: insignă + etichetă, cu o linie fină dedesubt.
class ColumnHeader extends StatelessWidget {
  const ColumnHeader({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.size = 22,
  });

  final IconData icon;
  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeaderRulePainter(color),
      child: Row(
        children: <Widget>[
          IconBadge(icon: icon, color: color, size: 56),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: Txt.label(color, size: size))),
        ],
      ),
    );
  }
}

class _HeaderRulePainter extends CustomPainter {
  const _HeaderRulePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double x0 = 72; // după insigna de 56 px și spațiul de 16 px
    if (size.width <= x0) return;
    final double y = size.height - 0.75;
    canvas.drawLine(Offset(x0, y), Offset(size.width, y), Paint()..strokeWidth = 1.0..color = color.o(0.30));
    canvas.drawLine(Offset(x0, y), Offset(x0 + 84, y), Paint()..strokeWidth = 2.0..color = color.o(0.90));
  }

  @override
  bool shouldRepaint(_HeaderRulePainter old) => old.color != color;
}

/// Chip teșit: text scurt, cu pictogramă opțională.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.size = 22,
  });

  final String text;
  final Color color;
  final IconData? icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ChamferPainter(
        color: color,
        cut: 9,
        fillAlpha: 0.10,
        strokeAlpha: 0.55,
        strokeWidth: 1.2,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, color: color, size: size + 2),
              const SizedBox(width: 10),
            ],
            Text(text, style: Txt.body(size: size, weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
