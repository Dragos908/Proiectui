import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 09 – 4.3 Nitritul și Nitratul de Sodiu (E250 și E251)
//
// ANIMAȚII FUNDAL:
//   1) Circuit board cu trace-uri pulsatoare (cyan + roșu)
//   2) Scan line orizontal
//   3) Particule flotante
//   4) Neon strip stânga (animat)
// ─────────────────────────────────────────────────────────────────────────────

class Slide07DesktopGaming extends StatefulWidget {
  const Slide07DesktopGaming({super.key});
  @override
  State<Slide07DesktopGaming> createState() => _S09State();
}

class _S09State extends State<Slide07DesktopGaming>
    with TickerProviderStateMixin {
  late AnimationController _circuitCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _neonCtrl;

  static const Color _cyan = Color(0xFF00F0FF);
  static const Color _red  = Color(0xFFFF3B3B);

  final List<Map<String, String>> _tableRows = [
    {
      'prop': 'Formula chimică',
      'e250': 'NaNO₂',
      'e251': 'NaNO₃',
    },
    {
      'prop': 'Aspect',
      'e250': 'Pulbere cristalină albă sau ușor gălbuie',
      'e251': 'Pulbere cristalină albă, granulară',
    },
    {
      'prop': 'Mecanism\nde acțiune',
      'e250': 'Inhibă direct Clostridium botulinum; formează oxid nitric care blochează respirația bacteriană',
      'e251': 'Convertit treptat în nitrit de bacterii (conservant cu acțiune lentă / de rezervă)',
    },
    {
      'prop': 'Rolul culorii',
      'e250': 'Reacționează cu mioglobina → culoare roz-roșiatică stabilă (nitrozomioglobină)',
      'e251': 'Efect similar, dar mai lent',
    },
    {
      'prop': 'DZA',
      'e250': '0,06 mg/kg corp\n(EXTREM DE MICĂ)',
      'e251': '3,7 mg/kg corp',
    },
    {
      'prop': 'Conc. max. UE',
      'e250': '150 mg/kg\nîn produse din carne',
      'e251': '250 mg/kg\nîn produse din carne',
    },
    {
      'prop': 'Interzis în',
      'e250': 'Norvegia, Suedia, Canada, parțial Germania',
      'e251': 'Reglementat strict UE, SUA, Canada',
    },
    {
      'prop': 'Risc major',
      'e250': 'Formare de nitrozamine cancerigene la temp. înaltă',
      'e251': 'Formare de nitrozamine prin conversie în nitrit',
    },
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
      key: const ValueKey('slide_09'),
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
            painter: _CircuitBoardPainter09(
              progress: _circuitCtrl.value,
              primaryColor: _cyan,
              secondaryColor: _red,
            ),
            size: Size.infinite,
          ),
        ),
        AnimatedBuilder(
          animation: _scanCtrl,
          builder: (_, __) => CustomPaint(
            painter: _ScanLinePainter09(
              progress: _scanCtrl.value,
              color: _cyan,
            ),
            size: Size.infinite,
          ),
        ),
        AnimatedBuilder(
          animation: _particleCtrl,
          builder: (_, __) => CustomPaint(
            painter: _ParticlePainter09(_particleCtrl.value),
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
                _cyan.withOpacity(0.09),
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
                _red.withOpacity(0.08),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        // ── CONȚINUT ─────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(48, 32, 48, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── HEADER ──────────────────────────────────────────────────
              Row(children: [
                Container(width: 46, height: 4, color: _cyan),
                const SizedBox(width: 14),
                const Text('6', style: TextStyle(
                  color: _cyan, fontSize: 21,
                  fontWeight: FontWeight.w800, letterSpacing: 4,
                )),
                const SizedBox(width: 10),
                Container(width: 1, height: 22,
                    color: _cyan.withOpacity(0.4)),
                const SizedBox(width: 10),
                Text('ADITIVI ALIMENTARI — CONSERVANȚI',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 16, letterSpacing: 3,
                    )),
              ]).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 10),

              // ── TITLU + BADGE-URI ──────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.warning_rounded, color: _red, size: 34),
                  const SizedBox(width: 14),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFFFB0B0)],
                    ).createShader(b),
                    child: const Text(
                      'NITRITUL ȘI NITRATUL DE SODIU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _Badge09(label: 'E250', color: _red),
                  const SizedBox(width: 8),
                  _Badge09(label: 'E251', color: _cyan),
                ],
              ).animate()
                  .fadeIn(duration: 700.ms, delay: 200.ms)
                  .slideY(begin: 0.06, end: 0, duration: 600.ms, delay: 200.ms),

              const SizedBox(height: 14),

              // ── LAYOUT PRINCIPAL: tabel stânga | carduri dreapta ─────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── STÂNGA: Tabel comparativ ──────────────────────────
                    Expanded(
                      flex: 58,
                      child: Column(
                        children: [
                          // Header tabel
                          Container(
                            decoration: BoxDecoration(
                              color: _cyan.withOpacity(0.11),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(11),
                                topRight: Radius.circular(11),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 9),
                            child: Row(children: [
                              Expanded(flex: 22,
                                  child: Text('Proprietate',
                                      style: TextStyle(color: _cyan,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8))),
                              Expanded(flex: 39,
                                  child: Row(children: [
                                    _BadgeSmall09(label: 'E250', color: _red),
                                    const SizedBox(width: 7),
                                    Text('Nitrit de Sodiu',
                                        style: TextStyle(color: _red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                  ])),
                              Expanded(flex: 39,
                                  child: Row(children: [
                                    _BadgeSmall09(label: 'E251', color: _cyan),
                                    const SizedBox(width: 7),
                                    Text('Nitrat de Sodiu',
                                        style: TextStyle(color: _cyan,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                  ])),
                            ]),
                          ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

                          // Rânduri tabel (wrapped într-un Expanded propriu)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _cyan.withOpacity(0.16)),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(11),
                                  bottomRight: Radius.circular(11),
                                ),
                                color: _cyan.withOpacity(0.02),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: _tableRows.length,
                                itemBuilder: (context, i) {
                                  final row = _tableRows[i];
                                  final even = i % 2 == 0;
                                  // DZA row gets a subtle red tint
                                  final isDza = row['prop']!.contains('DZA');
                                  return Container(
                                    color: isDza
                                        ? _red.withOpacity(0.06)
                                        : even
                                        ? Colors.transparent
                                        : Colors.white.withOpacity(0.022),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Expanded(flex: 22,
                                            child: Text(row['prop']!,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.85),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.4,
                                                ))),
                                        Expanded(flex: 39,
                                            child: Text(row['e250']!,
                                                style: TextStyle(
                                                  color: isDza
                                                      ? _red.withOpacity(0.9)
                                                      : Colors.white
                                                      .withOpacity(0.62),
                                                  fontSize: 14,
                                                  height: 1.4,
                                                  fontWeight: isDza
                                                      ? FontWeight.w700
                                                      : FontWeight.normal,
                                                ))),
                                        Expanded(flex: 39,
                                            child: Text(row['e251']!,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.62),
                                                  fontSize: 14,
                                                  height: 1.4,
                                                ))),
                                      ],
                                    ),
                                  ).animate().fadeIn(
                                      duration: 320.ms,
                                      delay: Duration(
                                          milliseconds: 380 + i * 50));
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Card: Rol dublu esențial
                          _InfoCard09(
                            color: _cyan,
                            icon: Icons.balance_outlined,
                            title: 'Rolul dublu esențial',
                            body:
                            'Previne cu eficiență deosebită toxiinfecția botulinică '
                                '(botulismul) — una dintre cele mai periculoase intoxicații '
                                'alimentare, potențial letală chiar și în cantități microscopice '
                                'de toxină.\n\n'
                                'Totodată, conferă mezelurilor culoarea roz-roșiatică '
                                'atractivă — fără E250, produsele ar arăta gri-cenușiu, '
                                'neapetisant.',
                          ).animate()
                              .fadeIn(duration: 500.ms, delay: 450.ms)
                              .slideX(begin: -0.07, end: 0,
                              duration: 450.ms, delay: 450.ms),

                          const SizedBox(height: 14),

                          // Card: Formarea nitrozaminelor (warning)
                          _DangerCard09(
                            icon: Icons.science_outlined,
                            title: 'Formarea nitrozaminelor',
                            body:
                            'NaNO₂ (nitrit) + aminele din proteinele cărnii → '
                                'nitrozamine (R₂N-NO) — cancerigene și mutagene.\n\n'
                                'Reacția este accelerată de: temperatură înaltă (prăjire, '
                                'grătar), mediu acid (suc gastric), absența antioxidanților '
                                '(vitamina C, E).',
                            reactionLine:
                            'E250 + amine  →  R₂N-NO  →  cancerigen',
                          ).animate()
                              .fadeIn(duration: 500.ms, delay: 580.ms)
                              .slideX(begin: -0.07, end: 0,
                              duration: 450.ms, delay: 580.ms),

                          const SizedBox(height: 12),

                          // ── OMS WARNING (stânga, sub carduri) ────────────
                          _OmsWarning09()
                              .animate()
                              .slideY(begin: 0.08, end: 0,
                              duration: 500.ms, delay: 750.ms)
                              .fadeIn(duration: 500.ms, delay: 750.ms),

                        ],
                      ),
                    ),

                    const SizedBox(width: 22),

                    // ── DREAPTA: fotografia pe toată înălțimea ───────────
                    Expanded(
                      flex: 42,
                      child: _PhotoPlaceholder09Full()
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 600.ms)
                          .slideX(begin: 0.05, end: 0,
                          duration: 450.ms, delay: 600.ms),
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
                    _cyan.withOpacity(0),
                    _cyan.withOpacity(
                        0.75 +
                            0.25 *
                                math.sin(_neonCtrl.value * 2 * math.pi)),
                    _red.withOpacity(0.65),
                    _cyan.withOpacity(0),
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
// Badge mare (titlu)
// ─────────────────────────────────────────────────────────────────────────────
class _Badge09 extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge09({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.14),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withOpacity(0.55)),
    ),
    child: Text(label,
        style: TextStyle(
          color: color, fontSize: 15,
          fontWeight: FontWeight.w800, letterSpacing: 1.5,
        )),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Badge mic (header tabel)
// ─────────────────────────────────────────────────────────────────────────────
class _BadgeSmall09 extends StatelessWidget {
  final String label;
  final Color color;
  const _BadgeSmall09({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.18),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: color.withOpacity(0.45)),
    ),
    child: Text(label,
        style: TextStyle(
          color: color, fontSize: 10,
          fontWeight: FontWeight.w800, letterSpacing: 0.8,
        )),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Card informativ (cyan)
// ─────────────────────────────────────────────────────────────────────────────
class _InfoCard09 extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String body;
  const _InfoCard09(
      {required this.color,
        required this.icon,
        required this.title,
        required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.28)),
        color: color.withOpacity(0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 19),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                  color: color, fontSize: 15,
                  fontWeight: FontWeight.w700, letterSpacing: 0.6,
                )),
          ]),
          const SizedBox(height: 9),
          Text(body,
              style: TextStyle(
                color: Colors.white.withOpacity(0.70),
                fontSize: 14, height: 1.55,
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card pericol – formare nitrozamine
// ─────────────────────────────────────────────────────────────────────────────
class _DangerCard09 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String reactionLine;
  static const Color _warn = Color(0xFFFF3B3B);

  const _DangerCard09(
      {required this.icon,
        required this.title,
        required this.body,
        required this.reactionLine});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            Icon(icon, color: _warn, size: 19),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                  color: _warn, fontSize: 15,
                  fontWeight: FontWeight.w700, letterSpacing: 0.6,
                )),
          ]),
          const SizedBox(height: 9),
          Text(body,
              style: TextStyle(
                color: Colors.white.withOpacity(0.70),
                fontSize: 14, height: 1.55,
              )),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: _warn.withOpacity(0.10),
              border: Border.all(color: _warn.withOpacity(0.30)),
            ),
            child: Text(reactionLine,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14, fontFamily: 'monospace',
                  fontWeight: FontWeight.w600, height: 1.5,
                )),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder fotografie FULL HEIGHT (dreapta)
// ─────────────────────────────────────────────────────────────────────────────
class _PhotoPlaceholder09Full extends StatelessWidget {
  static const Color _cyan = Color(0xFF00F0FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _cyan.withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/2.jpg', // ← schimbă cu numele fișierului tău
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder fotografie (original – păstrat pentru compatibilitate)
// ─────────────────────────────────────────────────────────────────────────────
class _PhotoPlaceholder09 extends StatelessWidget {
  static const Color _cyan = Color(0xFF00F0FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _cyan.withOpacity(0.35),
          width: 1.5,
        ),
        color: _cyan.withOpacity(0.04),
      ),
      child: Stack(
        children: [
          // Dashed overlay corners
          Positioned(top: 8, left: 8,
              child: _CornerMark09(color: _cyan)),
          Positioned(top: 8, right: 8,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14159),
                child: _CornerMark09(color: _cyan),
              )),
          Positioned(bottom: 8, left: 8,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(3.14159),
                child: _CornerMark09(color: _cyan),
              )),
          Positioned(bottom: 8, right: 8,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(0)..rotateZ(3.14159),
                child: _CornerMark09(color: _cyan),
              )),
          // Centru
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    color: _cyan.withOpacity(0.50), size: 38),
                const SizedBox(height: 8),
                Text(
                  'INSERAȚI FOTOGRAFIA AICI',
                  style: TextStyle(
                    color: _cyan.withOpacity(0.50),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Recomandat: 16 : 9 · min. 800 × 450 px',
                  style: TextStyle(
                    color: _cyan.withOpacity(0.30),
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerMark09 extends StatelessWidget {
  final Color color;
  const _CornerMark09({required this.color});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 16, height: 16,
    child: CustomPaint(
      painter: _CornerPainter09(color: color),
    ),
  );
}

class _CornerPainter09 extends CustomPainter {
  final Color color;
  const _CornerPainter09({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.70)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }
  @override
  bool shouldRepaint(_CornerPainter09 old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner OMS – Grupa 1 cancerigen
// ─────────────────────────────────────────────────────────────────────────────
class _OmsWarning09 extends StatelessWidget {
  static const Color _warn = Color(0xFFFF3B3B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            _warn.withOpacity(0.14),
            _warn.withOpacity(0.06),
          ],
        ),
        border: Border.all(color: _warn.withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _warn.withOpacity(0.20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _warn.withOpacity(0.60)),
            ),
            child: const Text(
              'OMS\nGrupa 1',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _warn,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                height: 1.3,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 15, height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'OMS clasifică carnea procesată industrial în ',
                  ),
                  const TextSpan(
                    text: 'Grupa 1 de risc carcinogen',
                    style: TextStyle(
                      color: _warn,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const TextSpan(
                    text:
                    ' — același grup cu fumatul de tutun — în parte datorită '
                        'nitrozaminelor formate din E250. '
                        'Reacția este accelerată de temperaturi înalte (prăjire, grătar) și de mediul acid gastric.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAINTERS FUNDAL
// ─────────────────────────────────────────────────────────────────────────────

class _CircuitBoardPainter09 extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  _CircuitBoardPainter09(
      {required this.progress,
        required this.primaryColor,
        required this.secondaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final nodePaint = Paint()..style = PaintingStyle.fill;
    const gridX = 14;
    const gridY = 10;
    final cellW = size.width / gridX;
    final cellH = size.height / gridY;

    for (int i = 0; i < 22; i++) {
      final seed = i * 17;
      final startX = (seed % gridX) * cellW + cellW / 2;
      final startY = ((seed ~/ gridX) % gridY) * cellH + cellH / 2;
      final isRed = rng.nextDouble() > 0.72;
      final baseColor = isRed ? secondaryColor : primaryColor;
      final pulse = math.sin((progress + i / 22.0) * 2 * math.pi);
      final opacity = 0.04 + 0.06 * ((pulse + 1) / 2);
      linePaint.color = baseColor.withOpacity(opacity);
      nodePaint.color = baseColor.withOpacity(opacity * 2.5);

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
        canvas.drawCircle(Offset(nx, ny), 3.0, nodePaint);
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
  bool shouldRepaint(_CircuitBoardPainter09 old) =>
      old.progress != progress;
}

class _ScanLinePainter09 extends CustomPainter {
  final double progress;
  final Color color;
  _ScanLinePainter09({required this.progress, required this.color});

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
  bool shouldRepaint(_ScanLinePainter09 old) =>
      old.progress != progress;
}

class _ParticlePainter09 extends CustomPainter {
  final double progress;
  static final _rng = math.Random(99);
  static final List<_P09> _pts = List.generate(
    38,
        (i) => _P09(
      x: _rng.nextDouble(),
      speed: 0.05 + _rng.nextDouble() * 0.15,
      size: 1.0 + _rng.nextDouble() * 2.0,
      isRed: _rng.nextDouble() > 0.72,
      phase: _rng.nextDouble(),
    ),
  );
  _ParticlePainter09(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _pts) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final opacity = 0.15 * math.sin(t * math.pi);
      canvas.drawCircle(
        Offset(p.x * size.width, (1.0 - t) * size.height),
        p.size,
        Paint()
          ..color = (p.isRed
              ? const Color(0xFFFF3B3B)
              : const Color(0xFF00F0FF))
              .withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter09 old) =>
      old.progress != progress;
}

class _P09 {
  final double x, speed, size, phase;
  final bool isRed;
  const _P09(
      {required this.x,
        required this.speed,
        required this.size,
        required this.isRed,
        required this.phase});
}