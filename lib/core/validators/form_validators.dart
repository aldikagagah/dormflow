/// Form validators untuk DormFlow Mobile
///
/// Semua validasi input form dikumpulkan di sini
/// untuk konsistensi dan reusability.
library;

import '../constants/app_constants.dart';

/// Kumpulan validator untuk form input.
class FormValidators {
  FormValidators._();

  /// Validasi email address.
  ///
  /// Returns null jika valid, pesan error jika tidak valid.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }

    final trimmed = value.trim().toLowerCase();
    // Regex yang require minimal satu dot di domain (TLD)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
    );

    if (!emailRegex.hasMatch(trimmed)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Validasi password dengan kriteria keamanan.
  ///
  /// Kriteria:
  /// - Minimal 8 karakter
  /// - Mengandung huruf besar
  /// - Mengandung huruf kecil
  /// - Mengandung angka
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password minimal ${AppConstants.minPasswordLength} karakter';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password maksimal ${AppConstants.maxPasswordLength} karakter';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }

    return null;
  }

  /// Validasi password simple (hanya cek panjang minimal).
  ///
  /// Digunakan untuk login, bukan registrasi.
  static String? passwordSimple(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  /// Validasi konfirmasi password.
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }

    if (value != originalPassword) {
      return 'Password tidak cocok';
    }

    return null;
  }

  /// Validasi field wajib.
  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  /// Validasi nama.
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }

    if (value.trim().length < 2) {
      return 'Nama minimal 2 karakter';
    }

    if (value.trim().length > AppConstants.maxNameLength) {
      return 'Nama maksimal ${AppConstants.maxNameLength} karakter';
    }

    // Only allow letters, spaces, and common name characters
    if (!RegExp(r"^[a-zA-Z\s\.''-]+$").hasMatch(value.trim())) {
      return 'Nama hanya boleh mengandung huruf';
    }

    return null;
  }

  /// Validasi nomor telepon Indonesia.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{7,11}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  /// Validasi jumlah uang.
  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah wajib diisi';
    }

    // Check for negative sign first (before cleaning)
    if (value.trim().startsWith('-')) {
      return 'Jumlah harus lebih dari 0';
    }

    // Remove currency formatting
    final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
    final amount = double.tryParse(cleaned);

    if (amount == null) {
      return 'Format jumlah tidak valid';
    }

    if (amount <= 0) {
      return 'Jumlah harus lebih dari 0';
    }

    if (amount > 999999999999) {
      return 'Jumlah terlalu besar';
    }

    return null;
  }

  /// Validasi deskripsi/catatan.
  static String? description(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Deskripsi wajib diisi' : null;
    }

    if (value.trim().length > AppConstants.maxDescriptionLength) {
      return 'Deskripsi maksimal ${AppConstants.maxDescriptionLength} karakter';
    }

    return null;
  }
}
