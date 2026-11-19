import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firebase_service.dart';
import '../models/presentation_state.dart';
import '../theme/palette.dart';
import '../theme/text_styles.dart';
import '../widgets/slide_stage.dart';
import 'slide_deck.dart';


/// Reference resolution (16:9) that every slide is laid out for. The slides are
/// rendered at this size and then scaled to the real screen by [_ScaledSlide].
/// If the slides were originally designed for another resolution
/// (e.g. Size(1280, 720)), change this single value.
const Size _kSlideCanvasSize = Size(1920, 1080);

// Slide-urile, luminile lor, scenele din fundal și slide-urile interactive stau
// acum împreună, câte un rând pe slide, în slide_deck.dart (`kDeck`).

class PresentationPage extends StatefulWidget {
  const PresentationPage({super.key});

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  final _fb = FirebaseService();
  PresentationState _state = const PresentationState();
  bool _showControls = false;
  int _previousIndex = 0;

  StreamSubscription<PresentationState>? _stateSub;
  final FocusNode _keyboardFocus = FocusNode();

  List<Widget> get _slides => kDeckSlides;

  int get _safeIndex => _state.slideIndex.clamp(0, _slides.length - 1);

  // Slides that have internal interactive buttons and must NOT be covered
  // by the toggle-controls overlay. Calculat din `kDeck`, deci rămâne corect
  // și când se adaugă sau se șterg slide-uri.
  static Set<int> get _interactiveSlides => kDeckInteractive;

  bool get _currentSlideIsInteractive => _interactiveSlides.contains(_safeIndex);

  void _goToSlide(int index) {
    // Stay within bounds: going forward on the last slide used to make solidCurent reach 17 in the database
    final int target = index.clamp(0, _slides.length - 1);
    if (target == _safeIndex) return; // nothing to change → write nothing to the database
    final bool goingForward = target > _previousIndex;
    _previousIndex = target;
    _fb.setSlide(target, forward: goingForward);
  }

  @override
  void initState() {
    super.initState();
    html.document.documentElement?.requestFullscreen();
    _fb.publishTotal(_slides.length); // Android can read how many slides the presentation has
    _stateSub = _fb.stateStream.listen((s) {
      if (mounted) {
        // Remember which slide is shown (used to tell forward from back).
        _previousIndex = s.slideIndex.clamp(0, _slides.length - 1);
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

  // `actiune` is written by the Android app using Romanian wire values (shared
  // protocol, so they are not renamed). Show them to the user in English.
  String _actionLabel(String actiune) {
    switch (actiune) {
      case 'inainte':
        return 'next';
      case 'inapoi':
        return 'previous';
      case 'sunet':
        return 'sound';
      default:
        return actiune;
    }
  }

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
        backgroundColor: Palette.abis,
        body: Stack(
          children: [
            // ── Active slide ────────────────────────────────────────────
            // Fundalul de bază, slide-ul (cu scena lui animată), șina etapelor și
            // scan-wipe-ul trăiesc pe același canvas fix 16:9, scalat pe ecran
            // (vezi _ScaledSlide, la finalul fișierului).
            Positioned.fill(
              child: _ScaledSlide(
                child: SlideStage(
                  index: _safeIndex,
                  slides: _slides,
                  lights: kDeckLights,
                  scenes: kDeckScenes,
                ),
              ),
            ),

            // ── Overlay for toggling the controls ────────────────────────────
            // If the current slide is interactive (e.g. Slide08 with buttons),
            // we use only a narrow strip at the top for the toggle,
            // leaving the central area free for the slide's own buttons.
            // For non-interactive slides, we cover the whole screen.
            if (_currentSlideIsInteractive)
            // 60px strip at the top – enough for the toggle
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
            // Slide without internal buttons – full overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleControls,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              ),

            // ── Control bar (top) ──────────────────────────────────────
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
          ],
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    final bool active = _state.actiune.isNotEmpty;
    final Color badge = active ? Palette.green : Palette.ceata;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Palette.punte.o(0.94),
        border: Border(
          bottom: BorderSide(color: Palette.gheata.o(0.30), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            icon: const Icon(Icons.arrow_back, color: Palette.gheata),
            tooltip: 'Back to menu',
          ),
          const Spacer(),
          IconButton(
            onPressed: () =>
                _goToSlide(_safeIndex > 0 ? _safeIndex - 1 : 0),
            icon: const Icon(Icons.chevron_left, color: Palette.gheata),
            iconSize: 32,
          ),
          IconButton(
            onPressed: () => _goToSlide(_safeIndex + 1),
            icon: const Icon(Icons.chevron_right, color: Palette.gheata),
            iconSize: 32,
          ),
          const Spacer(),
          // Insigna „Android”: contur teșit în loc de pastilă rotunjită.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: ShapeDecoration(
              color: badge.o(0.12),
              shape: BeveledRectangleBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                side: BorderSide(color: badge.o(0.45)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_android, color: badge, size: 18),
                const SizedBox(width: 8),
                Text(
                  active
                      ? 'Android: ${_actionLabel(_state.actiune)}'
                      : 'Android: waiting...',
                  style: Txt.mono(badge, size: 16, weight: FontWeight.w500, height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders [child] on a fixed-size canvas ([_kSlideCanvasSize]) and scales it
/// uniformly to fit the available space, keeping the aspect ratio. The slide
/// therefore looks the same on any screen or browser-window size; any spare
/// space is left as the page background (letterboxing).
class _ScaledSlide extends StatelessWidget {
  const _ScaledSlide({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: ClipRect(
        child: SizedBox(
          width: _kSlideCanvasSize.width,
          height: _kSlideCanvasSize.height,
          // Slides that read MediaQuery.of(context).size must see the canvas
          // size, not the real screen size, otherwise they would lay
          // themselves out for the screen and then be scaled a second time.
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(size: _kSlideCanvasSize),
            child: child,
          ),
        ),
      ),
    );
  }
}
