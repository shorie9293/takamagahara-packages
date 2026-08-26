/// 高天原ユニバーサルID — 全現世で同一の冒険者を識別するUUID値オブジェクト
///
/// UUID v4形式を検証し、型安全に取り扱う。
///
/// ```dart
/// // 新規生成
/// final id = UniversalId.generate();
///
/// // 文字列から復元（無効なら例外）
/// final restored = UniversalId.parse('550e8400-e29b-41d4-a716-446655440000');
///
/// // 比較
/// if (id == restored) { ... }
///
/// // JSON
/// final json = id.toJson(); // "550e8400-..."
/// ```
library;

import 'package:takamagahara_core/takamagahara_core.dart';
import 'package:uuid/uuid.dart';

/// フォーマット不正時のエラー
class InvalidUniversalIdFormat extends ResultUnwrapError {
  InvalidUniversalIdFormat(super.message);
}

/// UUID v4形式の正規表現
final _uuidV4Pattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);

/// 全現世で同一の冒険者を識別するユニバーサルID
///
/// 内部にUUID v4文字列を保持する不変（immutable）な値オブジェクト。
/// 文字列からの構築時はフォーマットを検証し、不正ならThrow。
final class UniversalId {
  final String _value;

  const UniversalId._(this._value);

  /// 新しいUUID v4を生成
  factory UniversalId.generate() {
    return UniversalId._(const Uuid().v4());
  }

  /// 文字列からIDを構築。不正フォーマットなら[InvalidUniversalIdFormat]をThrow
  factory UniversalId.parse(String value) {
    if (!_uuidV4Pattern.hasMatch(value)) {
      throw InvalidUniversalIdFormat(
        'Invalid UUID v4 format: "$value". '
        'Expected format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx',
      );
    }
    return UniversalId._(value.toLowerCase());
  }

  /// 文字列から安全に構築。不正なら[Result.err]
  static Result<UniversalId, InvalidUniversalIdFormat> tryParse(
    String value,
  ) {
    try {
      return Result.ok(UniversalId.parse(value));
    } on InvalidUniversalIdFormat catch (e) {
      return Result.err(e);
    }
  }

  /// 生のUUID文字列
  String get value => _value;

  @override
  String toString() => _value;

  @override
  bool operator ==(Object other) =>
      other is UniversalId && other._value == _value;

  @override
  int get hashCode => _value.hashCode;

  /// JSON直列化用
  String toJson() => _value;

  /// JSON復元用。[fromJson] factoryのエイリアス
  factory UniversalId.fromJson(String json) => UniversalId.parse(json);
}
