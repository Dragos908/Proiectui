// Lista slide-urilor, într-un singur loc: ordinea, scena animată din fundal,
// culorile ei și dacă slide-ul are butoane proprii. Dacă ștergi sau muți un rând,
// totul se mută împreună.
//
// Fișierul nu importă `dart:html`, ca testele din `test/` să-l poată verifica.

import 'package:flutter/material.dart';
import '../slides/slide_00_cover.dart';
import '../slides/slide_01_sange.dart';
import '../slides/slide_02_istorie.dart';
import '../slides/slide_03_nastere.dart';
import '../slides/slide_04_nu_moare.dart';
import '../slides/slide_05_coduri_1_2.dart';
import '../slides/slide_06_coduri_3_4.dart';
import '../slides/slide_07_coduri_5_7.dart';
import '../slides/slide_08_faramitare.dart';
import '../slides/slide_09_enzime.dart';
import '../slides/slide_10_ambalaje.dart';
import '../slides/slide_11_concluzie.dart';
import '../theme/light.dart';
import '../theme/palette.dart';
import '../widgets/scenes.dart';

/// Un slide și tot ce ține de el.
class SlideSpec {
  const SlideSpec({
    required this.name,
    required this.slide,
    required this.scene,
    required this.light,
    this.interactive = false,
  });

  /// Numele slide-ului (pentru teste și mesaje).
  final String name;

  final Widget slide;

  /// Animația din fundal (vezi `Scene` în widgets/scenes.dart).
  final int scene;

  /// Culorile scenei și locul de unde urcă lumina.
  final SlideLight light;

  /// Slide-ul are butoane proprii: bara de control se deschide doar din banda
  /// de sus, ca restul ecranului să rămână liber pentru butoane.
  final bool interactive;
}

/// Slide-urile, în ordinea din prezentare: coperta și cele 11 slide-uri din discurs.
const List<SlideSpec> kDeck = <SlideSpec>[
  SlideSpec(
    name: 'Copertă',
    slide: Slide00Cover(),
    scene: Scene.chains,
    light: SlideLight(x: 0.75, colors: <Color>[Palette.cyan, Palette.green]),
  ),
  SlideSpec(
    name: '1 Plastic în sângele nostru',
    slide: Slide01Blood(),
    scene: Scene.blood,
    light: SlideLight(x: 0.8, colors: <Color>[Palette.red, Palette.gold]),
  ),
  SlideSpec(
    name: '2 Inventat ca să salveze elefanții',
    slide: Slide02History(),
    scene: Scene.spheres,
    light: SlideLight(x: 0.4, colors: <Color>[Palette.gold, Palette.coral]),
  ),
  SlideSpec(
    name: '3 Cum se naște plasticul',
    slide: Slide03Birth(),
    scene: Scene.assembly,
    light: SlideLight(x: 0.3, colors: <Color>[Palette.cyan, Palette.violet]),
  ),
  SlideSpec(
    name: '4 De ce plasticul nu moare',
    slide: Slide04WhyNot(),
    scene: Scene.repel,
    light: SlideLight(x: 0.5, colors: <Color>[Palette.cyan, Palette.red]),
  ),
  SlideSpec(
    name: '5 Codurile 1 și 2',
    slide: Slide05Codes12(),
    scene: Scene.triangles,
    light: SlideLight(x: 0.25, colors: <Color>[Palette.cyan, Palette.green]),
  ),
  SlideSpec(
    name: '6 Codurile 3 și 4',
    slide: Slide06Codes34(),
    scene: Scene.triangles,
    light: SlideLight(x: 0.5, colors: <Color>[Palette.red, Palette.gold]),
  ),
  SlideSpec(
    name: '7 Codurile 5, 6 și 7',
    slide: Slide07Codes57(),
    scene: Scene.triangles,
    light: SlideLight(x: 0.75, colors: <Color>[Palette.violet, Palette.orange]),
  ),
  SlideSpec(
    name: '8 Plasticul nu dispare, se fărâmițează',
    slide: Slide08Fragments(),
    scene: Scene.shatter,
    light: SlideLight(x: 0.35, colors: <Color>[Palette.orange, Palette.gold]),
  ),
  SlideSpec(
    name: '9 Chimia care desface plasticul',
    slide: Slide09Enzymes(),
    scene: Scene.cut,
    light: SlideLight(x: 0.5, colors: <Color>[Palette.green, Palette.cyan]),
  ),
  SlideSpec(
    name: '10 Ambalaje pe care natura le poate digera',
    slide: Slide10Packaging(),
    scene: Scene.organic,
    light: SlideLight(x: 0.6, colors: <Color>[Palette.green, Palette.gold]),
  ),
  SlideSpec(
    name: '11 Concluzie',
    slide: Slide11Conclusion(),
    scene: Scene.weakPoint,
    light: SlideLight(x: 0.5, colors: <Color>[Palette.violet, Palette.green]),
  ),
];

/// Slide-urile, pentru `SlideStage`.
final List<Widget> kDeckSlides = <Widget>[for (final SlideSpec s in kDeck) s.slide];

/// Luminile, în aceeași ordine.
final List<SlideLight> kDeckLights = <SlideLight>[for (final SlideSpec s in kDeck) s.light];

/// Scenele din fundal, în aceeași ordine.
final List<int> kDeckScenes = <int>[for (final SlideSpec s in kDeck) s.scene];

/// Pozițiile slide-urilor cu butoane proprii.
final Set<int> kDeckInteractive = <int>{
  for (int i = 0; i < kDeck.length; i++)
    if (kDeck[i].interactive) i,
};
