import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/attendance_service.dart';
import '../theme/app_theme.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  final AttendanceService _service = AttendanceService();
  String _currentTime = '';
  String _currentDate = '';
  Timer? _timer;
  bool _isLoading = false;
  bool _showSuccess = false;
  String _successMessage = '';

  // Attendance State
  bool _hasCheckedIn = false;
  bool _hasCheckedOut = false;
  String? _checkInTime;
  String? _checkOutTime;
  String _status = 'Belum Absen';

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    _loadTodayStatus();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
  }

  Future<void> _loadTodayStatus() async {
    setState(() => _isLoading = true);
    final status = await _service.getTodayStatus();
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _checkInTime = status['checkIn'] as String?;
      _checkOutTime = status['checkOut'] as String?;
      _status = (status['status'] as String?) ?? 'Belum Absen';
      _hasCheckedIn = status['hasCheckedIn'] == true;
      _hasCheckedOut = status['hasCheckedOut'] == true;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
      _currentDate = DateFormat('EEEE, dd MMMM yyyy').format(now);
    });
  }

  Future<void> _handleAttendance(String type) async {
    setState(() => _isLoading = true);

    final result = await _service.markAttendance(type);
    await _loadTodayStatus();

    if (!mounted) return;

    if (result == 'success') {
      setState(() {
        _showSuccess = true;
        _successMessage = type == 'Masuk' ? 'Check-In Berhasil!' : 'Check-Out Berhasil!';
      });
      _animController.forward(from: 0);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showSuccess = false);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
    }
  }

  AttendanceState get _attendanceState {
    if (!_hasCheckedIn) return AttendanceState.notCheckedIn;
    if (_hasCheckedIn && !_hasCheckedOut) return AttendanceState.checkedIn;
    return AttendanceState.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar with Clock
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppTheme.secondary,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.secondaryGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingLg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            // Digital Clock
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                              ),
                              child: Text(
                                _currentTime,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'monospace',
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _currentDate,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.9),
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
                    // Status Card
                    _buildStatusCard(),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Time Cards
                    _buildTimeCards(),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Action Buttons
                    _buildActionButtons(),
                    const SizedBox(height: AppTheme.spacingXl),

                    // History
                    _buildHistorySection(),
                  ]),
                ),
              ),
            ],
          ),

          // Success Overlay
          if (_showSuccess) _buildSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final state = _attendanceState;
    Color statusColor;
    String statusText;
    IconData statusIcon;
    String statusDescription;

    switch (state) {
      case AttendanceState.notCheckedIn:
        statusColor = AppTheme.neutral500;
        statusText = 'Belum Check-In';
        statusIcon = Icons.schedule_rounded;
        statusDescription = 'Silakan lakukan check-in untuk memulai';
        break;
      case AttendanceState.checkedIn:
        statusColor = AppTheme.success;
        statusText = _status;
        statusIcon = Icons.check_circle_rounded;
        statusDescription = 'Anda sudah check-in, jangan lupa check-out';
        break;
      case AttendanceState.completed:
        statusColor = AppTheme.primary;
        statusText = 'Selesai';
        statusIcon = Icons.verified_rounded;
        statusDescription = 'Absensi hari ini telah selesai';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.shadowMd,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            child: Icon(statusIcon, color: statusColor, size: 32),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Text(
                    statusText,
                    style: AppTheme.labelMd.copyWith(color: statusColor),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  statusDescription,
                  style: AppTheme.bodySm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCards() {
    return Row(
      children: [
        Expanded(
          child: _timeCard(
            icon: Icons.login_rounded,
            label: 'Check In',
            time: _checkInTime,
            color: AppTheme.success,
            isActive: _hasCheckedIn,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _timeCard(
            icon: Icons.logout_rounded,
            label: 'Check Out',
            time: _checkOutTime,
            color: AppTheme.warning,
            isActive: _hasCheckedOut,
          ),
        ),
      ],
    );
  }

  Widget _timeCard({
    required IconData icon,
    required String label,
    required String? time,
    required Color color,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.shadowSm,
        border: isActive
            ? Border.all(color: color.withValues(alpha: 0.5), width: 2)
            : null,
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? color.withValues(alpha: 0.1) : AppTheme.neutral100,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(
              icon,
              color: isActive ? color : AppTheme.neutral400,
              size: 26,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(label, style: AppTheme.bodySm),
          const SizedBox(height: 4),
          Text(
            time ?? '--:--',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isActive ? color : AppTheme.neutral400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final state = _attendanceState;
    final canCheckIn = state == AttendanceState.notCheckedIn && !_isLoading;
    final canCheckOut = state == AttendanceState.checkedIn && !_isLoading;

    return Row(
      children: [
        Expanded(
          child: _actionButton(
            label: 'Check In',
            icon: Icons.fingerprint_rounded,
            color: AppTheme.success,
            isEnabled: canCheckIn,
            isPrimary: true,
            isLoading: _isLoading && !_hasCheckedIn,
            onTap: () => _handleAttendance('Masuk'),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _actionButton(
            label: 'Check Out',
            icon: Icons.exit_to_app_rounded,
            color: AppTheme.warning,
            isEnabled: canCheckOut,
            isPrimary: false,
            isLoading: _isLoading && _hasCheckedIn && !_hasCheckedOut,
            onTap: () => _handleAttendance('Keluar'),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isEnabled,
    required bool isPrimary,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 60,
      child: isPrimary
          ? ElevatedButton(
              onPressed: isEnabled ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.neutral200,
                disabledForegroundColor: AppTheme.neutral400,
                elevation: isEnabled ? 4 : 0,
                shadowColor: color.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            )
          : OutlinedButton(
              onPressed: isEnabled ? onTap : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(
                  color: isEnabled ? color : AppTheme.neutral300,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: color,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isEnabled ? color : AppTheme.neutral400,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Riwayat Absensi', style: AppTheme.headingSm),
        const SizedBox(height: AppTheme.spacingMd),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: _service.getAttendanceHistory(),
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

            final history = snapshot.data ?? [];

            if (history.isEmpty) {
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
                      Icons.history_rounded,
                      size: 48,
                      color: AppTheme.neutral300,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    Text(
                      'Belum ada riwayat absensi',
                      style: AppTheme.bodyMd.copyWith(color: AppTheme.neutral500),
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
                itemCount: history.length > 10 ? 10 : history.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: AppTheme.neutral100,
                ),
                itemBuilder: (context, index) {
                  final item = history[index];
                  final isCheckIn = (item['type'] as String?) == 'Masuk';

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (isCheckIn ? AppTheme.success : AppTheme.warning)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: Icon(
                        isCheckIn ? Icons.login_rounded : Icons.logout_rounded,
                        color: isCheckIn ? AppTheme.success : AppTheme.warning,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      isCheckIn ? 'Check In' : 'Check Out',
                      style: AppTheme.labelLg,
                    ),
                    subtitle: Text(
                      (item['date'] as String?) ?? '',
                      style: AppTheme.bodySm,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          (item['time'] as String?) ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor((item['status'] as String?) ?? '')
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            (item['status'] as String?) ?? '',
                            style: AppTheme.labelSm.copyWith(
                              color: _getStatusColor((item['status'] as String?) ?? ''),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hadir':
        return AppTheme.success;
      case 'Terlambat':
        return AppTheme.warning;
      case 'Selesai':
        return AppTheme.primary;
      default:
        return AppTheme.neutral500;
    }
  }

  Widget _buildSuccessOverlay() {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return ColoredBox(
          color: Colors.black.withValues(alpha: 0.4),
          child: Center(
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: Container(
                margin: const EdgeInsets.all(AppTheme.spacingXl),
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                  boxShadow: AppTheme.shadowLg,
                ),
                child: Column(
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
                        size: 64,
                        color: AppTheme.success,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    Text(
                      _successMessage,
                      style: AppTheme.headingMd,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text(
                      _currentTime,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum AttendanceState {
  notCheckedIn,
  checkedIn,
  completed,
}
