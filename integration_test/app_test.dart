/// Main Integration Test Suite
///
/// Run: flutter test integration_test/app_test.dart
/// Or: flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart
library;

import 'package:dormflow_mobile/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'robots/app_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DormFlow Mobile Integration Tests', () {
    late AppRobot robot;

    // Test credentials (use test account)
    const testEmail = 'test@dormflow.com';
    const testPassword = 'Test123456';
    // ignore: unused_local_variable
    const testName = 'Test User';

    // ========================================
    // 1. AUTHENTICATION TESTS
    // ========================================
    group('Authentication', () {
      testWidgets('IT-AUTH-001: Login with valid credentials', (tester) async {
        // Arrange
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();

        // Act
        await robot.login(email: testEmail, password: testPassword);

        // Assert - Should see dashboard
        robot.expectTextVisible('Selamat');
      });

      testWidgets('IT-AUTH-002: Login with invalid credentials', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();

        // Act
        await robot.login(email: 'wrong@email.com', password: 'wrongpass');

        // Assert - Should see error
        robot.expectTextVisible('Email atau password salah');
      });

      testWidgets('IT-AUTH-003: Login validation - empty fields', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();

        // Act - Try to login with empty fields
        await robot.tapByText('Masuk');
        await robot.waitForApp();

        // Assert - Should see validation error
        robot.expectTextVisible('wajib diisi');
      });

      testWidgets('IT-AUTH-004: Logout flow', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();

        // Login first
        await robot.login(email: testEmail, password: testPassword);

        // Act - Logout
        await robot.logout();

        // Assert - Should be back at login
        robot.expectTextVisible('Masuk');
      });
    });

    // ========================================
    // 2. DASHBOARD TESTS
    // ========================================
    group('Dashboard', () {
      testWidgets('IT-DASH-001: Load dashboard after login', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);

        // Assert - Dashboard components visible
        robot.expectTextVisible('Selamat');
      });

      testWidgets('IT-DASH-002: Navigate to all tabs', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);

        // Navigate to Finance
        await robot.navigateToFinance();
        robot.expectTextVisible('Keuangan');

        // Navigate to Schedule
        await robot.navigateToSchedule();
        robot.expectTextVisible('Jadwal');

        // Navigate to Profile
        await robot.navigateToProfile();
        robot.expectTextVisible('Profil');

        // Back to Dashboard
        await robot.navigateToDashboard();
        robot.expectTextVisible('Selamat');
      });
    });

    // ========================================
    // 3. FINANCE TESTS
    // ========================================
    group('Finance', () {
      testWidgets('IT-FIN-001: Add income transaction', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);
        await robot.navigateToFinance();

        // Act
        await robot.addTransaction(
          isIncome: true,
          amount: '100000',
          category: 'Gaji',
          description: 'Test income',
        );

        // Assert
        robot.expectTextVisible('100.000');
      });

      testWidgets('IT-FIN-002: Add expense transaction', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);
        await robot.navigateToFinance();

        // Act
        await robot.addTransaction(
          isIncome: false,
          amount: '50000',
          category: 'Makan',
          description: 'Test expense',
        );

        // Assert
        robot.expectTextVisible('50.000');
      });

      testWidgets('IT-FIN-003: View transaction list', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);
        await robot.navigateToFinance();

        // Assert - Should show transaction list or empty state
        // List will have summary cards at minimum
        expect(find.byType(Card), findsWidgets);
      });
    });

    // ========================================
    // 4. ATTENDANCE TESTS
    // ========================================
    group('Attendance', () {
      testWidgets('IT-ATT-001: View attendance status', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);
        await robot.navigateToAttendance();

        // Assert - Should show attendance UI
        robot.expectTextVisible('Kehadiran');
      });

      // Note: Check-in/out tests would need mock time or test-specific logic
    });

    // ========================================
    // 5. SCHEDULE TESTS
    // ========================================
    group('Schedule', () {
      testWidgets('IT-SCH-001: View schedule list', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);
        await robot.navigateToSchedule();

        // Assert - Should show schedule UI
        robot.expectTextVisible('Jadwal');
      });
    });

    // ========================================
    // 6. PROFILE TESTS
    // ========================================
    group('Profile', () {
      testWidgets('IT-PRF-001: View profile', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);
        await robot.navigateToProfile();

        // Assert
        robot.expectTextVisible('Profil');
        robot.expectTextVisible(testEmail);
      });

      testWidgets('IT-PRF-002: Edit profile name', (tester) async {
        app.main();
        robot = AppRobot(tester);
        await robot.waitForApp();
        await robot.login(email: testEmail, password: testPassword);
        await robot.navigateToProfile();

        // Act
        await robot.editProfileName('Updated Name');

        // Assert
        robot.expectTextVisible('Updated Name');
      });
    });
  });
}
