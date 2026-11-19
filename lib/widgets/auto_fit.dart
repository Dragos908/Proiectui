import 'package:flutter/material.dart';

/// Safety net against overflow: the content keeps its
/// natural size and is scaled down proportionally only if it does not fit
/// in height. The content must have an intrinsic height (no vertical
/// `Expanded` / `Flexible`) and the parent's width must be
/// finite.
class AutoFit extends StatelessWidget {
  const AutoFit({
    super.key,
    required this.child,
    this.alignment = Alignment.topLeft,
  });

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        if (!w.isFinite) return child;
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignment,
          child: SizedBox(width: w, child: child),
        );
      },
    );
  }
}
