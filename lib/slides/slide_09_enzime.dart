// Slide 9 — Chimia care desface plasticul
// Surse: Yoshida și colab., Science 2016 (Ideonella sakaiensis 201-F6); Tournier și
// colab., Nature 2020 (enzima Carbios); Sanluis-Verdes și colab., Nat. Commun. 2022
// (larvele moliei de ceară); Yang și colab., ES&T 2015 (viermii de făină).
// Pentru întrebări (nu pe slide): ecuațiile glicolizei și metanolizei PET.

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/auto_fit.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Chimia care desface plasticul';

class Slide09Enzymes extends StatelessWidget {
  const Slide09Enzymes({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '09',
      chapter: 'SOLUȚIA',
      title: _kTitle,
      accent: Palette.green,
      accent2: Palette.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 11,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 13, child: _bacterium().enter(0)),
                const SizedBox(width: 24),
                Expanded(flex: 6, child: _carbios().enter(1)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            flex: 8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: const PhotoCard(
                    photo: Photos.waxWorm,
                    caption: 'Larvă de molie de ceară',
                    accent: Palette.gold,
                    captionSize: 20,
                  ).enter(2, stepMs: 130),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: const PhotoCard(
                    photo: Photos.mealworms,
                    caption: 'Viermi de făină',
                    accent: Palette.gold,
                    captionSize: 20,
                  ).enter(3, stepMs: 130),
                ),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: _larvae().enter(4, stepMs: 130)),
                const SizedBox(width: 20),
                Expanded(flex: 4, child: _pyrolysis().enter(5, stepMs: 130)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bacterium() {
    return GlassCard(
      accent: Palette.green,
      glow: true,
      fit: false,
      padding: const EdgeInsets.fromLTRB(32, 22, 26, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 10,
            child: AutoFit(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'Ideonella sakaiensis',
                          style: Txt.strong(Palette.green, size: 46).copyWith(fontStyle: FontStyle.italic),
                        ),
                        TextSpan(text: '  (2016)', style: Txt.strong(Palette.gheata, size: 36)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const PointList(
                    <String>[
                      'Kohei Oda și Kenji Miyamoto:|250 de probe de sediment, sol, ape uzate și nămol',
                      'De unde:|o instalație de reciclare a sticlelor PET din Sakai',
                      'Bacterie nouă:|folosește PET-ul ca hrană',
                      'PETaza + MHETaza:|hidroliza legăturilor esterice → monomerii înapoi',
                      'La 30 °C:|60 de ore → suprafața foliei de PET ciuruită; 6 săptămâni → aproape complet degradată',
                    ],
                    color: Palette.green,
                    size: 26,
                    gap: 12,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            flex: 4,
            child: PhotoCard(
              photo: Photos.petase,
              caption: 'PETaza (model 3D)',
              fit: BoxFit.contain,
              accent: Palette.green,
              background: const Color(0xFF02060D),
              captionSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _carbios() {
    return GlassCard(
      accent: Palette.cyan,
      glow: true,
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 22),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('ENZIMĂ ÎMBUNĂTĂȚITĂ · CARBIOS', style: Txt.label(Palette.cyan, size: 22)),
          const SizedBox(height: 8),
          Text('cel puțin', style: Txt.body(size: 26, alpha: 0.85)),
          Text('90%', style: Txt.hero(Palette.cyan, size: 84)),
          Text('din PET → monomeri, în 10 ore', style: Txt.body(size: 27, weight: FontWeight.w500)),
          const SizedBox(height: 16),
          const PointList(
            <String>[
              'fabrica de la Longlaville: amânată',
              'dec. 2024: cu 6–9 luni; dec. 2025: cu încă 3 luni',
              'pornire estimată: prima jumătate a lui 2028',
            ],
            color: Palette.cyan,
            size: 23,
            gap: 6,
          ),
        ],
      ),
    );
  }

  Widget _larvae() {
    return GlassCard(
      accent: Palette.gold,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('LARVE', style: Txt.label(Palette.gold, size: 22)),
          const SizedBox(height: 12),
          const PointList(
            <String>[
              'Larvele moliei de ceară:|par să oxideze polietilena cu enzime din salivă',
              'Viermii de făină:|≈ 48% din carbonul polistirenului mâncat → CO₂',
            ],
            color: Palette.gold,
            size: 24,
            gap: 12,
          ),
          const SizedBox(height: 16),
          const TagChip(
            text: 'doar în laborator, unele contestate',
            color: Palette.red,
            icon: Icons.science_outlined,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _pyrolysis() {
    return GlassCard(
      accent: Palette.orange,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('PE ȘI PP', style: Txt.label(Palette.orange, size: 22)),
          const SizedBox(height: 6),
          Text('piroliză', style: Txt.strong(Palette.orange, size: 44)),
          const SizedBox(height: 12),
          const PointList(
            <String>[
              'încălzire fără oxigen',
              'rupe catenele → amestecuri de hidrocarburi',
              'consumă multă energie',
            ],
            color: Palette.orange,
            size: 24,
            gap: 6,
          ),
        ],
      ),
    );
  }
}
