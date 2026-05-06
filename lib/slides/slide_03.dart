import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ── DATA ──────────────────────────────────────────────────────────────────────

class _ChemGroup {
  final String group;
  final String examples;
  final String foods;
  final String mechanism;
  final Color color;
  const _ChemGroup(this.group, this.examples, this.foods, this.mechanism, this.color);
}

const _chemGroups = [
  _ChemGroup('Benzoați',        'E210, E211',  'Băuturi, sosuri, sucuri',          'Inhibă enzimele microbiene în mediu acid',       Color(0xFF00F0FF)),
  _ChemGroup('Sorbați',         'E200, E202',  'Brânzeturi, panificație, vinuri',   'Blochează respirația fungică și bacteriană',     Color(0xFF5BE0FF)),
  _ChemGroup('Nitriți/Nitrați', 'E250, E251',  'Mezeluri, bacon, carne procesată', 'Inhibă C. botulinum, fixează culoarea roșie',    Color(0xFF00FF88)),
  _ChemGroup('Sulfiți',         'E220, E221',  'Vinuri, fructe uscate, cartofi',   'Antioxidant puternic, inhibă bacterii și enzime',Color(0xFFFFCC00)),
  _ChemGroup('Propionați',      'E280, E282',  'Pâine, produse de panificație',    'Antifungic, inhibă mucegaiul',                   Color(0xFFFF6B35)),
  _ChemGroup('Acizi organici',  'E330, E270',  'Conserve, băuturi, lactate',       'Scad pH < 4.5 – mediu nefavorabil bacteriilor',  Color(0xFFB06BFF)),
];

class _ActionMechanism {
  final String number;
  final String title;
  final String tag;
  final String description;
  final Color color;
  const _ActionMechanism(this.number, this.title, this.tag, this.description, this.color);
}

const _actionMechanisms = [
  _ActionMechanism(
    '1', 'Antimicrobieni', '→ bacterii · fungi · drojdii',
    'Inhibă enzime esențiale, alterează membrana celulară și denaturează proteine microbiene.',
    Color(0xFF00F0FF),
  ),
  _ActionMechanism(
    '2', 'Antioxidanți', '→ previn oxidarea lipidelor',
    'Captează radicalii liberi, previn râncezirea grăsimilor și brunificarea enzimatică.',
    Color(0xFF00FF88),
  ),
  _ActionMechanism(
    '3', 'Control pH', '→ mediu acid (< 4.5)',
    'E330, E260, E270 scad pH-ul sub valori critice, mediu incompatibil cu multiplicarea bacteriană.',
    Color(0xFFFFCC00),
  ),
  _ActionMechanism(
    '4', 'Control Aw', '→ activitatea apei',
    'Reduc apa disponibilă: bacteriile nu supraviețuiesc Aw < 0.85 · mucegaiurile Aw < 0.70.',
    Color(0xFFFF6B35),
  ),
];

// ── SLIDE 03 – CLASIFICARE CONSERVANȚI ───────────────────────────────────────
class Slide03History extends StatefulWidget {
  const Slide03History({super.key});

  @override
  State<Slide03History> createState() => _Slide03State();
}

class _Slide03State extends State<Slide03History>
    with TickerProviderStateMixin {
  late AnimationController _glowCtrl;
  late AnimationController _cardsCtrl;

  @override
  void initState() {
    super.initState();

    _glowCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat();

    _cardsCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _cardsCtrl.forward();
    });
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _cardsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final s = (size.width / 1920.0).clamp(0.40, 1.6);

    return Container(
      key: const ValueKey('slide_03'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF040810), Color(0xFF080C1A), Color(0xFF04101A)],
        ),
      ),
      child: Stack(
        children: [
          CustomPaint(painter: _DotGridPainter2(), size: Size.infinite),

          // Glow orb – top right (mirrored from slide 02)
          Positioned(
            top: -80 * s,
            right: 80 * s,
            child: Container(
              width: 320 * s,
              height: 320 * s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF00F0FF).withOpacity(0.09),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(72 * s, 44 * s, 72 * s, 36 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HEADER ─────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SlideLabel2(
                            topic: 'CONSERVANȚI CHIMICI · 2026'),
                        SizedBox(height: 18 * s),
                        ShaderMask(
                          shaderCallback: (b) => const LinearGradient(
                            colors: [Colors.white, Color(0xFF90D8FF)],
                          ).createShader(b),
                          child: Text(
                            'Clasificarea\nConservanților Chimici',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 76 * s,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              letterSpacing: -1.5,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 600.ms),

                    // Aici am înlocuit cardurile KPI cu cardurile pentru formule
                    Row(
                      children: [
                        _FormulaCard(
                          formula: 'C₇H₆O₂', // Formula brută pentru Acidul Benzoic
                          label: 'Acid Benzoic\n(E210)',
                          color: const Color(0xFF00F0FF),
                          scale: s,
                        ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                        SizedBox(width: 16 * s),
                        _FormulaCard(
                          formula: 'C₆H₈O₂', // Formula brută pentru Acidul Sorbic
                          label: 'Acid Sorbic\n(E200)',
                          color: const Color(0xFF00FF88),
                          scale: s,
                        ).animate().fadeIn(duration: 600.ms, delay: 450.ms),
                        SizedBox(width: 16 * s),
                        _FormulaCard(
                          formula: 'NaNO₂', // Formula pentru Nitritul de Sodiu
                          label: 'Nitrit de Sodiu\n(E250)',
                          color: const Color(0xFFFFCC00),
                          scale: s,
                        ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 28 * s),

                // ── BODY ───────────────────────────────────────────────────
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── LEFT: chemical groups table ──────────────────────
                      Expanded(
                        flex: 58,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionHeader(
                              label: '2  CLASIFICARE DUPĂ NATURĂ CHIMICĂ',
                              color: const Color(0xFF00F0FF),
                              scale: s,
                            ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
                            SizedBox(height: 10 * s),
                            _TableColumnHeaders(scale: s)
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 650.ms),
                            SizedBox(height: 6 * s),
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _cardsCtrl,
                                builder: (context, _) => Column(
                                  children: List.generate(_chemGroups.length,
                                          (i) {
                                        final delay = 0.30 + i * 0.10;
                                        final progress = math.max(
                                            0.0,
                                            math.min(
                                                1.0,
                                                (_cardsCtrl.value - delay) /
                                                    0.15));
                                        return Expanded(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(bottom: 6 * s),
                                            child: Opacity(
                                              opacity: progress,
                                              child: Transform.translate(
                                                offset:
                                                Offset(28 * (1 - progress), 0),
                                                child: _ChemGroupRow(
                                                  group: _chemGroups[i],
                                                  scale: s,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 24),

                      // ── RIGHT: action mechanisms ─────────────────────────
                      Expanded(
                        flex: 42,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionHeader(
                              label: '2.1  CLASIFICARE DUPĂ MODUL DE ACȚIUNE',
                              color: const Color(0xFF00FF88),
                              scale: s,
                            ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
                            SizedBox(height: 10 * s),
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _cardsCtrl,
                                builder: (context, _) => Column(
                                  children: List.generate(
                                      _actionMechanisms.length, (i) {
                                    final delay = 0.45 + i * 0.12;
                                    final progress = math.max(
                                        0.0,
                                        math.min(
                                            1.0,
                                            (_cardsCtrl.value - delay) /
                                                0.15));
                                    return Expanded(
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(bottom: 10 * s),
                                        child: Opacity(
                                          opacity: progress,
                                          child: Transform.translate(
                                            offset:
                                            Offset(0, 20 * (1 - progress)),
                                            child: _MechanismCard(
                                              mechanism:
                                              _actionMechanisms[i],
                                              scale: s,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

// ── WIDGETS ───────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  final double scale;
  const _SectionHeader({required this.label, required this.color, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Row(
      children: [
        Container(
            width: 3,
            height: 16 * s,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2), color: color)),
        SizedBox(width: 10 * s),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.85),
            fontSize: 18 * s,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
          ),
        ),
      ],
    );
  }
}

class _TableColumnHeaders extends StatelessWidget {
  final double scale;
  const _TableColumnHeaders({this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    final style = TextStyle(
        color: const Color(0xFF3A5070),
        fontSize: 17 * s,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5);
    return Padding(
      padding: EdgeInsets.fromLTRB(16 * s, 2, 8 * s, 2),
      child: Row(
        children: [
          Expanded(flex: 22, child: Text('GRUPĂ CHIMICĂ', style: style)),
          Expanded(flex: 18, child: Text('EXEMPLE (E-uri)', style: style)),
          Expanded(flex: 30, child: Text('ALIMENTE TIPICE', style: style)),
          Expanded(flex: 30, child: Text('MECANISM PRINCIPAL', style: style)),
        ],
      ),
    );
  }
}

class _ChemGroupRow extends StatelessWidget {
  final _ChemGroup group;
  final double scale;
  const _ChemGroupRow({required this.group, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 8 * s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: group.color.withOpacity(0.22)),
        color: group.color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Container(
            width: 4 * s,
            height: double.infinity,
            constraints: BoxConstraints(minHeight: 22 * s),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: group.color,
              boxShadow: [
                BoxShadow(color: group.color.withOpacity(0.4), blurRadius: 6)
              ],
            ),
          ),
          SizedBox(width: 10 * s),
          Expanded(
            flex: 22,
            child: Text(
              group.group,
              style: TextStyle(
                  color: group.color,
                  fontSize: 17 * s,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            flex: 18,
            child: Text(
              group.examples,
              style: TextStyle(
                  color: group.color.withOpacity(0.7),
                  fontSize: 18 * s,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3),
            ),
          ),
          Expanded(
            flex: 30,
            child: Text(
              group.foods,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.55), fontSize: 16 * s),
            ),
          ),
          Expanded(
            flex: 30,
            child: Text(
              group.mechanism,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 16 * s,
                  height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _MechanismCard extends StatelessWidget {
  final _ActionMechanism mechanism;
  final double scale;
  const _MechanismCard({required this.mechanism, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 14 * s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: mechanism.color.withOpacity(0.3)),
        color: mechanism.color.withOpacity(0.06),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42 * s,
            height: 42 * s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: mechanism.color.withOpacity(0.45), width: 1.5),
              color: mechanism.color.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                mechanism.number,
                style: TextStyle(
                    color: mechanism.color,
                    fontSize: 23 * s,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          SizedBox(width: 14 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        mechanism.title,
                        style: TextStyle(
                            color: mechanism.color,
                            fontSize: 18 * s,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(width: 8 * s),
                    Flexible(
                      child: Text(
                        mechanism.tag,
                        style: TextStyle(
                            color: mechanism.color.withOpacity(0.45),
                            fontSize: 15 * s,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4 * s),
                Text(
                  mechanism.description,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 15 * s,
                      height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ── SHARED WIDGETS ────────────────────────────────────────────────────────────

// Am înlocuit _KpiCard cu _FormulaCard
class _FormulaCard extends StatelessWidget {
  final String formula;
  final String label;
  final Color color;
  final double scale;

  const _FormulaCard({
    required this.formula,
    required this.label,
    required this.color,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      width: 190 * s,
      padding: EdgeInsets.symmetric(horizontal: 20 * s, vertical: 18 * s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35)),
        color: color.withOpacity(0.07),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formula,
              style: TextStyle(
                  color: color,
                  fontSize: 40 * s,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5)),
          SizedBox(height: 8 * s),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 17 * s,
                  height: 1.3)),
        ],
      ),
    );
  }
}

class _SlideLabel2 extends StatelessWidget {
  final String topic;
  const _SlideLabel2({required this.topic});

  @override
  Widget build(BuildContext context) {
    final s = (MediaQuery.of(context).size.width / 1920.0).clamp(0.40, 1.6);
    return Row(
      children: [
        Container(
            width: 1,
            height: 18 * s,
            color: const Color(0xFF00FF88).withOpacity(0.4)),
        SizedBox(width: 10 * s),
        Text(topic,
            style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 19 * s,
                letterSpacing: 3)),
      ],
    );
  }
}

class _DotGridPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.035);
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter2 _) => false;
}