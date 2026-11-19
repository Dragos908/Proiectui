import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/fx.dart';
import '../theme/palette.dart';
import 'scenes.dart';
import '../theme/light.dart';

/// Scena prezentării, pe canvasul de 1920×1080: fundalul de bază, slide-ul curent
/// cu scena lui animată și „scan-wipe”-ul dintre slide-uri.
///
/// Fiecare slide are propria animație în fundal (`SceneBackdrop`, câte una pe indice);
/// scena stă în stratul slide-ului, deci scan-wipe-ul o dezvăluie odată cu el.
/// Direcția vine din indexul anterior față de cel curent (înainte: stânga → dreapta).
/// Un singur controller ambiental conduce toate scenele.
class SlideStage extends StatefulWidget {
  const SlideStage({
    super.key,
    required this.index,
    required this.slides,
    required this.lights,
    this.scenes = const <int>[],
  });

  final int index;
  final List<Widget> slides;

  /// Câte un `SlideLight` pe slide (șina + culorile scenei). Lipsă = atenuat.
  final List<SlideLight> lights;

  /// Numărul scenei din fundal pentru fiecare slide (vezi `scenes.dart`).
  /// Lipsă = scena cu numărul poziției slide-ului, ca înainte.
  final List<int> scenes;

  @override
  State<SlideStage> createState() => _SlideStageState();
}

class _SlideStageState extends State<SlideStage> with TickerProviderStateMixin {
  late final AnimationController _wipe;
  late final AnimationController _ambient;
  int? _prev;
  int _dir = 1;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _wipe = AnimationController(vsync: this, duration: Fx.wipe, value: 1.0);
    _wipe.addStatusListener((AnimationStatus st) {
      if (st == AnimationStatus.completed && _prev != null && mounted) {
        setState(() => _prev = null);
      }
    });
    _ambient = AnimationController(vsync: this, duration: Fx.ambient);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final bool reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (kFxHigh && !reduced) {
      _ambient.repeat();
    } else {
      _ambient.value = 0.18; // scene statice
    }
  }

  @override
  void didUpdateWidget(SlideStage old) {
    super.didUpdateWidget(old);
    if (old.index == widget.index) return;
    final bool reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      _prev = null;
      _wipe.value = 1.0;
      return;
    }
    _prev = old.index;
    _dir = widget.index > old.index ? 1 : -1;
    _wipe.forward(from: 0.0);
  }

  @override
  void dispose() {
    _wipe.dispose();
    _ambient.dispose();
    super.dispose();
  }

  SlideLight _light(int i) => i < widget.lights.length ? widget.lights[i] : SlideLight.dim;

  int _scene(int i) => i < widget.scenes.length ? widget.scenes[i] : i;

  Widget _layer(int i) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        SceneBackdrop(scene: _scene(i), light: _light(i), ambient: _ambient),
        widget.slides[i],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int n = widget.slides.length;
    final int cur = widget.index.clamp(0, n - 1).toInt();
    final int? prev = _prev?.clamp(0, n - 1).toInt();
    final Widget curChild = _layer(cur);
    final Widget? prevChild = prev == null ? null : _layer(prev);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const BaseBackdrop(),
        AnimatedBuilder(
          animation: _wipe,
          builder: (BuildContext context, Widget? _) {
            final double p = Fx.inOut.transform(_wipe.value);
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (prevChild != null)
                  _Layer(
                    key: ValueKey<int>(prev!),
                    clipper: _WipeClipper(p, _dir, false),
                    child: prevChild,
                  ),
                _Layer(
                  key: ValueKey<int>(cur),
                  clipper: prevChild != null ? _WipeClipper(p, _dir, true) : null,
                  child: curChild,
                ),
              ],
            );
          },
        ),
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _wipe,
            builder: (BuildContext context, Widget? _) {
              if (_prev == null || !_wipe.isAnimating) return const SizedBox.shrink();
              return RepaintBoundary(
                child: CustomPaint(
                  painter: _ScanLinePainter(Fx.inOut.transform(_wipe.value), _dir),
                  size: Size.infinite,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Strat de slide: structura rămâne aceeași (cu sau fără decupare), ca slide-ul
/// să nu fie reconstruit când începe sau se termină tranziția.
class _Layer extends StatelessWidget {
  const _Layer({super.key, required this.clipper, required this.child});

  final CustomClipper<Rect>? clipper;
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRect(clipper: clipper, child: child);
}

/// Decupează slide-ul de o parte sau de alta a liniei de scanare.
class _WipeClipper extends CustomClipper<Rect> {
  const _WipeClipper(this.p, this.dir, this.incoming);

  final double p;
  final int dir; // 1 = înainte (stânga → dreapta), -1 = înapoi
  final bool incoming;

  @override
  Rect getClip(Size size) {
    final double x = dir > 0 ? p * size.width : (1 - p) * size.width;
    final bool left = (dir > 0) == incoming;
    return left
        ? Rect.fromLTRB(0, 0, x + 1, size.height)
        : Rect.fromLTRB(x - 1, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(_WipeClipper old) =>
      old.p != p || old.dir != dir || old.incoming != incoming;
}

/// Linia luminoasă care „mătură” ecranul: neutră (alb-gheață), cu o dâră în spate.
class _ScanLinePainter extends CustomPainter {
  const _ScanLinePainter(this.p, this.dir);

  final double p;
  final int dir;

  @override
  void paint(Canvas canvas, Size size) {
    final double x = dir > 0 ? p * size.width : (1 - p) * size.width;
    final double a = math.sin(p * math.pi).clamp(0.0, 1.0).toDouble(); // dispare la capete
    if (a <= 0.0) return;
    const double trail = 220;
    final double x0 = dir > 0 ? x - trail : x;
    final double x1 = dir > 0 ? x : x + trail;
    final Color clear = Palette.gheata.o(0);
    final Color lit = Palette.gheata.o(0.10 * a);
    canvas.drawRect(
      Rect.fromLTRB(x0, 0, x1, size.height),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(x0, 0),
          Offset(x1, 0),
          dir > 0 ? <Color>[clear, lit] : <Color>[lit, clear],
        ),
    );
    canvas.drawRect(
      Rect.fromLTRB(x - 14, 0, x + 14, size.height),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(x - 14, 0),
          Offset(x + 14, 0),
          <Color>[clear, Palette.gheata.o(0.22 * a), clear],
          const <double>[0, 0.5, 1],
        ),
    );
    canvas.drawRect(
      Rect.fromLTRB(x - 1.5, 0, x + 1.5, size.height),
      Paint()..color = Palette.gheata.o(0.9 * a),
    );
  }

  @override
  bool shouldRepaint(_ScanLinePainter old) => old.p != p || old.dir != dir;
}
