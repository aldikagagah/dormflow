/// Test helpers dan mocks untuk DormFlow Mobile
library;

// ignore_for_file: subtype_of_sealed_class
// Note: Firestore classes are sealed but we need to mock them for testing.
// This is a known limitation with cloud_firestore and mocktail.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mocktail/mocktail.dart';

// ============ FIREBASE MOCKS ============

/// Mock untuk FirebaseAuth
class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

/// Mock untuk FirebaseUser
class MockFirebaseUser extends Mock implements fb.User {}

/// Mock untuk UserCredential
class MockUserCredential extends Mock implements fb.UserCredential {}

/// Mock untuk UserMetadata
class MockUserMetadata extends Mock implements fb.UserMetadata {}

/// Mock untuk FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

/// Mock untuk CollectionReference
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

/// Mock untuk DocumentReference
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

/// Mock untuk DocumentSnapshot
class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

/// Mock untuk QuerySnapshot
class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

/// Mock untuk QueryDocumentSnapshot
class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

/// Mock untuk Query
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

// ============ TEST DATA ============

/// Test data constants
class TestData {
  TestData._();

  static const String testUid = 'test-user-id-123';
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'Password123';
  static const String testName = 'Test User';
  static const String testPhone = '081234567890';
  static const String testAddress = 'Jl. Test No. 123';

  /// Create a mock Firebase user with default or custom values
  static MockFirebaseUser createMockUser({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? creationTime,
  }) {
    final mockUser = MockFirebaseUser();
    final mockMetadata = MockUserMetadata();

    when(() => mockUser.uid).thenReturn(uid ?? testUid);
    when(() => mockUser.email).thenReturn(email ?? testEmail);
    when(() => mockUser.displayName).thenReturn(displayName ?? testName);
    when(() => mockUser.photoURL).thenReturn(photoURL);
    when(() => mockUser.metadata).thenReturn(mockMetadata);
    when(() => mockMetadata.creationTime)
        .thenReturn(creationTime ?? DateTime.now());

    return mockUser;
  }

  /// Create a mock UserCredential
  static MockUserCredential createMockCredential({
    MockFirebaseUser? user,
  }) {
    final mockCredential = MockUserCredential();
    when(() => mockCredential.user).thenReturn(user ?? createMockUser());
    return mockCredential;
  }
}

// ============ FAKE CLASSES ============

/// Fake untuk AuthCredential (required untuk registerFallbackValue)
class FakeAuthCredential extends Fake implements fb.AuthCredential {}

/// Setup fallback values untuk mocktail
void setupTestFallbackValues() {
  registerFallbackValue(FakeAuthCredential());
}
