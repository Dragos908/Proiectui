// Cardul unui cod de pe ambalaj (slide-urile 5, 6 și 7): insigna cu triunghi,
// abrevierea polimerului, câteva puncte scurte și o fotografie.

import 'package:flutter/material.dart';
import '../theme/photos.dart';
import '../theme/text_styles.dart';
import 'chem.dart';
import 'glass_card.dart';

class ResinCard extends StatelessWidget {
  const ResinCard({
    super.key,
    required this.code,
    required this.abbr,
    required this.color,
    required this.points,
    required this.photo,
    required this.caption,
    this.compact = false,
    this.photoAlignment = Alignment.center,
  });

  final int code;
  final String abbr;
  final Color color;

  /// Textul de pe card, câte un punct pe rând.
  final List<String> points;
  final Photo photo;
  final String caption;

  /// Trei carduri pe slide (în loc de două): totul puțin mai mic.
  final bool compact;
  final Alignment photoAlignment;

  @override
  Widget build(BuildContext context) {
    final double size = compact ? 23 : 27;
    return GlassCard(
      accent: color,
      glow: true,
      fit: false,
      padding: EdgeInsets.fromLTRB(compact ? 24 : 30, 20, compact ? 24 : 30, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              ResinBadge(code: code, abbr: abbr, color: color, size: compact ? 100 : 118),
              SizedBox(width: compact ? 18 : 26),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(abbr, style: Txt.title(size: compact ? 56 : 66).copyWith(color: color)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          PointList(points, color: color, size: size, gap: compact ? 8 : 10),
          const SizedBox(height: 18),
          Expanded(
            child: PhotoCard(
              photo: photo,
              caption: caption,
              accent: color,
              alignment: photoAlignment,
              captionSize: compact ? 20 : 22,
            ),
          ),
        ],
      ),
    );
  }
}
