import 'package:flutter/material.dart';
import 'palette.dart';

/// Stiluri de text comune; mărimile sunt pe canvasul de proiectare 1920×1080.
/// Display: Chakra Petch · text: IBM Plex Sans · cod și indicatori: JetBrains Mono.
/// Fiecare stil are `fontFamilyFallback` (display → text → mono): pe Web, un glif
/// lipsă duce la descărcarea unui font de rezervă (offline: pătrățel).
class Txt {
  Txt._();

  static const String famDisplay = 'Chakra Petch';
  static const String famText = 'IBM Plex Sans';
  static const String famMono = 'JetBrains Mono';

  static const List<String> fbDisplay = <String>[famText, famMono];
  static const List<String> fbText = <String>[famDisplay, famMono];
  static const List<String> fbMono = <String>[famText, famDisplay];

  /// Etichetă (antete, secțiuni). Niciun text de conținut sub 22 px.
  static TextStyle label(Color color, {double size = 22, double alpha = 1.0}) {
    return TextStyle(
      fontFamily: famDisplay,
      fontFamilyFallback: fbDisplay,
      color: color.o(alpha),
      fontSize: size < 22 ? 22 : size,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      height: 1.2,
    );
  }

  /// Titlu de slide, alb-rece.
  static TextStyle title({double size = 76}) {
    return TextStyle(
      fontFamily: famDisplay,
      fontFamilyFallback: fbDisplay,
      color: Palette.gheata,
      fontSize: size,
      fontWeight: FontWeight.w600,
      height: 1.05,
      letterSpacing: -0.5,
    );
  }

  /// Text de corp (26–28 px pe canvas; minim 24).
  static TextStyle body({
    double size = 26,
    double alpha = 0.92,
    FontWeight weight = FontWeight.w400,
    double height = 1.35,
    Color color = Palette.gheata,
  }) {
    return TextStyle(
      fontFamily: famText,
      fontFamilyFallback: fbText,
      color: color.o(alpha),
      fontSize: size,
      fontWeight: weight,
      height: height,
    );
  }

  /// Text evidențiat (nume de panou, cuvinte-cheie, formule).
  static TextStyle strong(Color color, {double size = 28}) {
    return TextStyle(
      fontFamily: famDisplay,
      fontFamilyFallback: fbDisplay,
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
  }

  /// Număr mare, cu un halou discret.
  static TextStyle hero(Color color, {double size = 96}) {
    return TextStyle(
      fontFamily: famDisplay,
      fontFamilyFallback: fbDisplay,
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.0,
      letterSpacing: -1.0,
      shadows: <Shadow>[Shadow(color: color.o(0.35), blurRadius: 22)],
    );
  }

  /// Cod, contor, date.
  static TextStyle mono(
    Color color, {
    double size = 26,
    FontWeight weight = FontWeight.w400,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: famMono,
      fontFamilyFallback: fbMono,
      color: color,
      fontSize: size,
      fontWeight: weight,
      height: height,
    );
  }
}
