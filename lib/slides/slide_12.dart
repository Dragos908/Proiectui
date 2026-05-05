import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 12 – 5.2 Dezavantajele și riscurile utilizării conservanților
// ─────────────────────────────────────────────────────────────────────────────

class Slide12 extends StatefulWidget {
  const Slide12({super.key});
  @override
  State<Slide12> createState() => _S12State();
}

class _S12State extends State<Slide12>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // ── Coloana 1: Riscuri 1 & 2 ──────────────────────────────────────────────
  static const _col1 = [
    _RiskCard2(
      number: '1',
      title: 'Reacții alergice și hipersensibilitate',
      color: Color(0xFFFF4466),
      bullets: [
        'Sulfiții (E220–E228) — alergeni majori recunoscuți oficial de UE. La astmatici (5–10%) pot provoca crize de astm, urticarie, edem, greață, anafilaxie.',
        'Benzoații (E210–E213) agravează astmul și pot provoca urticarie la persoanele cu sensibilitate la aspirină.',
        'Prezența sulfiților pe etichetă este obligatorie în UE chiar și la concentrații >10 mg/kg.',
      ],
    ),
    _RiskCard2(
      number: '2',
      title: 'Formare de compuși toxici',
      color: Color(0xFFFF6600),
      bullets: [
        'E250 (nitrit de sodiu) + amine din carne → nitrozamine (R₂N–NO). Reacție accelerată la prăjire 180–200°C.',
        'IARC Grupa 2A: nitrozaminele sunt potențial cancerigene. OMS: carnea procesată (bacon, salamuri) → Grupa 1.',
        'E211 + E300 (benzoat + vitamina C) → benzen, carcinogen cert asociat cu leucemia mieloidă acută.',
      ],
    ),
  ];

  // ── Coloana 2: Riscuri 3 & 4 ──────────────────────────────────────────────
  static const _col2 = [
    _RiskCard2(
      number: '3',
      title: 'Efecte asupra atenției la copii',
      color: Color(0xFFFFCC00),
      bullets: [
        'Studiul McCann (2007) · The Lancet: mix de coloranți artificiali (E102, E110, E122, E124, E104, E129) + E211 → hiperactivitate ↑, concentrare ↓.',
        'Testat la copii de 3 ani și 8–9 ani — rezultate semnificative statistic.',
        'EFSA a impus avertisment obligatoriu pe etichetă: „Poate afecta negativ activitatea și atenția copiilor".',
      ],
    ),
    _RiskCard2(
      number: '4',
      title: 'Methemoglobinemie la sugari',
      color: Color(0xFF00D4FF),
      bullets: [
        'E250 / E251 (nitrit și nitrat de sodiu) transformă hemoglobina în methemoglobină, care nu mai transportă O₂.',
        'Simptome: cianoză (albăstrire piele), dificultăți respiratorii — poate fi fatală la sugari.',
        'Apa de fântână bogată în nitrați nu se folosește pentru prepararea laptelui praf.',
      ],
    ),
  ];

  // ── Coloana 3: Riscuri 5 & 6 ──────────────────────────────────────────────
  static const _col3 = [
    _RiskCard2(
      number: '5',
      title: 'Pierderea unor nutrienți esențiali',
      color: Color(0xFF00FF88),
      bullets: [
        'Procesul industrial de conservare poate degrada vitaminele termolabile (vitamina C, vitamina B1/tiamina).',
        'Sulfiții (E220) distrug vitamina B1 (tiamina) din alimente.',
        'Iradierea alimentelor poate afecta vitamina A și vitamina E, modificând valoarea nutritivă.',
      ],
    ),
    _RiskCard2(
      number: '6',
      title: 'Impact psihologic și percepție negativă',
      color: Color(0xFFB88BFF),
      bullets: [
        'Mulți consumatori percep orice produs cu E-uri ca „chimic" și nesănătos.',
        'Deși E300 = vitamina C · E330 = acid citric · E290 = dioxid de carbon — substanțe naturale și sigure.',
        'Percepția afectează comportamentul de cumpărare, uneori spre produse mai scumpe dar nu mai sănătoase.',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
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
      key: const ValueKey('slide_12'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF020609), Color(0xFF060A14), Color(0xFF030D13)],
        ),
      ),
      child: Stack(children: [
        CustomPaint(painter: _DotGridPainter12(), size: Size.infinite),

        // Glow orbs
        Positioned(
          top: -100, right: -60,
          child: Container(
            width: 500, height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFFFF4466).withOpacity(0.08),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -80, left: 40,
          child: Container(
            width: 400, height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFFFF8800).withOpacity(0.07),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(72, 28, 72, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ────────────────────────────────────────────────────
              Row(children: [
                Container(width: 56, height: 4, color: const Color(0xFFFF4466)),
                const SizedBox(width: 16),
                const Text('8', style: TextStyle(
                  color: Color(0xFFFF4466), fontSize: 27,
                  fontWeight: FontWeight.w800, letterSpacing: 4,
                )),
                const SizedBox(width: 10),
                Container(width: 1, height: 18,
                    color: const Color(0xFFFF4466).withOpacity(0.4)),
                const SizedBox(width: 10),
                Text('CHIMIE ALIMENTARĂ · CONSERVANȚI · 2026',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.42),
                      fontSize: 24, letterSpacing: 3,
                    )),
              ]).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 8),

              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFFFB0BC)],
                ).createShader(b),
                child: const Text(
                  'Dezavantaje &\nRiscuri · Conservanți',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 93,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -1.5,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 900.ms, delay: 200.ms)
                  .slideY(begin: 0.07, end: 0, duration: 700.ms, delay: 200.ms),

              const SizedBox(height: 14),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ── COLOANA 1 ─────────────────────────────────────────
                    Expanded(
                      child: _ColumnPanel(
                        accentColor: const Color(0xFFFF4466),
                        label: 'RISCURI 1–2',
                        icon: Icons.warning_amber_rounded,
                        cards: _col1,
                        delayBase: 300,
                      ),
                    ),

                    const SizedBox(width: 20),

                    // ── COLOANA 2 ─────────────────────────────────────────
                    Expanded(
                      child: _ColumnPanel(
                        accentColor: const Color(0xFFFFCC00),
                        label: 'RISCURI 3–4',
                        icon: Icons.child_care_rounded,
                        cards: _col2,
                        delayBase: 450,
                      ),
                    ),

                    const SizedBox(width: 20),

                    // ── COLOANA 3 ─────────────────────────────────────────
                    Expanded(
                      child: _ColumnPanel(
                        accentColor: const Color(0xFF00FF88),
                        label: 'RISCURI 5–6',
                        icon: Icons.psychology_outlined,
                        cards: _col3,
                        delayBase: 600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Neon strip stânga
        Positioned(
          left: 0, top: 0, bottom: 0,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Container(
              width: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFF4466).withOpacity(0),
                    const Color(0xFFFF4466).withOpacity(
                        0.75 + 0.25 * math.sin(_ctrl.value * 2 * math.pi)),
                    const Color(0xFFFF8800).withOpacity(0.65),
                    const Color(0xFFFF4466).withOpacity(0),
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
// Column Panel — wrapper pentru o coloană
// ─────────────────────────────────────────────────────────────────────────────

class _ColumnPanel extends StatelessWidget {
  final Color accentColor;
  final String label;
  final IconData icon;
  final List<_RiskCard2> cards;
  final int delayBase;

  const _ColumnPanel({
    required this.accentColor,
    required this.label,
    required this.icon,
    required this.cards,
    required this.delayBase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withOpacity(0.22),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                )),
          ]),
          const SizedBox(height: 12),
          ...List.generate(cards.length, (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: i == 0 ? 0 : 10,
              ),
              child: _RiskCardWidget(card: cards[i])
                  .animate()
                  .fadeIn(duration: 500.ms, delay: Duration(milliseconds: delayBase + i * 120))
                  .slideX(begin: -0.05, end: 0, duration: 450.ms, delay: Duration(milliseconds: delayBase + i * 120)),
            ),
          )),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: Duration(milliseconds: delayBase - 100))
        .slideY(begin: 0.06, end: 0, duration: 500.ms, delay: Duration(milliseconds: delayBase - 100));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data class + Widget pentru fiecare risc
// ─────────────────────────────────────────────────────────────────────────────

class _RiskCard2 {
  final String number, title;
  final Color color;
  final List<String> bullets;
  const _RiskCard2({
    required this.number,
    required this.title,
    required this.color,
    required this.bullets,
  });
}

class _RiskCardWidget extends StatelessWidget {
  final _RiskCard2 card;
  const _RiskCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: card.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: card.color.withOpacity(0.28), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titlu cu număr badge
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: card.color.withOpacity(0.12),
                border: Border.all(color: card.color.withOpacity(0.55)),
              ),
              child: Center(
                child: Text(card.number,
                    style: TextStyle(
                        color: card.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(card.title,
                  style: TextStyle(
                    color: card.color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                    height: 1.2,
                  )),
            ),
          ]),
          const SizedBox(height: 7),
          // Bullets
          ...card.bullets.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4, height: 4,
                  margin: const EdgeInsets.only(top: 5, right: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: card.color.withOpacity(0.6),
                  ),
                ),
                Expanded(
                  child: Text(b,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.68),
                        fontSize: 16,
                        height: 1.38,
                      ),
                      overflow: TextOverflow.fade),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dot grid background
// ─────────────────────────────────────────────────────────────────────────────

class _DotGridPainter12 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF4466).withOpacity(0.035)
      ..style = PaintingStyle.fill;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter12 _) => false;
}