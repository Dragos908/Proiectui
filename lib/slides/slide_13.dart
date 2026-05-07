import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 13 – Descarcă Open Food Facts (Android + iOS)
// Stil hi-tech identic cu Slide00 — hex grid animat + scanline + particule
// ─────────────────────────────────────────────────────────────────────────────

// ── Fundal animat ─────────────────────────────────────────────────────────────
class _HexGridPainter extends CustomPainter {
  final double t;
  _HexGridPainter(this.t);

  static const Color _cyan  = Color(0xFF00E5FF);
  static const Color _green = Color(0xFF00FFAA);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Hex grid pulsant
    const hexR = 52.0;
    const hexW = hexR * 1.732050808; // sqrt(3)
    const hexH = hexR * 2.0;
    final cols = (size.width  / hexW).ceil() + 2;
    final rows = (size.height / (hexH * 0.75)).ceil() + 2;
    final rng1 = math.Random(7);
    final linePaint = Paint()
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final cx    = col * hexW + (row.isOdd ? hexW / 2 : 0);
        final cy    = row * hexH * 0.75;
        final phase = rng1.nextDouble() * 2 * math.pi;
        final pulse = 0.5 + 0.5 * math.sin(t * 2 * math.pi + phase);
        linePaint.color = _cyan.withOpacity((0.04 + 0.08 * pulse).clamp(0.0, 1.0));
        final path = Path();
        for (int i = 0; i < 6; i++) {
          final ang = (i * 60 - 30) * math.pi / 180;
          final x   = cx + hexR * math.cos(ang);
          final y   = cy + hexR * math.sin(ang);
          if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
        }
        path.close();
        canvas.drawPath(path, linePaint);
      }
    }

    // 2. Scanline
    final scanY   = (t * size.height * 1.6) % (size.height * 1.2) - size.height * 0.1;
    final scanRect = Rect.fromLTWH(0, scanY - 60, size.width, 120);
    canvas.drawRect(
      scanRect,
      Paint()..shader = LinearGradient(
        begin: Alignment.topCenter,
        end:   Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          _green.withOpacity(0.05),
          _green.withOpacity(0.09),
          _green.withOpacity(0.05),
          Colors.transparent,
        ],
        stops: const [0, 0.35, 0.5, 0.65, 1],
      ).createShader(scanRect),
    );

    // 3. Particule + conexiuni
    final rng2 = math.Random(42);
    final pts  = List.generate(28, (i) {
      final bx    = rng2.nextDouble() * size.width;
      final by    = rng2.nextDouble() * size.height;
      final phase = rng2.nextDouble() * 2 * math.pi;
      return Offset(
        bx + math.sin(t * 2 * math.pi + phase)        * 18,
        by + math.cos(t * 2 * math.pi + phase * 1.3)  * 18,
      );
    });

    final rng3 = math.Random(42);
    final dotPaint = Paint();
    for (int i = 0; i < pts.length; i++) {
      final phase = rng3.nextDouble() * 2 * math.pi;
      final alpha = (0.15 + 0.25 * math.sin(t * 2 * math.pi + phase)).abs();
      dotPaint.color = (i.isEven ? _cyan : _green).withOpacity(alpha);
      canvas.drawCircle(pts[i], 2.2, dotPaint);
    }

    final linePaint2 = Paint()..strokeWidth = 0.8;
    for (int i = 0; i < pts.length; i++) {
      for (int j = i + 1; j < pts.length; j++) {
        final d = (pts[i] - pts[j]).distance;
        if (d < 180) {
          linePaint2.color = _green.withOpacity((1 - d / 180) * 0.12);
          canvas.drawLine(pts[i], pts[j], linePaint2);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_HexGridPainter old) => old.t != t;
}

// ── Corner brackets ───────────────────────────────────────────────────────────
class _BracketPainter extends CustomPainter {
  final Color color;
  _BracketPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final len = math.min(size.width, size.height) * 0.16;
    final p   = Paint()
      ..color       = color
      ..strokeWidth = 2.2
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.square;

    void bracket(List<Offset> pts) {
      final path = Path()
        ..moveTo(pts[0].dx, pts[0].dy)
        ..lineTo(pts[1].dx, pts[1].dy)
        ..lineTo(pts[2].dx, pts[2].dy);
      canvas.drawPath(path, p);
    }

    bracket([Offset(0, len),              const Offset(0, 0),         Offset(len, 0)]);
    bracket([Offset(size.width - len, 0), Offset(size.width, 0),      Offset(size.width, len)]);
    bracket([Offset(0, size.height - len),Offset(0, size.height),     Offset(len, size.height)]);
    bracket([Offset(size.width - len, size.height), Offset(size.width, size.height), Offset(size.width, size.height - len)]);
  }

  @override
  bool shouldRepaint(_BracketPainter old) => old.color != color;
}

// ── QR Card ───────────────────────────────────────────────────────────────────
class _QrCard extends StatelessWidget {
  final String   url;
  final String   platform;
  final IconData icon;
  final Color    accent;
  final double   scale;
  final int      animDelay;

  const _QrCard({
    required this.url,
    required this.platform,
    required this.icon,
    required this.accent,
    required this.scale,
    required this.animDelay,
  });

  @override
  Widget build(BuildContext context) {
    final qrSize = 300.0 * scale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Platform label
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: accent, size: 20 * scale),
            SizedBox(width: 7 * scale),
            Text(
              platform,
              style: TextStyle(
                color:         accent,
                fontSize:      13 * scale,
                fontWeight:    FontWeight.w600,
                letterSpacing: 3.5,
              ),
            ),
          ],
        ).animate().fadeIn(delay: (animDelay + 250).ms),

        SizedBox(height: 14 * scale),

        // QR + brackets
        CustomPaint(
          painter: _BracketPainter(accent),
          child: Padding(
            padding: EdgeInsets.all(qrSize * 0.055),
            child: QrImageView(
              data:            url,
              version:         QrVersions.auto,
              size:            qrSize,
              backgroundColor: Colors.white,
              padding:         const EdgeInsets.all(10),
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color:    Color(0xFF010C0F),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color:           Color(0xFF010C0F),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(delay: animDelay.ms, duration: 700.ms)
            .scale(
              begin: const Offset(0.82, 0.82),
              curve: Curves.easeOutBack,
              duration: 850.ms,
              delay: animDelay.ms,
            ),

        SizedBox(height: 10 * scale),

        Text(
          platform == 'ANDROID' ? 'Google Play' : 'App Store',
          style: TextStyle(
            color:         accent.withOpacity(0.50),
            fontSize:      10 * scale,
            letterSpacing: 2.5,
            fontWeight:    FontWeight.w300,
          ),
        ).animate().fadeIn(delay: (animDelay + 450).ms),
      ],
    );
  }
}

// ── Slide13 ───────────────────────────────────────────────────────────────────
class Slide13 extends StatefulWidget {
  const Slide13({super.key});

  @override
  State<Slide13> createState() => _S13State();
}

class _S13State extends State<Slide13> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static const _androidUrl =
      'https://play.google.com/store/apps/details?id=org.openfoodfacts.scanner&pcampaignid=web_share';
  static const _iosUrl =
      'https://apps.apple.com/app/open-food-facts/id588797948';

  static const _cyan  = Color(0xFF00E5FF);
  static const _green = Color(0xFF00FFAA);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 12))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static double _scale(double w, double h) =>
      (math.min(w / 1440, h / 900)).clamp(0.38, 1.6);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final s = _scale(constraints.maxWidth, constraints.maxHeight);

      return Container(
        key: const ValueKey('slide_13'),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin:  Alignment.topLeft,
            end:    Alignment.bottomRight,
            colors: [Color(0xFF01080B), Color(0xFF02141A), Color(0xFF000507)],
          ),
        ),
        child: Stack(children: [

          // Fundal animat
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => CustomPaint(
              painter: _HexGridPainter(_ctrl.value),
              size:    Size.infinite,
            ),
          ),

          // Conținut
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Titlu principal
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [Colors.white, _green],
                  ).createShader(b),
                  child: Text(
                    'DESCARCĂ APLICAȚIA',
                    style: TextStyle(
                      color:         Colors.white,
                      fontSize:      34 * s,
                      fontWeight:    FontWeight.w900,
                      letterSpacing: 6,
                      height:        1.0,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .blur(begin: const Offset(18, 0), end: Offset.zero, duration: 1.seconds)
                    .slideY(begin: -0.15, end: 0, curve: Curves.easeOutBack),

                SizedBox(height: 36 * s),

                // Cele două QR-uri
                Row(
                  mainAxisSize:       MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _QrCard(
                      url:       _androidUrl,
                      platform:  'ANDROID',
                      icon:      Icons.android,
                      accent:    _green,
                      scale:     s,
                      animDelay: 800,
                    ),

                    SizedBox(width: 56 * s),

                    // Separator vertical
                    Container(
                      width: 1,
                      height: 340 * s,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin:  Alignment.topCenter,
                          end:    Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            _cyan.withOpacity(0.30),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 1.seconds, duration: 700.ms),

                    SizedBox(width: 56 * s),

                    _QrCard(
                      url:       _iosUrl,
                      platform:  'iOS',
                      icon:      Icons.apple,
                      accent:    _cyan,
                      scale:     s,
                      animDelay: 1100,
                    ),
                  ],
                ),


              ],
            ),
          ),
        ]),
      );
    });
  }
}