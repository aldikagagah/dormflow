/// Unit tests for AttendanceModel
library;

import 'package:dormflow_mobile/data/models/attendance_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AttendanceType', () {
    test('should have correct values', () {
      expect(AttendanceType.masuk.name, 'masuk');
      expect(AttendanceType.keluar.name, 'keluar');
    });
  });

  group('AttendanceStatus', () {
    test('should have correct values', () {
      expect(AttendanceStatus.hadir.name, 'hadir');
      expect(AttendanceStatus.terlambat.name, 'terlambat');
      expect(AttendanceStatus.selesai.name, 'selesai');
      expect(AttendanceStatus.belumAbsen.name, 'belumAbsen');
    });
  });

  group('AttendanceModel', () {
    late AttendanceModel attendance;
    late DateTime testTimestamp;

    setUp(() {
      testTimestamp = DateTime(2026, 1, 15, 8, 30);
      attendance = AttendanceModel(
        id: 'attendance-123',
        userId: 'user-1',
        userEmail: 'user@example.com',
        type: AttendanceType.masuk,
        timestamp: testTimestamp,
        date: '2026-01-15',
        status: AttendanceStatus.hadir,
        localTime: '2026-01-15T08:30:00+07:00',
      );
    });

    test('should create a valid AttendanceModel', () {
      expect(attendance.id, 'attendance-123');
      expect(attendance.userId, 'user-1');
      expect(attendance.userEmail, 'user@example.com');
      expect(attendance.type, AttendanceType.masuk);
      expect(attendance.timestamp, testTimestamp);
      expect(attendance.date, '2026-01-15');
      expect(attendance.status, AttendanceStatus.hadir);
    });

    test('formattedTime should return HH:mm format', () {
      expect(attendance.formattedTime, '08:30');
    });

    test('formattedDate should return readable date', () {
      expect(attendance.formattedDate, '15 Jan 2026');
    });

    test('formattedTime12h should return 12-hour format', () {
      expect(attendance.formattedTime12h, contains('AM'));
    });

    test('toJson should work correctly', () {
      final json = attendance.toJson();
      expect(json['id'], 'attendance-123');
      expect(json['userId'], 'user-1');
      expect(json['userEmail'], 'user@example.com');
    });

    test('fromJson should work correctly', () {
      final json = {
        'id': 'test-id',
        'userId': 'user-test',
        'type': 'Masuk',
        'timestamp': '2026-01-15T08:30:00.000',
        'date': '2026-01-15',
        'status': 'Hadir',
      };
      final model = AttendanceModel.fromJson(json);
      expect(model.id, 'test-id');
      expect(model.userId, 'user-test');
    });

    test('should handle AttendanceType.keluar', () {
      final checkOut = attendance.copyWith(type: AttendanceType.keluar);
      expect(checkOut.type, AttendanceType.keluar);
    });

    test('should handle all status types', () {
      final terlambat = attendance.copyWith(status: AttendanceStatus.terlambat);
      expect(terlambat.status, AttendanceStatus.terlambat);

      final selesai = attendance.copyWith(status: AttendanceStatus.selesai);
      expect(selesai.status, AttendanceStatus.selesai);

      final belumAbsen = attendance.copyWith(status: AttendanceStatus.belumAbsen);
      expect(belumAbsen.status, AttendanceStatus.belumAbsen);
    });
  });

  group('TodayAttendanceStatus', () {
    test('should create with default values', () {
      const status = TodayAttendanceStatus();
      expect(status.checkInTime, isNull);
      expect(status.checkOutTime, isNull);
      expect(status.status, AttendanceStatus.belumAbsen);
      expect(status.hasCheckedIn, false);
      expect(status.hasCheckedOut, false);
    });

    test('should create with check-in data', () {
      const status = TodayAttendanceStatus(
        checkInTime: '08:00',
        hasCheckedIn: true,
        status: AttendanceStatus.hadir,
      );
      expect(status.checkInTime, '08:00');
      expect(status.hasCheckedIn, true);
      expect(status.status, AttendanceStatus.hadir);
    });

    test('should create with complete attendance', () {
      const status = TodayAttendanceStatus(
        checkInTime: '08:00',
        checkOutTime: '17:00',
        hasCheckedIn: true,
        hasCheckedOut: true,
        status: AttendanceStatus.selesai,
      );
      expect(status.checkInTime, '08:00');
      expect(status.checkOutTime, '17:00');
      expect(status.hasCheckedIn, true);
      expect(status.hasCheckedOut, true);
      expect(status.status, AttendanceStatus.selesai);
    });

    test('toJson and fromJson should work correctly', () {
      const status = TodayAttendanceStatus(
        checkInTime: '09:00',
        hasCheckedIn: true,
        status: AttendanceStatus.terlambat,
      );

      final json = status.toJson();
      expect(json['checkInTime'], '09:00');
      expect(json['hasCheckedIn'], true);

      final restored = TodayAttendanceStatus.fromJson(json);
      expect(restored.checkInTime, status.checkInTime);
      expect(restored.hasCheckedIn, status.hasCheckedIn);
    });
  });
}
