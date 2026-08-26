import 'package:flutter_test/flutter_test.dart';
import 'package:takamagahara_identity/takamagahara_identity.dart';

void main() {
  late UniversalId testId;

  setUp(() {
    testId = UniversalId.parse('550e8400-e29b-41d4-a716-446655440000');
  });

  group('UniversalProfile', () {
    group('create', () {
      test('creates profile with generated UUID and default name', () {
        final profile = UniversalProfile.create();
        expect(profile.displayName, equals('名も無き冒険者'));
        expect(profile.universalId, isA<UniversalId>());
        expect(profile.createdAt, isA<DateTime>());
        expect(profile.lastSyncedAt, equals(profile.createdAt));
      });

      test('creates profile with custom display name', () {
        final profile = UniversalProfile.create(displayName: 'テスト冒険者');
        expect(profile.displayName, equals('テスト冒険者'));
      });

      test('createdAt is UTC', () {
        final profile = UniversalProfile.create();
        expect(profile.createdAt.isUtc, isTrue);
      });
    });

    group('immutability', () {
      test('withDisplayName returns new instance', () {
        final profile = UniversalProfile(
          universalId: testId,
          displayName: '旧名',
          createdAt: DateTime(2026, 1, 1),
        );
        final updated = profile.withDisplayName('新名');
        expect(profile.displayName, equals('旧名'));
        expect(updated.displayName, equals('新名'));
        expect(updated.universalId, equals(testId));
        expect(updated.createdAt, equals(DateTime(2026, 1, 1)));
      });

      test('withSyncedNow updates lastSyncedAt', () {
        final profile = UniversalProfile(
          universalId: testId,
          createdAt: DateTime(2026, 1, 1),
        );
        final updated = profile.withSyncedNow();
        expect(updated.lastSyncedAt.isAfter(profile.lastSyncedAt), isTrue);
        // Other fields unchanged
        expect(updated.universalId, equals(testId));
        expect(updated.displayName, equals(profile.displayName));
        expect(updated.createdAt, equals(profile.createdAt));
      });

      test('withAppMetadata adds new metadata', () {
        final profile = UniversalProfile(
          universalId: testId,
          createdAt: DateTime(2026, 1, 1),
        );
        final updated = profile.withAppMetadata('rpg-task', {'level': 5});
        expect(updated.appMetadata['rpg-task'], equals({'level': 5}));
        // Original unchanged
        expect(profile.appMetadata, isEmpty);
      });

      test('withAppMetadata overwrites existing metadata for same app', () {
        final profile = UniversalProfile(
          universalId: testId,
          createdAt: DateTime(2026, 1, 1),
          appMetadata: {'rpg-task': {'old': 'data'}},
        );
        final updated = profile.withAppMetadata('rpg-task', {'new': 'data'});
        expect(updated.appMetadata['rpg-task'], equals({'new': 'data'}));
      });

      test('getAppMetadata returns typed data', () {
        final profile = UniversalProfile(
          universalId: testId,
          createdAt: DateTime(2026, 1, 1),
          appMetadata: {'rpg-task': {'level': 5}},
        );
        final data = profile.getAppMetadata<Map>('rpg-task');
        expect(data, equals({'level': 5}));
      });

      test('getAppMetadata returns null for missing app', () {
        final profile = UniversalProfile.create();
        expect(profile.getAppMetadata('nonexistent'), isNull);
      });
    });

    group('JSON serialization', () {
      test('toJson produces correct structure', () {
        final profile = UniversalProfile(
          universalId: testId,
          displayName: 'テスト',
          createdAt: DateTime.utc(2026, 6, 7, 10, 0, 0),
          appMetadata: {'app': {'key': 'value'}},
        );
        final json = profile.toJson();
        expect(json['universalId'], equals(testId.value));
        expect(json['displayName'], equals('テスト'));
        expect(json['createdAt'], equals('2026-06-07T10:00:00.000Z'));
        expect(json['lastSyncedAt'], isNotNull);
        expect(json['appMetadata'], equals({'app': {'key': 'value'}}));
      });

      test('fromJson roundtrips', () {
        final original = UniversalProfile(
          universalId: testId,
          displayName: 'ラウンドトリップ',
          createdAt: DateTime.utc(2026, 1, 1),
          appMetadata: {'rpg-task': {'level': 42}},
        );
        final json = original.toJson();
        final restored = UniversalProfile.fromJson(json);
        expect(restored.universalId, equals(original.universalId));
        expect(restored.displayName, equals(original.displayName));
        expect(restored.createdAt, equals(original.createdAt));
        expect(restored.appMetadata, equals(original.appMetadata));
      });

      test('fromJson with missing optional fields uses defaults', () {
        final json = {
          'universalId': testId.value,
          'createdAt': '2026-06-07T10:00:00.000Z',
        };
        final profile = UniversalProfile.fromJson(json);
        expect(profile.displayName, equals('名も無き冒険者'));
        expect(profile.appMetadata, isEmpty);
      });
    });

    group('equality', () {
      test('identical profiles are equal', () {
        final a = UniversalProfile(
          universalId: testId,
          createdAt: DateTime(2026, 1, 1),
        );
        final b = UniversalProfile(
          universalId: testId,
          createdAt: DateTime(2026, 1, 1),
        );
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different profiles are not equal', () {
        final a = UniversalProfile(
          universalId: testId,
          createdAt: DateTime(2026, 1, 1),
        );
        final b = UniversalProfile.create();
        expect(a, isNot(equals(b)));
      });
    });

    test('toString includes key info', () {
      final profile = UniversalProfile(
        universalId: testId,
        displayName: '吾輩',
        createdAt: DateTime(2026, 1, 1),
      );
      final str = profile.toString();
      expect(str, contains(testId.value));
      expect(str, contains('吾輩'));
    });
  });
}
