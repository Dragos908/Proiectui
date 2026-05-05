import 'dart:async';
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firebase_service.dart';
import '../models/prezentare_state.dart';
import '../slides/slide_00.dart';
import '../slides/slide_01.dart';
import '../slides/slide_03.dart';
import '../slides/slide_04.dart';
import '../slides/slide_07.dart';
import '../slides/slide_09.dart';
import '../slides/slide_10.dart';
import '../slides/slide_12.dart';
import '../slides/slide_13.dart';
import '../slides/slide_14.dart';


class PresentationPage extends StatefulWidget {
  const PresentationPage({super.key});

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  final _fb = FirebaseService();
  PrezentareState _state = const PrezentareState();
  bool _showControls = false;
  int _previousIndex = 0;

  StreamSubscription<PrezentareState>? _stateSub;
  final FocusNode _keyboardFocus = FocusNode();

  List<Widget> get _slides => [
    const Slide00Intro(),            // 0  – Titlu / copertă
    const Slide01WhatIsApp(),        // 1  – Ce este o aplicație
    Slide03History(),                // 2  – Istoric
    const Slide04Milestones(),       // 3  – Coduri E (cu butoane interne)
    Slide05TipuriAppWeb(),           // 4  – Aplicații Web
    Slide07DesktopGaming(),          // 5  – Desktop & Gaming
    Slide08BackendSecurity(),        // 6
    Slide12(),                       // 7  – Arhitectura & Baze de Date
    Slide13(),                       // 8  – Securitatea: STRIDE & OWASP
    Slide14Concluzie(),              // 9  – AI & Concluzie
  ];

  int get _safeIndex => _state.slideIndex.clamp(0, _slides.length - 1);

  // Slide-urile care au butoane interactive interne și NU trebuie
  // să fie acoperite de overlay-ul de toggle controls.
  static const _interactiveSlides = {3}; // Slide04Milestones = index 3

  bool get _currentSlideIsInteractive => _interactiveSlides.contains(_safeIndex);

  // ── Web Audio API – sunet plăcut de tip "chime" ──────────────────────────
  void _playFuturisticSound({bool forward = true}) {
    try {
      final script = '''
(function() {
  try {
    var ctx = new (window.AudioContext || window.webkitAudioContext)();
    if (ctx.state === 'suspended') ctx.resume();

    var master = ctx.createGain();
    master.gain.value = 0.18;
    master.connect(ctx.destination);

    var now = ctx.currentTime;
    var fwd = ${forward ? 'true' : 'false'};

    var freqs = fwd ? [523.25, 783.99, 1046.50]
                    : [1046.50, 783.99, 523.25];

    freqs.forEach(function(startF, i) {
      var endF = fwd ? startF * 1.04 : startF * 0.96;
      var delay = i * 0.045;

      var osc  = ctx.createOscillator();
      var env  = ctx.createGain();

      osc.type = 'sine';
      osc.frequency.setValueAtTime(startF, now + delay);
      osc.frequency.linearRampToValueAtTime(endF, now + delay + 0.25);

      env.gain.setValueAtTime(0, now + delay);
      env.gain.linearRampToValueAtTime(1.0, now + delay + 0.02);
      env.gain.setValueAtTime(1.0,  now + delay + 0.02);
      env.gain.exponentialRampToValueAtTime(0.001, now + delay + 0.38);

      osc.connect(env);
      env.connect(master);
      osc.start(now + delay);
      osc.stop(now + delay + 0.40);
    });

    var sub  = ctx.createOscillator();
    var subG = ctx.createGain();
    sub.type = 'sine';
    sub.frequency.value = fwd ? 261.63 : 130.81;
    subG.gain.setValueAtTime(0, now);
    subG.gain.linearRampToValueAtTime(0.55, now + 0.02);
    subG.gain.exponentialRampToValueAtTime(0.001, now + 0.22);
    sub.connect(subG);
    subG.connect(master);
    sub.start(now);
    sub.stop(now + 0.24);
  } catch(e) {}
})();
''';
      js.context.callMethod('eval', [script]);
    } catch (_) {}
  }

  void _goToSlide(int index) {
    final bool goingForward = index > _previousIndex;
    _playFuturisticSound(forward: goingForward);
    _previousIndex = index;
    _fb.setSlide(index);
  }

  @override
  void initState() {
    super.initState();
    html.document.documentElement?.requestFullscreen();
    _stateSub = _fb.stateStream.listen((s) {
      if (mounted) {
        final newIndex = s.slideIndex.clamp(0, _slides.length - 1);
        if (newIndex != _previousIndex) {
          _playFuturisticSound(forward: newIndex > _previousIndex);
          _previousIndex = newIndex;
        }
        setState(() => _state = s);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => _keyboardFocus.requestFocus());
  }

  @override
  void dispose() {
    html.document.exitFullscreen();
    _stateSub?.cancel();
    _keyboardFocus.dispose();
    super.dispose();
  }

  void _toggleControls() => setState(() => _showControls = !_showControls);

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _keyboardFocus,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
              event.logicalKey == LogicalKeyboardKey.space) {
            _goToSlide(_safeIndex + 1);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _goToSlide(_safeIndex > 0 ? _safeIndex - 1 : 0);
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            Navigator.pushReplacementNamed(context, '/');
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF040810),
        body: Stack(
          children: [
            // ── Slide-ul activ ────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: SizedBox.expand(
                key: ValueKey(_safeIndex),
                child: _slides[_safeIndex],
              ),
            ),

            // ── Overlay pentru toggle controls ────────────────────────────
            // Dacă slide-ul curent este interactiv (ex: Slide04 cu butoane),
            // folosim doar o bandă îngustă în partea de sus pentru toggle,
            // lăsând zona centrală liberă pentru butoanele slide-ului.
            // Pentru slide-uri non-interactive, acoperim tot ecranul.
            if (_currentSlideIsInteractive)
            // Bandă de 60px în partea de sus – suficientă pentru toggle
              Positioned(
                top: 0, left: 0, right: 0,
                height: 60,
                child: GestureDetector(
                  onTap: _toggleControls,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              )
            else
            // Slide fără butoane interne – overlay complet
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleControls,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              ),

            // ── Bara de control (sus) ──────────────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !_showControls,
                  child: _buildControlBar(),
                ),
              ),
            ),

            // ── Indicatori de slide (jos) ──────────────────────────────────
            Positioned(
              bottom: 14, left: 0, right: 0,
              child: IgnorePointer(
                child: _buildSlideIndicators(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (i) {
        final active = i == _safeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active
                ? const Color(0xFF00F0FF)
                : const Color(0xFF00F0FF).withOpacity(0.22),
          ),
        );
      }),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.80),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF00F0FF), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00F0FF)),
            tooltip: 'Înapoi la meniu',
          ),
          const SizedBox(width: 8),
          Text(
            '${_safeIndex + 1} / ${_slides.length}',
            style: const TextStyle(
              color: Color(0xFF00F0FF),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () =>
                _goToSlide(_safeIndex > 0 ? _safeIndex - 1 : 0),
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            iconSize: 32,
          ),
          IconButton(
            onPressed: () => _goToSlide(_safeIndex + 1),
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            iconSize: 32,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _state.actiune.isNotEmpty
                  ? const Color(0xFF00FF88).withOpacity(0.12)
                  : Colors.grey.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _state.actiune.isNotEmpty
                    ? const Color(0xFF00FF88).withOpacity(0.4)
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.phone_android,
                  color: _state.actiune.isNotEmpty
                      ? const Color(0xFF00FF88)
                      : Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  _state.actiune.isNotEmpty
                      ? 'Android: ${_state.actiune}'
                      : 'Android: aștept...',
                  style: TextStyle(
                    color: _state.actiune.isNotEmpty
                        ? const Color(0xFF00FF88)
                        : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}