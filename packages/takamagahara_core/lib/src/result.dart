/// 高天原共通 Result型 — RustのResultに倣う成功/失敗の型
///
/// Dart 3のsealed class + pattern matchingで安全に扱える。
///
/// ```dart
/// final result = fetchData();
/// final message = switch (result) {
///   Ok(value: final v) => '成功: $v',
///   Err(error: final e) => '失敗: $e',
/// };
/// ```
sealed class Result<T, E> {
  const Result();

  /// 成功値を取り出す。Errの場合throw
  T unwrap() => switch (this) {
        Ok(value: final v) => v,
        Err(error: final e) => throw ResultUnwrapError('unwrap() called on Err: $e'),
      };

  /// エラー値を取り出す。Okの場合throw
  E unwrapErr() => switch (this) {
        Ok(value: final v) =>
          throw ResultUnwrapError('unwrapErr() called on Ok: $v'),
        Err(error: final e) => e,
      };

  /// 成功ならtrue
  bool get isOk => this is Ok<T, E>;

  /// 失敗ならtrue
  bool get isErr => this is Err<T, E>;

  /// 成功値を変換。Errならそのまま
  Result<U, E> map<U>(U Function(T value) fn) => switch (this) {
        Ok(value: final v) => Result<U, E>.ok(fn(v)),
        Err(error: final e) => Result<U, E>.err(e),
      };

  /// 成功なら値を、失敗ならdefaultValueを返す
  T getOrElse(T defaultValue) => switch (this) {
        Ok(value: final v) => v,
        Err() => defaultValue,
      };

  /// 成功Resultを作成
  factory Result.ok(T value) = Ok<T, E>;

  /// 失敗Resultを作成
  factory Result.err(E error) = Err<T, E>;
}

/// 成功
final class Ok<T, E> extends Result<T, E> {
  final T value;
  const Ok(this.value);
}

/// 失敗
final class Err<T, E> extends Result<T, E> {
  final E error;
  const Err(this.error);
}

/// Resultの不正アクセスエラー
class ResultUnwrapError extends Error {
  final String message;
  ResultUnwrapError(this.message);

  @override
  String toString() => 'ResultUnwrapError: $message';
}
