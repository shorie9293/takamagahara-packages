import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takamagahara_identity/takamagahara_identity.dart';

void main() {
  late UuidBridge bridge;
  late UniversalId testId;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    bridge = UuidBridge();
    testId = UniversalId.parse('550e8400-e29b-41d4-a716-446655440000');
  });

  group('UuidBridge', () {
    group('saveUuid', () {
      test('saves UUID successfully', () async {
        final result = await bridge.saveUuid(testId);
        expect(result, isTrue);
      });
    });

    group('loadUuid', () {
      test('loads previously saved UUID', () async {
        await bridge.saveUuid(testId);
        final loaded = await bridge.loadUuid();
        expect(loaded, equals(testId));
      });

      test('returns null when no UUID saved', () async {
        final loaded = await bridge.loadUuid();
        expect(loaded, isNull);
      });

      test('returns null for corrupted UUID', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('takamagahara_universal_id', 'not-a-uuid');
        final loaded = await bridge.loadUuid();
        expect(loaded, isNull);
      });
    });

    group('exists', () {
      test('returns true after save', () async {
        expect(await bridge.exists(), isFalse);
        await bridge.saveUuid(testId);
        expect(await bridge.exists(), isTrue);
      });

      test('returns false after remove', () async {
        await bridge.saveUuid(testId);
        await bridge.removeUuid();
        expect(await bridge.exists(), isFalse);
      });
    });

    group('removeUuid', () {
      test('removes UUID successfully', () async {
        await bridge.saveUuid(testId);
        final result = await bridge.removeUuid();
        expect(result, isTrue);
        expect(await bridge.loadUuid(), isNull);
      });

      test('remove when no UUID exists returns true', () async {
        final result = await bridge.removeUuid();
        expect(result, isTrue);
      });
    });

    test('cross-app sharing: save in one, load in another', () async {
      // Simulate App A saving the UUID
      final bridgeA = UuidBridge();
      await bridgeA.saveUuid(testId);

      // Simulate App B loading the UUID (same SharedPreferences, new bridge)
      final bridgeB = UuidBridge();
      final loaded = await bridgeB.loadUuid();
      expect(loaded, equals(testId));
    });
  });
}
