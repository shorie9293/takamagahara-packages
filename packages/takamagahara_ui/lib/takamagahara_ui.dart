/// takamagahara_ui — 高天原全Flutter現世共通UI基盤
///
/// 以下のモジュールを提供：
/// - [TakamagaharaTheme] — 和モダン×ピクセルアートテーマ
/// - [TakamagaharaColors] — ブランドカラー定義
/// - [SemanticHelper] — 試練可能なSemanticsヘルパー
/// - [SemanticTypes] — Semantics識別子の型プレフィックス
/// - [ErrorBoundary] — 禍津神の封印エラー境界
/// - [ErrorBoundaryWidget] — フォールバックエラーWidget
/// - [AppKeys] — 全画面テスト用Key一元管理
/// - [DivineButton] — 神話風ボタン
/// - [DivineLoading] — 御神籤ローディング
/// - [DivineDialog] — 神託ダイアログ
library takamagahara_ui;

export 'src/theme/colors.dart';
export 'src/theme/takamagahara_theme.dart';
export 'src/accessibility/semantic_helper.dart';
export 'src/error/error_boundary.dart';
export 'src/testing/app_keys.dart';
export 'src/widgets/divine_button.dart';
export 'src/widgets/divine_loading.dart';
export 'src/widgets/divine_dialog.dart';
