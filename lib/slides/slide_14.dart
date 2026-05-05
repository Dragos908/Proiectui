import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 14 – Cap. 10: Concluzie — Conservanții Chimici în Alimentația Modernă
// ─────────────────────────────────────────────────────────────────────────────

class Slide14Concluzie extends StatefulWidget {
  const Slide14Concluzie({super.key});
  @override
  State<Slide14Concluzie> createState() => _S14State();
}

class _S14State extends State<Slide14Concluzie>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static const _particles = [
    _Particle(x:0.5,y:0.95,speedX:0.1,speedY:0.02,amplitude:0.02,phase:0.0,radius:1.5,opacity:0.06,pulseSpeed:0.3,useColor2:true),
    _Particle(x:0.804,y:0.168,speedX:0.18,speedY:0.03,amplitude:0.035,phase:0.4,radius:2.3,opacity:0.10,pulseSpeed:0.45,useColor2:false),
    _Particle(x:0.052,y:0.538,speedX:0.26,speedY:0.04,amplitude:0.05,phase:0.8,radius:3.1,opacity:0.14,pulseSpeed:0.6,useColor2:false),
    _Particle(x:0.856,y:0.775,speedX:0.34,speedY:0.05,amplitude:0.065,phase:1.2,radius:3.9,opacity:0.18,pulseSpeed:0.75,useColor2:true),
    _Particle(x:0.423,y:0.057,speedX:0.42,speedY:0.06,amplitude:0.02,phase:1.6,radius:4.7,opacity:0.06,pulseSpeed:0.9,useColor2:false),
    _Particle(x:0.257,y:0.879,speedX:0.5,speedY:0.02,amplitude:0.035,phase:2.0,radius:1.5,opacity:0.10,pulseSpeed:1.05,useColor2:false),
    _Particle(x:0.935,y:0.386,speedX:0.58,speedY:0.03,amplitude:0.05,phase:2.4,radius:2.3,opacity:0.14,pulseSpeed:0.3,useColor2:true),
    _Particle(x:0.102,y:0.29,speedX:0.1,speedY:0.04,amplitude:0.065,phase:2.8,radius:3.1,opacity:0.18,pulseSpeed:0.45,useColor2:false),
    _Particle(x:0.651,y:0.924,speedX:0.18,speedY:0.05,amplitude:0.02,phase:3.2,radius:3.9,opacity:0.06,pulseSpeed:0.6,useColor2:false),
    _Particle(x:0.675,y:0.086,speedX:0.26,speedY:0.06,amplitude:0.035,phase:3.6,radius:4.7,opacity:0.10,pulseSpeed:0.75,useColor2:true),
    _Particle(x:0.091,y:0.687,speedX:0.34,speedY:0.02,amplitude:0.05,phase:4.0,radius:1.5,opacity:0.14,pulseSpeed:0.9,useColor2:false),
    _Particle(x:0.928,y:0.639,speedX:0.42,speedY:0.03,amplitude:0.065,phase:4.4,radius:2.3,opacity:0.18,pulseSpeed:1.05,useColor2:false),
    _Particle(x:0.279,y:0.108,speedX:0.5,speedY:0.04,amplitude:0.02,phase:4.8,radius:3.1,opacity:0.06,pulseSpeed:0.3,useColor2:true),
    _Particle(x:0.398,y:0.938,speedX:0.58,speedY:0.05,amplitude:0.035,phase:5.2,radius:3.9,opacity:0.10,pulseSpeed:0.45,useColor2:false),
    _Particle(x:0.872,y:0.246,speedX:0.1,speedY:0.06,amplitude:0.05,phase:5.6,radius:4.7,opacity:0.14,pulseSpeed:0.6,useColor2:false),
    _Particle(x:0.055,y:0.436,speedX:0.18,speedY:0.02,amplitude:0.065,phase:6.0,radius:1.5,opacity:0.18,pulseSpeed:0.75,useColor2:true),
    _Particle(x:0.785,y:0.849,speedX:0.26,speedY:0.03,amplitude:0.02,phase:6.4,radius:2.3,opacity:0.06,pulseSpeed:0.9,useColor2:false),
    _Particle(x:0.526,y:0.051,speedX:0.34,speedY:0.04,amplitude:0.035,phase:6.8,radius:3.1,opacity:0.10,pulseSpeed:1.05,useColor2:false),
    _Particle(x:0.177,y:0.813,speedX:0.42,speedY:0.05,amplitude:0.05,phase:7.2,radius:3.9,opacity:0.14,pulseSpeed:0.3,useColor2:true),
    _Particle(x:0.95,y:0.487,speedX:0.5,speedY:0.06,amplitude:0.065,phase:7.6,radius:4.7,opacity:0.18,pulseSpeed:0.45,useColor2:false),
    _Particle(x:0.16,y:0.205,speedX:0.58,speedY:0.02,amplitude:0.02,phase:8.0,radius:1.5,opacity:0.06,pulseSpeed:0.6,useColor2:false),
    _Particle(x:0.551,y:0.947,speedX:0.1,speedY:0.03,amplitude:0.035,phase:8.4,radius:2.3,opacity:0.10,pulseSpeed:0.75,useColor2:true),
  ];

  // ── Concluzia practică — carduri dreapta ───────────────────────────────────
  static const _concluzieItems = [
    _ConcItem(
      icon: Icons.menu_book_outlined,
      label: 'Citește eticheta',
      color: Color(0xFFFFCC00),
      desc: 'Identifică codurile E, cantitățile și dacă substanța este naturală sau sintetică.',
    ),
    _ConcItem(
      icon: Icons.balance_outlined,
      label: 'Varietate și moderație',
      color: Color(0xFF00FF88),
      desc: 'Alimentele cu conservanți nu sunt automat periculoase. O dietă bazată exclusiv pe produse ultraprocesate crește riscurile pe termen lung.',
    ),
    _ConcItem(
      icon: Icons.psychology_outlined,
      label: 'Gândire critică',
      color: Color(0xFF00F0FF),
      desc: 'Preferă produse cât mai puțin procesate. Înțelege că E300 = vitamina C, E330 = acid citric. Știința alimentară nu e alb sau negru.',
    ),
    _ConcItem(
      icon: Icons.verified_outlined,
      label: 'Sistemul EFSA',
      color: Color(0xFFB88BFF),
      desc: 'Fiecare substanță autorizată a trecut evaluare științifică riguroasă. Dozele prescrise sunt sigure pentru populația generală.',
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
      key: const ValueKey('slide_14'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF020609), Color(0xFF060A14), Color(0xFF030D13)],
        ),
      ),
      child: Stack(children: [
        CustomPaint(painter: _DotGridPainter14(), size: Size.infinite),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            painter: _ParticlePainter14(_ctrl.value),
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
                const Color(0xFFFFCC00).withOpacity(0.08),
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
                const Color(0xFF00FF88).withOpacity(0.07),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(72, 32, 72, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ──────────────────────────────────────────────────
              Row(children: [
                Container(width: 56, height: 4, color: const Color(0xFFFFCC00)),
                const SizedBox(width: 16),
                const Text('10', style: TextStyle(
                  color: Color(0xFFFFCC00), fontSize: 21.5,
                  fontWeight: FontWeight.w800, letterSpacing: 4,
                )),
                const SizedBox(width: 10),
                Container(width: 1, height: 18,
                    color: const Color(0xFFFFCC00).withOpacity(0.4)),
                const SizedBox(width: 10),
                Text('CHIMIE ALIMENTARĂ · CONCLUZIE',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.42),
                      fontSize: 19, letterSpacing: 3,
                    )),
              ]).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 10),

              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFFFE88A)],
                ).createShader(b),
                child: const Text(
                  'Concluzie',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 86.5,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -2.0,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 900.ms, delay: 200.ms)
                  .slideY(begin: 0.07, end: 0, duration: 700.ms, delay: 200.ms),

              const SizedBox(height: 6),

              Text(
                'Conservanții chimici nu sunt nici erou, nici dușman — sunt o unealtă care necesită înțelegere nuanțată a chimiei, biologiei și a contextului social.',
                style: TextStyle(
                  color: const Color(0xFFFFCC00).withOpacity(0.72),
                  fontSize: 19,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.6,
                ),
              ).animate().fadeIn(duration: 700.ms, delay: 450.ms),

              const SizedBox(height: 20),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ── COLOANA STÂNGA: Pe de o parte (avantaje) ──────────
                    Expanded(
                      child: _ArchCard(
                        delay: 300,
                        accentColor: const Color(0xFF00FF88),
                        icon: Icons.verified_user_outlined,
                        title: 'Indispensabili pentru siguranță',
                        subtitle: 'Pe de o parte · Argumente pro',
                        description:
                        'Fără nitrit de sodiu (E250), botulismul ar fi o amenințare reală în fiecare zi. Fără acid sorbic și sorbat de potasiu, mucegaiul ar fi omniprezent în lactate și panificație. Fără antioxidanți, uleiurile ar rânceji rapid, producând compuși toxici.',
                        noteText:
                        'Sistemul european de codificare E și evaluarea riguroasă a EFSA garantează că fiecare substanță autorizată este sigură în dozele prescrise.',
                        features: const [
                          _Feature('Previn botulismul și mucegaiul', Icons.check_circle_outline),
                          _Feature('Extind termenul de valabilitate', Icons.check_circle_outline),
                          _Feature('Reduc risipa alimentară globală', Icons.check_circle_outline),
                          _Feature('Aprobate prin evaluare EFSA', Icons.check_circle_outline),
                        ],
                        featureColor: const Color(0xFF00FF88),
                      ),
                    ),

                    const SizedBox(width: 24),

                    // ── COLOANA MIJLOC: Pe de altă parte (riscuri) ─────────
                    Expanded(
                      child: _ArchCard(
                        delay: 480,
                        accentColor: const Color(0xFFFF4466),
                        icon: Icons.warning_amber_rounded,
                        title: 'Riscuri reale la consum excesiv',
                        subtitle: 'Pe de altă parte · Argumente contra',
                        description:
                        'E250 (nitrit) formează nitrozamine cancerigene la temperaturi înalte. E211 (benzoat) + vitamina C → benzen. Sulfiții (E220–E228) sunt alergeni majori pentru persoanele sensibile.',
                        noteText:
                        'OMS clasifică carnea procesată în Grupa 1 de risc cancerigen, în parte datorită conservanților pe bază de azot. Studiul McCann (Lancet, 2007) leagă E211 de hiperactivitate la copii.',
                        features: const [
                          _Feature('Nitrozamine la prăjire >180°C', Icons.error_outline),
                          _Feature('Benzen din E211 + vitamina C', Icons.error_outline),
                          _Feature('Sulfiți — alergeni UE recunoscuți', Icons.error_outline),
                          _Feature('Carne procesată — OMS Grupa 1', Icons.error_outline),
                        ],
                        featureColor: const Color(0xFFFF4466),
                      ),
                    ),

                    const SizedBox(width: 24),

                    // ── COLOANA DREAPTA: Concluzie practică ───────────────
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCC00).withOpacity(0.03),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFFCC00).withOpacity(0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.lightbulb_outline_rounded,
                                  color: Color(0xFFFFCC00), size: 28),
                              const SizedBox(width: 12),
                              const Flexible(
                                child: Text('Concluzia\nPractică',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                    )),
                              ),
                            ]),
                            const SizedBox(height: 14),
                            Expanded(
                              child: Column(
                                children: List.generate(_concluzieItems.length, (i) {
                                  final item = _concluzieItems[i];
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: i < _concluzieItems.length - 1 ? 10 : 0),
                                      child: _ConcCard(item: item)
                                          .animate()
                                          .fadeIn(duration: 500.ms, delay: Duration(milliseconds: 600 + i * 80))
                                          .slideX(begin: 0.06, end: 0, duration: 450.ms, delay: Duration(milliseconds: 600 + i * 80)),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Citat final
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFCC00).withOpacity(0.07),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFFFFCC00).withOpacity(0.3)),
                              ),
                              child: Text(
                                '„Știința alimentară este o disciplină complexă, care necesită gândire critică, nu reacții emoționale."',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.80),
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                            ).animate().fadeIn(duration: 600.ms, delay: 1000.ms),
                          ],
                        ),
                      ).animate()
                          .fadeIn(duration: 700.ms, delay: 600.ms)
                          .slideY(begin: 0.06, end: 0, duration: 600.ms, delay: 600.ms),
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
                    const Color(0xFFFFCC00).withOpacity(0),
                    const Color(0xFFFFCC00).withOpacity(
                        0.75 + 0.25 * math.sin(_ctrl.value * 2 * math.pi)),
                    const Color(0xFF00FF88).withOpacity(0.65),
                    const Color(0xFFFFCC00).withOpacity(0),
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

// ── Data classes ──────────────────────────────────────────────────────────────

class _Feature {
  final String label;
  final IconData icon;
  const _Feature(this.label, this.icon);
}

class _ConcItem {
  final IconData icon;
  final String label;
  final Color color;
  final String desc;
  const _ConcItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.desc,
  });
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _ArchCard extends StatelessWidget {
  final int delay;
  final Color accentColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String noteText;
  final List<_Feature> features;
  final Color featureColor;

  const _ArchCard({
    required this.delay,
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.noteText,
    required this.features,
    required this.featureColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.25), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: accentColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(
                    color: Colors.white, fontSize: 21.5, fontWeight: FontWeight.w800,
                  )),
                  Text(subtitle, style: TextStyle(
                    color: accentColor.withOpacity(0.75), fontSize: 14,
                    fontWeight: FontWeight.w500, letterSpacing: 0.5,
                  )),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 14),
          Text(description, style: TextStyle(
            color: Colors.white.withOpacity(0.78),
            fontSize: 16, height: 1.5,
          )),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.07),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accentColor.withOpacity(0.18)),
            ),
            child: Text(noteText, style: TextStyle(
              color: Colors.white.withOpacity(0.68),
              fontSize: 15, height: 1.4, fontStyle: FontStyle.italic,
            )),
          ),
          const SizedBox(height: 14),
          Text('PUNCTE CHEIE', style: TextStyle(
            color: accentColor,
            fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 2,
          )),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Icon(f.icon, color: featureColor, size: 16),
                  const SizedBox(width: 10),
                  Expanded(child: Text(f.label, style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 15.5,
                  ))),
                ]),
              )).toList(),
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 700.ms, delay: Duration(milliseconds: delay))
        .slideY(begin: 0.06, end: 0, duration: 600.ms, delay: Duration(milliseconds: delay));
  }
}

class _ConcCard extends StatelessWidget {
  final _ConcItem item;
  const _ConcCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: item.color.withOpacity(0.22), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(item.icon, color: item.color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.label, style: TextStyle(
                  color: item.color,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                )),
                const SizedBox(height: 3),
                Flexible(
                  child: Text(item.desc, style: TextStyle(
                    color: Colors.white.withOpacity(0.60),
                    fontSize: 14,
                    height: 1.35,
                  ), overflow: TextOverflow.fade),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── PARTICLE SYSTEM ───────────────────────────────────────────────────────────

class _Particle {
  final double x, y, speedX, speedY, amplitude, phase, radius, opacity, pulseSpeed;
  final bool useColor2;
  const _Particle({
    required this.x, required this.y,
    required this.speedX, required this.speedY,
    required this.amplitude, required this.phase,
    required this.radius, required this.opacity,
    required this.pulseSpeed, required this.useColor2,
  });
}

class _ParticlePainter14 extends CustomPainter {
  final double t;
  _ParticlePainter14(this.t);

  static const _c1 = Color(0xFFFFCC00);
  static const _c2 = Color(0xFF00FF88);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _S14State._particles) {
      final dx = p.x * size.width +
          math.sin(t * 2 * math.pi * p.speedX + p.phase) * p.amplitude * size.width;
      final dy = (p.y + t * p.speedY) % 1.0 * size.height;
      final col = p.useColor2 ? _c2 : _c1;
      final paint = Paint()
        ..color = col.withOpacity(p.opacity *
            (0.5 + 0.5 * math.sin(t * 2 * math.pi * p.pulseSpeed + p.phase)))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter14 old) => old.t != t;
}

class _DotGridPainter14 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFCC00).withOpacity(0.03)
      ..style = PaintingStyle.fill;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter14 _) => false;
}