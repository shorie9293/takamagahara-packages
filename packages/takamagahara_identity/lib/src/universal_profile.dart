/// 高天原ユニバーサルプロファイル — 全現世横断の冒険者プロファイルモデル
///
/// 各現世個別のプレイヤーデータ（Player, PlayerV4等）とは別に、
/// **全現世で共有する最小限のアイデンティティ情報**を保持する。
///
/// 現世固有の拡張データは [appMetadata] に格納する。
library;

import 'universal_id.dart';

/// 高天原全現世で共有される冒険者のプロファイル
///
/// Hive Box `universal_profile` に永続化される。
final class UniversalProfile {
  /// ユニバーサルID（全現世共通）
  final UniversalId universalId;

  /// 表示名（任意、未設定時は `"名も無き冒険者"`）
  final String displayName;

  /// プロファイル作成日時（UTC）
  final DateTime createdAt;

  /// 最終同期日時（UTC、連携サーバーとの最終通信時）
  final DateTime lastSyncedAt;

  /// 現世固有の拡張メタデータ
  /// Key: 現世名（例: `"rpg-task"`, `"tsundoku-quest"`, `"kozuchi"`）
  /// Value: 現世固有の任意データ
  final Map<String, dynamic> appMetadata;

  const UniversalProfile({
    required this.universalId,
    this.displayName = '名も無き冒険者',
    required this.createdAt,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? appMetadata,
  }) : lastSyncedAt = lastSyncedAt ?? createdAt,
       appMetadata = appMetadata ?? const {};

  /// 新規プロファイルを作成
  factory UniversalProfile.create({
    String displayName = '名も無き冒険者',
  }) {
    final now = DateTime.now().toUtc();
    return UniversalProfile(
      universalId: UniversalId.generate(),
      displayName: displayName,
      createdAt: now,
    );
  }

  /// 表示名を変更した新しいプロファイルを返す（不変）
  UniversalProfile withDisplayName(String newName) {
    return UniversalProfile(
      universalId: universalId,
      displayName: newName,
      createdAt: createdAt,
      lastSyncedAt: lastSyncedAt,
      appMetadata: appMetadata,
    );
  }

  /// 同期日時を更新した新しいプロファイルを返す
  UniversalProfile withSyncedNow() {
    return UniversalProfile(
      universalId: universalId,
      displayName: displayName,
      createdAt: createdAt,
      lastSyncedAt: DateTime.now().toUtc(),
      appMetadata: appMetadata,
    );
  }

  /// 現世固有のメタデータを追加/更新
  UniversalProfile withAppMetadata(
    String appName,
    dynamic data,
  ) {
    final updated = Map<String, dynamic>.from(appMetadata);
    updated[appName] = data;
    return UniversalProfile(
      universalId: universalId,
      displayName: displayName,
      createdAt: createdAt,
      lastSyncedAt: lastSyncedAt,
      appMetadata: updated,
    );
  }

  /// 現世固有のメタデータを取得
  T? getAppMetadata<T>(String appName) {
    final data = appMetadata[appName];
    if (data is T) return data;
    return null;
  }

  @override
  String toString() =>
      'UniversalProfile($universalId, "$displayName", created=$createdAt)';

  @override
  bool operator ==(Object other) =>
      other is UniversalProfile &&
      other.universalId == universalId &&
      other.displayName == displayName &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(universalId, displayName, createdAt);

  /// JSON直列化
  Map<String, dynamic> toJson() => {
        'universalId': universalId.toJson(),
        'displayName': displayName,
        'createdAt': createdAt.toIso8601String(),
        'lastSyncedAt': lastSyncedAt.toIso8601String(),
        'appMetadata': appMetadata,
      };

  /// JSON復元
  factory UniversalProfile.fromJson(Map<String, dynamic> json) {
    return UniversalProfile(
      universalId: UniversalId.parse(json['universalId'] as String),
      displayName: json['displayName'] as String? ?? '名も無き冒険者',
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      appMetadata: json['appMetadata'] != null
          ? Map<String, dynamic>.from(json['appMetadata'] as Map)
          : null,
    );
  }
}
