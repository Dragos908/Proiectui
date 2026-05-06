import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 10 – 5.1 Avantajele utilizării conservanților
//
// ANIMAȚII FUNDAL:
//   1) Circuit board (verde + auriu)
//   2) Scan line sweep
//   3) Particule flotante
//   4) Neon strip stânga
// ─────────────────────────────────────────────────────────────────────────────

class Slide08BackendSecurity extends StatefulWidget {
  const Slide08BackendSecurity({super.key});
  @override
  State<Slide08BackendSecurity> createState() => _S10State();
}

class _S10State extends State<Slide08BackendSecurity>
    with TickerProviderStateMixin {
  late AnimationController _circuitCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _neonCtrl;

  static const Color _green = Color(0xFF00FF88);
  static const Color _gold  = Color(0xFFFFCC00);

  final List<_AdvData> _advantages = [
    _AdvData(
      number: '1',
      icon: Icons.access_time_filled_rounded,
      color: _green,
      title: 'Prelungirea duratei de valabilitate',
      body: 'Pâinea fără conservanți devine mucegăită în 2–3 zile; '
          'cu propionat de calciu (E282) rămâne proaspătă 10–14 zile. '
          'Sucurile de fructe fără conservanți fermentează în 3–5 zile; '
          'cu benzoat de sodiu pot fi păstrate la temperatura camerei luni de zile.',
    ),
    _AdvData(
      number: '2',
      icon: Icons.health_and_safety_rounded,
      color: _green,
      title: 'Siguranța alimentară și prevenirea bolilor',
      body: 'Fără nitrit de sodiu (E250) în mezeluri, botulismul ar fi mult mai frecvent. '
          'Toxina botulinică este una dintre cele mai periculoase substanțe naturale — '
          'doza letală: ≈ 1,3 ng/kg corp. '
          'Un singur gram de toxină pură ar putea ucide teoretic peste 1 milion de persoane.',
      highlight: '≈ 1,3 ng/kg corp',
    ),
    _AdvData(
      number: '3',
      icon: Icons.recycling_rounded,
      color: _gold,
      title: 'Reducerea risipei alimentare',
      body: 'ONU estimează că se risipesc ≈ 1,3 miliarde tone de alimente anual '
          '(~1/3 din producția mondială). Conservanții contribuie semnificativ '
          'la reducerea acestei cifre. Din perspectivă ecologică, înseamnă '
          'economisirea de apă, energie și teren agricol.',
      highlight: '1,3 mld. tone / an risipite',
    ),
    _AdvData(
      number: '4',
      icon: Icons.public_rounded,
      color: _gold,
      title: 'Distribuția globală a alimentelor',
      body: 'Conservanții fac posibil exportul și importul de produse alimentare '
          'la nivel global. Un iaurt fabricat în România poate fi exportat în '
          'Germania, Franța sau Marea Britanie, menținându-și calitățile și '
          'siguranța pe toată durata transportului (5–15 zile) și a '
          'perioadei de comercializare ulterioare.',
    ),
    _AdvData(
      number: '5',
      icon: Icons.savings_rounded,
      color: _green,
      title: 'Accesibilitate economică',
      body: 'Alimentele conservate chimic sunt în general mai ieftine decât '
          'alternativele organice sau fără conservanți. Aceasta le face accesibile '
          'unor categorii sociale mai largi, contribuind la siguranța alimentară '
          'a populației globale, mai ales în regiunile cu venituri mai mici.',
    ),
    _AdvData(
      number: '6',
      icon: Icons.science_rounded,
      color: _gold,
      title: 'Menținerea calității nutriționale',
      body: 'Antioxidanții (vitamina C, E, BHA, BHT) previn degradarea oxidativă '
          'a nutrienților esențiali și a grăsimilor. Fără aceștia, uleiurile '
          'vegetale ar râncezi rapid, generând compuși toxici (aldehide, peroxizi '
          'lipidici) și pierzându-și valoarea nutritivă.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _circuitCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 5))
      ..repeat();
    _scanCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 9))
      ..repeat();
    _neonCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
  }

  @override
  void dispose() {
    _circuitCtrl.dispose();
    _scanCtrl.dispose();
    _particleCtrl.dispose();
    _neonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('slide_10'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF020609), Color(0xFF060A14), Color(0xFF030D13)],
        ),
      ),
      child: Stack(children: [

        // ── FUNDAL ──────────────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _circuitCtrl,
          builder: (_, __) => CustomPaint(
            painter: _CircuitBoardPainter10(
              progress: _circuitCtrl.value,
              primaryColor: _green,
              secondaryColor: _gold,
            ),
            size: Size.infinite,
          ),
        ),
        AnimatedBuilder(
          animation: _scanCtrl,
          builder: (_, __) => CustomPaint(
            painter: _ScanLinePainter10(
                progress: _scanCtrl.value, color: _green),
            size: Size.infinite,
          ),
        ),
        AnimatedBuilder(
          animation: _particleCtrl,
          builder: (_, __) => CustomPaint(
            painter: _ParticlePainter10(_particleCtrl.value),
            size: Size.infinite,
          ),
        ),

        // Glow orbs
        Positioned(
          top: -120, right: -80,
          child: Container(
            width: 560, height: 560,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                _green.withOpacity(0.09),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -100, left: 60,
          child: Container(
            width: 420, height: 420,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                _gold.withOpacity(0.09),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        // ── CONȚINUT ─────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(56, 32, 56, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── HEADER ──────────────────────────────────────────────────
              Row(children: [
                Container(width: 46, height: 4, color: _green),
                const SizedBox(width: 14),
                const Text('7', style: TextStyle(
                  color: _green, fontSize: 17,
                  fontWeight: FontWeight.w800, letterSpacing: 4,
                )),
                const SizedBox(width: 10),
                Container(width: 1, height: 18,
                    color: _green.withOpacity(0.4)),
                const SizedBox(width: 10),
                Text('CONSERVANȚI ALIMENTARI — BENEFICII',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 14, letterSpacing: 3,
                    )),
              ]).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 10),

              // ── TITLU ────────────────────────────────────────────────────
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [Colors.white, Color(0xFF90FFD0)],
                ).createShader(b),
                child: const Text(
                  'Avantajele conservanților',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -0.5,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 200.ms)
                  .slideY(begin: 0.06, end: 0,
                  duration: 650.ms, delay: 200.ms),

              const SizedBox(height: 20),

              // ── GRID: stânga | foto | dreapta ────────────────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Coloana stânga (1, 2, 3)
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          for (int i = 0; i < 3; i++) ...[
                            if (i > 0) const SizedBox(height: 12),
                            Expanded(
                              child: _AdvantageCard(
                                data: _advantages[i],
                                delay: 300 + i * 120,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 18),

                    // Coloana centru: Fotografie
                    Expanded(
                      flex: 3,
                      child: _PhotoPlaceholder10()
                          .animate()
                          .fadeIn(duration: 700.ms, delay: 300.ms)
                          .scale(
                        begin: const Offset(0.97, 0.97),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        delay: 300.ms,
                      ),
                    ),

                    const SizedBox(width: 18),

                    // Coloana dreapta (4, 5, 6)
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          for (int i = 3; i < 6; i++) ...[
                            if (i > 3) const SizedBox(height: 12),
                            Expanded(
                              child: _AdvantageCard(
                                data: _advantages[i],
                                delay: 300 + i * 120,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── NEON STRIP STÂNGA ─────────────────────────────────────────────
        Positioned(
          left: 0, top: 0, bottom: 0,
          child: AnimatedBuilder(
            animation: _neonCtrl,
            builder: (_, __) => Container(
              width: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _green.withOpacity(0),
                    _green.withOpacity(
                        0.75 +
                            0.25 *
                                math.sin(
                                    _neonCtrl.value * 2 * math.pi)),
                    _gold.withOpacity(0.65),
                    _green.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Model date avantaj
// ─────────────────────────────────────────────────────────────────────────────
class _AdvData {
  final String number;
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String? highlight;
  const _AdvData({
    required this.number,
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    this.highlight,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Card avantaj
// ─────────────────────────────────────────────────────────────────────────────
class _AdvantageCard extends StatelessWidget {
  final _AdvData data;
  final int delay;
  const _AdvantageCard({required this.data, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: data.color.withOpacity(0.26), width: 1.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Număr + icon
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: data.color.withOpacity(0.40)),
                ),
                alignment: Alignment.center,
                child: Text(data.number,
                    style: TextStyle(
                      color: data.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    )),
              ),
              const SizedBox(height: 8),
              Icon(data.icon, color: data.color.withOpacity(0.55), size: 22),
            ],
          ),

          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(data.title,
                    style: TextStyle(
                      color: data.color,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                      height: 1.3,
                    )),
                const SizedBox(height: 6),
                Text(data.body,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.68),
                      fontSize: 14.5,
                      height: 1.5,
                    )),
                if (data.highlight != null) ...[
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: data.color.withOpacity(0.35)),
                    ),
                    child: Text(data.highlight!,
                        style: TextStyle(
                          color: data.color,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                        )),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: delay))
        .slideY(begin: 0.06, end: 0,
        duration: 550.ms, delay: Duration(milliseconds: delay));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Photo Placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _PhotoPlaceholder10 extends StatelessWidget {
  const _PhotoPlaceholder10();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF00FF88).withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/3.jpg', // ← schimbă cu numele fișierului tău
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
class _CornerMark10 extends StatelessWidget {
  final Color color;
  final double len, w;
  final bool flipX, flipY;
  const _CornerMark10({
    required this.color, required this.len, required this.w,
    required this.flipX, required this.flipY,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(len, len),
      painter: _CornerPainter10(color: color, w: w, flipX: flipX, flipY: flipY),
    );
  }
}

class _CornerPainter10 extends CustomPainter {
  final Color color;
  final double w;
  final bool flipX, flipY;
  const _CornerPainter10({required this.color, required this.w, required this.flipX, required this.flipY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.70)
      ..strokeWidth = w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final x  = flipX ? size.width  : 0.0;
    final y  = flipY ? size.height : 0.0;
    final dx = flipX ? -size.width  : size.width;
    final dy = flipY ? -size.height : size.height;
    canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter10 _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// PAINTERS FUNDAL
// ─────────────────────────────────────────────────────────────────────────────

class _CircuitBoardPainter10 extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  _CircuitBoardPainter10(
      {required this.progress,
        required this.primaryColor,
        required this.secondaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(55);
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final nodePaint = Paint()..style = PaintingStyle.fill;
    const gridX = 14;
    const gridY = 10;
    final cellW = size.width / gridX;
    final cellH = size.height / gridY;

    for (int i = 0; i < 24; i++) {
      final seed = i * 19;
      final startX = (seed % gridX) * cellW + cellW / 2;
      final startY = ((seed ~/ gridX) % gridY) * cellH + cellH / 2;
      final isGold = rng.nextDouble() > 0.65;
      final baseColor = isGold ? secondaryColor : primaryColor;
      final pulse = math.sin((progress + i / 24.0) * 2 * math.pi);
      final opacity = 0.04 + 0.07 * ((pulse + 1) / 2);
      linePaint.color = baseColor.withOpacity(opacity);
      nodePaint.color = baseColor.withOpacity(opacity * 2.8);

      final path = Path()..moveTo(startX, startY);
      var cx = startX, cy = startY;
      for (int s = 0; s < 4 + rng.nextInt(3); s++) {
        final dir = rng.nextInt(4);
        final len = (1 + rng.nextInt(2)) * cellW;
        double nx = cx, ny = cy;
        switch (dir) {
          case 0: nx = (cx + len).clamp(0, size.width); break;
          case 1: nx = (cx - len).clamp(0, size.width); break;
          case 2: ny = (cy + len).clamp(0, size.height); break;
          case 3: ny = (cy - len).clamp(0, size.height); break;
        }
        path.lineTo(nx, cy);
        path.lineTo(nx, ny);
        canvas.drawCircle(Offset(nx, ny), 2.8, nodePaint);
        cx = nx;
        cy = ny;
      }
      canvas.drawPath(path, linePaint);
    }

    final dotPaint = Paint()
      ..color = primaryColor.withOpacity(0.04)
      ..style = PaintingStyle.fill;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step)
      for (double y = 0; y < size.height; y += step)
        canvas.drawCircle(Offset(x, y), 1.4, dotPaint);
  }

  @override
  bool shouldRepaint(_CircuitBoardPainter10 old) =>
      old.progress != progress;
}

class _ScanLinePainter10 extends CustomPainter {
  final double progress;
  final Color color;
  _ScanLinePainter10({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final y = progress * size.height;
    final rect = Rect.fromLTWH(0, y - 60, size.width, 120);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            color.withOpacity(0.025),
            color.withOpacity(0.055),
            color.withOpacity(0.025),
            Colors.transparent,
          ],
        ).createShader(rect),
    );
    canvas.drawLine(Offset(0, y), Offset(size.width, y),
        Paint()
          ..color = color.withOpacity(0.10)
          ..strokeWidth = 1.0);
  }

  @override
  bool shouldRepaint(_ScanLinePainter10 old) =>
      old.progress != progress;
}

class _ParticlePainter10 extends CustomPainter {
  final double progress;
  static final _rng = math.Random(77);
  static final List<_P10> _pts = List.generate(
    40,
        (i) => _P10(
      x: _rng.nextDouble(),
      speed: 0.04 + _rng.nextDouble() * 0.14,
      size: 1.0 + _rng.nextDouble() * 2.2,
      isGold: _rng.nextDouble() > 0.65,
      phase: _rng.nextDouble(),
    ),
  );
  _ParticlePainter10(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _pts) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final opacity = 0.15 * math.sin(t * math.pi);
      canvas.drawCircle(
        Offset(p.x * size.width, (1.0 - t) * size.height),
        p.size,
        Paint()
          ..color = (p.isGold
              ? const Color(0xFFFFCC00)
              : const Color(0xFF00FF88))
              .withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter10 old) =>
      old.progress != progress;
}

class _P10 {
  final double x, speed, size, phase;
  final bool isGold;
  const _P10(
      {required this.x,
        required this.speed,
        required this.size,
        required this.isGold,
        required this.phase});
}