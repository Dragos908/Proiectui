// Slide 1 — Plastic în sângele nostru
// Vrije Universiteit Amsterdam, 2022: plastic în sângele a 17 din 22 de voluntari
// (77%); PET 50%, polistiren 36%, polietilenă 23% dintre donatori.

import 'package:flutter/material.dart';
import '../theme/fx.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Plastic în sângele nostru';

class _Polymer {
  const _Polymer(this.name, this.percent, this.color);
  final String name;
  final int percent; // % dintre donatori
  final Color color;
}

const List<_Polymer> _kPolymers = <_Polymer>[
  _Polymer('PET', 50, Palette.cyan),
  _Polymer('Polistiren', 36, Palette.coral),
  _Polymer('Polietilenă', 23, Palette.gold),
];

class Slide01Blood extends StatelessWidget {
  const Slide01Blood({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '01',
      chapter: 'INTRODUCERE',
      title: _kTitle,
      accent: Palette.red,
      accent2: Palette.gold,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(flex: 6, child: _study().enter(0)),
                      const SizedBox(width: 24),
                      Expanded(flex: 5, child: _caveat().enter(1)),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Expanded(child: _polymers().enter(2)),
                const SizedBox(height: 22),
                SizedBox(height: 200, child: _question().enter(3)),
              ],
            ),
          ),
          const SizedBox(width: 28),
          Expanded(
            flex: 4,
            child: const PhotoCard(
              photo: Photos.blood,
              caption: 'Analiza unei probe de sânge',
              accent: Palette.red,
            ).enter(2, stepMs: 140),
          ),
        ],
      ),
    );
  }

  Widget _study() {
    return GlassCard(
      accent: Palette.red,
      glow: true,
      padding: const EdgeInsets.fromLTRB(30, 22, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('VRIJE UNIVERSITEIT AMSTERDAM, 2022', style: Txt.label(Palette.red, size: 22)),
          const SizedBox(height: 6),
          Text('17 din 22', style: Txt.hero(Palette.red, size: 76)),
          const SizedBox(height: 8),
          Text(
            'voluntari sănătoși cu plastic în sânge (77%)',
            style: Txt.body(size: 27, weight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          const PointList(
            <String>['cantitate măsurabilă de particule de plastic'],
            color: Palette.red,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _caveat() {
    return GlassCard(
      accent: Palette.gold,
      glow: true,
      padding: const EdgeInsets.fromLTRB(30, 22, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('ATENȚIE', style: Txt.label(Palette.gold, size: 22)),
          const SizedBox(height: 6),
          Text('Studiu mic', style: Txt.hero(Palette.gold, size: 60)),
          const SizedBox(height: 16),
          const PointList(
            <String>[
              'arată doar că plasticul poate ajunge în sânge',
              'nu arată cât de periculos este acolo',
            ],
            color: Palette.gold,
            size: 25,
          ),
        ],
      ),
    );
  }

  Widget _polymers() {
    return GlassCard(
      accent: Palette.cyan,
      fit: false,
      padding: const EdgeInsets.fromLTRB(32, 22, 32, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('CEL MAI DES', style: Txt.label(Palette.cyan, size: 24)),
              const Spacer(),
              Text('% din donatori', style: Txt.body(size: 22, alpha: 0.65)),
            ],
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < _kPolymers.length; i++)
            Expanded(child: _Bar(polymer: _kPolymers[i], delayMs: 500 + i * 180)),
        ],
      ),
    );
  }

  Widget _question() {
    return GlassCard(
      accent: Palette.gold,
      glow: true,
      fill: 0.10,
      padding: const EdgeInsets.fromLTRB(34, 22, 34, 22),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('ÎNTREBAREA', style: Txt.label(Palette.gold, size: 22)),
          const SizedBox(height: 4),
          Text('De ce plasticul nu „moare”?', style: Txt.title(size: 56)),
          const SizedBox(height: 8),
          Text(
            '… ci doar se fărâmițează până ajunge în noi',
            style: Txt.body(size: 30, weight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

/// O bară orizontală care „crește” la intrarea pe slide.
class _Bar extends StatelessWidget {
  const _Bar({required this.polymer, required this.delayMs});

  final _Polymer polymer;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    final bool reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 210,
          child: Text(polymer.name, style: Txt.strong(polymer.color, size: 30)),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints c) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: reduced ? 1 : 0, end: 1),
                duration: Duration(milliseconds: reduced ? 0 : 900 + delayMs),
                curve: Interval(reduced ? 0 : delayMs / (900 + delayMs), 1, curve: Fx.out),
                builder: (BuildContext context, double t, Widget? _) {
                  final double w = c.maxWidth * 0.82 * polymer.percent / 50 * t;
                  return Row(
                    children: <Widget>[
                      Container(
                        width: w,
                        height: 34,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[polymer.color.o(0.35), polymer.color.o(0.9)],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '${(polymer.percent * t).round()}%',
                        style: Txt.mono(Palette.gheata, size: 30, weight: FontWeight.w700),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
