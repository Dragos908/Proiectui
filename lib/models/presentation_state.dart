class PresentationState {
  // ─── Fields compatible with the Android app ───────────────────
  // Firebase node: 'solide'
  // NOTE: the field names and the `actiune` values are the wire format shared
  // with the Android app, so they are intentionally kept in Romanian.
  final int solidCurent;   // 1-based (1 = cover) = slideIndex + 1 on web
  final String actiune;    // 'inainte' (forward) | 'inapoi' (back) | 'sunet' (sound) | ''
  final bool vibratieOK;
  // ─── Extra fields for web only ──────────────────────────────
  final String videoId;
  final bool videoPlay;

  const PresentationState({
    this.solidCurent = 1,
    this.actiune = '',
    this.vibratieOK = false,
    this.videoId = '',
    this.videoPlay = false,
  });

  // slideIndex is an alias for solidCurent (0-based, for the slide list)
  int get slideIndex => (solidCurent - 1).clamp(0, 9999);

  factory PresentationState.fromMap(Map<dynamic, dynamic> map) {
    return PresentationState(
      solidCurent: _asInt(map['solidCurent'], 1),
      actiune: map['actiune']?.toString() ?? '',
      vibratieOK: _asBool(map['vibratieOK']),
      videoId: map['videoId']?.toString() ?? '',
      videoPlay: _asBool(map['videoPlay']),
    );
  }

  Map<String, dynamic> toMap() => {
    'solidCurent': solidCurent,
    'actiune': actiune,
    'vibratieOK': vibratieOK,
    'videoId': videoId,
    'videoPlay': videoPlay,
  };

  // ─── Tolerant parsing ───────────────────────────────────────────
  // If an app writes "3" (text) instead of 3 (number), or "true" instead of
  // true, the old parsing (`as num?` / `as bool?`) threw an error and stopped
  // the whole state flow. Now the default value is used instead.
  static int _asInt(Object? v, int fallback) {
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? fallback;
    return fallback;
  }

  static bool _asBool(Object? v) {
    if (v is bool) return v;
    if (v is String) return v.trim().toLowerCase() == 'true';
    if (v is num) return v != 0;
    return false;
  }
}
