/// Integration Test Robot
///
/// Helper class untuk mempermudah penulisan integration test
/// dengan pola Page Object Model.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot helper untuk integration testing
class AppRobot {
  AppRobot(this.tester);

  final WidgetTester tester;

  // ===== GENERAL HELPERS =====

  /// Wait for app to settle
  Future<void> waitForApp() async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// Wait for loading to complete
  Future<void> waitForLoading() async {
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  /// Tap widget by key
  Future<void> tapByKey(String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  /// Tap widget by text
  Future<void> tapByText(String text) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  /// Enter text in field by key
  Future<void> enterTextByKey(String key, String text) async {
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pumpAndSettle();
  }

  /// Verify text is visible
  void expectTextVisible(String text) {
    expect(find.text(text), findsWidgets);
  }

  /// Verify text is not visible
  void expectTextNotVisible(String text) {
    expect(find.text(text), findsNothing);
  }

  /// Verify widget by key is visible
  void expectWidgetByKey(String key) {
    expect(find.byKey(Key(key)), findsOneWidget);
  }

  // ===== AUTH ROBOT =====

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Find email field
    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, email);

    // Find password field
    final passwordField = find.byType(TextFormField).at(1);
    await tester.enterText(passwordField, password);

    await tester.pumpAndSettle();

    // Tap login button
    final loginButton = find.text('Masuk');
    await tester.tap(loginButton);

    await waitForLoading();
  }

  /// Register new account
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Tap register link
    await tapByText('Daftar');
    await waitForApp();

    // Fill form
    final nameField = find.byType(TextFormField).first;
    await tester.enterText(nameField, name);

    final emailField = find.byType(TextFormField).at(1);
    await tester.enterText(emailField, email);

    final passwordField = find.byType(TextFormField).at(2);
    await tester.enterText(passwordField, password);

    final confirmField = find.byType(TextFormField).at(3);
    await tester.enterText(confirmField, password);

    await tester.pumpAndSettle();

    // Tap register button
    await tapByText('Daftar');
    await waitForLoading();
  }

  /// Logout
  Future<void> logout() async {
    // Go to profile
    await navigateToProfile();

    // Tap logout
    await tapByText('Keluar');
    await waitForApp();

    // Confirm
    await tapByText('Ya');
    await waitForLoading();
  }

  // ===== NAVIGATION ROBOT =====

  /// Navigate to Dashboard tab
  Future<void> navigateToDashboard() async {
    final dashboardIcon = find.byIcon(Icons.home).first;
    await tester.tap(dashboardIcon);
    await tester.pumpAndSettle();
  }

  /// Navigate to Finance tab
  Future<void> navigateToFinance() async {
    final financeIcon = find.byIcon(Icons.account_balance_wallet);
    await tester.tap(financeIcon);
    await tester.pumpAndSettle();
  }

  /// Navigate to Attendance tab
  Future<void> navigateToAttendance() async {
    final attendanceIcon = find.byIcon(Icons.calendar_today);
    await tester.tap(attendanceIcon);
    await tester.pumpAndSettle();
  }

  /// Navigate to Schedule tab
  Future<void> navigateToSchedule() async {
    final scheduleIcon = find.byIcon(Icons.schedule);
    await tester.tap(scheduleIcon);
    await tester.pumpAndSettle();
  }

  /// Navigate to Profile tab
  Future<void> navigateToProfile() async {
    final profileIcon = find.byIcon(Icons.person);
    await tester.tap(profileIcon);
    await tester.pumpAndSettle();
  }

  // ===== FINANCE ROBOT =====

  /// Add transaction
  Future<void> addTransaction({
    required bool isIncome,
    required String amount,
    required String category,
    String? description,
  }) async {
    // Tap FAB
    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Select type
    if (isIncome) {
      await tapByText('Pemasukan');
    } else {
      await tapByText('Pengeluaran');
    }

    // Enter amount
    final amountField = find.byType(TextFormField).first;
    await tester.enterText(amountField, amount);

    // Select category
    await tapByText(category);

    // Add description if provided
    if (description != null) {
      final descField = find.byType(TextFormField).last;
      await tester.enterText(descField, description);
    }

    // Save
    await tapByText('Simpan');
    await waitForLoading();
  }

  // ===== SCHEDULE ROBOT =====

  /// Add schedule
  Future<void> addSchedule({
    required String taskName,
    required String category,
    required String memberName,
  }) async {
    // Tap FAB
    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Select task
    await tapByText(taskName);

    // Select category
    await tapByText(category);

    // Select member
    await tapByText(memberName);

    // Save
    await tapByText('Simpan');
    await waitForLoading();
  }

  // ===== ATTENDANCE ROBOT =====

  /// Check in
  Future<void> checkIn() async {
    await tapByText('Check In');
    await waitForLoading();
  }

  /// Check out
  Future<void> checkOut() async {
    await tapByText('Check Out');
    await waitForLoading();
  }

  // ===== PROFILE ROBOT =====

  /// Edit profile name
  Future<void> editProfileName(String newName) async {
    await tapByText('Edit Profil');
    await waitForApp();

    // Clear and enter new name
    final nameField = find.byType(TextFormField).first;
    await tester.enterText(nameField, newName);

    // Save
    await tapByText('Simpan');
    await waitForLoading();
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    final themeButton = find.byIcon(Icons.light_mode);
    await tester.tap(themeButton);
    await tester.pumpAndSettle();

    await tapByText('Gelap');
    await tester.pumpAndSettle();
  }
}
