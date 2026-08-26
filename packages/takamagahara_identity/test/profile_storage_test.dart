import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:takamagahara_identity/takamagahara_identity.dart';

void main() {
  late String tempDir;
  late HiveProfileStorage storage;
  late UniversalProfile testProfile;

  setUp(() async {
    // Create temp directory for Hive
    tempDir = Directory.systemTemp.createTempSync('hive_test_').path;
    Hive.init(tempDir);

    storage = HiveProfileStorage();
    testProfile = UniversalProfile(
      universalId: UniversalId.parse('550e8400-e29b-41d4-a716-446655440000'),
      displayName: 'テスト冒険者',
      createdAt: DateTime.utc(2026, 6, 7),
      appMetadata: {
        'rpg-task': {'level': 42, 'job': '戦士'},
      },
    );
  });

  tearDown(() async {
    await storage.close();
    // Clean up temp directory
    final dir = Directory(tempDir);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  });

  group('HiveProfileStorage', () {
    group('save and load', () {
      test('saves and loads a profile successfully', () async {
        await storage.save(testProfile);

        final loaded = await storage.load();
        expect(loaded, isNotNull);
        expect(loaded!.universalId, equals(testProfile.universalId));
        expect(loaded.displayName, equals('テスト冒険者'));
        expect(loaded.createdAt, equals(testProfile.createdAt));
        expect(loaded.appMetadata, equals(testProfile.appMetadata));
      });

      test('load returns null when no profile exists', () async {
        final loaded = await storage.load();
        expect(loaded, isNull);
      });

      test('save overwrites existing profile', () async {
        await storage.save(testProfile);

        final updated = testProfile.withDisplayName('改名冒険者');
        await storage.save(updated);

        final loaded = await storage.load();
        expect(loaded!.displayName, equals('改名冒険者'));
      });

      test('exists returns true after save', () async {
        expect(await storage.exists(), isFalse);
        await storage.save(testProfile);
        expect(await storage.exists(), isTrue);
      });

      test('exists returns false after delete', () async {
        await storage.save(testProfile);
        await storage.delete();
        expect(await storage.exists(), isFalse);
      });

      test('delete clears profile', () async {
        await storage.save(testProfile);
        await storage.delete();
        final loaded = await storage.load();
        expect(loaded, isNull);
      });
    });

    group('backup and recovery', () {
      test('recovers from backup when main box is corrupted', () async {
        // First, save normally
        await storage.save(testProfile);

        // Close storage so we can manipulate boxes directly
        await storage.close();

        // Simulate a mid-save crash scenario:
        // Manually write backup (as if the previous save wrote backup but crashed
        // before clearing it)
        final backup = await Hive.openBox('universal_profile_backup');
        await backup.put('data', testProfile.toJson());
        await backup.put('backup_timestamp', DateTime.now().toIso8601String());
        await backup.close();

        // Now corrupt the main box
        final box = await Hive.openBox<Map>('universal_profile');
        await box.clear();
        await box.put(0, {'corrupted': true}); // invalid data, no universalId
        await box.close();

        // Re-create storage and try to load
        storage = HiveProfileStorage();
        final loaded = await storage.load();
        expect(loaded, isNotNull);
        expect(loaded!.universalId, equals(testProfile.universalId));
        expect(loaded.displayName, equals('テスト冒険者'));
      });
    });

    group('close', () {
      test('close allows re-opening', () async {
        await storage.save(testProfile);
        await storage.close();

        // Create new storage instance and load
        final storage2 = HiveProfileStorage();
        final loaded = await storage2.load();
        expect(loaded, isNotNull);
        expect(loaded!.universalId, equals(testProfile.universalId));
        await storage2.close();
      });
    });
  });
}
