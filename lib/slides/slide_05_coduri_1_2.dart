// Slide 5 — Codurile 1 și 2: PET și HDPE
// Codurile din triunghi: introduse de SPI în 1988, azi în standardul ASTM D7611.

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/glass_card.dart';
import '../widgets/resin_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Codurile 1 și 2: PET și HDPE';

class Slide05Codes12 extends StatelessWidget {
  const Slide05Codes12({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '05',
      chapter: 'MOLECULA',
      title: _kTitle,
      accent: Palette.cyan,
      accent2: Palette.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 118, child: _banner().enter(0)),
          const SizedBox(height: 22),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: const ResinCard(
                    code: 1,
                    abbr: 'PET',
                    color: Palette.cyan,
                    points: <String>[
                      'singurul din primele șase coduri cu legături esterice în catenă',
                      'de aceea: ținta preferată a reciclării chimice și a enzimelor',
                    ],
                    photo: Photos.petBales,
                    caption: 'Sticle PET presate, gata de reciclare',
                  ).enter(1, stepMs: 160),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: const ResinCard(
                    code: 2,
                    abbr: 'HDPE',
                    color: Palette.green,
                    points: <String>[
                      'polietilenă cu catene aproape fără ramificații',
                      'catenele se așază ordonat, una lângă alta',
                      'apar zone cristaline, densitatea crește',
                      'material rigid, bun pentru flacoane',
                    ],
                    photo: Photos.hdpeMilk,
                    caption: 'Bidoane de lapte din HDPE',
                    photoAlignment: Alignment(0, 0.2),
                  ).enter(2, stepMs: 160),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner() {
    return GlassCard(
      accent: Palette.gold,
      fill: 0.05,
      padding: const EdgeInsets.fromLTRB(26, 14, 26, 14),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          const Icon(Icons.info_outline, color: Palette.gold, size: 40),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    style: Txt.body(size: 30),
                    children: const <InlineSpan>[
                      TextSpan(text: 'Triunghiul cu număr = '),
                      TextSpan(
                        text: 'tipul de polimer',
                        style: TextStyle(color: Palette.gold, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ', nu „reciclabil”'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Introduse în 1988 de asociația americană SPI · azi în standardul ASTM D7611',
                  style: Txt.body(size: 25, alpha: 0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
