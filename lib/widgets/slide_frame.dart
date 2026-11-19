import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/fx.dart';
import '../theme/palette.dart';
import '../theme/text_styles.dart';
export 'enter_choreo.dart' show SlideEnter;

/// Fundalul „planșă tehnică” a dispărut: fundalul e acum un strat persistent
/// (`HoloBackdrop`, în `SlideStage`). Clasa rămâne goală doar ca să compileze
/// `slide_00_cover.dart` până în Faza 2.
class BlueprintBackdrop extends StatelessWidget {
  const BlueprintBackdrop({
    super.key,
    required this.accent,
    this.organic = false,
  });

  final Color accent;
  final bool organic;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Cadrul comun al unui slide: titlul (cu „decodare” la intrare), firul de semnal
/// de sub el și zona de conținut. Fundalul nu mai e desenat aici.
///
/// Parametrii `chapterNo` / `chapter` sunt încă acceptați (nu se afișează), ca slide-urile
/// existente să compileze; `organic` e ignorat.
///
/// Conținutul se așază pe un canvas fix de 1920×1080, scalat uniform pe ecran
/// (`FittedBox`); zona `child` primește ~1728 × 815–858 px.
class SlideFrame extends StatelessWidget {
  const SlideFrame({
    super.key,
    required this.chapterNo,
    required this.chapter,
    required this.title,
    required this.accent,
    required this.child,
    this.subtitle,
    this.organic = false,
    this.titleSize = 76,
    this.accent2,
  });

  final String chapterNo; // nu se mai afișează
  final String chapter; // nu se mai afișează
  final String title;
  final String? subtitle;
  final Color accent;

  /// A doua culoare a firului de semnal, pentru slide-urile cu două etape (ex. 03, 04, 06).
  final Color? accent2;
  final bool organic;
  final double titleSize;
  final Widget child;

  static const double canvasW = 1920;
  static const double canvasH = 1080;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: canvasW,
              height: canvasH,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(96, 54, 96, 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _titleBlock(),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(subtitle!, style: Txt.body(size: 26, alpha: 0.65)),
                      ),
                    // Firul stă în cei 24 px dintre titlu și conținut: spațiul util nu se schimbă.
                    SizedBox(height: 24, child: _SignalRule(accent: accent, accent2: accent2)),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleBlock() {
    return Semantics(
      header: true,
      label: title,
      excludeSemantics: true,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: _DecodeTitle(text: title, style: Txt.title(size: titleSize)),
      ),
    );
  }
}

/// Titlul se „decodează” de la stânga la dreapta (~700 ms, o singură dată).
/// Dimensiunea rămâne cea a textului final; cu animațiile oprite apare direct.
class _DecodeTitle extends StatefulWidget {
  const _DecodeTitle({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<_DecodeTitle> createState() => _DecodeTitleState();
}

class _DecodeTitleState extends State<_DecodeTitle> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: Fx.decode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final bool reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      _c.value = 1.0;
    } else {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  String _scramble(double t, int step) {
    final String s = widget.text;
    final int n = s.length;
    final int resolved = (t * n * 1.12).floor();
    final StringBuffer b = StringBuffer();
    for (int i = 0; i < n; i++) {
      final String ch = s[i];
      if (i < resolved || ch == ' ') {
        b.write(ch);
        continue;
      }
      final int h = ((i * 73856093) ^ (step * 19349663)) & 0x7fffffff;
      final String src = (h % 3 == 0) ? '01' : s;
      b.write(src[(h ~/ 3) % src.length]);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? _) {
        if (_c.value >= 1.0) return Text(widget.text, style: widget.style);
        final int step = (_c.value * Fx.decode.inMilliseconds).round() ~/ 80;
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Opacity(opacity: 0.0, child: Text(widget.text, style: widget.style)),
            Positioned(
              left: 0,
              top: 0,
              child: Text(
                _scramble(_c.value, step),
                style: widget.style,
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Fir de semnal sub titlu: un puls de lumină își „desenează” drumul o singură dată.
class _SignalRule extends StatefulWidget {
  const _SignalRule({required this.accent, this.accent2});

  final Color accent;
  final Color? accent2;

  @override
  State<_SignalRule> createState() => _SignalRuleState();
}

class _SignalRuleState extends State<_SignalRule> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final bool reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      _c.value = 1.0;
    } else {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _RulePainter(t: _c, accent: widget.accent, accent2: widget.accent2),
        size: Size.infinite,
      ),
    );
  }
}

class _RulePainter extends CustomPainter {
  _RulePainter({required this.t, required this.accent, this.accent2}) : super(repaint: t);

  final Animation<double> t;
  final Color accent;
  final Color? accent2;

  @override
  void paint(Canvas canvas, Size size) {
    const double start = 0.22; // pulsul pornește după ce titlul s-a „decodat”
    final double k = ((t.value - start) / (1.0 - start)).clamp(0.0, 1.0).toDouble();
    if (k <= 0.0) return;
    final double y = size.height / 2;
    final double total = accent2 != null ? size.width : math.min(size.width, 640.0);
    final double head = total * Fx.inOut.transform(k);
    final Color end = accent2 != null ? accent2!.o(0.95) : accent.o(0.0);
    canvas.drawLine(
      Offset(0, y),
      Offset(head, y),
      Paint()
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(Offset.zero, Offset(total, 0), <Color>[accent.o(0.95), end]),
    );
    if (k < 1.0) {
      canvas.drawCircle(Offset(head, y), 10, Paint()..color = accent.o(0.20));
      canvas.drawCircle(Offset(head, y), 3.4, Paint()..color = Palette.gheata);
    }
  }

  @override
  bool shouldRepaint(_RulePainter old) =>
      old.t != t || old.accent != accent || old.accent2 != accent2;
}
