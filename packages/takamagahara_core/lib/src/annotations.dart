/// 高天原 神聖アノテーション
///
/// コード内で神格や現世を明示するためのメタデータアノテーション。

/// 此のクラス/関数が属する現世（アプリ）を示す
class Utsushiyo {
  /// 現世名（例: 'rpg-task', 'tsundoku-quest', 'money-quest'）
  final String name;

  /// 現世の説明（任意）
  final String? description;

  const Utsushiyo(this.name, {this.description});
}

/// 此のクラス/関数の担当神格を示す
class Feature {
  /// Feature名
  final String name;

  /// 担当神（PM/Dev/UX/QA）
  final String? ownedBy;

  const Feature(this.name, {this.ownedBy});
}
