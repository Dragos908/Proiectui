// Slide 10 — Ambalaje pe care natura le poate „digera”
// Surse: Royal.uk 2023, The Chemical Engineer 2022 (Notpla, Earthshot Prize 2022);
// Ecovative / Mushroom Packaging (miceliu, ~7 zile); Narancic și colab. 2018,
// Royer și colab., PLOS ONE 2023 (PLA); Biodegradation 2025, Polymer Journal (PHA).

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Ambalaje pe care natura le poate „digera”';

class Slide10Packaging extends StatelessWidget {
  const Slide10Packaging({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '10',
      chapter: 'SOLUȚIA',
      title: _kTitle,
      accent: Palette.green,
      accent2: Palette.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _option(
                    photo: Photos.ooho,
                    caption: 'Capsule din alge',
                    title: 'Notpla',
                    tag: 'Earthshot 2022',
                    points: const <String>[
                      'firmă britanică: ambalaje din alge',
                      'alge = polizaharide, cu legături glicozidice',
                      'ca în amidon și celuloză',
                    ],
                    color: Palette.green,
                  ).enter(0, stepMs: 140),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _option(
                    photo: Photos.mycelium,
                    caption: 'Cutie din miceliu pentru o sticlă',
                    title: 'Miceliu de ciuperci',
                    tag: '~7 zile',
                    points: const <String>[
                      '„crescut” în matriță',
                      'pe resturi de cânepă',
                    ],
                    color: Palette.gold,
                  ).enter(1, stepMs: 140),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _option(
                    photo: Photos.plaCups,
                    caption: 'Pahare din PLA',
                    title: 'PLA și PHA',
                    tag: 'poliesteri',
                    points: const <String>[
                      'PLA: din acid lactic',
                      'PHA: produs chiar de bacterii',
                      'legături esterice: rupte de apă și enzime',
                    ],
                    color: Palette.cyan,
                  ).enter(2, stepMs: 140),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            flex: 7,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 8, child: _bonds().enter(3)),
                const SizedBox(width: 24),
                Expanded(flex: 12, child: _warning().enter(4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _option({
    required Photo photo,
    required String caption,
    required String title,
    required String tag,
    required List<String> points,
    required Color color,
  }) {
    return GlassCard(
      accent: color,
      glow: true,
      fit: false,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: PhotoCard(photo: photo, caption: caption, accent: color, captionSize: 20)),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(title, style: Txt.strong(color, size: 32)),
                ),
              ),
              const SizedBox(width: 10),
              TagChip(text: tag, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 112,
            child: PointList(points, color: color, size: 23, gap: 4),
          ),
        ],
      ),
    );
  }

  Widget _bonds() {
    return GlassCard(
      accent: Palette.green,
      glow: true,
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 18),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle_outline, color: Palette.green, size: 56),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Apa și enzimele le pot rupe legăturile',
                  style: Txt.body(size: 30, weight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'spre deosebire de catena C–C a polietilenei',
                  style: Txt.body(size: 26, alpha: 0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _warning() {
    return GlassCard(
      accent: Palette.orange,
      glow: true,
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          const IconBadge(icon: Icons.warning_amber_rounded, color: Palette.orange, size: 66),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const PointList(
                  <String>[
                    'PLA:|se degradează complet doar în compost industrial, la ≈ 58 °C',
                    'În apa mării:|niciun semn de degradare nici după 428 de zile',
                    'PHA:|se degradează și în sol, și în mare, dar încet',
                  ],
                  color: Palette.orange,
                  size: 24,
                  gap: 6,
                ),
                const SizedBox(height: 10),
                Text(
                  '„Biodegradabil” nu înseamnă „dispare oriunde”',
                  style: Txt.strong(Palette.orange, size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
