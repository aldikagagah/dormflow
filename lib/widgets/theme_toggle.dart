import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

/// Widget tombol icon untuk toggle tema
class ThemeToggleButton extends StatelessWidget {
  final Color? iconColor;
  final double size;

  const ThemeToggleButton({
    super.key,
    this.iconColor,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return PopupMenuButton<AppThemeMode>(
          onSelected: (mode) => themeProvider.setThemeMode(mode),
          icon: Icon(
            themeProvider.themeModeIcon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
            size: size,
          ),
          tooltip: 'Ganti Tema',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          itemBuilder: (context) => [
            _buildMenuItem(
              context,
              AppThemeMode.light,
              Icons.light_mode_rounded,
              'Terang',
              themeProvider.themeMode == AppThemeMode.light,
            ),
            _buildMenuItem(
              context,
              AppThemeMode.dark,
              Icons.dark_mode_rounded,
              'Gelap',
              themeProvider.themeMode == AppThemeMode.dark,
            ),
            _buildMenuItem(
              context,
              AppThemeMode.system,
              Icons.brightness_auto_rounded,
              'Ikuti Sistem',
              themeProvider.themeMode == AppThemeMode.system,
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem<AppThemeMode> _buildMenuItem(
    BuildContext context,
    AppThemeMode mode,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return PopupMenuItem<AppThemeMode>(
      value: mode,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppTheme.primary : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : null,
                color: isSelected ? AppTheme.primary : null,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_rounded,
              size: 18,
              color: AppTheme.primary,
            ),
        ],
      ),
    );
  }
}

/// Widget tombol sederhana cycle theme (tap untuk ganti)
class ThemeCycleButton extends StatelessWidget {
  final Color? iconColor;
  final double size;
  final bool showBackground;

  const ThemeCycleButton({
    super.key,
    this.iconColor,
    this.size = 24,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return GestureDetector(
          onTap: () => _cycleTheme(themeProvider),
          child: Container(
            padding: showBackground ? const EdgeInsets.all(8) : null,
            decoration: showBackground
                ? BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  )
                : null,
            child: Icon(
              themeProvider.themeModeIcon,
              color: iconColor ?? Colors.white,
              size: size,
            ),
          ),
        );
      },
    );
  }

  void _cycleTheme(ThemeProvider provider) {
    switch (provider.themeMode) {
      case AppThemeMode.light:
        provider.setThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        provider.setThemeMode(AppThemeMode.system);
        break;
      case AppThemeMode.system:
        provider.setThemeMode(AppThemeMode.light);
        break;
    }
  }
}
