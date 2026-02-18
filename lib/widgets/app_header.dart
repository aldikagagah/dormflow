import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget SliverAppBar yang konsisten untuk semua screen
class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Widget? trailing;
  final double expandedHeight;
  final bool showBackButton;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.backgroundColor,
    this.gradient,
    this.trailing,
    this.expandedHeight = 120,
    this.showBackButton = false,
  });

  // Preset untuk warna
  static Gradient get primaryGradient => AppTheme.primaryGradient;
  static Gradient get secondaryGradient => AppTheme.secondaryGradient;
  static Gradient get warningGradient => LinearGradient(
    colors: [AppTheme.warning, AppTheme.warning.withValues(alpha: 0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static Gradient get successGradient => LinearGradient(
    colors: [AppTheme.success, AppTheme.success.withValues(alpha: 0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static Gradient get infoGradient => LinearGradient(
    colors: [AppTheme.info, AppTheme.info.withValues(alpha: 0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: backgroundColor ?? AppTheme.primary,
      automaticallyImplyLeading: showBackButton,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: gradient ?? primaryGradient,
            color: gradient == null ? backgroundColor : null,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                subtitle!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget untuk header pill/badge
class HeaderBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const HeaderBadge({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
