// Slide 4 — De ce plasticul nu moare
// Energiile medii de legătură: Chemistry LibreTexts (C–C ≈ 347, C–H ≈ 413 kJ/mol).
// Dreapta: catena de polietilenă, fără „punct slab”, și plasticul care se fărâmițează.

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'De ce plasticul nu moare';

class Slide04WhyNot extends StatelessWidget {
  const Slide04WhyNot({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '04',
      chapter: 'MOLECULA',
      title: _kTitle,
      accent: Palette.cyan,
      accent2: Palette.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 210,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(child: _energy('C–C', '347').enter(0)),
                      const SizedBox(width: 24),
                      Expanded(child: _energy('C–H', '413').enter(1)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(child: _reasons().enter(2)),
              ],
            ),
          ),
          const SizedBox(width: 28),
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 11, child: _enzymeView().enter(3, stepMs: 140)),
                const SizedBox(height: 24),
                Expanded(
                  flex: 8,
                  child: const PhotoCard(
                    photo: Photos.beach,
                    caption: 'Nu putrezește ca o frunză: nu se descompune chimic, doar se rupe în bucăți tot mai mici',
                    accent: Palette.red,
                  ).enter(4, stepMs: 140),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _energy(String bond, String kj) {
    return GlassCard(
      accent: Palette.cyan,
      glow: true,
      padding: const EdgeInsets.fromLTRB(30, 22, 30, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('legătură puternică $bond · în medie', style: Txt.label(Palette.cyan, size: 24)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text('≈ $kj', style: Txt.hero(Palette.gheata, size: 92)),
              const SizedBox(width: 12),
              Text('kJ/mol', style: Txt.body(size: 30, alpha: 0.8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reasons() {
    return GlassCard(
      accent: Palette.cyan,
      padding: const EdgeInsets.fromLTRB(34, 30, 34, 30),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const PointList(
            <String>[
              'Secretul|nu este doar tăria legăturilor',
              'Polietilena:|catenă saturată, nepolară și hidrofobă (respinge apa)',
              'Enzimele din natură|rup cu ajutorul apei legături polare (esterice, glicozidice) = hidroliză',
              'Molecula de PE|e mult prea mare ca să intre într-o celulă de bacterie',
            ],
            color: Palette.cyan,
            size: 32,
            gap: 26,
          ),
        ],
      ),
    );
  }

  Widget _enzymeView() {
    return GlassCard(
      accent: Palette.red,
      glow: true,
      padding: const EdgeInsets.fromLTRB(30, 22, 30, 22),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('CATENA DE POLIETILENĂ', style: Txt.label(Palette.cyan, size: 24)),
          const SizedBox(height: 10),
          const ChainSketch(color: Palette.cyan, atoms: 9, height: 130),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              const IconBadge(icon: Icons.block, color: Palette.red, size: 58),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  'Pe catena PE nu există un „punct slab” pentru enzime',
                  style: Txt.body(size: 30, weight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
