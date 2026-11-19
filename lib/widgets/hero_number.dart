import 'package:flutter/material.dart';
import '../theme/text_styles.dart';

/// Hero number: a large, colored figure with an explanatory label below it.
/// [prefix] (e.g. “UP TO”, “OVER”) appears above the figure.
class HeroNumber extends StatelessWidget {
  const HeroNumber({
    super.key,
    required this.value,
    required this.label,
    required this.color,
    this.prefix,
    this.size = 96,
    this.labelSize = 22,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String value;
  final String label;
  final Color color;
  final String? prefix;
  final double size;
  final double labelSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final bool centered = crossAxisAlignment == CrossAxisAlignment.center;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (prefix != null)
          Text(prefix!, style: Txt.label(color, size: labelSize - 2, alpha: 0.85)),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: Txt.hero(color, size: size)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: Txt.body(size: labelSize, alpha: 0.85),
        ),
      ],
    );
  }
}
