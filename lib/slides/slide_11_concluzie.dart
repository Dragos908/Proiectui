// Slide 11 — Concluzie: chimia îi poate construi un „punct slab”
// Cele patru idei ale prezentării, fiecare cu imaginea ei, unde au ajuns soluțiile
// și mesajul final.

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Concluzie: chimia îi poate construi un „punct slab”';

class _Idea {
  const _Idea(this.title, this.points, this.color, this.photo, this.caption, {this.contain = false});
  final String title;
  final List<String> points;
  final Color color;
  final Photo photo;
  final String caption;
  final bool contain;
}

const List<_Idea> _kIdeas = <_Idea>[
  _Idea(
    'Se naște',
    <String>['în reactor, la nivel de moleculă', 'ajunge până în sângele nostru'],
    Palette.cyan,
    Photos.pellets,
    'Granule de plastic',
  ),
  _Idea(
    'Nu moare',
    <String>['doar legături C–C și C–H, nepolare', 'apa și enzimele din natură nu le pot rupe'],
    Palette.violet,
    Photos.pe3d,
    'Catene de polietilenă',
    contain: true,
  ),
  _Idea(
    'Nu dispare',
    <String>['lumina și oxigenul doar îl fărâmițează', 'tot mai mic, tot mai greu de văzut'],
    Palette.orange,
    Photos.microplasticHand,
    'Microplastice',
  ),
  _Idea(
    'Chimia răspunde',
    <String>[
      'desface PET-ul în monomeri: enzime sau reciclare chimică',
      'materiale cu legături glicozidice sau esterice, pe care natura le poate rupe',
    ],
    Palette.green,
    Photos.petase,
    'PETaza',
    contain: true,
  ),
];

class Slide11Conclusion extends StatelessWidget {
  const Slide11Conclusion({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '11',
      chapter: 'CONCLUZIE',
      title: _kTitle,
      titleSize: 64,
      accent: Palette.violet,
      accent2: Palette.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < _kIdeas.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 22),
                  Expanded(child: _card(i).enter(i, stepMs: 120)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(height: 236, child: _closing().enter(5)),
        ],
      ),
    );
  }

  Widget _card(int i) {
    final _Idea idea = _kIdeas[i];
    return GlassCard(
      accent: idea.color,
      glow: true,
      fit: false,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: PhotoCard(
              photo: idea.photo,
              caption: idea.caption,
              accent: idea.color,
              fit: idea.contain ? BoxFit.contain : BoxFit.cover,
              background: idea.contain ? const Color(0xFF02060D) : const Color(0xFF0B1627),
              captionSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Text('${i + 1}', style: Txt.hero(idea.color, size: 42)),
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(idea.title, style: Txt.strong(idea.color, size: 32)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 168,
            child: PointList(idea.points, color: idea.color, size: 22, gap: 6),
          ),
        ],
      ),
    );
  }

  Widget _closing() {
    return GlassCard(
      accent: Palette.violet,
      glow: true,
      fill: 0.10,
      padding: const EdgeInsets.fromLTRB(36, 20, 36, 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          const IconBadge(icon: Icons.science_outlined, color: Palette.violet, size: 76),
          const SizedBox(width: 26),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(text: 'Soluții abia la început: ', style: Txt.strong(Palette.violet, size: 30)),
                      TextSpan(
                        text: 'fabricile întârzie, „biodegradabil” ≠ „dispare oriunde”',
                        style: Txt.body(size: 27, weight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ShaderMask(
                  shaderCallback: (Rect b) => const LinearGradient(
                    colors: <Color>[Palette.violet, Palette.green],
                  ).createShader(b),
                  child: Text(
                    'Plasticul nu moare pentru că nu are un punct slab. Chimia îi poate construi unul.',
                    style: Txt.title(size: 40),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('Mulțumesc', style: Txt.strong(Palette.gheata, size: 36)),
              Text('pentru atenție!', style: Txt.body(size: 28, alpha: 0.8)),
              const SizedBox(height: 10),
              const ArrowRight(color: Palette.green, width: 80),
            ],
          ),
        ],
      ),
    );
  }
}
