import 'package:flutter/material.dart';
import '../theme/fx.dart';

/// Marcaj: widgetul își conduce singur intrarea (panourile `GlassCard`).
abstract class SelfEntering {}

/// Progresul local al unei intrări (0..1 după întârziere), pus de `.enter()`
/// pentru panourile din interior: marginea se desenează, apoi apare conținutul.
class EnterProgress extends InheritedWidget {
  const EnterProgress({
    super.key,
    required this.animation,
    required this.generic,
    required super.child,
  });

  final Animation<double> animation;

  /// `true` dacă `.enter()` aplică el însuși un fade (copilul nu e panou direct).
  final bool generic;

  static EnterProgress? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EnterProgress>();

  @override
  bool updateShouldNotify(EnterProgress old) =>
      old.animation != animation || old.generic != generic;
}

/// Intrare eșalonată. Se aplică pe conținutul unui `Expanded` / `Positioned`,
/// niciodată pe acesta. `GlassCard` direct: marginea se desenează, apoi apare
/// conținutul; orice alt widget: fade scurt cu o ridicare discretă.
extension SlideEnter on Widget {
  Widget enter(int index, {int baseMs = 250, int stepMs = 110, double dy = 0.06}) {
    return _Enter(
      delay: Duration(milliseconds: baseMs + index * stepMs),
      rise: dy * 120,
      selfAnimated: this is SelfEntering,
      child: this,
    );
  }
}

class _Enter extends StatefulWidget {
  const _Enter({
    required this.delay,
    required this.rise,
    required this.selfAnimated,
    required this.child,
  });

  final Duration delay;
  final double rise;
  final bool selfAnimated;
  final Widget child;

  @override
  State<_Enter> createState() => _EnterState();
}

class _EnterState extends State<_Enter> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _p;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    final int total = widget.delay.inMilliseconds + Fx.enterMs;
    _c = AnimationController(vsync: this, duration: Duration(milliseconds: total));
    _p = _c.drive(CurveTween(curve: Interval(widget.delay.inMilliseconds / total, 1.0)));
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
    Widget child = widget.child;
    if (!widget.selfAnimated) {
      child = AnimatedBuilder(
        animation: _p,
        child: child,
        builder: (BuildContext context, Widget? ch) {
          final double t = Fx.out.transform((_p.value / 0.5).clamp(0.0, 1.0).toDouble());
          return Opacity(
            opacity: t,
            child: Transform.translate(offset: Offset(0, (1 - t) * widget.rise), child: ch),
          );
        },
      );
    }
    return EnterProgress(animation: _p, generic: !widget.selfAnimated, child: child);
  }
}
