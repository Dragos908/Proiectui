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

  // ── Web Audio API – sunet cristal cu reverb, stabil și plăcut ────────────
  // AudioContext-ul este refolosit (singleton în window) pentru stabilitate.
  void _playFuturisticSound({bool forward = true}) {
    try {
      final script = '''
(function() {
  try {
    // ── Singleton AudioContext – evită crearea repetată și click-urile audio ──
    if (!window._slideAudioCtx || window._slideAudioCtx.state === 'closed') {
      window._slideAudioCtx = new (window.AudioContext || window.webkitAudioContext)();
    }
    var ctx = window._slideAudioCtx;
    if (ctx.state === 'suspended') ctx.resume();

    var now = ctx.currentTime;
    var fwd = ${forward ? 'true' : 'false'};

    // ── Reverb simplu prin ConvolverNode cu IR sintetic ───────────────────
    function makeReverb(ctx, duration, decay) {
      var rate = ctx.sampleRate;
      var length = rate * duration;
      var impulse = ctx.createBuffer(2, length, rate);
      for (var c = 0; c < 2; c++) {
        var ch = impulse.getChannelData(c);
        for (var i = 0; i < length; i++) {
          ch[i] = (Math.random() * 2 - 1) * Math.pow(1 - i / length, decay);
        }
      }
      var conv = ctx.createConvolver();
      conv.buffer = impulse;
      return conv;
    }

    // ── Graf audio: osc → env → filter → dry/wet mix → master ───────────
    var master = ctx.createGain();
    master.gain.value = 0.22;
    master.connect(ctx.destination);

    var reverb = makeReverb(ctx, 1.4, 3.5);
    var reverbGain = ctx.createGain();
    reverbGain.gain.value = 0.38;          // wet
    reverb.connect(reverbGain);
    reverbGain.connect(master);

    var dryGain = ctx.createGain();
    dryGain.gain.value = 0.62;             // dry
    dryGain.connect(master);

    // ── Acorduri pentatonice plăcute ──────────────────────────────────────
    // Forward:  Do5 – Mi5 – Sol5 – Do6  (major chord ascendent)
    // Backward: Do6 – Sol5 – Mi5 – Do5  (acord descendent, mai moale)
    var notes = fwd
      ? [523.25, 659.25, 783.99, 1046.50]
      : [1046.50, 783.99, 622.25, 493.88];

    var stagger = fwd ? 0.055 : 0.065;    // întârziere între note

    notes.forEach(function(freq, i) {
      var t0 = now + i * stagger;

      // Oscilator principal (sine pur – cristal)
      var osc = ctx.createOscillator();
      osc.type = 'sine';
      osc.frequency.value = freq;

      // Armonicul 2 (triangle, mai moale decât sawtooth)
      var osc2 = ctx.createOscillator();
      osc2.type = 'triangle';
      osc2.frequency.value = freq * 2.001; // ușor detunat → cordy

      // Envelope cu atac rapid și decay natural
      var env = ctx.createGain();
      env.gain.setValueAtTime(0, t0);
      env.gain.linearRampToValueAtTime(0.9, t0 + 0.018);
      env.gain.setValueAtTime(0.9, t0 + 0.018);
      env.gain.exponentialRampToValueAtTime(0.001, t0 + 0.55 + i * 0.04);

      // Osc2 mai liniștit
      var env2 = ctx.createGain();
      env2.gain.setValueAtTime(0, t0);
      env2.gain.linearRampToValueAtTime(0.22, t0 + 0.018);
      env2.gain.exponentialRampToValueAtTime(0.001, t0 + 0.45);

      // Low-pass filter – rotunjește tonul
      var filt = ctx.createBiquadFilter();
      filt.type = 'lowpass';
      filt.frequency.setValueAtTime(fwd ? 3200 : 2400, t0);
      filt.frequency.exponentialRampToValueAtTime(800, t0 + 0.5);
      filt.Q.value = 0.8;

      osc.connect(env);
      osc2.connect(env2);
      env.connect(filt);
      env2.connect(filt);
      filt.connect(dryGain);
      filt.connect(reverb);

      osc.start(t0);
      osc2.start(t0);
      osc.stop(t0 + 0.65);
      osc2.stop(t0 + 0.55);
    });

    // ── Sub-bass scurt – dă greutate tranzitiei ───────────────────────────
    var sub = ctx.createOscillator();
    var subEnv = ctx.createGain();
    sub.type = 'sine';
    sub.frequency.value = fwd ? 130.81 : 98.00;
    subEnv.gain.setValueAtTime(0, now);
    subEnv.gain.linearRampToValueAtTime(0.45, now + 0.015);
    subEnv.gain.exponentialRampToValueAtTime(0.001, now + 0.18);
    sub.connect(subEnv);
    subEnv.connect(dryGain);
    sub.start(now);
    sub.stop(now + 0.20);

  } catch(e) { console.warn('SlideSound error:', e); }
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