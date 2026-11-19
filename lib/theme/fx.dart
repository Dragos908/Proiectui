import 'package:flutter/material.dart';

/// `true` = toate efectele. Pune `false` dacă PC-ul de la proiector e slab:
/// fundalul rămâne static, dispar halourile late și BackdropFilter-ul.
const bool kFxHigh = true;

/// Tokenii de design: durate, curbe, teșituri (45°) și grosimi de linie.
class Fx {
  Fx._();

  // Durate
  static const int enterMs = 900; // un panou: marginea se desenează, apoi apare conținutul
  static const Duration decode = Duration(milliseconds: 700); // titlul, o singură dată
  static const Duration wipe = Duration(milliseconds: 500); // scan-wipe între slide-uri
  static const Duration railTravel = Duration(milliseconds: 650); // pulsul pe șină
  static const Duration ambient = Duration(seconds: 56); // bucla lentă a fundalului (≥ 14 s)

  /// Cât de vii sunt scenele din fundal (1.0 = implicit). Dacă proiectorul le „spală”, crește-l
  /// (1.3); dacă obosesc privirea, scade-l (0.7).
  static const double sceneGain = 1.0;

  // Curbe
  static const Curve out = Curves.easeOutCubic;
  static const Curve inOut = Curves.easeInOutCubic;

  // Teșituri: un singur unghi, 45°
  static const double chamferL = 28; // panou principal
  static const double chamferM = 16; // panou secundar
  static const double chamferS = 10; // insigne, chip-uri, taste

  // Grosimi de linie
  static const double hair = 1.0;
  static const double line = 1.6;
  static const double heavy = 2.6;
}
