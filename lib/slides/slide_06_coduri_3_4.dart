// Slide 6 — Codurile 3 și 4: PVC și LDPE
// PVC: clorul este ≈ 57% din masa unității –CH₂–CHCl–.

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/glass_card.dart';
import '../widgets/resin_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Codurile 3 și 4: PVC și LDPE';

class Slide06Codes34 extends StatelessWidget {
  const Slide06Codes34({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '06',
      chapter: 'MOLECULA',
      title: _kTitle,
      accent: Palette.red,
      accent2: Palette.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: const ResinCard(
                    code: 3,
                    abbr: 'PVC',
                    color: Palette.red,
                    points: <String>[
                      'singurul plastic obișnuit cu clor',
                      'unitatea –CH₂–CHCl–: aproape 57% din masă e clor',
                      'clorul îl face greu inflamabil',
                      'la încălzire eliberează HCl, un gaz acid și coroziv',
                    ],
                    photo: Photos.pvcBlister,
                    caption: 'Blistere pentru pastile',
                  ).enter(0, stepMs: 160),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: const ResinCard(
                    code: 4,
                    abbr: 'LDPE',
                    color: Palette.gold,
                    points: <String>[
                      'exact același monomer ca HDPE: etena',
                      'catene ramificate: nu se pot așeza strâns',
                      'ramificațiile lasă spații între catene',
                      'mai ușor, mai moale și mai transparent',
                    ],
                    photo: Photos.ldpeFilm,
                    caption: 'Folie alimentară',
                  ).enter(1, stepMs: 160),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(height: 92, child: _sameStart().enter(2)),
        ],
      ),
    );
  }

  Widget _sameStart() {
    return GlassCard(
      accent: Palette.gold,
      fill: 0.06,
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          const Icon(Icons.lightbulb_outline, color: Palette.gold, size: 40),
          const SizedBox(width: 18),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: Txt.body(size: 30),
                children: const <InlineSpan>[
                  TextSpan(text: 'Aceeași moleculă de pornire → materiale diferite, '),
                  TextSpan(
                    text: 'doar prin forma catenei',
                    style: TextStyle(color: Palette.gold, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
