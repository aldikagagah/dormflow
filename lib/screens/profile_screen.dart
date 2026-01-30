import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../theme/app_theme.dart';
import '../widgets/edit_profile_sheet.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  Map<String, dynamic> _profile = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await _profileService.getUserProfile();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          backgroundImage: ((_profile['photoUrl'] as String?) ?? '').isNotEmpty
                              ? NetworkImage((_profile['photoUrl'] as String?) ?? '')
                              : null,
                          child: ((_profile['photoUrl'] as String?) ?? '').isEmpty
                              ? Text(
                                  (((_profile['name'] as String?) ?? 'U')[0]).toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        ((_profile['name'] as String?) ?? 'User'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email
                      Text(
                        ((_profile['email'] as String?) ?? ''),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _profile['role'] == 'Admin'
                                  ? Icons.admin_panel_settings_rounded
                                  : Icons.person_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              ((_profile['role'] as String?) ?? 'Member'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _showEditSheet,
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  // Stats Section
                  _buildStatsRow(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Personal Info Section
                  _buildSection(
                    title: 'Informasi Personal',
                    children: [
                      _infoTile(
                        Icons.phone_rounded,
                        'Telepon',
                        ((_profile['phone'] as String?) ?? '-'),
                      ),
                      _infoTile(
                        Icons.location_on_rounded,
                        'Alamat',
                        ((_profile['address'] as String?) ?? '-'),
                      ),
                      _infoTile(
                        Icons.calendar_today_rounded,
                        'Bergabung',
                        _profile['createdAt'] != null
                            ? DateFormat('dd MMMM yyyy').format(
                                DateTime.parse((_profile['createdAt'] as String?) ?? ''))
                            : '-',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Account Section
                  _buildSection(
                    title: 'Pengaturan Akun',
                    children: [
                      _actionTile(
                        Icons.lock_rounded,
                        'Ganti Password',
                        () => _showChangePasswordDialog(),
                      ),
                      _themeTile(),
                      _actionTile(
                        Icons.notifications_rounded,
                        'Notifikasi',
                        () {},
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeTrackColor: AppTheme.primary.withValues(alpha: 0.5),
                          thumbColor: WidgetStateProperty.all(AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Danger Zone
                  _buildSection(
                    title: 'Lainnya',
                    children: [
                      _actionTile(
                        Icons.help_outline_rounded,
                        'Bantuan',
                        () {},
                      ),
                      _actionTile(
                        Icons.info_outline_rounded,
                        'Tentang Aplikasi',
                        () => _showAboutDialog(),
                      ),
                      _actionTile(
                        Icons.logout_rounded,
                        'Keluar',
                        _logout,
                        isDestructive: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // App Version
                  Center(
                    child: Text(
                      'Dormflow v1.0.0',
                      style: AppTheme.bodySm,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.shadowMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: _statItem(
              icon: Icons.calendar_month_rounded,
              label: 'Jadwal',
              value: '12',
              color: AppTheme.primary,
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: AppTheme.neutral200,
          ),
          Expanded(
            child: _statItem(
              icon: Icons.check_circle_rounded,
              label: 'Absensi',
              value: '98%',
              color: AppTheme.success,
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: AppTheme.neutral200,
          ),
          Expanded(
            child: _statItem(
              icon: Icons.star_rounded,
              label: 'Poin',
              value: '450',
              color: AppTheme.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.headingSm.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.bodySm),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.headingSm),
        const SizedBox(height: AppTheme.spacingMd),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: AppTheme.shadowSm,
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(label, style: AppTheme.bodySm),
      subtitle: Text(
        value,
        style: AppTheme.labelLg,
      ),
    );
  }

  Widget _actionTile(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.error.withValues(alpha: 0.1)
              : AppTheme.neutral100,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppTheme.error : AppTheme.neutral600,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: AppTheme.labelLg.copyWith(
          color: isDestructive ? AppTheme.error : AppTheme.neutral800,
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.neutral400,
          ),
    );
  }

  Widget _themeTile() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ListTile(
          onTap: () => _showThemeDialog(),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(
              themeProvider.themeModeIcon,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            'Tampilan',
            style: AppTheme.labelLg,
          ),
          subtitle: Text(
            themeProvider.themeModeLabel,
            style: AppTheme.bodySm,
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.neutral400,
          ),
        );
      },
    );
  }

  void _showThemeDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Text('Pilih Tampilan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _themeOption(
              icon: Icons.light_mode_rounded,
              label: 'Terang',
              isSelected: themeProvider.themeMode == AppThemeMode.light,
              onTap: () {
                themeProvider.setThemeMode(AppThemeMode.light);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _themeOption(
              icon: Icons.dark_mode_rounded,
              label: 'Gelap',
              isSelected: themeProvider.themeMode == AppThemeMode.dark,
              onTap: () {
                themeProvider.setThemeMode(AppThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _themeOption(
              icon: Icons.brightness_auto_rounded,
              label: 'Ikuti Sistem',
              isSelected: themeProvider.themeMode == AppThemeMode.system,
              onTap: () {
                themeProvider.setThemeMode(AppThemeMode.system);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.neutral200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.neutral500,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.primary : AppTheme.neutral700,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(
        initialData: _profile,
        onSave: (name, phone, address) async {
          return await _profileService.updateProfile(
            name: name,
            phone: phone,
            address: address,
          );
        },
      ),
    ).then((result) {
      if (result == true) _loadProfile();
    });
  }

  void _showChangePasswordDialog() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Text('Ganti Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Lama',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                prefixIcon: Icon(Icons.lock_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
                prefixIcon: Icon(Icons.lock_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password tidak cocok')),
                );
                return;
              }
              final result = await _profileService.changePassword(
                currentController.text,
                newController.text,
              );
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result == 'success'
                      ? 'Password berhasil diubah'
                      : result),
                  backgroundColor:
                      result == 'success' ? AppTheme.success : AppTheme.error,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: const Icon(Icons.apartment_rounded, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Text('Dormflow'),
          ],
        ),
        content: const Text(
          'Aplikasi manajemen asrama modern untuk pengelolaan jadwal, absensi, dan keuangan yang lebih efisien.\n\nDibuat dengan ❤️ menggunakan Flutter.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

}
