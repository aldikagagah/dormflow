import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/schedule_service.dart';
import '../widgets/add_schedule_form.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleService _service = ScheduleService();
  DateTime _selectedDate = DateTime.now();
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _weekStart = _service.getStartOfWeek(_selectedDate);
  }

  List<DateTime> get _weekDays {
    return List.generate(7, (i) => _weekStart.add(Duration(days: i)));
  }

  void _previousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
      _selectedDate = _weekStart;
    });
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
      _selectedDate = _weekStart;
    });
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday = _selectedDate.year == today.year &&
        _selectedDate.month == today.month &&
        _selectedDate.day == today.day;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Jadwal Kegiatan',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
                                DateFormat('MMM yyyy').format(_weekStart),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Week Calendar
          SliverToBoxAdapter(
            child: _buildWeekCalendar(today),
          ),

          // Selected Date Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppTheme.primary.withValues(alpha: 0.1)
                          : AppTheme.neutral100,
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isToday) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          isToday
                              ? 'Hari Ini'
                              : DateFormat('EEEE, dd MMM').format(_selectedDate),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isToday ? AppTheme.primary : AppTheme.neutral700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Schedule List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
            sliver: _buildScheduleList(),
          ),

          // Bottom Spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSchedule(),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
      ),
    );
  }

  Widget _buildWeekCalendar(DateTime today) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        children: [
          // Week Navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousWeek,
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: AppTheme.neutral600,
                ),
                Text(
                  'Minggu ${_getWeekOfMonth(_weekStart)}',
                  style: AppTheme.labelLg,
                ),
                IconButton(
                  onPressed: _nextWeek,
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: AppTheme.neutral600,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Day Cards
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              itemCount: _weekDays.length,
              itemBuilder: (context, index) {
                final day = _weekDays[index];
                return _buildDayCard(day, today);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(DateTime day, DateTime today) {
    final isSelected = day.year == _selectedDate.year &&
        day.month == _selectedDate.month &&
        day.day == _selectedDate.day;
    final isToday = day.year == today.year &&
        day.month == today.month &&
        day.day == today.day;

    return GestureDetector(
      onTap: () => _selectDate(day),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : isToday
                  ? AppTheme.primary.withValues(alpha: 0.1)
                  : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: isToday && !isSelected
              ? Border.all(color: AppTheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(day).substring(0, 3).toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppTheme.neutral500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              day.day.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppTheme.neutral800,
              ),
            ),
            if (isToday) ...[
              const SizedBox(height: 4),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getWeekOfMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final dayOfMonth = date.day;
    return ((dayOfMonth + firstDayWeekday - 2) / 7).floor() + 1;
  }

  Widget _buildScheduleList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _service.getSchedulesForDate(_selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacingXl),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final schedules = snapshot.data ?? [];

        if (schedules.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: AppTheme.shadowSm,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 64,
                    color: AppTheme.neutral300,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Tidak ada jadwal',
                    style: AppTheme.headingSm.copyWith(color: AppTheme.neutral500),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    'Tambahkan jadwal baru dengan tombol + di bawah',
                    style: AppTheme.bodySm,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final schedule = schedules[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                child: _buildScheduleCard(schedule),
              );
            },
            childCount: schedules.length,
          ),
        );
      },
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    final category = schedule['category'] ?? '';
    final status = schedule['status'] ?? 'Pending';
    final isCompleted = status == 'Selesai';

    Color categoryColor;
    IconData categoryIcon;

    switch (category) {
      case 'Piket':
        categoryColor = AppTheme.secondary;
        categoryIcon = Icons.cleaning_services_rounded;
        break;
      case 'Ngaji':
        categoryColor = AppTheme.primary;
        categoryIcon = Icons.menu_book_rounded;
        break;
      case 'Pemateri':
        categoryColor = Colors.purple;
        categoryIcon = Icons.mic_rounded;
        break;
      default:
        categoryColor = AppTheme.neutral500;
        categoryIcon = Icons.event_note_rounded;
    }

    return Dismissible(
      key: Key(schedule['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.error,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(schedule['id']),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.shadowSm,
          border: Border(
            left: BorderSide(color: categoryColor, width: 4),
          ),
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 26),
            ),
            const SizedBox(width: AppTheme.spacingMd),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Text(
                          category,
                          style: AppTheme.labelSm.copyWith(color: categoryColor),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.success.withValues(alpha: 0.1)
                              : AppTheme.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Text(
                          status,
                          style: AppTheme.labelSm.copyWith(
                            color: isCompleted ? AppTheme.success : AppTheme.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    schedule['taskName'] ?? '',
                    style: AppTheme.headingSm,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: AppTheme.neutral500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        schedule['assignedMemberName'] ?? '',
                        style: AppTheme.bodySm,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Complete Button
            if (!isCompleted)
              IconButton(
                onPressed: () => _markComplete(schedule['id']),
                icon: const Icon(Icons.check_circle_outline_rounded),
                color: AppTheme.success,
              ),
          ],
        ),
      ),
    );
  }

  void _showAddSchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddScheduleForm(
        onSaved: () {
          // Stream will auto-update
        },
      ),
    );
  }

  Future<void> _markComplete(String id) async {
    await _service.markAsCompleted(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Jadwal ditandai selesai! ✓'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
    }
  }

  Future<bool> _confirmDelete(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Text('Hapus Jadwal'),
        content: const Text('Yakin ingin menghapus jadwal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, true);
              await _service.deleteSchedule(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
