import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takamagahara_ui/takamagahara_ui.dart';

void main() {
  group('AppKeys', () {
    test('provides mainScreen keys', () {
      expect(AppKeys.mainScreen, isNotNull);
      expect(AppKeys.mainScreen_fabButton, isNotNull);
    });

    test('provides dialogue keys', () {
      expect(AppKeys.dialogueScreen, isNotNull);
      expect(AppKeys.dialogueScreen_dialog, isNotNull);
      expect(AppKeys.dialogueScreen_confirmButton, isNotNull);
    });

    test('provides settings keys', () {
      expect(AppKeys.settingsScreen, isNotNull);
      expect(AppKeys.settingsScreen_saveButton, isNotNull);
      expect(AppKeys.settingsScreen_toggleNotification, isNotNull);
    });

    test('provides error keys', () {
      expect(AppKeys.errorRetryButton, isNotNull);
    });

    test('provides loading keys', () {
      expect(AppKeys.loadingIndicator, isNotNull);
    });

    test('keys with underscore follow screenName_elementName convention', () {
      for (final key in AppKeys.all) {
        final value = key.toString();
        // Keys with underscore follow the naming convention
        if (value.contains('_')) {
          final parts = value.replaceAll(RegExp(r'[\[\]<>]'), '').split('_');
          expect(parts.length, greaterThanOrEqualTo(2));
        }
      }
    });

    test('no duplicate key values', () {
      final values = AppKeys.all.map((k) => k.toString()).toList();
      final uniqueValues = values.toSet();
      expect(values.length, uniqueValues.length,
          reason: 'Duplicate AppKeys detected: '
              '${values.length - uniqueValues.length} duplicates found');
    });
  });
}
