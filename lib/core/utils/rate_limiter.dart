/// Rate limiter utility untuk mencegah spam actions
library;

/// Utility untuk membatasi frekuensi eksekusi action.
class RateLimiter {

  RateLimiter({this.cooldown = const Duration(seconds: 5)});
  final Map<String, DateTime> _lastActionTime = {};
  final Duration cooldown;

  /// Cek apakah action bisa dilakukan.
  bool canPerformAction(String actionKey) {
    final lastTime = _lastActionTime[actionKey];
    if (lastTime == null) return true;

    return DateTime.now().difference(lastTime) >= cooldown;
  }

  /// Catat waktu eksekusi action.
  void recordAction(String actionKey) {
    _lastActionTime[actionKey] = DateTime.now();
  }

  /// Dapatkan sisa waktu cooldown.
  Duration? getRemainingCooldown(String actionKey) {
    final lastTime = _lastActionTime[actionKey];
    if (lastTime == null) return null;

    final elapsed = DateTime.now().difference(lastTime);
    if (elapsed >= cooldown) return null;

    return cooldown - elapsed;
  }

  /// Reset cooldown untuk action tertentu.
  void resetAction(String actionKey) {
    _lastActionTime.remove(actionKey);
  }

  /// Reset semua cooldowns.
  void resetAll() {
    _lastActionTime.clear();
  }
}

/// Extension untuk Duration formatting.
extension DurationFormatting on Duration {
  /// Format duration ke string readable (e.g., "5 detik", "2 menit").
  String toReadableString() {
    if (inSeconds < 60) {
      return '$inSeconds detik';
    } else if (inMinutes < 60) {
      return '$inMinutes menit';
    } else {
      return '$inHours jam';
    }
  }
}
