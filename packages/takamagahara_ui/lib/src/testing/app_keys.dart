import 'package:flutter/widgets.dart';

/// 全Widget Keyを一元管理。
///
/// 命名規則: `{screenName}_{elementName}`
///   例: mainScreen_fabButton, dialogueScreen_confirmButton
///
/// 重複検知：開発時（assert有効時）に重複をチェックする。
abstract final class AppKeys {
  AppKeys._();

  // ━━━ メイン画面 ━━━
  static const Key mainScreen = Key('mainScreen');
  static const Key mainScreen_fabButton = Key('mainScreen_fabButton');

  // ━━━ 対話画面 ━━━
  static const Key dialogueScreen = Key('dialogueScreen');
  static const Key dialogueScreen_dialog = Key('dialogueScreen_dialog');
  static const Key dialogueScreen_confirmButton = Key(
    'dialogueScreen_confirmButton',
  );

  // ━━━ 設定画面 ━━━
  static const Key settingsScreen = Key('settingsScreen');
  static const Key settingsScreen_saveButton = Key(
    'settingsScreen_saveButton',
  );
  static const Key settingsScreen_toggleNotification = Key(
    'settingsScreen_toggleNotification',
  );

  // ━━━ エラー関連 ━━━
  static const Key errorRetryButton = Key('errorRetryButton');

  // ━━━ ローディング関連 ━━━
  static const Key loadingIndicator = Key('loadingIndicator');

  // ━━━ CSVエクスポート画面 ━━━
  static const Key csvExportScreen = Key('csvExportScreen');
  static const Key csvExport_dateRangeCard = Key('csvExport_dateRangeCard');
  static const Key csvExport_dateRangePicker = Key('csvExport_dateRangePicker');
  static const Key csvExport_exportButton = Key('csvExport_exportButton');
  static const Key csvExport_loadingIndicator =
      Key('csvExport_loadingIndicator');
  static const Key csvExport_errorCard = Key('csvExport_errorCard');
  static const Key csvExport_successCard = Key('csvExport_successCard');

  // ━━━ 実績一覧画面 ━━━
  static const Key achievementListScreen = Key('achievementListScreen');
  static const Key achievementList_gridView = Key('achievementList_gridView');
  static const Key achievementList_loadingIndicator =
      Key('achievementList_loadingIndicator');
  static const Key achievementList_errorView = Key('achievementList_errorView');
  static const Key achievementList_emptyView = Key('achievementList_emptyView');

  // ━━━ CSVインポート画面 ━━━
  static const Key csvImportScreen = Key('csvImportScreen');
  static const Key csvImport_pickButton = Key('csvImport_pickButton');
  static const Key csvImport_resultCard = Key('csvImport_resultCard');
  static const Key csvImport_errorText = Key('csvImport_errorText');
  static const Key csvImport_importedList = Key('csvImport_importedList');

  // ━━━ 定期取引画面 ━━━
  static const Key recurringTxScreen = Key('recurringTxScreen');
  static const Key recurringTx_addButton = Key('recurringTx_addButton');
  static const Key recurringTx_purposeField = Key('recurringTx_purposeField');
  static const Key recurringTx_amountField = Key('recurringTx_amountField');
  static const Key recurringTx_frequencyDropdown =
      Key('recurringTx_frequencyDropdown');
  static const Key recurringTx_dayOfWeekDropdown =
      Key('recurringTx_dayOfWeekDropdown');
  static const Key recurringTx_dayOfMonthField =
      Key('recurringTx_dayOfMonthField');
  static const Key recurringTx_saveButton = Key('recurringTx_saveButton');

  /// 定期取引の削除ボタンKey（定義IDごとに生成）
  static Key recurringTxDeleteButton(String id) =>
      Key('recurringTx_deleteButton_$id');

  /// 全キーのリスト（重複チェック用）
  static List<Key> get all => [
        mainScreen,
        mainScreen_fabButton,
        dialogueScreen,
        dialogueScreen_dialog,
        dialogueScreen_confirmButton,
        settingsScreen,
        settingsScreen_saveButton,
        settingsScreen_toggleNotification,
        errorRetryButton,
        loadingIndicator,
        csvExportScreen,
        csvExport_dateRangeCard,
        csvExport_dateRangePicker,
        csvExport_exportButton,
        csvExport_loadingIndicator,
        csvExport_errorCard,
        csvExport_successCard,
        achievementListScreen,
        achievementList_gridView,
        achievementList_loadingIndicator,
        achievementList_errorView,
        achievementList_emptyView,
        csvImportScreen,
        csvImport_pickButton,
        csvImport_resultCard,
        csvImport_errorText,
        csvImport_importedList,
        recurringTxScreen,
        recurringTx_addButton,
        recurringTx_purposeField,
        recurringTx_amountField,
        recurringTx_frequencyDropdown,
        recurringTx_dayOfWeekDropdown,
        recurringTx_dayOfMonthField,
        recurringTx_saveButton,
      ];

  /// 重複チェック — 開発時のみ実行
  static void _assertNoDuplicates() {
    final values = all.map((k) => k.toString()).toList();
    final unique = values.toSet();
    assert(
      values.length == unique.length,
      'AppKeys 重複検知: ${values.length - unique.length} 個の重複があります\n'
      '重複キー: ${_findDuplicates(values)}',
    );
  }

  static List<String> _findDuplicates(List<String> values) {
    final counts = <String, int>{};
    for (final v in values) {
      counts[v] = (counts[v] ?? 0) + 1;
    }
    return counts.entries
        .where((e) => e.value > 1)
        .map((e) => e.key)
        .toList();
  }

  /// クラスロード時に重複チェックを実行
  static final _initialized = _assertNoDuplicates();
}
