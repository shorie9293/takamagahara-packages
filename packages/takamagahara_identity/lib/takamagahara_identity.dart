/// takamagahara_identity — 高天原ユニバーサルID体系
///
/// 全現世横断の共通アイデンティティ永続化基盤。
/// 以下のモジュールを提供：
///
/// - [UniversalId] — UUID v4値オブジェクト（生成・検証・比較・JSON）
/// - [UniversalProfile] — 全現世共有の冒険者プロファイル
/// - [IProfileStorage] + [HiveProfileStorage] — Hive Box永続化
/// - [UuidBridge] — SharedPreferencesを用いた現世間UUID共有
// ignore_for_file: unnecessary_library_name
library takamagahara_identity;

export 'src/universal_id.dart';
export 'src/universal_profile.dart';
export 'src/profile_storage.dart';
export 'src/uuid_bridge.dart';
