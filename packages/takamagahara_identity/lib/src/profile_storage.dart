/// プロファイル永続化ストレージ — 抽象インターフェース + Hive実装
///
/// Hive Box `universal_profile` を用いて [UniversalProfile] を永続化する。
/// rpg-task の PlayerRepository パターンに倣い、バックアップBoxも併用。
library;

import 'package:hive/hive.dart';
import 'universal_profile.dart';

/// プロファイル永続化の抽象インターフェース
///
/// テスト時のモック差し替えを可能にする。
abstract class IProfileStorage {
  /// プロファイルを保存
  Future<void> save(UniversalProfile profile);

  /// プロファイルを読み込み。存在しない場合はnull
  Future<UniversalProfile?> load();

  /// プロファイルが存在するか
  Future<bool> exists();

  /// プロファイルを削除
  Future<void> delete();

  /// Boxを閉じる（アプリ終了時）
  Future<void> close();
}

/// Hive Box `universal_profile` を用いたプロファイル永続化実装
///
/// 使用前に `Hive.initFlutter()` および `HiveAdapter.register()` を
/// アプリ側で実行すること。
///
/// ```dart
/// // アプリ起動時
/// await Hive.initFlutter();
/// HiveAdapter.register();
///
/// // 使用
/// final storage = HiveProfileStorage();
/// await storage.save(profile);
/// ```
class HiveProfileStorage implements IProfileStorage {
  static const String _boxName = 'universal_profile';
  static const String _backupBoxName = 'universal_profile_backup';
  static const int _profileKey = 0;

  Box<Map<dynamic, dynamic>>? _box;
  Box? _backupBox;

  Future<Box<Map<dynamic, dynamic>>> _getBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
    return _box!;
  }

  Future<Box> _getBackupBox() async {
    if (_backupBox != null && _backupBox!.isOpen) return _backupBox!;
    _backupBox = await Hive.openBox(_backupBoxName);
    return _backupBox!;
  }

  @override
  Future<void> save(UniversalProfile profile) async {
    final box = await _getBox();
    final backup = await _getBackupBox();

    // 保存前に現在のデータをバックアップ
    try {
      if (box.isNotEmpty) {
        await backup.put('data', box.get(_profileKey));
        await backup.put('backup_timestamp', DateTime.now().toIso8601String());
      }
    } catch (_) {
      // バックアップ失敗は非致命的
    }

    // プロファイルを保存
    await box.put(_profileKey, profile.toJson());
    await box.flush();

    // 保存成功後、バックアップをクリア
    try {
      await backup.clear();
    } catch (_) {}
  }

  @override
  Future<UniversalProfile?> load() async {
    try {
      final box = await _getBox();
      if (box.isEmpty) return null;

      final data = box.get(_profileKey);
      if (data == null) return null;

      final json = Map<String, dynamic>.from(data);
      return UniversalProfile.fromJson(json);
    } catch (_) {
      // デシリアライズ失敗 → バックアップから復元を試みる
      return _restoreFromBackup();
    }
  }

  Future<UniversalProfile?> _restoreFromBackup() async {
    try {
      final backup = await _getBackupBox();
      final data = backup.get('data');
      if (data == null) return null;

      final json = Map<String, dynamic>.from(data);
      return UniversalProfile.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> exists() async {
    final box = await _getBox();
    return box.isNotEmpty && box.containsKey(_profileKey);
  }

  @override
  Future<void> delete() async {
    final box = await _getBox();
    if (box.isNotEmpty) {
      await box.delete(_profileKey);
    }
  }

  @override
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
      _box = null;
    }
    if (_backupBox != null && _backupBox!.isOpen) {
      await _backupBox!.close();
      _backupBox = null;
    }
  }
}
