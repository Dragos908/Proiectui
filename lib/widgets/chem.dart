// Piesele comune ale slide-urilor de chimie: fotografii, formule,
// insignele codurilor de pe ambalaje, rânduri cu etichetă și săgeți.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/fx.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import 'glass_card.dart';
import 'panel_shapes.dart';

/// Fotografie cu colțuri teșite, margine fină în culoarea slide-ului, o legendă
/// opțională (jos, stânga).
/// Dacă fișierul lipsește, apare un înlocuitor cu legenda, nu o eroare.
class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    required this.photo,
    this.caption,
    this.accent = Palette.cyan,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.background = const Color(0xFF0B1627),
    this.cut = 22,
    this.captionSize = 22,
  });

  final Photo photo;
  final String? caption;
  final Color accent;
  final BoxFit fit;
  final Alignment alignment;
  final Color background;
  final double cut;
  final double captionSize;

  @override
  Widget build(BuildContext context) {
    final Widget img = Image.asset(
      photo.path,
      fit: fit,
      alignment: alignment,
      filterQuality: FilterQuality.medium,
      semanticLabel: caption ?? photo.file,
      errorBuilder: (BuildContext context, Object error, StackTrace? st) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            caption ?? photo.file,
            textAlign: TextAlign.center,
            style: Txt.body(size: 22, color: accent, alpha: 0.7),
          ),
        ),
      ),
    );
    return CustomPaint(
      foregroundPainter: _EdgePainter(accent, cut),
      child: ClipPath(
        clipper: _ChamferClipper(cut),
        child: ColoredBox(
          color: background,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              img,
              // Umbră jos, ca legenda să se citească pe orice fotografie.
              if (caption != null) const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 96,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0x00050B17), Color(0xCC050B17)],
                    ),
                  ),
                ),
              ),
              if (caption != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 8,
                  child: Text(
                    caption!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Txt.body(size: captionSize, weight: FontWeight.w600, alpha: 0.96),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChamferClipper extends CustomClipper<Path> {
  const _ChamferClipper(this.cut);
  final double cut;

  @override
  Path getClip(Size size) {
    final double c = math.min(cut, math.min(size.width, size.height) / 3);
    return chamferPath(Offset.zero & size, tl: c, br: c);
  }

  @override
  bool shouldReclip(_ChamferClipper old) => old.cut != cut;
}

class _EdgePainter extends CustomPainter {
  const _EdgePainter(this.color, this.cut);
  final Color color;
  final double cut;

  @override
  void paint(Canvas canvas, Size size) {
    final double c = math.min(cut, math.min(size.width, size.height) / 3);
    final Path p = chamferPath((Offset.zero & size).deflate(0.75), tl: c, br: c);
    canvas.drawPath(
      p,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = color.o(0.55),
    );
    final Paint hi = Paint()
      ..strokeWidth = Fx.heavy
      ..color = Color.lerp(color, Palette.gheata, 0.5)!.o(0.9);
    canvas.drawLine(Offset(0, c), Offset(c, 0), hi);
    canvas.drawLine(Offset(size.width, size.height - c), Offset(size.width - c, size.height), hi);
  }

  @override
  bool shouldRepaint(_EdgePainter old) => old.color != color || old.cut != cut;
}

/// Formulă chimică, în font monospațiat. Indicele „ₙ” (care lipsește din fonturi)
/// se desenează ca un „n” mic, coborât. Textul dintre « și » apare în [highlight].
class Eq extends StatelessWidget {
  const Eq(
    this.text, {
    super.key,
    this.size = 26,
    this.color = Palette.gheata,
    this.highlight = Palette.gold,
    this.textAlign = TextAlign.start,
    this.weight = FontWeight.w500,
  });

  final String text;
  final double size;
  final Color color;
  final Color highlight;
  final TextAlign textAlign;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = Txt.mono(color, size: size, weight: weight, height: 1.45);
    final TextStyle hl = base.copyWith(color: highlight, fontWeight: FontWeight.w700);
    final List<InlineSpan> spans = <InlineSpan>[];
    bool on = false;
    final StringBuffer buf = StringBuffer();
    void flush() {
      if (buf.isEmpty) return;
      spans.add(TextSpan(text: buf.toString(), style: on ? hl : base));
      buf.clear();
    }

    for (final int rune in text.runes) {
      final String ch = String.fromCharCode(rune);
      if (ch == '«' || ch == '»') {
        flush();
        on = ch == '«';
      } else if (ch == 'ₙ') {
        flush();
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Transform.translate(
              offset: Offset(0, size * 0.22),
              child: Text('n', style: (on ? hl : base).copyWith(fontSize: size * 0.68)),
            ),
          ),
        );
      } else {
        buf.write(ch);
      }
    }
    flush();
    return Text.rich(TextSpan(children: spans), textAlign: textAlign);
  }
}

/// Insigna unui cod de pe ambalaj: triunghiul de săgeți, numărul în mijloc și
/// abrevierea dedesubt (ca pe ambalaj).
class ResinBadge extends StatelessWidget {
  const ResinBadge({
    super.key,
    required this.code,
    required this.abbr,
    required this.color,
    this.size = 132,
  });

  final int code;
  final String abbr;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: size,
            height: size * 0.9,
            child: CustomPaint(
              painter: _TrianglePainter(color),
              child: Align(
                alignment: const Alignment(0, 0.28),
                child: Text('$code', style: Txt.hero(color, size: size * 0.36)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(abbr, style: Txt.strong(color, size: size * 0.2)),
          ),
        ],
      ),
    );
  }
}

/// Triunghiul de pe ambalaje: trei săgeți care se urmăresc.
class _TrianglePainter extends CustomPainter {
  const _TrianglePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double a = math.min(size.width, size.height / 0.87) * 0.94;
    final double h = a * math.sqrt(3) / 2;
    final Offset c = Offset(size.width / 2, size.height / 2 + h * 0.04);
    final List<Offset> v = <Offset>[
      c + Offset(0, -h * 2 / 3),
      c + Offset(a / 2, h / 3),
      c + Offset(-a / 2, h / 3),
    ];
    final Paint line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = a * 0.055
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    canvas.drawPath(
      Path()
        ..moveTo(v[0].dx, v[0].dy)
        ..lineTo(v[1].dx, v[1].dy)
        ..lineTo(v[2].dx, v[2].dy)
        ..close(),
      Paint()..color = color.o(0.08),
    );
    for (int i = 0; i < 3; i++) {
      final Offset p0 = v[i];
      final Offset p1 = v[(i + 1) % 3];
      final Offset d = (p1 - p0) / (p1 - p0).distance;
      final Offset s = p0 + d * a * 0.14; // un mic spațiu la fiecare colț
      final Offset e = p1 - d * a * 0.14;
      canvas.drawLine(s, e, line);
      // vârful săgeții
      final Offset n = Offset(-d.dy, d.dx);
      final double w = a * 0.09;
      canvas.drawPath(
        Path()
          ..moveTo(e.dx + d.dx * w * 0.9, e.dy + d.dy * w * 0.9)
          ..lineTo(e.dx + n.dx * w, e.dy + n.dy * w)
          ..lineTo(e.dx - n.dx * w, e.dy - n.dy * w)
          ..close(),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}

/// Rând cu etichetă (stânga, colorată) și text (dreapta): „Monomer: …”.
class LabeledLine extends StatelessWidget {
  const LabeledLine({
    super.key,
    required this.label,
    required this.text,
    required this.color,
    this.size = 24,
    this.labelWidth = 150,
    this.child,
  });

  final String label;
  final String text;
  final Color color;
  final double size;
  final double labelWidth;

  /// Conținut în locul textului (de exemplu o formulă).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: labelWidth,
          child: Padding(
            padding: EdgeInsets.only(top: size * 0.12),
            child: Text(
              label.toUpperCase(),
              style: Txt.label(color, size: size * 0.86).copyWith(fontSize: size * 0.8),
            ),
          ),
        ),
        Expanded(child: child ?? Text(text, style: Txt.body(size: size))),
      ],
    );
  }
}

/// Săgeată orizontală subțire, cu vârf, în culoarea dată.
class ArrowRight extends StatelessWidget {
  const ArrowRight({super.key, required this.color, this.width = 60, this.height = 24});

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _ArrowPainter(color)),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double y = size.height / 2;
    canvas.drawLine(
      Offset(2, y),
      Offset(size.width - 6, y),
      Paint()
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width, y)
        ..lineTo(size.width - 14, y - 8)
        ..lineTo(size.width - 14, y + 8)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.color != color;
}

/// O catenă desenată (bile și bețe), pentru ilustrații mici în carduri.
/// [atoms] = numărul de atomi de C; [hydrogens] adaugă H sus și jos.
class ChainSketch extends StatelessWidget {
  const ChainSketch({
    super.key,
    required this.color,
    this.atoms = 8,
    this.hydrogens = true,
    this.breakAt = -1,
    this.height = 90,
  });

  final Color color;
  final int atoms;
  final bool hydrogens;

  /// Legătura ruptă (după atomul cu acest indice); −1 = niciuna.
  final int breakAt;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _ChainSketchPainter(color, atoms, hydrogens, breakAt),
        size: Size.infinite,
      ),
    );
  }
}

class _ChainSketchPainter extends CustomPainter {
  const _ChainSketchPainter(this.color, this.atoms, this.hydrogens, this.breakAt);
  final Color color;
  final int atoms;
  final bool hydrogens;
  final int breakAt;

  @override
  void paint(Canvas canvas, Size size) {
    final double step = size.width / (atoms + 0.4);
    final double amp = math.min(size.height * 0.16, step * 0.3);
    final double cy = size.height / 2;
    final double r = math.min(step * 0.2, size.height * 0.12);
    final List<Offset> c = <Offset>[
      for (int i = 0; i < atoms; i++)
        Offset(step * (i + 0.7) + (breakAt >= 0 && i > breakAt ? step * 0.35 : 0) - (breakAt >= 0 ? step * 0.17 : 0),
            cy + (i.isEven ? -amp : amp)),
    ];
    final Paint bond = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = color.o(0.75);
    final Paint hBond = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Palette.ceata.o(0.55);
    for (int i = 0; i < atoms; i++) {
      if (hydrogens) {
        final double dir = i.isEven ? -1 : 1;
        final Offset h1 = c[i] + Offset(-r * 1.3, dir * r * 2.6);
        final Offset h2 = c[i] + Offset(r * 1.3, dir * r * 2.6);
        canvas.drawLine(c[i], h1, hBond);
        canvas.drawLine(c[i], h2, hBond);
        canvas.drawCircle(h1, r * 0.55, Paint()..color = Palette.gheata.o(0.85));
        canvas.drawCircle(h2, r * 0.55, Paint()..color = Palette.gheata.o(0.85));
      }
      if (i < atoms - 1 && i != breakAt) canvas.drawLine(c[i], c[i + 1], bond);
    }
    for (final Offset o in c) {
      canvas.drawCircle(o, r, Paint()..color = color);
      canvas.drawCircle(o + Offset(-r * 0.3, -r * 0.3), r * 0.3, Paint()..color = Palette.gheata.o(0.45));
    }
  }

  @override
  bool shouldRepaint(_ChainSketchPainter old) =>
      old.color != color || old.atoms != atoms || old.hydrogens != hydrogens || old.breakAt != breakAt;
}

/// Listă de puncte scurte, cu marcaj în culoarea dată. Un punct scris
/// „Început|rest” are începutul evidențiat în culoare.
class PointList extends StatelessWidget {
  const PointList(
    this.items, {
    super.key,
    required this.color,
    this.size = 24,
    this.gap = 10,
  });

  final List<String> items;
  final Color color;
  final double size;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: gap),
          _row(items[i]),
        ],
      ],
    );
  }

  Widget _row(String item) {
    final int k = item.indexOf('|');
    return BulletRow(
      lead: k < 0 ? null : item.substring(0, k),
      text: k < 0 ? item : item.substring(k + 1),
      color: color,
      size: size,
      gap: 14,
    );
  }
}
