import 'package:flutter_test/flutter_test.dart';
import 'package:takamagahara_identity/takamagahara_identity.dart';

void main() {
  group('UniversalId', () {
    group('generate', () {
      test('generates a valid UUID v4', () {
        final id = UniversalId.generate();
        final parsed = UniversalId.parse(id.value);
        expect(parsed, equals(id));
      });

      test('generates unique IDs each time', () {
        final ids = List.generate(10, (_) => UniversalId.generate());
        final uniqueIds = ids.toSet();
        expect(uniqueIds.length, equals(10));
      });
    });

    group('parse', () {
      test('parses a valid UUID v4 string', () {
        const valid = '550e8400-e29b-41d4-a716-446655440000';
        final id = UniversalId.parse(valid);
        expect(id.value, equals(valid));
      });

      test('normalizes to lowercase', () {
        const mixed = '550E8400-E29B-41D4-A716-446655440000';
        final id = UniversalId.parse(mixed);
        expect(id.value, equals(mixed.toLowerCase()));
      });

      test('throws on invalid format', () {
        expect(
          () => UniversalId.parse('not-a-uuid'),
          throwsA(isA<InvalidUniversalIdFormat>()),
        );
      });

      test('throws on UUID v1 (non-v4)', () {
        // UUID v1 has version nibble = 1
        const v1 = '550e8400-e29b-11d4-a716-446655440000';
        expect(
          () => UniversalId.parse(v1),
          throwsA(isA<InvalidUniversalIdFormat>()),
        );
      });

      test('throws on empty string', () {
        expect(
          () => UniversalId.parse(''),
          throwsA(isA<InvalidUniversalIdFormat>()),
        );
      });
    });

    group('tryParse', () {
      test('returns Ok on valid UUID', () {
        const valid = '550e8400-e29b-41d4-a716-446655440000';
        final result = UniversalId.tryParse(valid);
        expect(result.isOk, isTrue);
        expect(result.unwrap().value, equals(valid));
      });

      test('returns Err on invalid UUID', () {
        final result = UniversalId.tryParse('not-valid');
        expect(result.isErr, isTrue);
      });
    });

    group('equality', () {
      test('same UUIDs are equal', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        final a = UniversalId.parse(uuid);
        final b = UniversalId.parse(uuid);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different UUIDs are not equal', () {
        final a = UniversalId.parse('550e8400-e29b-41d4-a716-446655440000');
        final b = UniversalId.parse('660e8400-e29b-41d4-a716-446655440000');
        expect(a, isNot(equals(b)));
      });
    });

    group('JSON serialization', () {
      test('toJson returns UUID string', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        final id = UniversalId.parse(uuid);
        expect(id.toJson(), equals(uuid));
      });

      test('fromJson roundtrips', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        final id = UniversalId.fromJson(uuid);
        expect(id.toJson(), equals(uuid));
      });
    });

    test('toString returns UUID string', () {
      const uuid = '550e8400-e29b-41d4-a716-446655440000';
      final id = UniversalId.parse(uuid);
      expect(id.toString(), equals(uuid));
    });
  });
}
