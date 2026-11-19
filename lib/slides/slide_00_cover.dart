// Slide 0 — Copertă
// Titlul proiectului, întrebarea și autorul.
// Fotografia: microplastice adunate de pe o plajă din Florida (Key Largo).

import 'package:flutter/material.dart';
import '../theme/palette.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import '../widgets/chem.dart';
import '../widgets/slide_frame.dart';

const String _kKicker = 'PROIECT LA CHIMIE';
const String _kTitle1 = 'De ce plasticul';
const String _kTitle2 = 'nu „moare”?';
const String _kSubtitle =
    'Plasticul la nivel de moleculă: cum se naște, ce i se întâmplă în natură '
    'și cum îl poate desface chimia.';
const String _kByLabel = 'REALIZAT DE';
const String _kAuthor = 'Dragoș Constantinov';
const String _kSchool = 'IPLT Waldorf · 2026';

class Slide00Cover extends StatelessWidget {
  const Slide00Cover({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(110, 90, 96, 90),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Spacer(),
                Text(_kKicker, style: Txt.label(Palette.gold, size: 28)).enter(0),
                const SizedBox(height: 18),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(_kTitle1, style: Txt.title(size: 116)),
                ).enter(1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: ShaderMask(
                    shaderCallback: (Rect b) => const LinearGradient(
                      colors: <Color>[Palette.cyan, Palette.green],
                    ).createShader(b),
                    child: Text(_kTitle2, style: Txt.title(size: 116)),
                  ),
                ).enter(2),
                const SizedBox(height: 28),
                SizedBox(
                  width: 860,
                  child: Text(
                    _kSubtitle,
                    style: Txt.body(size: 32, weight: FontWeight.w300, alpha: 0.9),
                  ),
                ).enter(3),
                const Spacer(),
                Text(_kByLabel, style: Txt.label(Palette.ceata, size: 22)).enter(5),
                const SizedBox(height: 6),
                Text(_kAuthor, style: Txt.strong(Palette.gheata, size: 40)).enter(5),
                const SizedBox(height: 4),
                Text(_kSchool, style: Txt.body(size: 26, alpha: 0.75)).enter(6),
              ],
            ),
          ),
          const SizedBox(width: 56),
          Expanded(
            flex: 8,
            child: const PhotoCard(
              photo: Photos.microplasticHand,
              caption: 'Microplastice adunate de pe o plajă',
              accent: Palette.cyan,
              cut: 36,
            ).enter(3, stepMs: 140),
          ),
        ],
      ),
    );
  }
}
