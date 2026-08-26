import 'package:test/test.dart';
import 'package:takamagahara_core/src/datetime_utils.dart';

void main() {
  group('DateTimeUtils', () {
    group('toJapaneseEra', () {
      test('令和', () {
        final d = DateTime(2026, 5, 7);
        expect(d.toJapaneseEra(), equals('令和8年5月7日'));
      });

      test('令和元年', () {
        final d = DateTime(2019, 5, 1);
        expect(d.toJapaneseEra(), equals('令和元年5月1日'));
      });

      test('平成', () {
        final d = DateTime(2015, 3, 15);
        expect(d.toJapaneseEra(), equals('平成27年3月15日'));
      });

      test('昭和', () {
        final d = DateTime(1980, 1, 1);
        expect(d.toJapaneseEra(), equals('昭和55年1月1日'));
      });
    });

    group('startOfDay', () {
      test('returns midnight of the same day', () {
        final d = DateTime(2026, 5, 7, 15, 30, 45);
        final start = d.startOfDay;
        expect(start.year, equals(2026));
        expect(start.month, equals(5));
        expect(start.day, equals(7));
        expect(start.hour, equals(0));
        expect(start.minute, equals(0));
        expect(start.second, equals(0));
      });
    });

    group('endOfDay', () {
      test('returns last microsecond of the same day', () {
        final d = DateTime(2026, 5, 7, 10, 0, 0);
        final end = d.endOfDay;
        expect(end.year, equals(2026));
        expect(end.month, equals(5));
        expect(end.day, equals(7));
        expect(end.hour, equals(23));
        expect(end.minute, equals(59));
        expect(end.second, equals(59));
      });
    });

    group('addDays', () {
      test('adds days correctly', () {
        final d = DateTime(2026, 5, 7);
        final result = d.addDays(3);
        expect(result.day, equals(10));
      });

      test('handles month boundary', () {
        final d = DateTime(2026, 5, 30);
        final result = d.addDays(3);
        expect(result.month, equals(6));
        expect(result.day, equals(2));
      });
    });
  });
}
