import 'package:flutter/material.dart';

/// Paleta „Holo-Pipeline”: neutre pentru interfață + câte o culoare-lumină pe etapă.
///
/// Etape (vezi `theme/stages.dart`):
///  1 Analiza ........ cyan      4 Codificarea .... green
///  2 Modelul ........ violet    5 Testarea ........ red
///  3 Algoritmul ..... gold      6 Documentarea .... coral
/// Orange nu e culoarea unei etape: rămâne pentru accente (de exemplu „Greșeli celebre”).
class Palette {
  Palette._();

  // ── Neutre (interfață, text, panouri) ────────────────────────────────────
  static const Color abis = Color(0xFF050B17); // fundal: albastru-negru, nu negru pur
  static const Color punte = Color(0xFF0B1627); // baza panourilor
  static const Color fir = Color(0xFF2B3F5C); // linii și noduri stinse (doar grafică, nu text)
  static const Color ceata = Color(0xFFA9BBD0); // text secundar (10:1 pe Abis)
  static const Color gheata = Color(0xFFE9F2FB); // text, cifre, capul pulsului (17:1 pe Abis)

  // Alias-uri păstrate pentru slide-urile existente.
  static const Color bg = abis;
  static const Color bgMid = Color(0xFF070F1E);
  static const Color bgEnd = Color(0xFF06111F);

  // ── Etapele (sursele de lumină) ──────────────────────────────────────────
  static const Color cyan = Color(0xFF00F0FF);
  static const Color violet = Color(0xFFB88BFF);
  static const Color gold = Color(0xFFFFCC00);
  static const Color green = Color(0xFF00FF88);
  static const Color red = Color(0xFFFF4255); // era #FF4466: se confunda cu coral (ΔE 31 → 45)
  static const Color coral = Color(0xFFFF6EB4); // era #FF7AA8
  static const Color orange = Color(0xFFFF7700); // era #FF6600
}

/// Opacitate independentă de versiunea Flutter (evită `withOpacity` / `withValues`).
extension PaletteColor on Color {
  Color o(double opacity) {
    final double v = opacity.clamp(0.0, 1.0).toDouble();
    return withAlpha((v * 255).round());
  }
}
