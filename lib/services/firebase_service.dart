import 'package:firebase_database/firebase_database.dart';
import '../models/prezentare_state.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // ─── Același nod ca aplicația Android ──────────────────────────
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('solide');

  // Stream de stare – UI-ul web ascultă asta
  Stream<PrezentareState> get stateStream => _ref.onValue.map((event) {
    final data = event.snapshot.value;
    if (data == null) return const PrezentareState();
    return PrezentareState.fromMap(data as Map<dynamic, dynamic>);
  });

  // Stream conexiune Firebase
  Stream<bool> get connectionStream => FirebaseDatabase.instance
      .ref('.info/connected')
      .onValue
      .map((e) => e.snapshot.value as bool? ?? false);

  // Web poate și el schimba slide-ul (solidCurent e 1-based ca în Android)
  Future<void> setSlide(int slideIndex) async {
    final solidCurent = slideIndex + 1; // web e 0-based, Android e 1-based
    await _ref.update({
      'solidCurent': solidCurent,
      'actiune': 'inainte',
      'vibratieOK': true,
    });
  }

  // Inițializare nod dacă nu există
  Future<void> initializeNode() async {
    final snap = await _ref.get();
    if (!snap.exists) {
      await _ref.set(const PrezentareState().toMap());
    }
  }

  // Pornește/oprește video (câmpuri extra pentru web)
  Future<void> setVideo({required String videoId, required bool play}) async {
    await _ref.update({'videoId': videoId, 'videoPlay': play});
  }

  // Calculează latența (nu mai avem lastUpdate din Android, deci returnăm -1)
  int getLatentyMs(int lastUpdate) {
    if (lastUpdate == 0) return -1;
    return DateTime.now().millisecondsSinceEpoch - lastUpdate;
  }
}