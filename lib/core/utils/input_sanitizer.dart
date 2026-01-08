/// Input sanitizer untuk keamanan data
///
/// Digunakan untuk membersihkan input sebelum disimpan
/// ke database untuk mencegah XSS dan injection attacks.
library;

/// Utility class untuk sanitasi input pengguna.
class InputSanitizer {
  InputSanitizer._();

  /// Sanitize text input untuk mencegah XSS.
  ///
  /// Mengubah karakter berbahaya menjadi HTML entities.
  static String sanitizeText(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .trim();
  }

  /// Sanitize dan normalize email.
  static String sanitizeEmail(String email) {
    return email.toLowerCase().trim();
  }

  /// Hapus semua HTML tags dari string.
  static String stripHtml(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'&[a-zA-Z]+;'), '')
        .trim();
  }

  /// Sanitize nama (hanya huruf, spasi, dan karakter umum nama).
  static String sanitizeName(String name) {
    return name
        .replaceAll(RegExp(r"[^\w\s.'\-]"), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Sanitize dan format nomor telepon.
  ///
  /// Menghapus karakter non-digit kecuali + di awal.
  static String sanitizePhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Normalize Indonesian phone numbers
    if (cleaned.startsWith('62')) {
      return '+$cleaned';
    } else if (cleaned.startsWith('0')) {
      return '+62${cleaned.substring(1)}';
    }

    return cleaned;
  }

  /// Sanitize deskripsi/catatan.
  ///
  /// Menghapus HTML dan membatasi panjang.
  static String sanitizeDescription(String description, {int maxLength = 500}) {
    final cleaned = stripHtml(description).trim();
    if (cleaned.length > maxLength) {
      return cleaned.substring(0, maxLength);
    }
    return cleaned;
  }

  /// Sanitize amount string menjadi number string.
  static String sanitizeAmount(String amount) {
    // Remove all non-digit and non-decimal characters
    return amount.replaceAll(RegExp(r'[^\d.]'), '');
  }

  /// Decode HTML entities kembali ke karakter asli.
  ///
  /// Digunakan saat menampilkan data yang sudah di-sanitize.
  static String decodeHtmlEntities(String input) {
    return input
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/')
        .replaceAll('&amp;', '&');
  }
}
