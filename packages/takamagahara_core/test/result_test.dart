import 'package:test/test.dart';
import 'package:takamagahara_core/src/result.dart';

void main() {
  group('Result<T, E>', () {
    test('ok() creates success result', () {
      final result = Result<int, String>.ok(42);
      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
      expect(result.unwrap(), equals(42));
    });

    test('err() creates error result', () {
      final result = Result<int, String>.err('failure');
      expect(result.isOk, isFalse);
      expect(result.isErr, isTrue);
      expect(result.unwrapErr(), equals('failure'));
    });

    test('unwrap on err throws', () {
      final result = Result<int, String>.err('failure');
      expect(() => result.unwrap(), throwsA(isA<ResultUnwrapError>()));
    });

    test('unwrapErr on ok throws', () {
      final result = Result<int, String>.ok(42);
      expect(() => result.unwrapErr(), throwsA(isA<ResultUnwrapError>()));
    });

    test('map transforms ok value', () {
      final result = Result<int, String>.ok(42);
      final mapped = result.map((v) => v.toString());
      expect(mapped.unwrap(), equals('42'));
    });

    test('map on err preserves error', () {
      final result = Result<int, String>.err('failure');
      final mapped = result.map((v) => v.toString());
      expect(mapped.isErr, isTrue);
      expect(mapped.unwrapErr(), equals('failure'));
    });

    test('getOrElse returns value on ok', () {
      final result = Result<int, String>.ok(42);
      expect(result.getOrElse(0), equals(42));
    });

    test('getOrElse returns default on err', () {
      final result = Result<int, String>.err('failure');
      expect(result.getOrElse(0), equals(0));
    });

    test('pattern matching with switch', () {
      final result = Result<String, int>.ok('success');

      final message = switch (result) {
        Ok(value: final v) => 'got: $v',
        Err(error: final e) => 'error: $e',
      };

      expect(message, equals('got: success'));
    });

    test('pattern matching with err', () {
      final result = Result<String, int>.err(404);

      final message = switch (result) {
        Ok(value: final v) => 'got: $v',
        Err(error: final e) => 'error code: $e',
      };

      expect(message, equals('error code: 404'));
    });
  });
}
