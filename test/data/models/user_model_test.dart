/// Unit tests for UserModel
library;

import 'package:dormflow_mobile/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    late UserModel user;
    late DateTime createdAt;
    late DateTime updatedAt;

    setUp(() {
      createdAt = DateTime(2026);
      updatedAt = DateTime(2026, 1, 15);
      user = UserModel(
        uid: 'user-123',
        email: 'john.doe@example.com',
        name: 'John Doe',
        photoUrl: 'https://example.com/photo.jpg',
        phone: '081234567890',
        address: 'Jl. Contoh No. 123',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    });

    test('should create a valid UserModel', () {
      expect(user.uid, 'user-123');
      expect(user.email, 'john.doe@example.com');
      expect(user.name, 'John Doe');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.phone, '081234567890');
      expect(user.address, 'Jl. Contoh No. 123');
      expect(user.role, 'Admin');
      expect(user.createdAt, createdAt);
      expect(user.updatedAt, updatedAt);
    });

    test('should have correct default values', () {
      const minimalUser = UserModel(
        uid: 'user-minimal',
        email: 'minimal@example.com',
      );
      expect(minimalUser.name, '');
      expect(minimalUser.photoUrl, isNull);
      expect(minimalUser.phone, '');
      expect(minimalUser.address, '');
      expect(minimalUser.role, 'Admin');
      expect(minimalUser.createdAt, isNull);
      expect(minimalUser.updatedAt, isNull);
    });

    group('hasCompleteProfile', () {
      test('should return true when name and phone are filled', () {
        expect(user.hasCompleteProfile, true);
      });

      test('should return false when name is empty', () {
        final incompleteUser = user.copyWith(name: '');
        expect(incompleteUser.hasCompleteProfile, false);
      });

      test('should return false when phone is empty', () {
        final incompleteUser = user.copyWith(phone: '');
        expect(incompleteUser.hasCompleteProfile, false);
      });

      test('should return false when both name and phone are empty', () {
        final incompleteUser = user.copyWith(name: '', phone: '');
        expect(incompleteUser.hasCompleteProfile, false);
      });
    });

    group('initials', () {
      test('should return two letter initials for full name', () {
        expect(user.initials, 'JD');
      });

      test('should return single initial for single name', () {
        final singleNameUser = user.copyWith(name: 'John');
        expect(singleNameUser.initials, 'J');
      });

      test('should return first letter of email when name is empty', () {
        final noNameUser = user.copyWith(name: '');
        expect(noNameUser.initials, 'J'); // from john.doe@example.com
      });

      test('should return ? when both name and email are empty', () {
        const emptyUser = UserModel(uid: 'user', email: '');
        expect(emptyUser.initials, '?');
      });

      test('should handle name with multiple words', () {
        final multiNameUser = user.copyWith(name: 'John Michael Doe');
        expect(multiNameUser.initials, 'JM');
      });

      test('should return uppercase initials', () {
        final lowerNameUser = user.copyWith(name: 'john doe');
        expect(lowerNameUser.initials, 'JD');
      });

      test('should handle name with leading/trailing spaces', () {
        final spacedNameUser = user.copyWith(name: '  John Doe  ');
        expect(spacedNameUser.initials, 'JD');
      });
    });

    group('JSON serialization', () {
      test('toJson should work correctly', () {
        final json = user.toJson();
        expect(json['uid'], 'user-123');
        expect(json['email'], 'john.doe@example.com');
        expect(json['name'], 'John Doe');
        expect(json['photoUrl'], 'https://example.com/photo.jpg');
        expect(json['phone'], '081234567890');
        expect(json['address'], 'Jl. Contoh No. 123');
        expect(json['role'], 'Admin');
      });

      test('fromJson should work correctly', () {
        final json = {
          'uid': 'test-user',
          'email': 'test@example.com',
          'name': 'Test User',
          'phone': '081234567890',
          'address': 'Test Address',
          'role': 'Member',
        };
        final model = UserModel.fromJson(json);
        expect(model.uid, 'test-user');
        expect(model.email, 'test@example.com');
        expect(model.name, 'Test User');
        expect(model.role, 'Member');
      });

      test('round-trip JSON serialization should preserve data', () {
        final json = user.toJson();
        final restored = UserModel.fromJson(json);
        expect(restored.uid, user.uid);
        expect(restored.email, user.email);
        expect(restored.name, user.name);
        expect(restored.phone, user.phone);
        expect(restored.address, user.address);
        expect(restored.role, user.role);
      });
    });

    group('copyWith', () {
      test('should create a copy with updated fields', () {
        final updatedUser = user.copyWith(
          name: 'Jane Doe',
          phone: '089876543210',
        );
        expect(updatedUser.uid, user.uid); // unchanged
        expect(updatedUser.email, user.email); // unchanged
        expect(updatedUser.name, 'Jane Doe'); // changed
        expect(updatedUser.phone, '089876543210'); // changed
      });

      test('should allow setting photoUrl to null', () {
        final updatedUser = user.copyWith(photoUrl: null);
        expect(updatedUser.photoUrl, isNull);
      });

      test('should allow updating role', () {
        final updatedUser = user.copyWith(role: 'Member');
        expect(updatedUser.role, 'Member');
      });
    });

    group('role handling', () {
      test('should handle Admin role', () {
        expect(user.role, 'Admin');
      });

      test('should handle Member role', () {
        final memberUser = user.copyWith(role: 'Member');
        expect(memberUser.role, 'Member');
      });

      test('should handle custom roles', () {
        final customUser = user.copyWith(role: 'SuperAdmin');
        expect(customUser.role, 'SuperAdmin');
      });
    });
  });
}
