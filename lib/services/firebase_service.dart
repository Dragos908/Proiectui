import 'package:flutter/foundation.dart' show debugPrint;
import 'package:firebase_database/firebase_database.dart';
import '../models/presentation_state.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // ─── Same node as the Android app ──────────────────────────
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('solide');

  // State stream – the web UI listens to this
  Stream<PresentationState> get stateStream => _ref.onValue.map((event) {
    final data = event.snapshot.value;
    // Node missing or of another type (e.g. a number instead of an object) → default values
    if (data is! Map) return const PresentationState();
    return PresentationState.fromMap(data);
  }).handleError((Object e) => debugPrint('[Firebase] read failed: $e'));

  // Firebase connection stream.
  // NOTE: true only means "connected to the server", NOT "the rules allow
  // access". Use initializeNode() for that.
  Stream<bool> get connectionStream => FirebaseDatabase.instance
      .ref('.info/connected')
      .onValue
      .map((e) => e.snapshot.value as bool? ?? false);

  // The web app can also change the slide (solidCurent is 1-based, as in Android).
  // `forward` = true for "forward", false for "back".
  Future<void> setSlide(int slideIndex, {required bool forward}) async {
    final int index = slideIndex < 0 ? 0 : slideIndex;
    await _write({
      'solidCurent': index + 1, // web is 0-based, Android is 1-based
      'actiune': forward ? 'inainte' : 'inapoi',
      'vibratieOK': true,
    });
  }

  // Publishes the real number of slides so the Android app can read it
  // instead of hard-coding it.
  Future<void> publishTotal(int total) => _write({'totalSolide': total});

  // Restarts the presentation from the cover (unused by default; see the note in the reply).
  Future<void> resetToStart() => _write({
        'solidCurent': 1,
        'actiune': '',
        'vibratieOK': false,
      });

  // Initializes the node if it does not exist. Returns false if the database
  // cannot be read or written (usually: expired/too-strict rules, or no internet).
  Future<bool> initializeNode() async {
    try {
      final snap = await _ref.get();
      if (!snap.exists) {
        await _ref.set(const PresentationState().toMap());
      }
      return true;
    } catch (e) {
      debugPrint('[Firebase] access denied or error: $e');
      return false;
    }
  }

  // Starts/stops the video (extra fields for web)
  Future<void> setVideo({required String videoId, required bool play}) =>
      _write({'videoId': videoId, 'videoPlay': play});

  // Computes the latency (we no longer get lastUpdate from Android, so we return -1)
  int getLatencyMs(int lastUpdate) {
    if (lastUpdate == 0) return -1;
    return DateTime.now().millisecondsSinceEpoch - lastUpdate;
  }

  // Shared write: a write rejected by the rules no longer stays a silent error
  // in the browser console, it shows up clearly in the log.
  Future<void> _write(Map<String, Object?> data) async {
    try {
      await _ref.update(data);
    } catch (e) {
      debugPrint('[Firebase] write failed: $e');
    }
  }
}
