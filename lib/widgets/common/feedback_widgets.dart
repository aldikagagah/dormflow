/// Feedback widgets for user interactions - Snackbars, Dialogs, Toasts
library;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Type of snackbar to display
enum SnackBarType {
  success,
  error,
  warning,
  info,
}

/// Custom styled snackbar helper
class AppSnackBar {
  /// Show a success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(context, message: message, type: SnackBarType.success, duration: duration, action: action);
  }

  /// Show an error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _show(context, message: message, type: SnackBarType.error, duration: duration, action: action);
  }

  /// Show a warning snackbar
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(context, message: message, type: SnackBarType.warning, duration: duration, action: action);
  }

  /// Show an info snackbar
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(context, message: message, type: SnackBarType.info, duration: duration, action: action);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    required Duration duration,
    SnackBarAction? action,
  }) {
    final colors = _getColors(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(colors.icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: colors.background,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        margin: const EdgeInsets.all(AppTheme.spacingMd),
        duration: duration,
        action: action,
      ),
    );
  }

  static _SnackBarColors _getColors(SnackBarType type) {
    return switch (type) {
      SnackBarType.success => const _SnackBarColors(
        background: AppTheme.success,
        icon: Icons.check_circle_rounded,
      ),
      SnackBarType.error => const _SnackBarColors(
        background: AppTheme.error,
        icon: Icons.error_rounded,
      ),
      SnackBarType.warning => const _SnackBarColors(
        background: AppTheme.warning,
        icon: Icons.warning_rounded,
      ),
      SnackBarType.info => const _SnackBarColors(
        background: AppTheme.info,
        icon: Icons.info_rounded,
      ),
    };
  }
}

class _SnackBarColors {

  const _SnackBarColors({required this.background, required this.icon});
  final Color background;
  final IconData icon;
}

/// Confirmation dialog helper
class AppDialog {
  /// Show confirmation dialog
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    Color? confirmColor,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text(title, style: AppTheme.headingSm),
        content: Text(message, style: AppTheme.bodyMd),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ??
                  (isDangerous ? AppTheme.error : AppTheme.primary),
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show delete confirmation
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    String title = 'Hapus Data',
    String message = 'Yakin ingin menghapus? Tindakan ini tidak dapat dibatalkan.',
  }) {
    return showConfirmation(
      context,
      title: title,
      message: message,
      confirmText: 'Hapus',
      isDangerous: true,
    );
  }

  /// Show loading dialog
  static void showLoading(
    BuildContext context, {
    String message = 'Mohon tunggu...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Show success dialog with animation
  static Future<void> showSuccess(
    BuildContext context, {
    String title = 'Berhasil!',
    String? message,
    String buttonText = 'OK',
    VoidCallback? onClose,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.success,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTheme.headingSm, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message, style: AppTheme.bodyMd, textAlign: TextAlign.center),
            ],
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onClose?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  static Future<void> showError(
    BuildContext context, {
    String title = 'Terjadi Kesalahan',
    String? message,
    String buttonText = 'OK',
    VoidCallback? onRetry,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_rounded,
                color: AppTheme.error,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTheme.headingSm, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message, style: AppTheme.bodyMd, textAlign: TextAlign.center),
            ],
          ],
        ),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Coba Lagi'),
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

/// In-app notification banner (shows at top of screen)
class NotificationBanner extends StatelessWidget {

  const NotificationBanner({
    super.key,
    required this.message,
    this.type = SnackBarType.info,
    this.onDismiss,
    this.onAction,
    this.actionText,
  });
  final String message;
  final SnackBarType type;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.1),
        border: Border.all(color: colors.background.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          Icon(colors.icon, color: colors.background, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTheme.bodyMd.copyWith(color: colors.background),
            ),
          ),
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close, color: colors.background, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  _BannerColors _getColors() {
    return switch (type) {
      SnackBarType.success => const _BannerColors(
        background: AppTheme.success,
        icon: Icons.check_circle_outline_rounded,
      ),
      SnackBarType.error => const _BannerColors(
        background: AppTheme.error,
        icon: Icons.error_outline_rounded,
      ),
      SnackBarType.warning => const _BannerColors(
        background: AppTheme.warning,
        icon: Icons.warning_amber_rounded,
      ),
      SnackBarType.info => const _BannerColors(
        background: AppTheme.info,
        icon: Icons.info_outline_rounded,
      ),
    };
  }
}

class _BannerColors {

  const _BannerColors({required this.background, required this.icon});
  final Color background;
  final IconData icon;
}
