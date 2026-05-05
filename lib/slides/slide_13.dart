import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 13 – Cap. 7: Tendințe Moderne în Conservarea Alimentelor
// Layout: Header+Title (top) | 3 coloane: Ambalaje Active | Foto | Ambalaje Inteligente
// ─────────────────────────────────────────────────────────────────────────────

class Slide13 extends StatefulWidget {
  const Slide13({super.key});
  @override
  State<Slide13> createState() => _S13State();
}

class _S13State extends State<Slide13>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // ── Ambalaje Active ────────────────────────────────────────────────────────
  static const _active = [
    _TrendItem(
      icon: Icons.air_outlined,
      label: 'Absorbanți de Oxigen',
      color: Color(0xFF00F0FF),
      desc: 'Utilizează fier pulverizat sau acid ascorbic, care reacționează chimic cu O₂ și reduc oxidarea alimentelor.',
    ),
    _TrendItem(
      icon: Icons.co2_outlined,
      label: 'Emiteri de CO₂',
      color: Color(0xFF00CFFF),
      desc: 'Eliberează CO₂ prin reacții chimice pentru a inhiba dezvoltarea microorganismelor în ambalaj.',
    ),
    _TrendItem(
      icon: Icons.biotech_outlined,
      label: 'Filme cu Nanoparticule de Argint',
      color: Color(0xFF90D8FF),
      desc: 'Ionii de Ag⁺ au efect antibacterian puternic și distrug membranele celulare ale bacteriilor.',
    ),
    _TrendItem(
      icon: Icons.eco_outlined,
      label: 'Pelicule cu Uleiuri Esențiale',
      color: Color(0xFF00FFB0),
      desc: 'Conțin compuși fenolici naturali (timol, carvacrol, eugenol) cu proprietăți antimicrobiene și antioxidante.',
    ),
  ];

  // ── Ambalaje Inteligente ───────────────────────────────────────────────────
  static const _inteligente = [
    _TrendItem(
      icon: Icons.thermostat_outlined,
      label: 'Indicatori de Temperatură',
      color: Color(0xFFFF6BFF),
      desc: 'Substanțe care își schimbă culoarea când produsul este expus la temperaturi necorespunzătoare.',
    ),
    _TrendItem(
      icon: Icons.science_outlined,
      label: 'Indicatori de pH',
      color: Color(0xFFFFCC00),
      desc: 'Detectează acidifierea produsului prin reacții de schimbare a culorii – semnal al degradării.',
    ),
    _TrendItem(
      icon: Icons.sensors_outlined,
      label: 'Senzori pentru Gaze',
      color: Color(0xFFFF9933),
      desc: 'Identifică compușii volatili produși în timpul alterării alimentului (amine, aldehide, H₂S).',
    ),
    _TrendItem(
      icon: Icons.coronavirus_outlined,
      label: 'Biosenzori Microbiologici',
      color: Color(0xFFFF4466),
      desc: 'Detectează prezența bacteriilor patogene (Salmonella, Listeria, E. coli) direct în ambalaj.',
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
      key: const ValueKey('slide_13'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF020609), Color(0xFF060A14), Color(0xFF030D13)],
        ),
      ),
      child: Stack(children: [

        // ── DOT GRID BACKGROUND ──────────────────────────────────────────────
        CustomPaint(painter: _DotGridPainter13(), size: Size.infinite),

        // ── GLOW ORBS ────────────────────────────────────────────────────────
        Positioned(
          top: -100, right: -60,
          child: Container(
            width: 500, height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFF00F0FF).withOpacity(0.07),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -80, left: 40,
          child: Container(
            width: 380, height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFFFF6BFF).withOpacity(0.06),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        // ── CONȚINUT PRINCIPAL ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(44, 22, 44, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── HEADER ────────────────────────────────────────────────────
              Row(children: [
                Container(width: 40, height: 3, color: const Color(0xFF00F0FF)),
                const SizedBox(width: 12),
                const Text('9', style: TextStyle(
                  color: Color(0xFF00F0FF), fontSize: 22.5,
                  fontWeight: FontWeight.w800, letterSpacing: 2,
                )),
                const SizedBox(width: 10),
                Container(width: 1, height: 14,
                    color: const Color(0xFF00F0FF).withOpacity(0.4)),
                const SizedBox(width: 10),
                Text('CHIMIE ALIMENTARĂ · INOVAȚIE · AMBALARE',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.38),
                      fontSize: 19.5, letterSpacing: 2.5,
                    )),
              ]).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 6),

              // ── TITLU PRINCIPAL ───────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [Colors.white, Color(0xFF90FFD8)],
                    ).createShader(b),
                    child: const Text(
                      'Tendințe Moderne',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      'în Conservarea Alimentelor',
                      style: TextStyle(
                        color: const Color(0xFF00FF88).withOpacity(0.60),
                        fontSize: 19.5,
                        fontWeight: FontWeight.w300,
                        height: 1.5,
                      ),
                    ).animate().fadeIn(duration: 700.ms, delay: 400.ms),
                  ),
                ],
              ).animate()
                  .fadeIn(duration: 900.ms, delay: 200.ms)
                  .slideY(begin: 0.06, end: 0, duration: 700.ms, delay: 200.ms),

              const SizedBox(height: 4),

              // ── SUBTITLU ──────────────────────────────────────────────────
              Text(
                'Industria alimentară globală se află într-un proces continuu de inovare.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.3,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 350.ms),

              const SizedBox(height: 4),

              // ── DIVIDER + SUBTITLU SECTIUNE ───────────────────────────────
              Row(children: [
                Container(
                  width: 5, height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF00F0FF),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ambalaje Active și Inteligente – Aplicarea Chimiei în Conservarea Alimentelor',
                    style: TextStyle(
                      color: const Color(0xFF00F0FF).withOpacity(0.85),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ]).animate().fadeIn(duration: 600.ms, delay: 450.ms),

              const SizedBox(height: 12),

              // ── 3 COLOANE ─────────────────────────────────────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ── COLOANA STÂNGA: Ambalaje Active ───────────────────
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(
                            label: 'AMBALAJE ACTIVE',
                            color: const Color(0xFF00F0FF),
                            subtitle: 'Compuși chimici integrați în materialul de ambalare',
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Column(
                              children: List.generate(_active.length, (i) {
                                final p = _active[i];
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: i < _active.length - 1 ? 7 : 0),
                                    child: _TrendCard(item: p)
                                        .animate()
                                        .fadeIn(duration: 500.ms, delay: Duration(milliseconds: 250 + i * 70))
                                        .slideX(begin: -0.05, end: 0, duration: 450.ms, delay: Duration(milliseconds: 250 + i * 70)),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 18),

                    // ── COLOANA CENTRU: Placeholder Fotografie ────────────
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _PhotoPlaceholder()
                                .animate()
                                .fadeIn(duration: 700.ms, delay: 300.ms)
                                .scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1), duration: 600.ms, delay: 300.ms),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 18),

                    // ── COLOANA DREAPTA: Ambalaje Inteligente ─────────────
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(
                            label: 'AMBALAJE INTELIGENTE',
                            color: const Color(0xFFFF6BFF),
                            subtitle: 'Indicatori chimici și biosenzori de monitorizare',
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Column(
                              children: List.generate(_inteligente.length, (i) {
                                final m = _inteligente[i];
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: i < _inteligente.length - 1 ? 7 : 0),
                                    child: _TrendCard(item: m)
                                        .animate()
                                        .fadeIn(duration: 500.ms, delay: Duration(milliseconds: 350 + i * 80))
                                        .slideX(begin: 0.05, end: 0, duration: 450.ms, delay: Duration(milliseconds: 350 + i * 80)),
                                  ),
                                );
                              }),
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

        // ── NEON STRIP STÂNGA ─────────────────────────────────────────────────
        Positioned(
          left: 0, top: 0, bottom: 0,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Container(
              width: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF00F0FF).withOpacity(0),
                    const Color(0xFF00F0FF).withOpacity(
                        0.75 + 0.25 * math.sin(_ctrl.value * 2 * math.pi)),
                    const Color(0xFFFF6BFF).withOpacity(0.55),
                    const Color(0xFF00F0FF).withOpacity(0),
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
// DATA CLASS
// ─────────────────────────────────────────────────────────────────────────────

class _TrendItem {
  final IconData icon;
  final String label;
  final Color color;
  final String desc;
  const _TrendItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.desc,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  final String subtitle;
  const _SectionLabel({
    required this.label,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(width: 3, height: 12, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                )),
          ),
        ]),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 11),
          child: Text(subtitle,
              style: TextStyle(
                color: color.withOpacity(0.50),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              )),
        ),
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  final _TrendItem item;
  const _TrendCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: item.color.withOpacity(0.22), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.label,
                    style: TextStyle(
                      color: item.color,
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    )),
                const SizedBox(height: 3),
                Flexible(
                  child: Text(item.desc,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.60),
                        fontSize: 15.5,
                        height: 1.35,
                      ),
                      overflow: TextOverflow.fade),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Photo Placeholder ─────────────────────────────────────────────────────────
class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF00F0FF).withOpacity(0.25),
          width: 1.5,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00F0FF).withOpacity(0.06),
            const Color(0xFFFF6BFF).withOpacity(0.04),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Corner accents
          ..._corners(),
          // Inner content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00F0FF).withOpacity(0.08),
                  border: Border.all(
                    color: const Color(0xFF00F0FF).withOpacity(0.20),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: const Color(0xFF00F0FF).withOpacity(0.55),
                  size: 52,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'FOTOGRAFIE',
                style: TextStyle(
                  color: const Color(0xFF00F0FF).withOpacity(0.55),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ambalaje active și inteligente',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.30),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static List<Widget> _corners() {
    const c = Color(0xFF00F0FF);
    const len = 14.0;
    const w = 2.0;
    return [
      // Top-left
      Positioned(top: 10, left: 10, child: _CornerMark(color: c, len: len, w: w, flipX: false, flipY: false)),
      // Top-right
      Positioned(top: 10, right: 10, child: _CornerMark(color: c, len: len, w: w, flipX: true, flipY: false)),
      // Bottom-left
      Positioned(bottom: 10, left: 10, child: _CornerMark(color: c, len: len, w: w, flipX: false, flipY: true)),
      // Bottom-right
      Positioned(bottom: 10, right: 10, child: _CornerMark(color: c, len: len, w: w, flipX: true, flipY: true)),
    ];
  }
}

class _CornerMark extends StatelessWidget {
  final Color color;
  final double len, w;
  final bool flipX, flipY;
  const _CornerMark({
    required this.color,
    required this.len,
    required this.w,
    required this.flipX,
    required this.flipY,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(len, len),
      painter: _CornerPainter(color: color, w: w, flipX: flipX, flipY: flipY),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double w;
  final bool flipX, flipY;
  const _CornerPainter({required this.color, required this.w, required this.flipX, required this.flipY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.70)
      ..strokeWidth = w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final x = flipX ? size.width : 0.0;
    final y = flipY ? size.height : 0.0;
    final dx = flipX ? -size.width : size.width;
    final dy = flipY ? -size.height : size.height;

    canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// PAINTERS
// ─────────────────────────────────────────────────────────────────────────────

class _DotGridPainter13 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF88).withOpacity(0.035)
      ..style = PaintingStyle.fill;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter13 _) => false;
}