/// Unit tests for ScheduleModel
library;

import 'package:dormflow_mobile/data/models/schedule_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScheduleCategory', () {
    test('should have correct label for each category', () {
      expect(ScheduleCategory.piket.label, 'Piket');
      expect(ScheduleCategory.ngaji.label, 'Ngaji');
      expect(ScheduleCategory.pemateri.label, 'Pemateri');
      expect(ScheduleCategory.rapat.label, 'Rapat');
      expect(ScheduleCategory.kegiatan.label, 'Kegiatan');
      expect(ScheduleCategory.lainnya.label, 'Lainnya');
    });
  });

  group('ScheduleModel', () {
    late ScheduleModel schedule;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2026, 1, 15, 10);
      schedule = ScheduleModel(
        id: 'test-id-123',
        taskName: 'Piket Pagi',
        category: 'Piket',
        assignedMemberId: 'member-1',
        assignedMemberName: 'John Doe',
        date: testDate,
        dateString: '2026-01-15',
        weekNumber: 3,
        createdBy: 'admin-1',
      );
    });

    test('should create a valid ScheduleModel', () {
      expect(schedule.id, 'test-id-123');
      expect(schedule.taskName, 'Piket Pagi');
      expect(schedule.category, 'Piket');
      expect(schedule.assignedMemberId, 'member-1');
      expect(schedule.assignedMemberName, 'John Doe');
      expect(schedule.date, testDate);
      expect(schedule.dateString, '2026-01-15');
      expect(schedule.weekNumber, 3);
      expect(schedule.status, ScheduleStatus.pending);
      expect(schedule.createdBy, 'admin-1');
    });

    test('formattedDate should return readable date format', () {
      expect(schedule.formattedDate, '15 Jan 2026');
    });

    test('shortDate should return short date format', () {
      expect(schedule.shortDate, '15/01');
    });

    test('isCompleted should return correct value', () {
      expect(schedule.isCompleted, false);

      final completedSchedule = schedule.copyWith(
        status: ScheduleStatus.selesai,
      );
      expect(completedSchedule.isCompleted, true);
    });

    test('isPast should return true for past dates', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 5));
      final pastSchedule = schedule.copyWith(date: pastDate);
      expect(pastSchedule.isPast, true);
    });

    test('isPast should return false for future dates', () {
      final futureDate = DateTime.now().add(const Duration(days: 5));
      final futureSchedule = schedule.copyWith(date: futureDate);
      expect(futureSchedule.isPast, false);
    });

    test('isToday should return true for today\'s date', () {
      final now = DateTime.now();
      final todaySchedule = schedule.copyWith(
        date: DateTime(now.year, now.month, now.day, 12),
      );
      expect(todaySchedule.isToday, true);
    });

    test('isToday should return false for other dates', () {
      final tomorrowDate = DateTime.now().add(const Duration(days: 1));
      final tomorrowSchedule = schedule.copyWith(date: tomorrowDate);
      expect(tomorrowSchedule.isToday, false);
    });

    test('toJson and fromJson should work correctly', () {
      final json = schedule.toJson();
      expect(json['id'], 'test-id-123');
      expect(json['taskName'], 'Piket Pagi');
      expect(json['category'], 'Piket');
    });

    test('should default to pending status', () {
      final defaultSchedule = ScheduleModel(
        id: 'test-2',
        taskName: 'Test Task',
        category: 'Lainnya',
        assignedMemberId: 'member-2',
        assignedMemberName: 'Jane Doe',
        date: testDate,
        dateString: '2026-01-15',
        weekNumber: 3,
      );
      expect(defaultSchedule.status, ScheduleStatus.pending);
    });
  });

  group('MemberModel', () {
    test('should create a valid MemberModel', () {
      const member = MemberModel(
        id: 'member-123',
        name: 'John Doe',
        email: 'john@example.com',
      );

      expect(member.id, 'member-123');
      expect(member.name, 'John Doe');
      expect(member.email, 'john@example.com');
    });

    test('email should default to empty string', () {
      const member = MemberModel(
        id: 'member-456',
        name: 'Jane Doe',
      );

      expect(member.email, '');
    });

    test('toJson and fromJson should work correctly', () {
      const member = MemberModel(
        id: 'member-789',
        name: 'Test User',
        email: 'test@example.com',
      );

      final json = member.toJson();
      expect(json['id'], 'member-789');
      expect(json['name'], 'Test User');
      expect(json['email'], 'test@example.com');

      final restored = MemberModel.fromJson(json);
      expect(restored.id, member.id);
      expect(restored.name, member.name);
      expect(restored.email, member.email);
    });
  });
}
