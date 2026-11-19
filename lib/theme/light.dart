import 'package:flutter/material.dart';

/// Lumina unui slide: culorile scenei animate din fundal și locul de unde urcă
/// lumina difuză (de jos).
class SlideLight {
  const SlideLight({
    this.colors = const <Color>[],
    this.x = 0.5,
    this.intensity = 1.0,
  });

  /// 1–2 culori pentru scena din fundal.
  final List<Color> colors;

  /// Unde urcă lumina, pe lățimea ecranului (0 = stânga, 1 = dreapta).
  final double x;

  /// 0..1: cât de vie e scena (slide-ul cu surse o vrea calmă).
  final double intensity;

  static const SlideLight dim = SlideLight(intensity: 0.5);
}
