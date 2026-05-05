class PrezentareState {
  // ─── Câmpuri compatibile cu aplicația Android ───────────────────
  // Nod Firebase: 'solide'
  final int solidCurent;   // = slideIndex în web
  final String actiune;    // 'inainte' | 'inapoi' | 'sunet'
  final bool vibratieOK;
  // ─── Câmpuri extra doar pentru web ──────────────────────────────
  final String videoId;
  final bool videoPlay;

  const PrezentareState({
    this.solidCurent = 1,
    this.actiune = '',
    this.vibratieOK = false,
    this.videoId = '',
    this.videoPlay = false,
  });

  // slideIndex e un alias pentru solidCurent (0-based pentru lista de slide-uri)
  int get slideIndex => (solidCurent - 1).clamp(0, 9999);

  factory PrezentareState.fromMap(Map<dynamic, dynamic> map) {
    return PrezentareState(
      solidCurent: (map['solidCurent'] as num?)?.toInt() ?? 1,
      actiune: map['actiune']?.toString() ?? '',
      vibratieOK: map['vibratieOK'] as bool? ?? false,
      videoId: map['videoId']?.toString() ?? '',
      videoPlay: map['videoPlay'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'solidCurent': solidCurent,
    'actiune': actiune,
    'vibratieOK': vibratieOK,
    'videoId': videoId,
    'videoPlay': videoPlay,
  };
}