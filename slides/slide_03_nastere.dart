// Slide 3 — Cum se naște plasticul
// Polimerizarea (etenă → polietilenă) și policondensarea (acid tereftalic +
// etilenglicol → PET + apă). Modelele 3D: Wikimedia Commons.

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Cum se naște plasticul';

class Slide03Birth extends StatelessWidget {
  const Slide03Birth({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '03',
      chapter: 'MOLECULA',
      title: _kTitle,
      accent: Palette.cyan,
      accent2: Palette.violet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 7, child: _monomerToPolymer().enter(0)),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: const PhotoCard(
                    photo: Photos.pellets,
                    caption: 'Granule de plastic',
                    accent: Palette.cyan,
                  ).enter(1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _reaction(
                    name: 'Polimerizare',
                    color: Palette.cyan,
                    equation: 'etenă → polietilenă',
                    points: const <String>[
                      'legătura dublă a etenei se desface',
                      'moleculele se leagă una de alta',
                      'nu se pierde niciun atom',
                    ],
                    photo: Photos.pe3d,
                    caption: 'Catene de polietilenă (model 3D)',
                  ).enter(2, stepMs: 140),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _reaction(
                    name: 'Policondensare',
                    color: Palette.violet,
                    equation: 'acid tereftalic + etilenglicol → PET + apă',
                    points: const <String>[
                      'se unesc doi monomeri diferiți',
                      'se elimină apă: (2n–1) molecule de H₂O',
                    ],
                    photo: Photos.pet3d,
                    caption: 'O unitate de PET (model 3D)',
                  ).enter(3, stepMs: 140),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 84,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _bondNote(
                    'PE',
                    'doar legături «C–C» și «C–H»',
                    Palette.cyan,
                  ).enter(4),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _bondNote(
                    'PET',
                    'legături «esterice»: apa le poate rupe înapoi',
                    Palette.violet,
                  ).enter(5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _monomerToPolymer() {
    return GlassCard(
      accent: Palette.cyan,
      fit: false,
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('monomer', style: Txt.strong(Palette.cyan, size: 34)),
              const SizedBox(height: 6),
              Text('moleculă mică', style: Txt.body(size: 24, alpha: 0.85)),
            ],
          ),
          const SizedBox(width: 22),
          const ArrowRight(color: Palette.cyan, width: 70),
          const SizedBox(width: 22),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('polimer', style: Txt.strong(Palette.violet, size: 34)),
              const SizedBox(height: 6),
              Text('moleculă uriașă:', style: Txt.body(size: 24, alpha: 0.85)),
              Text('mii de monomeri legați', style: Txt.body(size: 24, alpha: 0.85)),
            ],
          ),
          const SizedBox(width: 26),
          const Expanded(child: ChainSketch(color: Palette.cyan, atoms: 12, height: 120)),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('n', style: Txt.hero(Palette.gold, size: 50)),
              Text(
                'grad de polimerizare\n= câți monomeri\nare polimerul',
                textAlign: TextAlign.right,
                style: Txt.body(size: 21, alpha: 0.85, height: 1.25),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reaction({
    required String name,
    required Color color,
    required String equation,
    required List<String> points,
    required Photo photo,
    required String caption,
  }) {
    return GlassCard(
      accent: color,
      glow: true,
      fit: false,
      padding: const EdgeInsets.fromLTRB(30, 22, 30, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(name, style: Txt.strong(color, size: 40)),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(equation, style: Txt.body(size: 32, weight: FontWeight.w500)),
          ),
          const SizedBox(height: 10),
          PointList(points, color: color, size: 25, gap: 6),
          const SizedBox(height: 14),
          Expanded(
            child: PhotoCard(
              photo: photo,
              fit: BoxFit.contain,
              accent: color,
              background: const Color(0xFF02060D),
              caption: caption,
              captionSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bondNote(String label, String text, Color color) {
    return GlassCard(
      accent: color,
      fill: 0.05,
      padding: const EdgeInsets.fromLTRB(26, 14, 26, 14),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          SizedBox(width: 90, child: Text(label, style: Txt.strong(color, size: 32))),
          Expanded(child: Eq(text, size: 28, highlight: color, weight: FontWeight.w400)),
        ],
      ),
    );
  }
}
