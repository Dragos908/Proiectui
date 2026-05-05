import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 07 – 4.1 Benzoatul de Sodiu (E211)
//
// ANIMAȚII FUNDAL:
//   1) Circuit board cu trace-uri și semnale călătoare
//   2) Scan beam orizontal (ping-pong) cu bracket-uri HUD
// ─────────────────────────────────────────────────────────────────────────────

class Slide05TipuriAppWeb extends StatefulWidget {
  const Slide05TipuriAppWeb({super.key});
  @override
  State<Slide05TipuriAppWeb> createState() => _Slide07State();
}

class _Slide07State extends State<Slide05TipuriAppWeb>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final Color _accent = const Color(0xFF00F0FF);

  final List<Map<String, String>> _tableRows = [
    {
      'prop': 'Denumire chimică',
      'val': 'Sarea de sodiu a acidului benzoic (C₆H₅-COONa)',
    },
    {
      'prop': 'Formula moleculară',
      'val': 'C₇H₅NaO₂   ·   Masă moleculară: 144,11 g/mol',
    },
    {
      'prop': 'Aspect fizic',
      'val':
      'Pulbere cristalină albă sau granule albe, inodore, gust slab dulce-acru',
    },
    {
      'prop': 'Solubilitate',
      'val': 'Solubil în apă rece (1:2) și în alcool (1:49)',
    },
    {
      'prop': 'pH optim de acțiune',
      'val': 'Sub 4,5 (mediu acid) – eficient în băuturi carbogazoase',
    },
    {
      'prop': 'DZA',
      'val': '5 mg/kg corp/zi  →  max. 350 mg/zi pentru un adult de 70 kg',
    },
    {
      'prop': 'Conc. max. admisă UE',
      'val': 'Până la 250–1000 mg/kg, în funcție de categoria alimentului',
    },
    {
      'prop': 'Obținere industrială',
      'val': 'Din toluen prin oxidare chimică + neutralizare cu NaOH',
    },
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('slide_07'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF020609), Color(0xFF060A14), Color(0xFF030D13)],
        ),
      ),
      child: Stack(children: [
        // ── 0: Dot grid static ──────────────────────────────────────────────
        CustomPaint(painter: _DotGridPainter07(), size: Size.infinite),

        // ── 1: Circuit board animat ─────────────────────────────────────────
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            painter: _CircuitBoardPainter07(_ctrl.value, _accent),
            size: Size.infinite,
          ),
        ),

        // ── 2: Scan beam orizontal animat ───────────────────────────────────
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            painter: _ScanBeamPainter07(_ctrl.value, _accent),
            size: Size.infinite,
          ),
        ),

        // Glow radial fundal dreapta-sus
        Positioned(
          top: -100,
          right: -60,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                _accent.withOpacity(0.08),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        // Neon strip stânga
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Container(
              width: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _accent.withOpacity(0),
                    _accent.withOpacity(
                        0.75 + 0.25 * math.sin(_ctrl.value * 2 * math.pi)),
                    Colors.white.withOpacity(0.5),
                    _accent.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Conținut principal ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 44, 40, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ────────────────────────────────────────────────────
              Row(children: [
                Container(width: 36, height: 3, color: _accent),
                const SizedBox(width: 12),
                Text('5',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    )),
                const SizedBox(width: 12),
                Container(
                    width: 1, height: 16, color: _accent.withOpacity(0.3)),
                const SizedBox(width: 12),
                Text('ADITIVI ALIMENTARI — CONSERVANȚI',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.38),
                      fontSize: 16,
                      letterSpacing: 3,
                    )),
              ]).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 20),

              // ── TITLU PRINCIPAL ───────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.science_outlined, color: _accent, size: 32),
                  const SizedBox(width: 14),
                  Text(
                    'BENZOATUL DE SODIU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border:
                      Border.all(color: _accent.withOpacity(0.5)),
                    ),
                    child: Text(
                      'E211',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 150.ms),

              const SizedBox(height: 22),

              // ── CONȚINUT: tabel stânga + mecanism dreapta ─────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── STÂNGA – Tabel proprietăți ─────────────────────────
                    Expanded(
                      flex: 55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Proprietăți fizico-chimice',
                            style: TextStyle(
                              color: _accent,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ).animate().fadeIn(
                              duration: 400.ms, delay: 300.ms),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: _accent.withOpacity(0.2)),
                                color: _accent.withOpacity(0.03),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                children: [
                                  // header tabel
                                  Container(
                                    color: _accent.withOpacity(0.12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    child: Row(children: [
                                      Expanded(
                                        flex: 35,
                                        child: Text('Proprietate',
                                            style: TextStyle(
                                              color: _accent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 65,
                                        child: Text('Detalii',
                                            style: TextStyle(
                                              color: _accent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                            )),
                                      ),
                                    ]),
                                  ),
                                  // rânduri
                                  Expanded(
                                    child: ListView.builder(
                                      physics:
                                      const BouncingScrollPhysics(),
                                      itemCount: _tableRows.length,
                                      itemBuilder: (context, i) {
                                        final row = _tableRows[i];
                                        final even = i % 2 == 0;
                                        return Container(
                                          color: even
                                              ? Colors.transparent
                                              : Colors.white
                                              .withOpacity(0.03),
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 9),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 35,
                                                child: Text(
                                                  row['prop']!,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.85),
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    height: 1.45,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 65,
                                                child: Text(
                                                  row['val']!,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.68),
                                                    fontSize: 15,
                                                    height: 1.45,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ).animate().fadeIn(
                                            duration: 350.ms,
                                            delay: Duration(
                                                milliseconds:
                                                400 + i * 60));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 28),

                    // ── DREAPTA – Mecanism + Reacție controversată ──────────
                    Expanded(
                      flex: 45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─ Mecanism de acțiune ─
                          _InfoCard(
                            accent: _accent,
                            icon: Icons.biotech_outlined,
                            title: 'Mecanism de acțiune',
                            body:
                            'Benzoatul de sodiu pătrunde în celula microbiană sub formă de '
                                'acid benzoic (în mediu acid), unde inhibă enzimele glicolitice '
                                'responsabile de metabolizarea glucozei. Practic, blochează sursa '
                                'de energie a microorganismului, provocând moartea acestuia.\n\n'
                                'Este bacteriostatic și fungistatic — inhibă, nu neapărat ucide.',
                          ).animate().slideX(
                              begin: 0.08,
                              end: 0,
                              duration: 450.ms,
                              delay: 400.ms),

                          const SizedBox(height: 16),

                          // ─ Reacție controversată ─
                          _WarningCard(
                            title: 'Reacție chimică controversată',
                            body:
                            'E211 + vitamina C (acid ascorbic, E300) poate produce '
                                'benzen (C₆H₆) — substanță cancerigenă dovedită, asociată '
                                'cu leucemia. Reacția este accelerată de căldură și lumină UV.\n\n'
                                'Din această cauză, Coca-Cola și alți producători au eliminat '
                                'treptat benzoatul de sodiu din produsele care conțin și '
                                'vitamina C adăugată.',
                            reaction:
                            'E211 + E300  →  C₆H₆ + CO₂ + H₂O\n'
                                'C₇H₅NaO₂ + C₆H₈O₆  →  benzen + CO₂ + H₂O + alte produse',
                            note:
                            'Cantitățile produse în condiții normale sunt mici, însă '
                                'prezența benzenului în băuturi a generat controverse majore și '
                                'investigații FDA / EFSA începând cu anii 2000.',
                          ).animate().slideX(
                              begin: 0.08,
                              end: 0,
                              duration: 450.ms,
                              delay: 550.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card: Mecanism de acțiune
// ─────────────────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String body;

  const _InfoCard({
    required this.accent,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.25)),
        color: accent.withOpacity(0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: accent, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: accent,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card: Reacție controversată (cu evidențiere portocalie de avertizare)
// ─────────────────────────────────────────────────────────────────────────────
class _WarningCard extends StatelessWidget {
  final String title;
  final String body;
  final String reaction;
  final String note;

  static const Color _warn = Color(0xFFFF8C42);

  const _WarningCard({
    required this.title,
    required this.body,
    required this.reaction,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _warn.withOpacity(0.40)),
        color: _warn.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.warning_amber_rounded, color: _warn, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Reacție chimică controversată',
              style: TextStyle(
                color: _warn,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 15,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          // Reacție chimică
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _warn.withOpacity(0.10),
              border: Border.all(color: _warn.withOpacity(0.30)),
            ),
            child: Text(
              reaction,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'monospace',
                height: 1.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline,
                  size: 13, color: Colors.white.withOpacity(0.35)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  note,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 16,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painters fundal Slide 07
// ─────────────────────────────────────────────────────────────────────────────

class _DotGridPainter07 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..style = PaintingStyle.fill;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step)
      for (double y = 0; y < size.height; y += step)
        canvas.drawCircle(Offset(x, y), 1.5, p);
  }

  @override
  bool shouldRepaint(_DotGridPainter07 _) => false;
}

/// ANIMAȚIE 1 — Circuit board: trace-uri + junction pads + semnale călătoare
class _CircuitBoardPainter07 extends CustomPainter {
  final double t;
  final Color accent;
  _CircuitBoardPainter07(this.t, this.accent);

  static const _hRatios = [0.10, 0.22, 0.35, 0.48, 0.60, 0.73, 0.86, 0.95];
  static const _vRatios = [0.18, 0.33, 0.52, 0.68, 0.84];

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final tp = Paint()..style = PaintingStyle.stroke..strokeWidth = 0.8;

    for (final ry in _hRatios) {
      tp.color = accent.withOpacity(0.055);
      canvas.drawLine(Offset(0, h * ry), Offset(w, h * ry), tp);
    }
    for (final rx in _vRatios) {
      tp.color = accent.withOpacity(0.055);
      canvas.drawLine(Offset(w * rx, 0), Offset(w * rx, h), tp);
    }

    final jFill = Paint()
      ..color = accent.withOpacity(0.13)
      ..style = PaintingStyle.fill;
    final jStroke = Paint()
      ..color = accent.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (final ry in _hRatios) {
      for (final rx in _vRatios) {
        final c = Offset(w * rx, h * ry);
        canvas.drawCircle(c, 2.5, jFill);
        canvas.drawRect(
            Rect.fromCenter(center: c, width: 7, height: 7), jStroke);
      }
    }

    for (int i = 0; i < _hRatios.length; i++) {
      final phase = (t * (0.55 + i * 0.05) + i * 0.125) % 1.0;
      final x = w * phase;
      final y = h * _hRatios[i];
      canvas.drawCircle(
          Offset(x, y),
          5,
          Paint()
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
            ..color = accent.withOpacity(0.55));
      canvas.drawCircle(
          Offset(x, y), 1.8, Paint()..color = Colors.white.withOpacity(0.9));
      canvas.drawLine(
          Offset(x - 36, y),
          Offset(x, y),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..shader = LinearGradient(
              colors: [accent.withOpacity(0), accent.withOpacity(0.45)],
            ).createShader(Rect.fromLTWH(x - 36, y - 1, 36, 2)));
    }

    for (int i = 0; i < _vRatios.length; i += 2) {
      final phase = (t * (0.38 + i * 0.04) + i * 0.22) % 1.0;
      final x = w * _vRatios[i];
      final y = h * phase;
      canvas.drawCircle(
          Offset(x, y),
          4,
          Paint()
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
            ..color = accent.withOpacity(0.4));
      canvas.drawCircle(
          Offset(x, y),
          1.5,
          Paint()..color = Colors.white.withOpacity(0.75));
    }
  }

  @override
  bool shouldRepaint(_CircuitBoardPainter07 old) => old.t != t;
}

/// ANIMAȚIE 2 — Scan beam orizontal cu bracket-uri HUD
class _ScanBeamPainter07 extends CustomPainter {
  final double t;
  final Color accent;
  _ScanBeamPainter07(this.t, this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final ping = (math.sin(t * math.pi * 2) + 1) / 2;
    final y = size.height * ping;
    const beamH = 90.0;

    canvas.drawRect(
      Rect.fromLTWH(0, y - beamH / 2, size.width, beamH),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accent.withOpacity(0),
            accent.withOpacity(0.05),
            accent.withOpacity(0.11),
            accent.withOpacity(0.05),
            accent.withOpacity(0),
          ],
        ).createShader(
            Rect.fromLTWH(0, y - beamH / 2, size.width, beamH)),
    );

    canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = accent.withOpacity(0.20)
          ..strokeWidth = 1.0);

    final bp = Paint()
      ..color = accent.withOpacity(0.55)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const bLen = 10.0;
    const bX = 24.0;
    const bIn = 10.0;
    canvas.drawLine(Offset(bX, y - bLen), Offset(bX, y + bLen), bp);
    canvas.drawLine(Offset(bX, y - bLen), Offset(bX + bIn, y - bLen), bp);
    canvas.drawLine(Offset(bX, y + bLen), Offset(bX + bIn, y + bLen), bp);
    final rx = size.width - bX;
    canvas.drawLine(Offset(rx, y - bLen), Offset(rx, y + bLen), bp);
    canvas.drawLine(Offset(rx, y - bLen), Offset(rx - bIn, y - bLen), bp);
    canvas.drawLine(Offset(rx, y + bLen), Offset(rx - bIn, y + bLen), bp);
  }

  @override
  bool shouldRepaint(_ScanBeamPainter07 old) => old.t != t;
}