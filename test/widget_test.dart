/// Basic smoke tests for DormFlow Mobile
///
/// These tests verify basic functionality without Firebase initialization.
library;

import 'package:dormflow_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DormFlow Mobile Smoke Tests', () {
    testWidgets('AppTheme should provide valid light theme', (
      WidgetTester tester,
    ) async {
      // Build a simple MaterialApp with light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      // Verify MaterialApp is rendered
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);

      // Verify theme colors
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
      expect(app.theme?.primaryColor, AppTheme.primary);
    });

    testWidgets('AppTheme should provide valid dark theme', (
      WidgetTester tester,
    ) async {
      // Build a simple MaterialApp with dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Text('Dark Mode'),
          ),
        ),
      );

      // Verify MaterialApp is rendered
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);

      // Verify dark theme brightness
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.brightness, Brightness.dark);
    });

    test('AppTheme constants should be valid', () {
      // Verify color constants
      expect(AppTheme.primary, const Color(0xFF4F46E5));
      expect(AppTheme.success, const Color(0xFF22C55E));
      expect(AppTheme.error, const Color(0xFFEF4444));

      // Verify spacing constants
      expect(AppTheme.spacingMd, 16.0);
      expect(AppTheme.radiusMd, 12.0);
    });
  });
}
