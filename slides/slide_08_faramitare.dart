// Slide 8 — Plasticul nu dispare, se fărâmițează
// Surse: Qian și colab., PNAS 2024 (≈ 240 000 particule/L); Napper și colab., One Earth
// 2020 (Everest); Jamieson și colab., R. Soc. Open Sci. 2019 (Groapa Marianelor);
// Marfella și colab., NEJM 2024 (artere); Nihart și colab., Nature Medicine 2025 (creier).

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Plasticul nu dispare, se fărâmițează';

class Slide08Fragments extends StatelessWidget {
  const Slide08Fragments({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '08',
      chapter: 'NATURA',
      title: _kTitle,
      accent: Palette.orange,
      accent2: Palette.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 6, child: _mechanism().enter(0)),
                const SizedBox(width: 24),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(flex: 3, child: _bottled().enter(1)),
                      const SizedBox(height: 20),
                      Expanded(flex: 2, child: _sizes().enter(2)),
                    ],
                  ),
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
                Expanded(
                  child: const PhotoCard(
                    photo: Photos.fragments,
                    caption: 'Fărâme de plastic dintr-un râu',
                    accent: Palette.orange,
                    captionSize: 20,
                  ).enter(3, stepMs: 120),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: const PhotoCard(
                    photo: Photos.everest,
                    caption: 'Everest · 8 440 m',
                    accent: Palette.cyan,
                    captionSize: 20,
                  ).enter(4, stepMs: 120),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: const PhotoCard(
                    photo: Photos.mariana,
                    caption: 'Crustacee din Groapa Marianelor · 10 890 m',
                    accent: Palette.violet,
                    captionSize: 20,
                  ).enter(5, stepMs: 120),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _bodyTile(
                    icon: Icons.favorite_border,
                    title: 'Artere',
                    text: 'în plăcile din arterele gâtului',
                    color: Palette.red,
                  ).enter(6, stepMs: 120),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _bodyTile(
                    icon: Icons.psychology_outlined,
                    title: 'Creier',
                    text: 'potrivit unui studiu contestat',
                    color: Palette.coral,
                  ).enter(7, stepMs: 120),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mechanism() {
    return GlassCard(
      accent: Palette.orange,
      glow: true,
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.wb_sunny_outlined, color: Palette.gold, size: 34),
              const SizedBox(width: 14),
              Text('LUMINA + OXIGENUL', style: Txt.label(Palette.orange, size: 28)),
            ],
          ),
          const SizedBox(height: 20),
          const PointList(
            <String>[
              'Singurul „dușman” natural al PE:|lumina',
              'Radiația UV|rupe o legătură C–H → radical',
              'Radical + oxigenul din aer|→ hidroperoxizi → grupe carbonil C=O',
              'Catenele se rup|→ plastic casant, care se sfărâmă',
              'Nu dispare:|devine micro- și nanoplastic',
            ],
            color: Palette.orange,
            size: 30,
            gap: 16,
          ),
        ],
      ),
    );
  }

  Widget _bottled() {
    return GlassCard(
      accent: Palette.cyan,
      glow: true,
      padding: const EdgeInsets.fromLTRB(30, 18, 30, 18),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('≈ 240 000', style: Txt.hero(Palette.cyan, size: 72)),
          const SizedBox(height: 4),
          Text('particule pe litru în apa îmbuteliată', style: Txt.body(size: 28, weight: FontWeight.w500)),
          const SizedBox(height: 12),
          const PointList(
            <String>[
              '≈ 90% nanoplastice',
              '3 mărci populare: între 110 000 și 370 000 pe litru',
              'Columbia University: echipa lui Wei Min și Beizhan Yan',
            ],
            color: Palette.cyan,
            size: 24,
            gap: 6,
          ),
        ],
      ),
    );
  }

  Widget _sizes() {
    return GlassCard(
      accent: Palette.gold,
      padding: const EdgeInsets.fromLTRB(30, 18, 30, 18),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _size('Microplastic', '< 5 mm', 22),
          const SizedBox(height: 14),
          _size('Nanoplastic', '< 1 µm (micrometru)', 10),
        ],
      ),
    );
  }

  Widget _size(String name, String limit, double dot) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          child: Center(
            child: Container(
              width: dot,
              height: dot,
              decoration: const BoxDecoration(color: Palette.gold, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(width: 14),
        SizedBox(width: 230, child: Text(name, style: Txt.strong(Palette.gold, size: 32))),
        Text(limit, style: Txt.body(size: 32, weight: FontWeight.w600)),
      ],
    );
  }

  Widget _bodyTile({
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    return GlassCard(
      accent: color,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconBadge(icon: icon, color: color, size: 80),
          const SizedBox(height: 14),
          Text(title, style: Txt.strong(color, size: 36)),
          const SizedBox(height: 8),
          Text(text, textAlign: TextAlign.center, style: Txt.body(size: 24)),
        ],
      ),
    );
  }
}
