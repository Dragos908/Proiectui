// Slide 7 — Codurile 5, 6 și 7: PP, PS și „altele”
// Polistirenul expandat: ≈ 2% polistiren, 98% aer (EUMEPS).
// 9% din deșeurile de plastic ale lumii, reciclate cu succes în 2019 (OECD, 22.02.2022).

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/resin_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Codurile 5, 6 și 7: PP, PS și „altele”';

class Slide07Codes57 extends StatelessWidget {
  const Slide07Codes57({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '07',
      chapter: 'MOLECULA',
      title: _kTitle,
      accent: Palette.violet,
      accent2: Palette.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: const ResinCard(
                    compact: true,
                    code: 5,
                    abbr: 'PP',
                    color: Palette.violet,
                    points: <String>[
                      'o grupă metil la fiecare al doilea atom de C',
                      'mai rezistentă la căldură',
                      'caserolele pentru microunde: de obicei codul 5',
                    ],
                    photo: Photos.ppLid,
                    caption: 'Capac din PP',
                  ).enter(0, stepMs: 150),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: const ResinCard(
                    compact: true,
                    code: 6,
                    abbr: 'PS',
                    color: Palette.coral,
                    points: <String>[
                      'polistiren expandat: tăvițele albe',
                      '≈ 2% polistiren și 98% aer',
                    ],
                    photo: Photos.psSem,
                    caption: 'Polistiren expandat la microscop: bule de aer',
                  ).enter(1, stepMs: 150),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: const ResinCard(
                    compact: true,
                    code: 7,
                    abbr: 'ALTELE',
                    color: Palette.orange,
                    points: <String>[
                      'tot ce nu se potrivește la codurile 1–6',
                      'policarbonat, ambalaje multistrat',
                      'bioplastice ca PLA',
                    ],
                    photo: Photos.pcJug,
                    caption: 'Bidon de apă din policarbonat',
                    photoAlignment: Alignment(0, -0.3),
                  ).enter(2, stepMs: 150),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(height: 186, child: _mixed().enter(3)),
        ],
      ),
    );
  }

  Widget _mixed() {
    return GlassCard(
      accent: Palette.red,
      glow: true,
      fill: 0.08,
      padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          const IconBadge(icon: Icons.warning_amber_rounded, color: Palette.red, size: 70),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Amestecate nu se reciclează', style: Txt.strong(Palette.red, size: 32)),
                const SizedBox(height: 8),
                const PointList(
                  <String>[
                    'la topire nu se amestecă, ca uleiul cu apa',
                    'au temperaturi de topire diferite',
                    'puțin PVC într-un lot de PET eliberează HCl și strică tot lotul',
                  ],
                  color: Palette.red,
                  size: 24,
                  gap: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('9%', style: Txt.hero(Palette.gold, size: 72)),
              Text('din deșeurile de plastic ale lumii', style: Txt.body(size: 23, alpha: 0.9)),
              Text('reciclate cu succes în 2019', style: Txt.body(size: 23, alpha: 0.9)),
            ],
          ),
        ],
      ),
    );
  }
}
