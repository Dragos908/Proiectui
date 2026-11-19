import 'package:flutter/material.dart';
import '../theme/fx.dart';
import '../theme/palette.dart';
import '../theme/text_styles.dart';
import 'panel_shapes.dart';

/// Tastă holografică de navigare (doar pe slide-urile interactive): contur teșit
/// în culoarea etapei, strălucire la apăsare, cursor „mână” pe Web.
class NavButton extends StatefulWidget {
  const NavButton({
    super.key,
    required this.label,
    required this.tooltip,
    required this.color,
    required this.onTap,
    this.icon,
    this.iconAfter = false,
    this.highlighted = false,
  });

  final String label;
  final String tooltip;
  final Color color;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool iconAfter;
  final bool highlighted;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool _pressed = false;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onTap != null;
    final Color c = widget.color;
    final bool strong = enabled && (_pressed || _hover || widget.highlighted);
    final double textAlpha = !enabled ? 0.30 : (strong ? 1.0 : 0.88);
    final double lit = !enabled ? 0.0 : (_pressed ? 1.0 : (strong ? 0.6 : 0.25));

    final Widget? iconWidget =
        widget.icon == null ? null : Icon(widget.icon, color: c.o(textAlpha), size: 28);
    final Widget text = Text(
      widget.label,
      style: TextStyle(
        fontFamily: Txt.famDisplay,
        fontFamilyFallback: Txt.fbDisplay,
        color: c.o(textAlpha),
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
    final Widget face = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (iconWidget != null && !widget.iconAfter) ...<Widget>[
            iconWidget,
            const SizedBox(width: 10),
          ],
          text,
          if (iconWidget != null && widget.iconAfter) ...<Widget>[
            const SizedBox(width: 10),
            iconWidget,
          ],
        ],
      ),
    );

    return Tooltip(
      message: widget.tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: widget.tooltip,
        child: MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: lit),
              duration: const Duration(milliseconds: 140),
              child: face,
              builder: (BuildContext context, double v, Widget? child) {
                return CustomPaint(
                  painter: ChamferPainter(
                    color: c,
                    cut: Fx.chamferS + 4,
                    fillAlpha: 0.05 + 0.23 * v,
                    strokeAlpha: 0.30 + 0.65 * v,
                    strokeWidth: 1.4 + 0.8 * v,
                    glow: kFxHigh ? v : 0.0,
                  ),
                  child: child,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Bară de progres segmentată (segmentul activ e mai lung și luminos); opțional apăsabilă.
class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    required this.count,
    required this.index,
    required this.color,
    this.onSelect,
  });

  final int count;
  final int index;
  final Color color;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${index + 1} of $count',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(count, (int i) {
          final bool active = i == index;
          final bool done = i < index;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSelect == null ? null : () => onSelect!(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: active ? 56 : 30,
                height: 12,
                child: CustomPaint(
                  painter: ChamferPainter(
                    color: color,
                    cut: 4,
                    fillAlpha: active ? 0.95 : (done ? 0.45 : 0.12),
                    strokeAlpha: active ? 1.0 : (done ? 0.6 : 0.3),
                    strokeWidth: 1.0,
                    glow: active && kFxHigh ? 1.0 : 0.0,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Indicator mic „n / total”, în monospace.
class PageCounter extends StatelessWidget {
  const PageCounter({
    super.key,
    required this.index,
    required this.count,
    required this.color,
  });

  final int index;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${index + 1} / $count',
      style: Txt.mono(color.o(0.9), size: 24, weight: FontWeight.w500, height: 1.2),
    );
  }
}
