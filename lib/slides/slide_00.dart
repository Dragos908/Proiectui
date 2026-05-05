import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Date conservanți
// ─────────────────────────────────────────────────────────────────────────────
class _Preservative {
  final String code;
  final String name;
  final String formula;
  final Color  accent;
  const _Preservative(this.code, this.name, this.formula, this.accent);
}

const List<_Preservative> _kList = [
  _Preservative('E200', 'Acid Sorbic',       'C₆H₈O₂',        Color(0xFF00FFAA)),
  _Preservative('E201', 'Sorbat de Sodiu',   'C₆H₇NaO₂',      Color(0xFF00E5FF)),
  _Preservative('E202', 'Sorbat de Potasiu', 'C₆H₇KO₂',       Color(0xFFFFD740)),
  _Preservative('E203', 'Sorbat de Calciu',  '(C₆H₇O₂)₂Ca',   Color(0xFFFF6E40)),
  _Preservative('E210', 'Acid Benzoic',      'C₇H₆O₂',        Color(0xFFEA80FC)),
];

// ─────────────────────────────────────────────────────────────────────────────
//  Fundal animat
// ─────────────────────────────────────────────────────────────────────────────
class _BgPainter extends CustomPainter {
  final double progress;
  _BgPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final dotP = Paint()..color = const Color(0xFF00E5FF).withOpacity(0.3);
    final rng  = math.Random(42);
    final pts  = <Offset>[];
    for (int i = 0; i < 15; i++) {
      double px = rng.nextDouble() * size.width;
      double py = rng.nextDouble() * size.height;
      px += math.sin(progress * 2 * math.pi + i) * 20;
      py += math.cos(progress * 2 * math.pi + i) * 20;
      pts.add(Offset(px, py));
    }
    for (int i = 0; i < pts.length; i++) {
      canvas.drawCircle(pts[i], 3, dotP);
      for (int j = i + 1; j < pts.length; j++) {
        final d = (pts[i] - pts[j]).distance;
        if (d < 200) {
          canvas.drawLine(pts[i], pts[j],
              Paint()
                ..color = const Color(0xFF00FFAA)
                    .withOpacity((1 - d / 200) * 0.2)
                ..strokeWidth = 1.0);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Painter structuri chimice — cu scalare completă
// ─────────────────────────────────────────────────────────────────────────────
class _StructurePainter extends CustomPainter {
  final double progress;
  final int    index;
  final double scale;
  _StructurePainter(this.progress, this.index, {this.scale = 1.0});

  /// Micro-vibrație termică
  Offset _w(double bx, double by, int i, {double amp = 2.0}) => Offset(
    bx + math.sin(progress * 2 * math.pi + i * 1.1) * amp,
    by + math.cos(progress * 2 * math.pi + i * 0.9) * amp,
  );

  void _bond(Canvas canvas, Offset a, Offset b, Color col) {
    canvas.drawLine(a, b, Paint()
      ..color = col.withOpacity(0.06) ..strokeWidth = 16 * scale ..strokeCap = StrokeCap.round);
    canvas.drawLine(a, b, Paint()
      ..color = col.withOpacity(0.20) ..strokeWidth =  7 * scale ..strokeCap = StrokeCap.round);
    canvas.drawLine(a, b, Paint()
      ..color = col.withOpacity(0.88) ..strokeWidth = 2.4 * scale ..strokeCap = StrokeCap.round);
  }

  void _doubleBond(Canvas canvas, Offset a, Offset b, Color col) {
    final d   = b - a;
    final len = d.distance;
    if (len < 1) return;
    final n     = Offset(-d.dy / len, d.dx / len) * 4.8;
    final pulse = 0.65 + 0.35 * math.sin(progress * 2 * math.pi);

    _bond(canvas, a + n, b + n, col);
    canvas.drawLine(a - n, b - n, Paint()
      ..color = col.withOpacity(0.06 * pulse) ..strokeWidth = 16 * scale ..strokeCap = StrokeCap.round);
    canvas.drawLine(a - n, b - n, Paint()
      ..color = col.withOpacity(0.20 * pulse) ..strokeWidth =  7 * scale ..strokeCap = StrokeCap.round);
    canvas.drawLine(a - n, b - n, Paint()
      ..color = col.withOpacity(0.88)         ..strokeWidth = 2.4 * scale ..strokeCap = StrokeCap.round);
  }

  void _atom(Canvas canvas, Offset pos, String txt, Color textCol, {double fs = 13}) {
    final scaledFs = fs * scale;
    final tp = TextPainter(
      text: TextSpan(
        text: txt,
        style: TextStyle(
            color: textCol, fontSize: scaledFs,
            fontWeight: FontWeight.bold, letterSpacing: 0.2),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final padDx = 5.0 * scale;
    final padDy = 3.0 * scale;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: pos,
          width:  tp.width  + padDx * 2,
          height: tp.height + padDy * 2),
      Radius.circular(5 * scale),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF010C0F).withOpacity(0.92));
    canvas.drawRRect(rrect, Paint()
      ..color = textCol.withOpacity(0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8);
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  E200–E203 : CH₃–CH=CH–CH=CH–COOX
  // ══════════════════════════════════════════════════════════════════════════
  void _drawSorbicChain(Canvas canvas, Size size, Color col, String endGroup) {
    final dx = 44.0 * scale;
    final dy = 24.0 * scale;
    final cx = size.width  / 2 - 10 * scale;
    final cy = size.height / 2 +  5 * scale;

    final base = [
      Offset(cx - 3 * dx, cy + dy),
      Offset(cx - 2 * dx, cy - dy),
      Offset(cx - 1 * dx, cy + dy),
      Offset(cx,           cy - dy),
      Offset(cx + 1 * dx, cy + dy),
      Offset(cx + 2 * dx, cy - dy),
    ];
    final a = List.generate(base.length, (i) => _w(base[i].dx, base[i].dy, i));

    final oD = _w(a[5].dx + 22 * scale, a[5].dy - 38 * scale, 7);
    final oS = _w(a[5].dx + 46 * scale, a[5].dy + 18 * scale, 8);

    _bond(canvas, a[0], a[1], col);
    _doubleBond(canvas, a[1], a[2], col);
    _bond(canvas, a[2], a[3], col);
    _doubleBond(canvas, a[3], a[4], col);
    _bond(canvas, a[4], a[5], col);
    _doubleBond(canvas, a[5], oD, col);
    _bond(canvas, a[5], oS, col);

    _atom(canvas, a[0], 'CH₃', col, fs: 14);
    _atom(canvas, a[1], 'CH',  col, fs: 13);
    _atom(canvas, a[2], 'CH',  col, fs: 13);
    _atom(canvas, a[3], 'CH',  col, fs: 13);
    _atom(canvas, a[4], 'CH',  col, fs: 13);
    _atom(canvas, a[5], 'C',   col, fs: 13);
    _atom(canvas, oD,   'O',   const Color(0xFFFF8080), fs: 14);
    _atom(canvas, oS,   endGroup,
        endGroup.length > 2 ? const Color(0xFFFFB0B0) : const Color(0xFFFF9999),
        fs: endGroup.length > 2 ? 11 : 13);
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  E210 : Acid Benzoic — inel benzenic + COOH
  // ══════════════════════════════════════════════════════════════════════════
  void _drawBenzoicAcid(Canvas canvas, Size size, Color col) {
    final cx = size.width  / 2 - 52 * scale;
    final cy = size.height / 2;
    final r  = 54.0 * scale;

    final hex = List.generate(6, (i) {
      final ang = (i * 60 - 90) * math.pi / 180;
      return _w(cx + r * math.cos(ang), cy + r * math.sin(ang), i, amp: 1.8);
    });

    final c1  = hex[1];
    final cC  = _w(c1.dx + 56 * scale, c1.dy,              7);
    final oDb = _w(cC.dx + 12 * scale, cC.dy - 32 * scale, 8);
    final oSg = _w(cC.dx + 28 * scale, cC.dy + 16 * scale, 9);

    for (int i = 0; i < 6; i++) {
      if (i.isEven) {
        _doubleBond(canvas, hex[i], hex[(i + 1) % 6], col);
      } else {
        _bond(canvas, hex[i], hex[(i + 1) % 6], col);
      }
    }

    final pulse = 0.15 + 0.12 * math.sin(progress * 2 * math.pi);
    canvas.drawCircle(Offset(cx, cy), r * 0.56,
        Paint()
          ..color = col.withOpacity(pulse * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7.0 * scale);
    canvas.drawCircle(Offset(cx, cy), r * 0.56,
        Paint()
          ..color = col.withOpacity(pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 * scale);

    _bond(canvas, c1, cC, col);
    _doubleBond(canvas, cC, oDb, col);
    _bond(canvas, cC, oSg, col);

    for (int i = 0; i < 6; i++) {
      if (i == 1) {
        _atom(canvas, hex[i], 'C',  col, fs: 13);
      } else {
        _atom(canvas, hex[i], 'CH', col, fs: 12);
      }
    }
    _atom(canvas, cC,  'C',  col, fs: 13);
    _atom(canvas, oDb, 'O',  const Color(0xFFFF8080), fs: 14);
    _atom(canvas, oSg, 'OH', const Color(0xFFFF9999), fs: 13);
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (index) {
      case 0: _drawSorbicChain(canvas, size, _kList[0].accent, 'OH');    break;
      case 1: _drawSorbicChain(canvas, size, _kList[1].accent, 'ONa');   break;
      case 2: _drawSorbicChain(canvas, size, _kList[2].accent, 'OK');    break;
      case 3: _drawSorbicChain(canvas, size, _kList[3].accent, 'O⁻Ca'); break;
      case 4: _drawBenzoicAcid(canvas, size, _kList[4].accent);          break;
    }
  }

  @override
  bool shouldRepaint(_StructurePainter old) =>
      old.progress != progress || old.index != index || old.scale != scale;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Slide principal — RESPONSIVE
// ─────────────────────────────────────────────────────────────────────────────
class Slide00Intro extends StatefulWidget {
  const Slide00Intro({super.key});
  @override
  State<Slide00Intro> createState() => _S00State();
}

class _S00State extends State<Slide00Intro>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int    _idx     = 0;
  double _opacity = 1.0;
  Timer? _cycleTimer;

  static const _kShowDuration = Duration(seconds: 7);
  static const _kFadeDuration = Duration(milliseconds: 550);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 10))
      ..repeat();

    _cycleTimer = Timer.periodic(_kShowDuration, (_) async {
      if (!mounted) return;
      setState(() => _opacity = 0.0);
      await Future.delayed(_kFadeDuration);
      if (!mounted) return;
      setState(() {
        _idx     = (_idx + 1) % _kList.length;
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  // ── Calculul factorului de scală ──────────────────────────────────────────
  /// Referință design: 1440 × 900 landscape.
  /// Pe ecrane înguste (< 800 px) se scalează față de 400 px lățime de bază
  /// și se afișează un layout vertical cu scroll.
  static double _computeScale(double w, double h, bool isNarrow) {
    if (isNarrow) {
      return (w / 400).clamp(0.65, 1.6);
    }
    return (math.min(w / 1440, h / 900)).clamp(0.38, 1.6);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w        = constraints.maxWidth;
        final h        = constraints.maxHeight;
        final isNarrow = w < 800;
        final s        = _computeScale(w, h, isNarrow);
        final p        = _kList[_idx];

        final structW  = 420.0 * s;
        final structH  = 290.0 * s;

        return Container(
          key: const ValueKey('slide_00'),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end:   Alignment.bottomRight,
              colors: [Color(0xFF01080B), Color(0xFF02141A), Color(0xFF000507)],
            ),
          ),
          child: Stack(children: [

            // Fundal animat
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => CustomPaint(
                  painter: _BgPainter(_ctrl.value), size: Size.infinite),
            ),

            // Conținut
            isNarrow
                ? _buildNarrowLayout(p, s, structW, structH)
                : _buildWideLayout(p, s, structW, structH),
          ]),
        );
      },
    );
  }

  // ── Layout landscape (≥ 800 px) ──────────────────────────────────────────
  Widget _buildWideLayout(
      _Preservative p, double s, double structW, double structH) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 90 * s, vertical: 52 * s),
      child: Row(children: [

        // ── STÂNGA ───────────────────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.center,
            children: [
              const Spacer(),

              _animatedText('Conservanți', 0, s),
              _animatedText('Chimici', 400, s),

              Padding(
                padding: EdgeInsets.only(top: 20 * s, bottom: 32 * s),
                child: Container(
                  width: 250 * s, height: 3,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFF00FFAA), Color(0xFF00E5FF), Colors.transparent,
                    ]),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(duration: 2.seconds, color: Colors.white70)
                    .animate()
                    .fadeIn(delay: 1.seconds)
                    .scaleX(begin: 0, alignment: Alignment.centerLeft, duration: 800.ms),
              ),

              SizedBox(
                width: 310 * s,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ELABORAT DE',
                      style: TextStyle(
                        color: const Color(0xFF00FFAA).withOpacity(0.55),
                        fontSize: 10 * s,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 6 * s),
                    Text(
                      'Dragoș',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22 * s,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1600.ms),

              const Spacer(),

              Row(children: [
                _MetaChip(icon: Icons.biotech, label: 'IPLT Waldorf', scale: s),
                SizedBox(width: 30 * s),
                _MetaChip(icon: Icons.science,  label: '2026',        scale: s),
              ]).animate().fadeIn(delay: 1500.ms),
            ],
          ),
        ),

        // ── DREAPTA ──────────────────────────────────────────────────────────
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                  width: structW, height: structH,
                  child: AnimatedOpacity(
                    opacity:  _opacity,
                    duration: _kFadeDuration,
                    curve:    Curves.easeInOut,
                    child: AnimatedBuilder(
                      animation: _ctrl,
                      builder: (_, __) => CustomPaint(
                        painter: _StructurePainter(_ctrl.value, _idx, scale: s),
                        size: Size(structW, structH),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1.seconds, duration: 1.seconds)
                    .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),

                SizedBox(height: 20 * s),

                AnimatedOpacity(
                  opacity:  _opacity,
                  duration: _kFadeDuration,
                  child: Column(children: [
                    AnimatedDefaultTextStyle(
                      duration: _kFadeDuration,
                      style: TextStyle(
                        color: p.accent, fontSize: 22 * s,
                        fontWeight: FontWeight.w700, letterSpacing: 3,
                      ),
                      child: Text(p.code),
                    ),
                    SizedBox(height: 4 * s),
                    AnimatedDefaultTextStyle(
                      duration: _kFadeDuration,
                      style: TextStyle(
                        color: p.accent.withOpacity(0.65), fontSize: 14 * s,
                        fontWeight: FontWeight.w300, letterSpacing: 1.4,
                      ),
                      child: Text('${p.name}  ·  ${p.formula}'),
                    ),
                  ]),
                ).animate().fadeIn(delay: 1800.ms),

                SizedBox(height: 18 * s),

                // Indicatori pilule
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_kList.length, (i) {
                    final active = i == _idx;
                    return AnimatedContainer(
                      duration: _kFadeDuration,
                      margin: EdgeInsets.symmetric(horizontal: 4 * s),
                      width:  active ? 26 * s : 8 * s,
                      height: 8 * s,
                      decoration: BoxDecoration(
                        color: active
                            ? _kList[i].accent
                            : _kList[i].accent.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: active
                            ? [BoxShadow(
                            color: _kList[i].accent.withOpacity(0.55),
                            blurRadius: 8)]
                            : null,
                      ),
                    );
                  }),
                ).animate().fadeIn(delay: 2.seconds),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // ── Layout portret / mobil (< 800 px) — scroll vertical ──────────────────
  Widget _buildNarrowLayout(
      _Preservative p, double s, double structW, double structH) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 28 * s, vertical: 36 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _animatedText('Conservanți', 0, s),
          _animatedText('Chimici',     400, s),

          SizedBox(height: 20 * s),

          SizedBox(
            width: structW, height: structH,
            child: AnimatedOpacity(
              opacity:  _opacity,
              duration: _kFadeDuration,
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => CustomPaint(
                  painter: _StructurePainter(_ctrl.value, _idx, scale: s),
                  size: Size(structW, structH),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 1.seconds, duration: 1.seconds),

          SizedBox(height: 12 * s),

          AnimatedOpacity(
            opacity: _opacity,
            duration: _kFadeDuration,
            child: Column(children: [
              AnimatedDefaultTextStyle(
                duration: _kFadeDuration,
                style: TextStyle(
                  color: p.accent, fontSize: 20 * s,
                  fontWeight: FontWeight.w700, letterSpacing: 3,
                ),
                child: Text(p.code),
              ),
              SizedBox(height: 4 * s),
              AnimatedDefaultTextStyle(
                duration: _kFadeDuration,
                style: TextStyle(
                  color: p.accent.withOpacity(0.65), fontSize: 13 * s,
                  fontWeight: FontWeight.w300, letterSpacing: 1.4,
                ),
                child: Text('${p.name}  ·  ${p.formula}'),
              ),
            ]),
          ),

          SizedBox(height: 14 * s),

          // Indicatori pilule
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_kList.length, (i) {
              final active = i == _idx;
              return AnimatedContainer(
                duration: _kFadeDuration,
                margin: EdgeInsets.symmetric(horizontal: 4 * s),
                width:  active ? 24 * s : 8 * s,
                height: 8 * s,
                decoration: BoxDecoration(
                  color: active
                      ? _kList[i].accent
                      : _kList[i].accent.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: active
                      ? [BoxShadow(
                      color: _kList[i].accent.withOpacity(0.55),
                      blurRadius: 8)]
                      : null,
                ),
              );
            }),
          ).animate().fadeIn(delay: 2.seconds),

          SizedBox(height: 28 * s),

          Text(
            'ELABORAT DE',
            style: TextStyle(
              color: const Color(0xFF00FFAA).withOpacity(0.55),
              fontSize: 10 * s,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
            ),
          ).animate().fadeIn(delay: 1600.ms),
          SizedBox(height: 6 * s),
          Text(
            'Dragoș',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20 * s,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(delay: 1700.ms),

          SizedBox(height: 20 * s),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _MetaChip(icon: Icons.biotech, label: 'IPLT Waldorf', scale: s),
            SizedBox(width: 24 * s),
            _MetaChip(icon: Icons.science,  label: '2026',        scale: s),
          ]).animate().fadeIn(delay: 1500.ms),
        ],
      ),
    );
  }

  Widget _animatedText(String text, int delayMs, double s) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, Color(0xFF00FFAA)],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 120 * s,
          fontWeight: FontWeight.w900,
          height: 1.0,
          letterSpacing: -2,
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delayMs.ms, duration: 800.ms)
        .blur(begin: const Offset(20, 0), end: Offset.zero, duration: 1.seconds)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack)
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
        delay: 3.seconds,
        duration: 2.seconds,
        color: const Color(0xFF00FFAA).withOpacity(0.3));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Widget chip meta — scalabil
// ─────────────────────────────────────────────────────────────────────────────
class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final double   scale;
  const _MetaChip({required this.icon, required this.label, this.scale = 1.0});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: const Color(0xFF00FFAA), size: 24 * scale)
        .animate(onPlay: (c) => c.repeat())
        .scale(
        duration: 2.seconds,
        begin: const Offset(0.8, 0.8),
        end:   const Offset(1.1, 1.1),
        curve: Curves.easeInOut),
    SizedBox(width: 12 * scale),
    Text(
      label,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 20 * scale,
        fontWeight: FontWeight.w300,
        letterSpacing: 1.5,
      ),
    ),
  ]);
}