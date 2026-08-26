/// 日付操作ユーティリティ
extension DateTimeUtils on DateTime {
  /// 和暦文字列を返す（例: '令和8年5月7日'）
  String toJapaneseEra() {
    const eras = [
      (name: '令和', startYear: 2019),
      (name: '平成', startYear: 1989),
      (name: '昭和', startYear: 1926),
    ];

    for (final era in eras) {
      if (year >= era.startYear) {
        final eraYear = year - era.startYear + 1;
        final eraYearStr = eraYear == 1 ? '元' : eraYear.toString();
        return '${era.name}${eraYearStr}年$month月$day日';
      }
    }
    return '$year年$month月$day日';
  }

  /// 本日の開始時刻（00:00:00.000）を返す
  DateTime get startOfDay => DateTime(year, month, day);

  /// 本日の終了時刻（23:59:59.999）を返す
  DateTime get endOfDay =>
      DateTime(year, month, day, 23, 59, 59, 999, 999);

  /// 指定日数だけ進めた日付を返す
  DateTime addDays(int days) => add(Duration(days: days));
}
