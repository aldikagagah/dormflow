import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/schedule_service.dart';
import '../theme/app_theme.dart';
import '../widgets/theme_toggle.dart';
import 'attendance_screen.dart';
import 'finance_screen.dart';
import 'profile_screen.dart';
import 'schedule_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const TodayPage(),
    const ScheduleScreen(),
    const AttendanceScreen(),
    const FinanceScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, 'Beranda'),
              _navItem(1, Icons.calendar_month_rounded, 'Jadwal'),
              _navItem(2, Icons.fingerprint_rounded, 'Absensi'),
              _navItem(3, Icons.account_balance_wallet_rounded, 'Kas'),
              _navItem(4, Icons.person_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppTheme.primary : AppTheme.neutral400,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== TODAY PAGE ====================

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final ScheduleService _scheduleService = ScheduleService();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppTheme.primary,
            automaticallyImplyLeading: false,
            actions: const [
              // Theme Toggle Icon
              ThemeCycleButton(
                iconColor: Colors.white,
              ),
              SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          greeting,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Selamat Datang! 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            DateFormat('EEEE, dd MMMM yyyy').format(now),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Actions
                _buildSectionTitle('Akses Cepat'),
                const SizedBox(height: AppTheme.spacingMd),
                _buildQuickActions(),
                const SizedBox(height: AppTheme.spacingXl),

                // Today's Schedule
                _buildSectionTitle('Jadwal Hari Ini'),
                const SizedBox(height: AppTheme.spacingMd),
                _buildTodaySchedules(),
                const SizedBox(height: AppTheme.spacingXl),

                // Stats Overview
                _buildSectionTitle('Ringkasan'),
                const SizedBox(height: AppTheme.spacingMd),
                _buildStatsCards(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return '🌅 Selamat Pagi';
    if (hour < 15) return '☀️ Selamat Siang';
    if (hour < 18) return '🌤️ Selamat Sore';
    return '🌙 Selamat Malam';
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.headingSm,
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _quickActionCard(
            icon: Icons.calendar_month_rounded,
            label: 'Jadwal',
            color: AppTheme.primary,
            onTap: () => _navigateToTab(1),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _quickActionCard(
            icon: Icons.fingerprint_rounded,
            label: 'Absensi',
            color: AppTheme.secondary,
            onTap: () => _navigateToTab(2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _quickActionCard(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Kas',
            color: AppTheme.warning,
            onTap: () => _navigateToTab(3),
          ),
        ),
      ],
    );
  }

  Widget _quickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              label,
              style: AppTheme.labelMd.copyWith(color: AppTheme.neutral700),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTab(int index) {
    final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
    dashboardState?._onItemTapped(index);
  }

  Widget _buildTodaySchedules() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _scheduleService.getTodaySchedulesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              boxShadow: AppTheme.shadowSm,
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final schedules = snapshot.data ?? [];

        if (schedules.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.event_available_rounded,
                  size: 48,
                  color: AppTheme.neutral300,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  'Tidak ada jadwal hari ini',
                  style: AppTheme.bodyMd.copyWith(color: AppTheme.neutral500),
                ),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  'Nikmati hari santai! 🎉',
                  style: AppTheme.bodySm,
                ),
              ],
            ),
          );
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: AppTheme.shadowSm,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedules.length > 3 ? 3 : schedules.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: AppTheme.neutral100,
            ),
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return _scheduleItem(schedule);
            },
          ),
        );
      },
    );
  }

  Widget _scheduleItem(Map<String, dynamic> schedule) {
    final category = schedule['category'] ?? '';
    Color color;
    IconData icon;

    switch (category) {
      case 'Piket':
        color = AppTheme.secondary;
        icon = Icons.cleaning_services_rounded;
        break;
      case 'Ngaji':
        color = AppTheme.primary;
        icon = Icons.menu_book_rounded;
        break;
      case 'Pemateri':
        color = Colors.purple;
        icon = Icons.mic_rounded;
        break;
      default:
        color = AppTheme.neutral500;
        icon = Icons.event_note_rounded;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        (schedule['taskName'] as String?) ?? '',
        style: AppTheme.labelLg,
      ),
      subtitle: Text(
        (schedule['assignedMemberName'] as String?) ?? '',
        style: AppTheme.bodySm,
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: schedule['status'] == 'Selesai'
              ? AppTheme.success.withValues(alpha: 0.1)
              : AppTheme.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        child: Text(
          (schedule['status'] as String?) ?? 'Pending',
          style: AppTheme.labelSm.copyWith(
            color: (schedule['status'] as String?) == 'Selesai'
                ? AppTheme.success
                : AppTheme.warning,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.check_circle_rounded,
            label: 'Absensi',
            value: 'Aktif',
            color: AppTheme.success,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _statCard(
            icon: Icons.event_note_rounded,
            label: 'Jadwal Minggu Ini',
            value: '5 Tugas',
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppTheme.spacingMd),
          Text(label, style: AppTheme.bodySm),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            value,
            style: AppTheme.headingSm.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
