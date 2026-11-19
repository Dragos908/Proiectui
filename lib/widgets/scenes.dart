import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/fx.dart';
import '../theme/light.dart';
import '../theme/palette.dart';

/// Fundalul de bază, comun tuturor slide-urilor: albastru-negru, o matrice fină
/// de puncte și vignetă. Static: se desenează o singură dată.
class BaseBackdrop extends StatelessWidget {
  const BaseBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(painter: _BasePainter(), size: Size.infinite),
    );
  }
}

class _BasePainter extends CustomPainter {
  const _BasePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Rect r = Offset.zero & size;
    canvas.drawRect(
      r,
      Paint()
        ..shader = ui.Gradient.linear(
          r.topCenter,
          r.bottomCenter,
          const <Color>[Palette.abis, Color(0xFF071022)],
        ),
    );
    const double pitch = 48;
    final List<double> pts = <double>[];
    for (double y = pitch / 2; y < size.height; y += pitch) {
      for (double x = pitch / 2; x < size.width; x += pitch) {
        pts
          ..add(x)
          ..add(y);
      }
    }
    canvas.drawRawPoints(
      ui.PointMode.points,
      Float32List.fromList(pts),
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = Palette.ceata.o(0.05),
    );
    canvas.drawRect(
      r,
      Paint()
        ..shader = ui.Gradient.radial(
          r.center,
          size.longestSide * 0.78,
          <Color>[Palette.abis.o(0), Palette.abis.o(0.62)],
          const <double>[0.55, 1.0],
        ),
    );
  }

  @override
  bool shouldRepaint(_BasePainter old) => false;
}

/// Numerele scenelor (câte una pe temă). Slide-urile le aleg în `slide_deck.dart`.
class Scene {
  Scene._();
  static const int chains = 0; // catene care plutesc (coperta)
  static const int blood = 1; // globule roșii și fărâme de plastic
  static const int spheres = 2; // sfere lucioase (bile de biliard, istorie)
  static const int assembly = 3; // monomeri care se leagă într-o catenă
  static const int repel = 4; // apa ricoșează din catena de polietilenă
  static const int triangles = 5; // triunghiurile codurilor
  static const int shatter = 6; // bucăți care se fărâmițează
  static const int cut = 7; // catena se desface la legăturile esterice
  static const int organic = 8; // fire de alge / miceliu
  static const int weakPoint = 9; // catena cu un „punct slab” care pulsează
  static const int calm = 10; // doar lumina (surse)
  static const int count = 11;
}

/// Scena animată din fundalul unui slide, legată de tema lui. Toate scenele sunt
/// conduse de același controller [ambient] (buclă de 56 s, deci nimic mai rapid de
/// 14 s), nu folosesc blur sau saveLayer, iar banda titlului e atenuată.
class SceneBackdrop extends StatelessWidget {
  const SceneBackdrop({
    super.key,
    required this.scene,
    required this.light,
    required this.ambient,
  });

  final int scene;
  final SlideLight light;
  final Animation<double> ambient;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ScenePainter(scene, light, ambient),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene, this.light, this.ambient) : super(repaint: ambient);

  final int scene;
  final SlideLight light;
  final Animation<double> ambient;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final _Pal pal = _Pal(light, Fx.sceneGain * light.intensity);
    final double t = ambient.value;
    _glow(canvas, size, pal, t);
    _scenes[scene.clamp(0, _scenes.length - 1).toInt()](canvas, size, t, pal);
    _calm(canvas, size);
  }

  @override
  bool shouldRepaint(_ScenePainter old) =>
      old.scene != scene || !identical(old.light, light) || old.ambient != ambient;
}

/// Culorile scenei (din `SlideLight`) și câștigul global.
class _Pal {
  _Pal(SlideLight l, this.g)
      : a = l.colors.isNotEmpty ? l.colors[0] : Palette.cyan,
        b = l.colors.length > 1
            ? l.colors[1]
            : (l.colors.isNotEmpty ? l.colors[0] : Palette.cyan),
        x = l.x;

  final Color a;
  final Color b;
  final double g;
  final double x; // 0..1, de unde urcă lumina
}

typedef _SceneFn = void Function(Canvas c, Size s, double t, _Pal p);

final List<_SceneFn> _scenes = <_SceneFn>[
  _chainsScene,
  _bloodScene,
  _spheresScene,
  _assemblyScene,
  _repelScene,
  _trianglesScene,
  _shatterScene,
  _cutScene,
  _organicScene,
  _weakPointScene,
  _calmScene,
];

double _fr(double x) => x - x.floorToDouble();

double _sm(double x) {
  final double v = x.clamp(0.0, 1.0).toDouble();
  return v * v * (3 - 2 * v);
}

double _k(Size s) => s.width / 1920;

/// Lumina difuză care urcă de jos (cel mult 13%).
void _glow(Canvas c, Size s, _Pal p, double t) {
  final double k = _k(s);
  c.save();
  c.translate(p.x * s.width + 40 * k * math.sin(2 * math.pi * t), s.height + 60);
  c.scale(1.0, 1.1);
  c.drawCircle(
    Offset.zero,
    900 * k,
    Paint()
      ..shader = ui.Gradient.radial(
        Offset.zero,
        900 * k,
        <Color>[p.a.o(0.13 * p.g), p.a.o(0.05 * p.g), p.a.o(0)],
        const <double>[0, 0.45, 1],
      ),
  );
  c.restore();
}

/// Atenuează banda titlului, ca scena să nu se bată cu textul mare.
void _calm(Canvas c, Size s) {
  c.drawRect(
    Rect.fromLTWH(0, 0, s.width, 200 * _k(s)),
    Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(0, 200 * _k(s)),
        <Color>[Palette.abis.o(0.72), Palette.abis.o(0)],
      ),
  );
}

/// Desenează o catenă „bilă-și-băț” în zigzag: [n] atomi de la [start], pe direcția
/// [angle]. [gapAt]/[gap] deschid o ruptură după atomul [gapAt].
void _chain(
  Canvas c,
  Offset start,
  double angle,
  int n,
  double step,
  Color col,
  double alpha, {
  double r = 6,
  int gapAt = -1,
  double gap = 0,
  int litAt = -1,
  double lit = 0,
}) {
  final Offset dir = Offset(math.cos(angle), math.sin(angle));
  final Offset nrm = Offset(-dir.dy, dir.dx);
  final List<Offset> pts = <Offset>[];
  double shift = 0;
  for (int i = 0; i < n; i++) {
    if (i == gapAt + 1 && gapAt >= 0) shift = gap;
    pts.add(start + dir * (i * step * 0.87 + shift) + nrm * ((i.isEven ? -1 : 1) * step * 0.25));
  }
  final Paint bond = Paint()
    ..strokeWidth = 2.2
    ..strokeCap = StrokeCap.round
    ..color = col.o(alpha * 0.55);
  for (int i = 0; i < n - 1; i++) {
    if (i == gapAt) continue;
    if (i == litAt && lit > 0) {
      c.drawLine(
        pts[i],
        pts[i + 1],
        Paint()
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..color = Palette.gheata.o(alpha * lit),
      );
    }
    c.drawLine(pts[i], pts[i + 1], bond);
  }
  final Paint atom = Paint()..color = col.o(alpha);
  final Paint hl = Paint()..color = Palette.gheata.o(alpha * 0.35);
  for (final Offset o in pts) {
    c.drawCircle(o, r, atom);
    c.drawCircle(o + Offset(-r * 0.3, -r * 0.3), r * 0.32, hl);
  }
}

// ── 0 Catene care plutesc încet (coperta) ───────────────────────────────────
void _chainsScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final math.Random rng = math.Random(3);
  for (int i = 0; i < 7; i++) {
    final double y0 = rng.nextDouble();
    final double ang = (rng.nextDouble() - 0.5) * 0.5;
    final int n = 10 + rng.nextInt(8);
    final int laps = 1 + rng.nextInt(2);
    final double step = (34 + rng.nextDouble() * 18) * k;
    final double len = n * step;
    final double x = _fr(rng.nextDouble() + t * laps) * (s.width + len * 2) - len;
    final double y = (120 + y0 * (s.height - 240)) + 24 * k * math.sin(2 * math.pi * (t * 2 + y0));
    final Color col = i.isEven ? p.a : p.b;
    final double pulse = 0.5 + 0.5 * math.sin(2 * math.pi * (t * 3 + i * 0.37));
    _chain(c, Offset(x, y), ang, n, step, col, 0.18 * p.g,
        r: (4.5 + rng.nextDouble() * 2.5) * k, litAt: n ~/ 2, lit: pulse * 0.9);
  }
}

// ── 1 Sânge: globule roșii care curg + fărâme de plastic colorate ───────────
void _bloodScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final math.Random rng = math.Random(17);
  for (int i = 0; i < 22; i++) {
    final double y0 = rng.nextDouble();
    final int laps = 1 + rng.nextInt(2);
    final double w = (38 + rng.nextDouble() * 30) * k;
    final double x = _fr(rng.nextDouble() + t * laps) * (s.width + 200 * k) - 100 * k;
    final double y = 140 * k + y0 * (s.height - 240 * k) + 30 * k * math.sin(2 * math.pi * (t * 2 + y0 * 3));
    final double rot = 2 * math.pi * (t * (i.isEven ? 1 : -1) + y0);
    c.save();
    c.translate(x, y);
    c.rotate(rot * 0.25);
    final Rect r = Rect.fromCenter(center: Offset.zero, width: w, height: w * 0.72);
    c.drawOval(r, Paint()..color = p.a.o(0.13 * p.g));
    c.drawOval(r.deflate(w * 0.18), Paint()..color = p.a.o(0.07 * p.g));
    c.restore();
  }
  // Fărâme de plastic: poligoane mici, colțuroase.
  const List<Color> frag = <Color>[Palette.cyan, Palette.gold, Palette.green, Palette.violet];
  for (int i = 0; i < 26; i++) {
    final double y0 = rng.nextDouble();
    final int laps = 1 + rng.nextInt(3);
    final double sz = (5 + rng.nextDouble() * 8) * k;
    final double x = _fr(rng.nextDouble() + t * laps) * s.width;
    final double y = 140 * k + y0 * (s.height - 240 * k);
    c.save();
    c.translate(x, y);
    c.rotate(2 * math.pi * (t * laps + y0));
    final Path tri = Path()
      ..moveTo(0, -sz)
      ..lineTo(sz * 0.9, sz * 0.4)
      ..lineTo(-sz * 0.5, sz * 0.8)
      ..close();
    c.drawPath(tri, Paint()..color = frag[i % frag.length].o(0.30 * p.g));
    c.restore();
  }
}

// ── 2 Sfere lucioase care plutesc (bilele de biliard din celuloid) ──────────
void _spheresScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final math.Random rng = math.Random(9);
  for (int i = 0; i < 12; i++) {
    final double x0 = rng.nextDouble();
    final double y0 = rng.nextDouble();
    final double r = (26 + rng.nextDouble() * 40) * k;
    final double ph = rng.nextDouble();
    final Offset o = Offset(
      x0 * s.width + 60 * k * math.sin(2 * math.pi * (t + ph)),
      180 * k + y0 * (s.height - 300 * k) + 40 * k * math.cos(2 * math.pi * (t * 2 + ph)),
    );
    final Color col = i.isEven ? p.a : p.b;
    c.drawCircle(
      o,
      r,
      Paint()
        ..shader = ui.Gradient.radial(
          o + Offset(-r * 0.35, -r * 0.35),
          r * 1.3,
          <Color>[Palette.gheata.o(0.16 * p.g), col.o(0.12 * p.g), col.o(0.02 * p.g)],
          const <double>[0, 0.35, 1],
        ),
    );
    c.drawCircle(
      o,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = col.o(0.18 * p.g),
    );
  }
}

// ── 3 Nașterea: monomerii vin și se leagă într-o catenă ─────────────────────
void _assemblyScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final math.Random rng = math.Random(5);
  const int n = 22;
  final double step = 70 * k;
  final double y = s.height - 170 * k;
  final double x0 = (s.width - n * step * 0.87) / 2;
  for (int i = 0; i < n; i++) {
    final double lx = x0 + i * step * 0.87;
    final double ly = y + (i.isEven ? -1 : 1) * step * 0.25;
    final double sx = rng.nextDouble() * s.width;
    final double sy = 200 * k + rng.nextDouble() * (s.height * 0.45);
    final double ph = _fr(t * 2 + i / n);
    final double go = _sm(ph / 0.5);
    final double env = _sm(ph / 0.08) * (1 - _sm((ph - 0.86) / 0.14));
    final Offset pos = Offset(sx + (lx - sx) * go, sy + (ly - sy) * go);
    final Color col = Color.lerp(p.a, p.b, go)!;
    // Monomerul: două bile legate printr-o legătură dublă, care se „deschide” la sosire.
    final Offset half = Offset(10 * k, 0);
    final Paint bond = Paint()
      ..strokeWidth = 2
      ..color = col.o(0.35 * env * p.g);
    c.drawLine(pos - half, pos + half, bond);
    if (go < 0.95) {
      c.drawLine(pos - half + Offset(0, 5 * k), pos + half + Offset(0, 5 * k), bond);
    }
    c.drawCircle(pos - half, 5 * k, Paint()..color = col.o(0.45 * env * p.g));
    c.drawCircle(pos + half, 5 * k, Paint()..color = col.o(0.45 * env * p.g));
  }
  // Șina catenei, foarte stinsă.
  for (int i = 0; i < n - 1; i++) {
    final Offset a = Offset(x0 + i * step * 0.87, y + (i.isEven ? -1 : 1) * step * 0.25);
    final Offset b = Offset(x0 + (i + 1) * step * 0.87, y + (i.isOdd ? -1 : 1) * step * 0.25);
    c.drawLine(a, b, Paint()..strokeWidth = 1.2..color = p.b.o(0.10 * p.g));
  }
}

/// Moleculă de apă în formă de V, centrată în [o].
void _water(Canvas c, Offset o, double k, double rot, Color col, double a) {
  c.save();
  c.translate(o.dx, o.dy);
  c.rotate(rot);
  final Offset h1 = Offset(-11 * k, 9 * k);
  final Offset h2 = Offset(11 * k, 9 * k);
  final Paint bond = Paint()
    ..strokeWidth = 2
    ..color = col.o(a * 0.6);
  c.drawLine(Offset.zero, h1, bond);
  c.drawLine(Offset.zero, h2, bond);
  c.drawCircle(Offset.zero, 7 * k, Paint()..color = col.o(a));
  c.drawCircle(h1, 4 * k, Paint()..color = Palette.gheata.o(a * 0.8));
  c.drawCircle(h2, 4 * k, Paint()..color = Palette.gheata.o(a * 0.8));
  c.restore();
}

// ── 4 Nu moare: picăturile de apă ricoșează din catena nepolară ─────────────
void _repelScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final double y = s.height - 150 * k;
  final double step = 60 * k;
  final int n = (s.width / (step * 0.87)).ceil() + 2;
  final double drift = _fr(t * 2) * step * 0.87 * 2;
  _chain(c, Offset(-step * 2 + drift, y), 0, n, step, p.a, 0.16 * p.g, r: 7 * k);
  final math.Random rng = math.Random(21);
  for (int i = 0; i < 14; i++) {
    final double x = (0.04 + 0.92 * rng.nextDouble()) * s.width;
    final double ph = _fr(t * 3 + rng.nextDouble());
    // cade, atinge catena la ph = 0,5 și urcă înapoi, deviat
    final double fall = ph < 0.5 ? _sm(ph / 0.5) : 1 - _sm((ph - 0.5) / 0.5) * 0.8;
    final double side = ph < 0.5 ? 0 : (_sm((ph - 0.5) / 0.5) * 90 * k * (i.isEven ? 1 : -1));
    final double top = 220 * k + rng.nextDouble() * 160 * k;
    final Offset o = Offset(x + side, top + (y - 40 * k - top) * fall);
    final double env = math.sin(math.pi * ph);
    _water(c, o, k, 2 * math.pi * ph * (i.isEven ? 1 : -1), p.b, 0.32 * env * p.g);
  }
}

/// Triunghi echilateral (contur), centrat, cu latura [a].
Path _triangle(double a) {
  final double h = a * math.sqrt(3) / 2;
  return Path()
    ..moveTo(0, -h * 2 / 3)
    ..lineTo(a / 2, h / 3)
    ..lineTo(-a / 2, h / 3)
    ..close();
}

// ── 5 Coduri: triunghiuri care urcă încet și se rotesc ──────────────────────
void _trianglesScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final math.Random rng = math.Random(13);
  for (int i = 0; i < 16; i++) {
    final double x0 = rng.nextDouble();
    final int laps = 1 + rng.nextInt(2);
    final double a = (40 + rng.nextDouble() * 70) * k;
    final double y = _fr(rng.nextDouble() - t * laps);
    final double env = math.sin(math.pi * y);
    c.save();
    c.translate(x0 * s.width, y * (s.height + 200 * k) - 100 * k);
    c.rotate(2 * math.pi * (t * (i.isEven ? 1 : -1) + x0));
    c.drawPath(
      _triangle(a),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.round
        ..color = (i.isEven ? p.a : p.b).o(0.22 * env * p.g),
    );
    c.restore();
  }
}

// ── 6 Fărâmițare: bucăți care cad și se sparg în bucăți tot mai mici ────────
void _shatterScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final math.Random rng = math.Random(29);
  for (int i = 0; i < 9; i++) {
    final double x0 = 0.05 + rng.nextDouble() * 0.9;
    final double ph = _fr(t * 2 + rng.nextDouble());
    final double y = 160 * k + ph * (s.height - 200 * k);
    final double env = _sm(ph / 0.1) * (1 - _sm((ph - 0.85) / 0.15));
    // generația: 1 bucată → 3 → 9, pe măsură ce coboară
    final int gen = ph < 0.33 ? 0 : (ph < 0.66 ? 1 : 2);
    final int pieces = gen == 0 ? 1 : (gen == 1 ? 3 : 9);
    final double sz = (gen == 0 ? 34 : (gen == 1 ? 16 : 7)) * k;
    final double spread = (gen == 0 ? 0 : (gen == 1 ? 40 : 80)) * k * _sm(ph * 3 - gen);
    final Color col = i.isEven ? p.a : p.b;
    for (int j = 0; j < pieces; j++) {
      final double ang = 2 * math.pi * j / pieces + i;
      final Offset o = Offset(x0 * s.width + math.cos(ang) * spread, y + math.sin(ang) * spread * 0.5);
      c.save();
      c.translate(o.dx, o.dy);
      c.rotate(2 * math.pi * ph + j);
      final Path shard = Path()
        ..moveTo(0, -sz)
        ..lineTo(sz * 0.8, -sz * 0.1)
        ..lineTo(sz * 0.35, sz * 0.9)
        ..lineTo(-sz * 0.7, sz * 0.4)
        ..close();
      c.drawPath(shard, Paint()..color = col.o(0.20 * env * p.g));
      c.drawPath(
        shard,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = col.o(0.35 * env * p.g),
      );
      c.restore();
    }
  }
}

// ── 7 Enzimele: catena se desface la legăturile esterice ────────────────────
void _cutScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final math.Random rng = math.Random(31);
  for (int row = 0; row < 3; row++) {
    final double y = 260 * k + row * 280 * k + rng.nextDouble() * 60 * k;
    final double step = 46 * k;
    final double ph = _fr(t * 2 + row / 3);
    final double open = _sm((ph - 0.3) / 0.3) * (1 - _sm((ph - 0.85) / 0.15));
    const int seg = 4; // o „unitate” de 4 atomi, apoi o legătură esterică
    final int units = (s.width / (seg * step * 0.87 + 40 * k)).ceil() + 1;
    final double drift = _fr(t * (row.isEven ? 1 : -1)) * (seg * step * 0.87 + 40 * k);
    for (int u = -1; u < units; u++) {
      final double x = u * (seg * step * 0.87 + 30 * k + 60 * k * open) + drift;
      _chain(c, Offset(x, y), 0, seg, step, row.isEven ? p.a : p.b, 0.17 * p.g, r: 5.5 * k);
      // legătura esterică dintre unități: se rupe și strălucește scurt
      final Offset a = Offset(x + (seg - 1) * step * 0.87, y + step * 0.25);
      final Offset b = Offset(x + seg * step * 0.87 + 30 * k + 60 * k * open - step * 0.87 * 0, y - step * 0.25);
      if (open < 0.5) {
        c.drawLine(a, b, Paint()..strokeWidth = 2..color = p.b.o(0.12 * p.g));
      } else {
        c.drawCircle(Offset.lerp(a, b, 0.5)!, 9 * k, Paint()..color = Palette.gheata.o(0.10 * p.g * (1 - open) * 2));
      }
    }
  }
}

// ── 8 Natura: fire ondulate (alge, miceliu) care cresc și se ramifică ───────
void _organicScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final math.Random rng = math.Random(41);
  for (int i = 0; i < 11; i++) {
    final double x0 = rng.nextDouble() * s.width;
    final double amp = (20 + rng.nextDouble() * 40) * k;
    final double len = (300 + rng.nextDouble() * 420) * k;
    final double ph = rng.nextDouble();
    final double grow = 0.55 + 0.45 * math.sin(2 * math.pi * (t + ph));
    final Path path = Path()..moveTo(x0, s.height + 10);
    const int segs = 40;
    for (int j = 1; j <= segs; j++) {
      final double f = j / segs;
      final double y = s.height + 10 - len * f * grow;
      final double x = x0 + amp * math.sin(2 * math.pi * (f * 2 + t * 2 + ph)) * f;
      path.lineTo(x, y);
    }
    c.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..color = (i.isEven ? p.a : p.b).o(0.16 * p.g),
    );
    // ramificații scurte
    for (int b = 1; b <= 3; b++) {
      final double f = b / 4;
      final double y = s.height + 10 - len * f * grow;
      final double x = x0 + amp * math.sin(2 * math.pi * (f * 2 + t * 2 + ph)) * f;
      final double dirx = (b.isEven ? 1 : -1) * 50 * k * grow;
      c.drawLine(
        Offset(x, y),
        Offset(x + dirx, y - 40 * k * grow),
        Paint()
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round
          ..color = (i.isEven ? p.a : p.b).o(0.12 * p.g),
      );
      c.drawCircle(Offset(x + dirx, y - 40 * k * grow), 4 * k, Paint()..color = p.b.o(0.18 * p.g));
    }
  }
}

// ── 9 Concluzie: o catenă lungă cu „punctul slab” care pulsează ─────────────
void _weakPointScene(Canvas c, Size s, double t, _Pal p) {
  final double k = _k(s);
  final double step = 64 * k;
  final int n = (s.width / (step * 0.87)).ceil() + 3;
  final double drift = _fr(t) * step * 0.87 * 2;
  final double pulse = 0.5 + 0.5 * math.sin(2 * math.pi * t * 4);
  _chain(c, Offset(-step * 2 + drift, s.height * 0.55), 0, n, step, p.a, 0.13 * p.g,
      r: 7 * k, litAt: n ~/ 2, lit: 0.6 + 0.4 * pulse);
  _chain(c, Offset(-step * 3 - drift, s.height * 0.82), 0, n, step, p.b, 0.10 * p.g,
      r: 6 * k, gapAt: n ~/ 2 + 2, gap: 28 * k * pulse);
}

// ── 10 Calm: doar lumina (pentru slide-ul cu surse) ─────────────────────────
void _calmScene(Canvas c, Size s, double t, _Pal p) {}
