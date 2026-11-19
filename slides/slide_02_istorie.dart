// Slide 2 — Inventat ca să salveze elefanții
// Surse: Science Museum Group (Parkesina, 1862); Albany Institute of History & Art,
// Smithsonian (celuloidul, 1869); American Chemical Society, Science Museum
// (bachelita, 1907–1909); Plastics Technology, New World Encyclopedia (polietilena).

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/auto_fit.dart';
import '../widgets/chem.dart';
import '../widgets/glass_card.dart';
import '../widgets/slide_frame.dart';

const String _kTitle = 'Inventat ca să salveze elefanții';

class _Milestone {
  const _Milestone({
    required this.year,
    required this.name,
    required this.points,
    required this.color,
    this.photo,
    this.caption,
    this.portrait,
  });

  final String year;
  final String name;
  final List<String> points;
  final Color color;
  final Photo? photo;
  final String? caption;
  final Photo? portrait;
}

const List<_Milestone> _kMilestones = <_Milestone>[
  _Milestone(
    year: '1862',
    name: 'Parkesina',
    points: <String>[
      'Alexander Parkes',
      'celuloză tratată cu acid azotic',
      'Expoziția Internațională de la Londra',
    ],
    color: Palette.coral,
    photo: Photos.parkes,
    caption: 'Placa memorială Alexander Parkes',
  ),
  _Milestone(
    year: '1869',
    name: 'Celuloidul',
    points: <String>[
      'brevet: John Wesley Hyatt și fratele său',
      'înlocuitor pentru fildeșul bilelor de biliard',
      'broșura: „un răgaz” pentru elefanți',
      'premiul: probabil neacordat oficial',
    ],
    color: Palette.gold,
    photo: Photos.billiard,
    caption: 'Bile de biliard din celuloid',
    portrait: Photos.hyatt,
  ),
  _Milestone(
    year: '1907–1909',
    name: 'Bachelita',
    points: <String>[
      'Leo Baekeland',
      'din fenol și formaldehidă',
      'cerere de brevet: 1907',
      'brevet: 7 decembrie 1909',
      'primul plastic complet sintetic',
    ],
    color: Palette.orange,
    photo: Photos.bakelitePhone,
    caption: 'Telefon din bachelită',
    portrait: Photos.baekeland,
  ),
  _Milestone(
    year: '1898 și 1933',
    name: 'Polietilena',
    points: <String>[
      'descoperită de două ori, din întâmplare',
      '1898: Hans von Pechmann',
      '1933: Eric Fawcett și Reginald Gibson (ICI)',
      'o urmă de oxigen pornește reacția etenei, la presiune foarte mare',
    ],
    color: Palette.cyan,
  ),
];

class Slide02History extends StatelessWidget {
  const Slide02History({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      chapterNo: '02',
      chapter: 'ISTORIE',
      title: _kTitle,
      accent: Palette.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 8),
          // Axa timpului: un punct pentru fiecare reper, deasupra cardului lui.
          SizedBox(
            height: 40,
            child: CustomPaint(
              painter: _TimelinePainter(<Color>[for (final _Milestone m in _kMilestones) m.color]),
            ),
          ).enter(0),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < _kMilestones.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 24),
                  Expanded(child: _card(_kMilestones[i]).enter(1 + i, stepMs: 140)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(_Milestone m) {
    return GlassCard(
      accent: m.color,
      glow: true,
      fit: false,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(m.year, style: Txt.hero(m.color, size: 54)),
          ),
          const SizedBox(height: 12),
          Expanded(child: _visual(m)),
          const SizedBox(height: 14),
          Text(m.name, style: Txt.strong(m.color, size: 34)),
          const SizedBox(height: 8),
          SizedBox(
            height: 236,
            child: AutoFit(child: PointList(m.points, color: m.color, size: 22, gap: 6)),
          ),
        ],
      ),
    );
  }

  Widget _visual(_Milestone m) {
    if (m.photo == null) {
      // Polietilena: catena desenată.
      return Center(child: ChainSketch(color: m.color, atoms: 7, height: 150));
    }
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PhotoCard(photo: m.photo!, caption: m.caption, accent: m.color, captionSize: 20),
        if (m.portrait != null)
          Positioned(
            right: 10,
            top: 10,
            width: 128,
            height: 160,
            child: _Portrait(photo: m.portrait!, color: m.color),
          ),
      ],
    );
  }
}

/// Portret mic, în colțul fotografiei (fără legendă).
class _Portrait extends StatelessWidget {
  const _Portrait({required this.photo, required this.color});

  final Photo photo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color.o(0.8), width: 2),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x99000000), blurRadius: 12)],
      ),
      child: Image.asset(
        photo.path,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (BuildContext c, Object e, StackTrace? s) => const SizedBox.shrink(),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  const _TimelinePainter(this.colors);
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final double y = size.height / 2;
    final int n = colors.length;
    const double gap = 24;
    final double w = (size.width - gap * (n - 1)) / n;
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      Paint()
        ..strokeWidth = 2
        ..shader = LinearGradient(colors: colors).createShader(Offset.zero & size),
    );
    for (int i = 0; i < n; i++) {
      final Offset o = Offset(i * (w + gap) + 34, y);
      canvas.drawCircle(o, 14, Paint()..color = colors[i].o(0.2));
      canvas.drawCircle(o, 7, Paint()..color = colors[i]);
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter old) => old.colors != colors;
}
