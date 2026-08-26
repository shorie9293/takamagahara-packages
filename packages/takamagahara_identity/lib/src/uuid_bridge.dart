/// UUID連携ブリッジ — SharedPreferencesを用いた現世間UUID共有
///
/// 同一デバイス上の全Takamagahara現世が同一のユニバーサルIDを
/// 共有するためのSharedPreferencesベースの連携機構。
///
/// ```dart
/// // 初回起動時: UUIDをSharedPreferencesに保存
/// final bridge = UuidBridge();
/// final existingId = await bridge.loadUuid();
/// if (existingId == null) {
///   final newId = UniversalId.generate();
///   await bridge.saveUuid(newId);
/// }
///
/// // 他現世の起動時: SharedPreferencesからUUIDを復元
/// final bridge = UuidBridge();
/// final sharedId = await bridge.loadUuid(); // ← 同一デバイスなら同じID
/// ```
library;

import 'package:shared_preferences/shared_preferences.dart';
import 'universal_id.dart';

/// SharedPreferencesを用いた現世間UUID連携
final class UuidBridge {
  static const String _uuidKey = 'takamagahara_universal_id';

  /// SharedPreferencesにユニバーサルIDを保存
  Future<bool> saveUuid(UniversalId id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_uuidKey, id.value);
  }

  /// SharedPreferencesからユニバーサルIDを読み込み
  /// 未保存または不正フォーマットの場合はnull
  Future<UniversalId?> loadUuid() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_uuidKey);
    if (raw == null) return null;

    final result = UniversalId.tryParse(raw);
    if (result.isOk) {
      return result.unwrap();
    }
    return null;
  }

  /// SharedPreferencesにユニバーサルIDが存在するか
  Future<bool> exists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_uuidKey);
  }

  /// SharedPreferencesからユニバーサルIDを削除
  Future<bool> removeUuid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_uuidKey);
  }
}
