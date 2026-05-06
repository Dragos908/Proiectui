import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 01 – Ce Sunt Conservantii Alimentari? (Fără citări)
// ─────────────────────────────────────────────────────────────────────────────

class  Slide01WhatIsApp extends StatefulWidget {
  const  Slide01WhatIsApp({super.key});
  @override
  State< Slide01WhatIsApp> createState() => _S01State();
}

class _S01State extends State< Slide01WhatIsApp>
    with TickerProviderStateMixin {
  late AnimationController _backgroundCtrl;

  @override
  void initState() {
    super.initState();
    _backgroundCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 15))
      ..repeat();
  }

  @override
  void dispose() {
    _backgroundCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('slide_01'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // Fundal Negru Pur pentru confort vizual
          colors: [Color(0xFF000000), Color(0xFF050505), Color(0xFF000000)],
        ),
      ),
      child: Stack(children: [

        // FUNDAL ANIMAT: Flux de date Hi-Tech
        AnimatedBuilder(
          animation: _backgroundCtrl,
          builder: (context, child) {
            return CustomPaint(painter: _TechFlowPainter(animation: _backgroundCtrl), size: Size.infinite);
          },
        ),

        Positioned(
          top: -120, right: -80,
          child: Container(
            width: 600, height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFF00F0FF).withOpacity(0.12),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -100, left: 50,
          child: Container(
            width: 450, height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFF00FF88).withOpacity(0.10),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(60, 40, 60, 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ── STÂNGA: Număr + Titlu + POZĂ ──────────────────────
              SizedBox(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(width: 60, height: 4, color: const Color(0xFF00F0FF)),
                      const SizedBox(width: 16),
                      const Text('1', style: TextStyle(
                        color: Color(0xFF00F0FF), fontSize: 18,
                        fontWeight: FontWeight.w800, letterSpacing: 4,
                      )),
                    ]).animate().fadeIn(duration: 500.ms),

                    const SizedBox(height: 24),

                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [Colors.white, Color(0xFF90D8FF)],
                      ).createShader(b),
                      child: const Text(
                        'Ce Sunt\nConservanții?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 900.ms, delay: 200.ms)
                        .slideY(begin: 0.08, end: 0, duration: 700.ms, delay: 200.ms),

                    const SizedBox(height: 40),

                    Container(
                      height: 380,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00F0FF).withOpacity(0.4),
                          width: 2.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ).animate().fadeIn(duration: 800.ms, delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
                  ],
                ),
              ),

              const SizedBox(width: 70),

              // ── DREAPTA: Informația text ───────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Definiția UE
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.4), width: 1.5),
                          color: const Color(0xFF00F0FF).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00F0FF).withOpacity(0.05),
                              blurRadius: 24,
                              spreadRadius: 4,
                            )
                          ]
                      ),
                      child: const Text(
                        'Conform UE (Reg. 1333/2008), conservanții sunt substanțe care prelungesc durata de stabilitate la depozitare a produselor alimentare prin protejarea acestora împotriva deteriorării cauzate de microorganisme.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ).animate().fadeIn(duration: 700.ms, delay: 300.ms).slideX(begin: 0.05),

                    const SizedBox(height: 32),

                    const _FeatureRow(
                      icon: Icons.timer_off_rounded,
                      color: Color(0xFF00F0FF),
                      text: 'Fără ei, alimentele s-ar degrada rapid (pâinea în 1-2 zile, mezelurile în câteva ore la temperatura camerei), iar importul/exportul ar fi practic imposibil.',
                      delay: 500,
                    ),

                    const SizedBox(height: 24),

                    const _FeatureRow(
                      icon: Icons.local_shipping_rounded,
                      color: Color(0xFF00FF88),
                      text: 'Lanțurile lungi de distribuție și producția de masă impun ca milioane de porții să rămână sigure și proaspete timp de săptămâni sau chiar luni.',
                      delay: 650,
                    ),

                    const SizedBox(height: 24),

                    const _FeatureRow(
                      icon: Icons.health_and_safety_rounded,
                      color: Color(0xFFFF5555),
                      text: 'Sunt vitali pentru siguranța sanitară, prevenind toxiinfecțiile alimentare grave, precum botulismul cauzat de Clostridium botulinum.',
                      delay: 800,
                    ),

                    const SizedBox(height: 24),

                    const _FeatureRow(
                      icon: Icons.price_check_rounded,
                      color: Color(0xFFFFCC00),
                      text: 'Asigură accesibilitate economică, permițând ca alimentele să fie produse mai ieftin și distribuite în zone fără acces facil la produse proaspete.',
                      delay: 950,
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

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final int delay;

  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.text,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: Duration(milliseconds: delay)).slideX(begin: 0.05);
  }
}

class _TechFlowPainter extends CustomPainter {
  final Animation<double> animation;
  _TechFlowPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final cyanPaint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.12)
      ..style = PaintingStyle.fill;
    final greenPaint = Paint()
      ..color = const Color(0xFF00FF88).withOpacity(0.08)
      ..style = PaintingStyle.fill;
    final textPaint = TextStyle(
      color: Colors.white.withOpacity(0.1),
      fontSize: 10,
      fontFamily: 'Monospace',
    );

    final step = 48.0;
    final animationValue = animation.value;

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step * 0.8) {
        double offsetX = (x + animationValue * 300) % size.width;
        double offsetY = y;
        offsetY += 12 * math.sin((x / step) + animationValue * 4 * math.pi);
        offsetX += 8 * math.cos((y / step) + animationValue * 2 * math.pi);

        if ((x / step).toInt() % 4 == 0) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(offsetX, offsetY, step * 0.7, 3), const Radius.circular(1.5)),
            (x + y).toInt() % 2 == 0 ? cyanPaint : greenPaint,
          );
        } else if ((x / step).toInt() % 4 == 1) {
          final textSpan = TextSpan(text: ((x + y + (animationValue * 100).toInt()).toInt() % 10).toString(), style: textPaint);
          final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, Offset(offsetX, offsetY));
        } else if ((x / step).toInt() % 4 == 2) {
          canvas.drawCircle(
            Offset(offsetX, offsetY),
            2.0,
            Paint()..color = greenPaint.color.withOpacity(cyanPaint.color.opacity)..style = PaintingStyle.fill,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_TechFlowPainter _) => true;
}